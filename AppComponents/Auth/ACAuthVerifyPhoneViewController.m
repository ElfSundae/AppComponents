//
//  ACAuthVerifyPhoneViewController.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACAuthVerifyPhoneViewController.h"
#import <objc/message.h>
#import <IconFontKit/IFFontAwesome.h>

static NSString *__gPhoneNumberRegexPattern = @"^1\\d{10}$";
static NSString *__gVerifyPhoneSharedPhoneZone = nil;
static NSString *__gVerifyPhoneSharedPhoneNumber = nil;
static NSDate *__gVerifyPhoneSharedDateOfPreviousSendingCode = nil;

@implementation ACAuthVerifyPhoneViewController

- (instancetype)initWithVerifyHandler:(void (^)(ACAuthVerifyPhoneViewController *controller, NSDictionary *data))verifyHandler
{
    self = [super init];
    if (self) {
        self.verifyHandler = verifyHandler;
        self.titleForNavigationBar = @"验证手机号";
        self.commitButtonTitle = @"验证手机号";
        self.timeIntervalForRetrySendingCode = 40.0;
        self.timeIntervalBeforeShowingSendSecondaryCodeButton = 12.0;
        self.supportedCodeTypes = @[@(ACAuthVerifyPhoneCodeTypeSMS), @(ACAuthVerifyPhoneCodeTypePhoneCall)];
        self.sendCodeButtonTitles = @{@(ACAuthVerifyPhoneCodeTypeSMS): @"获取验证码",
                                      @(ACAuthVerifyPhoneCodeTypePhoneCall): @"接听语音验证码"};

    }
    return self;
}

- (instancetype)init
{
    return [self initWithVerifyHandler:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!ESIsArrayWithItems(self.supportedCodeTypes)) {
        [NSException raise:[NSStringFromClass(self.class) stringByAppendingString:@"Exception"] format:@"没有支持的验证码类型"];
    }
    if (self.supportedCodeTypes.count > 2) {
        [NSException raise:[NSStringFromClass(self.class) stringByAppendingString:@"Exception"] format:@"最多支持两种验证码类型"];
    }
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startTimerIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
}

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
    [self stopTimer];
}

- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification
{
    [self startTimerIfNeeded];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UI

- (void)setupUI
{
    if (self.phoneTextField) {
        return;
    }

    CGFloat rowHeight;
    self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.phoneTextField];
    self.phoneTextField.delegate = self;
    self.phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTextField.font = [UIFont systemFontOfSize:18.f];
    self.phoneTextField.height = self.phoneTextField.font.lineHeight + 20.f;
    rowHeight = self.phoneTextField.height;
    self.phoneTextField.placeholder = @"手机号码";
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;

    UIView *phoneLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rowHeight, rowHeight)];
    UILabel *phoneIconLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    phoneIconLabel.backgroundColor = [UIColor clearColor];
    IFFontAwesome *phoneIcon = [IFFontAwesome iconWithType:IFFAMobile fontSize:30.0 color:[UIColor lightGrayColor]];
    phoneIconLabel.attributedText = [phoneIcon attributedString];
    [phoneIconLabel sizeToFit];
    [phoneLeftView addSubview:phoneIconLabel];
    phoneIconLabel.centerY = phoneLeftView.height / 2.f;
    phoneIconLabel.left = phoneLeftView.width - phoneIconLabel.width - 8.f;
    self.phoneTextField.leftView = phoneLeftView;
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;

    self.codeTextFiled = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.codeTextFiled];
    self.codeTextFiled.delegate = self;
    self.codeTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    self.codeTextFiled.font = [UIFont systemFontOfSize:18.f];
    self.codeTextFiled.height = rowHeight;
    self.codeTextFiled.placeholder = @"验证码";
    self.codeTextFiled.keyboardType = UIKeyboardTypeNumberPad;

    UIView *codeLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rowHeight, rowHeight)];
    UILabel *codeLeftIconLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    codeLeftIconLabel.backgroundColor = [UIColor clearColor];
    IFFontAwesome *codeLeftIcon = [IFFontAwesome iconWithType:IFFAExpeditedssl fontSize:24.0 color:[UIColor lightGrayColor]];
    codeLeftIconLabel.attributedText = [codeLeftIcon attributedString];
    [codeLeftIconLabel sizeToFit];
    [codeLeftView addSubview:codeLeftIconLabel];
    codeLeftIconLabel.centerY = codeLeftView.height / 2.f;
    codeLeftIconLabel.left = codeLeftView.width - codeLeftIconLabel.width - 2.f;
    self.codeTextFiled.leftView = codeLeftView;
    self.codeTextFiled.leftViewMode = UITextFieldViewModeAlways;

    self.commitButton = [ESButton buttonWithStyle:ESButtonStyleRoundedRect];
    self.commitButton.buttonColor = [UIColor es_successButtonColor];
    self.commitButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    [self.commitButton setTitle:self.commitButtonTitle forState:UIControlStateNormal];
    self.commitButton.buttonFlatStyled = @(YES);
    [self.view addSubview:self.commitButton];

    if (!ESIsStringWithAnyText(self.phoneTextField.text) && [[self class] sharedPhoneNumber]) {
        self.phoneTextField.text = [[self class] sharedPhoneNumber];
        [self.codeTextFiled becomeFirstResponder];
    } else {
        [self.phoneTextField becomeFirstResponder];
    }

    [self.sendCodeButton addTarget:self action:@selector(sendCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendSecondaryCodeButton addTarget:self action:@selector(sendCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.commitButton addTarget:self action:@selector(commitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:self.codeTextFiled];
}

- (void)updateUI
{
    // phoneNumber
    NSString *phoneNumber = nil;
    int retryTimeRemains = 0;
    BOOL canSendCode = [self canSendCode:&phoneNumber timeRemains:&retryTimeRemains];

    // sendCodeButton
    NSString *sendCodeButtonNormalTitle = self.sendCodeButtonTitles[self.supportedCodeTypes.firstObject];
    if (canSendCode) {
        [self setTextFieldRightButtonTitle:self.sendCodeButton title:sendCodeButtonNormalTitle enabled:YES];
        [self stopTimer];
    } else {
        if (retryTimeRemains > 0) {
            [self setTextFieldRightButtonTitle:self.sendCodeButton title:NSStringWith(@" %ds ", retryTimeRemains) enabled:NO];
        } else if (!phoneNumber) {
            [self setTextFieldRightButtonTitle:self.sendCodeButton title:sendCodeButtonNormalTitle enabled:NO];
            [self stopTimer];
        }
    }

    // sendSecondaryCodeButton
    if ([[self class] sharedPhoneNumber] && self.canShowSendSecondaryCodeButton && self.supportedCodeTypes.count > 1 && retryTimeRemains > 0) {
        NSString *sendSendaryCodeButtonNormalTitle = self.sendCodeButtonTitles[self.supportedCodeTypes[1]];
        NSAssert(sendSendaryCodeButtonNormalTitle, @"There is no title for sendSecondaryCodeButton.");
        NSTimeInterval waittedTime = self.timeIntervalForRetrySendingCode - [self currentTimeRemainsToEnableSendingCode];
        if (waittedTime >= self.timeIntervalBeforeShowingSendSecondaryCodeButton) {
            [self setTextFieldRightButtonTitle:self.sendSecondaryCodeButton title:sendSendaryCodeButtonNormalTitle enabled:YES];
        } else {
            [self setTextFieldRightButtonTitle:self.sendSecondaryCodeButton title:nil enabled:NO];
        }
    } else {
        [self setTextFieldRightButtonTitle:self.sendSecondaryCodeButton title:nil enabled:NO];
    }

    // codeTextFiled
    self.codeTextFiled.enabled = !!phoneNumber;

    // commitButton
    self.commitButton.enabled = !!phoneNumber && self.codeTextFiled.text.length > 3;

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    CGRect rowFrame = CGRectMake(-5.f, 0.f, self.view.width + 10.f, self.phoneTextField.height);
    self.phoneTextField.frame = rowFrame;
    self.phoneTextField.top = self.navigationController.navigationBar.bottom + 20.f;

    self.codeTextFiled.frame = rowFrame;
    self.codeTextFiled.top = self.phoneTextField.bottom + 5.f;

    self.commitButton.frame = rowFrame;
    self.commitButton.top = self.codeTextFiled.bottom + 16.f;
}

- (ESButton *)sendCodeButton
{
    if (!_sendCodeButton) {
        _sendCodeButton = [ESButton buttonWithStyle:ESButtonStyleRoundedRect];
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:self.phoneTextField.font.pointSize - 2.f];
        _sendCodeButton.buttonColor = [UIColor es_defaultButtonColor];
        _sendCodeButton.buttonFlatStyled = @(YES);
    }
    return _sendCodeButton;
}

- (ESButton *)sendSecondaryCodeButton
{
    if (!_sendSecondaryCodeButton) {
        _sendSecondaryCodeButton = [ESButton buttonWithStyle:ESButtonStyleRoundedRect];
        _sendSecondaryCodeButton.titleLabel.font = [UIFont systemFontOfSize:self.codeTextFiled.font.pointSize - 2.f];
        _sendSecondaryCodeButton.buttonColor = [UIColor es_purpleColor];
        _sendSecondaryCodeButton.buttonFlatStyled = @(YES);
    }
    return _sendSecondaryCodeButton;
}

- (void)setCommitButtonTitle:(NSString *)commitButtonTitle
{
    _commitButtonTitle = commitButtonTitle;
    [self.commitButton setTitle:_commitButtonTitle forState:UIControlStateNormal];
}

- (void)setTimeIntervalForRetrySendingCode:(NSTimeInterval)time
{
    if (_timeIntervalForRetrySendingCode != time) {
        _timeIntervalForRetrySendingCode = time;
        if (self.retrySendingCodeTimer) {
            // 重启timer
            [self startTimerIfNeeded];
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Methods

- (void)_dismissBarButtonItemAction:(UIBarButtonItem *)barItem
{
    if (self.navigationItem.leftBarButtonItem &&
        self.navigationController.viewControllers.firstObject == self &&
        self.retrySendingCodeTimer /* 当前timer在运行，说明已经发送过验证码了 */)
    {
        NSString *backTitle = self.navigationItem.leftBarButtonItem.title ?: @"取消";
        NSString *tips = @"接收验证码可能略有延迟，建议您稍做等待。";
        NSString *tipsMessage = NSStringWith(@"\n确定%@吗？\n", backTitle);
        ESWeakSelf;
        UIAlertView *alert = [UIAlertView alertViewWithTitle:tips message:tipsMessage cancelButtonTitle:@"继续等待" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            ESStrongSelf;
            if (alertView.cancelButtonIndex != buttonIndex) {
                [_self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        } otherButtonTitles:backTitle, nil];
        [alert show];
    } else {
        [super _dismissBarButtonItemAction:barItem];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITextFiledDelegate

// - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
// {
//        // 发送验证码倒计时开启时禁用电话号码文本框
//        if (textField == self.phoneTextField) {
//                return !self.retrySendingCodeTimer;
//        }
//        return YES;
// }

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *result = [textField.text ?: @"" mutableCopy];
    [result replaceCharactersInRange:range withString:string];

    if (textField == self.phoneTextField) {
        return [result isMatch:@"^\\d{0,11}$"];
    } else if (textField == self.codeTextFiled) {
        return result.length <= 6;
    }
    return YES;
}

- (void)textFieldTextDidChangeNotification:(NSNotification *)notification
{
    [self updateUI];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public Methods

+ (void)cleanUp
{
    [self setSharedPhoneZone:nil];
    [self setSharedPhoneNumber:nil];
    [self setSharedDateOfPreviousSendingCode:nil];
}

+ (NSString *)validatePhoneNumber:(id)phone
{
    if ([phone isKindOfClass:[NSNumber class]]) {
        phone = [(NSNumber *) phone stringValue];
    }
    if ([phone isKindOfClass:[NSString class]]) {
        NSString *phoneString = [(NSString *) phone trim];
        if ([phoneString isMatch:[self phoneNumberRegexPattern]]) {
            return phoneString;
        }
    }
    return nil;
}


+ (NSString *)phoneNumberRegexPattern
{
    return __gPhoneNumberRegexPattern;
}
+ (void)setPhoneNumberRegexPattern:(NSString *)pattern
{
    if (ESIsStringWithAnyText(pattern)) {
        __gPhoneNumberRegexPattern = pattern;
    }
}


+ (NSString *)sharedPhoneNumber
{
    return __gVerifyPhoneSharedPhoneNumber;
}
+ (void)setSharedPhoneNumber:(NSString *)phone
{
    NSString *phoneNumber = [self validatePhoneNumber:phone];
    __gVerifyPhoneSharedPhoneNumber = phoneNumber;
}

+ (NSString *)sharedPhoneZone
{
    return __gVerifyPhoneSharedPhoneZone ?: @"86";
}
+ (void)setSharedPhoneZone:(NSString *)zone
{
    __gVerifyPhoneSharedPhoneZone = zone;
}

+ (NSDate *)sharedDateOfPreviousSendingCode
{
    return __gVerifyPhoneSharedDateOfPreviousSendingCode;
}
+ (void)setSharedDateOfPreviousSendingCode:(NSDate *)date
{
    if (!date || [date isKindOfClass:[NSDate class]]) {
        __gVerifyPhoneSharedDateOfPreviousSendingCode = date;
    }
}

@end
