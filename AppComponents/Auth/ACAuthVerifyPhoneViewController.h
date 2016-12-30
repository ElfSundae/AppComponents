//
//  ACAuthVerifyPhoneViewController.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACAuthBaseViewController.h"
#import <ESFramework/ESFrameworkCore.h>
#import <ESFramework/ESButton.h>
@class ACAuthVerifyPhoneViewController;

/**
 * 验证手机号的验证码类型
 */
typedef NS_ENUM(NSInteger, ACAuthVerifyPhoneCodeType) {
    /// 短信验证码
    ACAuthVerifyPhoneCodeTypeSMS = 0,
    /// 语音验证码
    ACAuthVerifyPhoneCodeTypePhoneCall
};

@interface ACAuthVerifyPhoneViewController : ACAuthBaseViewController

- (instancetype)initWithVerifyHandler:(void (^)(ACAuthVerifyPhoneViewController *controller, NSDictionary *data))verifyHandler;

@property (nonatomic, copy) void (^verifyHandler)(ACAuthVerifyPhoneViewController *controller, NSDictionary *data);

/**
 * 默认为@"验证手机号"
 */
@property (nonatomic, copy) NSString *commitButtonTitle;
/**
 * 重试的时间间隔（秒）。默认为 40.0
 */
@property (nonatomic) NSTimeInterval timeIntervalForRetrySendingCode;
/**
 * 发送验证码后，等多久显示第二验证码(如果supportedCodeTypes支持第二验证码).
 * 默认为 12.0
 */
@property (nonatomic) NSTimeInterval timeIntervalBeforeShowingSendSecondaryCodeButton;
/**
 * 支持的代码类型，数组索引代表优先级. 最多支持两种代码类型.
 */
@property (nonatomic, strong) NSArray *supportedCodeTypes;
/**
 * 每种代码类型对应的发送按钮在 controlStateNormal 情况下的title
 * { @(codeType) : @"sendCodeButtonTitle" }
 *
 * buttonTitle支持NSString和NSAttributedString
 */
@property (nonatomic, strong) NSDictionary *sendCodeButtonTitles;

+ (NSString *)phoneNumberRegexPattern;
+ (void)setPhoneNumberRegexPattern:(NSString *)pattern;

/**
 * 外部成功处理后调用，清理全局临时变量。
 */
+ (void)cleanUp;

/// 更新各个UI控件的状态
- (void)updateUI;


@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) ESButton *sendCodeButton; // 在phoneTextField右边
@property (nonatomic, strong) UITextField *codeTextFiled;
@property (nonatomic, strong) ESButton *sendSecondaryCodeButton; // 在codeTextFiled右边
@property (nonatomic, strong) ESButton *commitButton;
@property (nonatomic, strong) NSTimer *retrySendingCodeTimer;

/**
 * Helper: 验证大陆手机号码是否正确, 支持NSString，NSNumber
 * 验证规则：对传入的phone进行trim后正则匹配纯数字11位.
 * 验证成功后返回解析后的手机号，否则返回nil
 */
+ (NSString *)validatePhoneNumber:(id)phone;
/**
 * Helper: 验证手机号码是否正确, 支持NSString，NSNumber
 *
 * @param phone    电话号码
 * @param zone     区号
 * @param strictly 严格模式， 为NO时只检查号码位数
 */
// + (NSString *)validatePhoneNumber:(id)phone zone:(NSString *)zone strictly:(BOOL)strictly;

/// 共享的属性，子类可以实现自己的共享属性.
/// 比如修改手机号的验证，可以继承UAVerifyPhoneViewController并修改共享属性

+ (NSString *)sharedPhoneNumber;
+ (void)setSharedPhoneNumber:(NSString *)phoneNumber;

+ (NSString *)sharedPhoneZone;
+ (void)setSharedPhoneZone:(NSString *)zone;

+ (NSDate *)sharedDateOfPreviousSendingCode;
+ (void)setSharedDateOfPreviousSendingCode:(NSDate *)date;

@end

@interface ACAuthVerifyPhoneViewController () <UITextFieldDelegate>
/**
 * 是否可以显示发送第二验证码的按钮。
 * 在发送过第二验证码后请设置该值为NO， 第二验证码只能发送一次
 */
@property (nonatomic) BOOL canShowSendSecondaryCodeButton;

/// 从notification.object中获取回调的textFiled
- (void)textFieldTextDidChangeNotification:(NSNotification *)notification;

@end

@interface ACAuthVerifyPhoneViewController (Private)

/**
 * 设置textField右边button的 title 和 enable，并自动跟textField对齐. title为nil时隐藏textField的rightView
 */
- (void)setTextFieldRightButtonTitle:(ESButton *)button title:(NSString *)title enabled:(BOOL)enabled;

/**
 * 当前禁止发送的剩余时间（秒）， 如果为0或者负数则可以发送验证码
 */
- (NSTimeInterval)currentTimeRemainsToEnableSendingCode;
/**
 * 对currentTimeRemainsToEnableSendingCode进行ceil操作
 */
- (int)currentTimeRemainsToEnableSendingCodeAsInt;

/**
 * 当前是否可以发送验证码短信. 可能是没填手机号，可能是当前禁止重新发送.
 *
 * @param phoneNumber 当前有效的手机号
 * @param timeRemains 还需要多少时间才可以重新发送
 */
- (BOOL)canSendCode:(NSString **)phoneNumber timeRemains:(int *)timeRemains;

/**
 * 重新发送验证码的倒计时. timer间隔1秒调用 -updateUI 方法
 */
- (void)startTimerIfNeeded;
- (void)stopTimer;
@end

@interface ACAuthVerifyPhoneViewController (Subclassing)

/**
 * 谈提示框，确认是否发送验证码
 */
- (void)confirmSendCodeToPhone:(NSString *)phoneNumber codeType:(ACAuthVerifyPhoneCodeType)codeType fromSecondaryButton:(BOOL)fromSecondaryButton;
/**
 * 发送主要的验证码方式
 * @see supportedCodeTypes
 */
- (void)sendCodeToPhone:(NSString *)phoneNumber codeType:(ACAuthVerifyPhoneCodeType)codeType;
/**
 * 发送第二验证码
 * @see supportedCodeTypes
 */
- (void)sendSecondaryCodeToPhone:(NSString *)phoneNumber codeType:(ACAuthVerifyPhoneCodeType)codeType;
/**
 * 验证手机和验证码是否正确.
 * 如果self.verifyHandler没有被设置，就调用这个方法.
 */
- (void)verifyPhone:(NSString *)phone phoneZone:(NSString *)phoneZone code:(NSString *)code;


- (void)sendCodeButtonAction:(id)sender;
- (void)commitButtonAction:(id)sender;

@end
