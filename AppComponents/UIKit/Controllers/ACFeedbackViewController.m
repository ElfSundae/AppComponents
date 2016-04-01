//
//  ACFeedbackViewController.m
//  AppComponents
//
//  Created by Elf Sundae on 16/2/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACFeedbackViewController.h"
#import <ESFramework/ESApp.h>
#import <AppComponents/AppComponentsApp.h>
#import <IconFontsKit/IFFontAwesome.h>

@implementation ACFeedbackViewController

- (instancetype)init
{
        self = [super init];
        if (self) {
                self.hidesBottomBarWhenPushed = YES;
        }
        return self;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.navigationItem.title = @"意见反馈";
        self.view.backgroundColor = [UIColor es_viewBackgroundColor];
        
        self.contentTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        self.contentTextView.font = [UIFont systemFontOfSize:16.];
        self.contentTextView.enablesReturnKeyAutomatically = YES;
        [self.view addSubview:self.contentTextView];
        
        self.contactTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.contactTextField.font = [UIFont systemFontOfSize:16.];
        self.contactTextField.borderStyle = UITextBorderStyleNone;
        self.contactTextField.backgroundColor = [UIColor whiteColor];
        self.contactTextField.height = ceil(self.contactTextField.font.lineHeight) + 22.;
        self.contactTextField.width = self.view.width;
        [self.contactTextField setCornerRadius:0.001 borderWidth:1. borderColor:[UIColor es_lightBorderColor]];
        UIImageView *leftView = [[UIImageView alloc] initWithImage:[IFFontAwesome imageWithType:IFFAMobile color:[UIColor es_oceanDarkColor] imageSize:CGSizeMake(28., 36.)]];
        self.contactTextField.leftView = leftView;
        self.contactTextField.leftViewMode = UITextFieldViewModeAlways;
        self.contactTextField.placeholder = @"联系方式: 手机号/邮箱/微信/QQ号";
        self.contactTextField.returnKeyType = UIReturnKeySend;
        [self.contactTextField addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [self.view addSubview:self.contactTextField];
        
        ESWeakSelf;
        [self.view addTapGestureHandler:^(UITapGestureRecognizer *gestureRecognizer, UIView *view, CGPoint locationInView) {
                ESStrongSelf;
                [ESApp dismissKeyboard];
        }];
        
        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
                self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交反馈" style:UIBarButtonItemStylePlain target:self action:@selector(commitAction:)];
        [self.contentTextView becomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
        UIColor *barTintColor = (self.navigationController.navigationBar.barTintColor ?: [UINavigationBar appearance].barTintColor);
        if (!barTintColor || barTintColor.es_isLightColor) {
                return UIStatusBarStyleDefault;
        } else {
                return UIStatusBarStyleLightContent;
        }
}

- (void)viewWillLayoutSubviews
{
        [super viewWillLayoutSubviews];
        self.contentTextView.frame = CGRectMake(0.f, self.navigationController.navigationBar.bottom + 15.f, self.view.width, self.contentTextView.font.lineHeight * 4);
        if (self.view.height > 480.f) {
                self.contentTextView.height = self.contentTextView.font.lineHeight * 6;
        }
        self.contactTextField.top = self.contentTextView.bottom;
}

- (void)commitAction:(id)sender
{
        NSString *content = [self.contentTextView.text trim];
        NSString *contact = [self.contactTextField.text trim];
        
        NSString *error = nil;
        if (!ESIsStringWithAnyText(content)) {
                error = @"请填写意见内容";
        } else if (content.length < 5) {
                error = @"反馈内容太少，请描述清楚你的问题";
        } else if (content.length > 300) {
                error = @"意见内容太长，请删减后再提交";
        }
        if (error) {
                ESWeakSelf;
                UIAlertView *alert = [UIAlertView alertViewWithTitle:error message:nil cancelButtonTitle:@"OK" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        ESStrongSelf;
                        [_self.contentTextView becomeFirstResponder];
                } otherButtonTitles:nil, nil];
                [alert show];
                return;
        }
        
        [self commitFeedbackWithContent:content contact:contact];
}

- (void)commitFeedbackWithContent:(NSString *)content contact:(NSString *)contact
{
        //   NSMutableDictionary *params = [ESApp sharedApp].analyticsInformation.mutableCopy;
        //   params[@"content"] = content;
        //   if (ESIsStringWithAnyText(contact)) {
        //           params[@"contact"] = contact;
        //   }
        //
        //   [ESApp dismissKeyboard];
        //
        //   [ESApp showProgressHUDWithTitle:@"提交中..." animated:YES];
        //   ESWeakSelf;
        //   // HTTP request to app server
        //   ESDispatchAfter(2, ^{
        //           [ESApp hideProgressHUD:YES];
        //           ESStrongSelf;
        //           UIAlertView *alert = [UIAlertView alertViewWithTitle:@"感谢反馈！\n我们会尽快处理！" message:nil cancelButtonTitle:@"OK" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        //                   ESStrongSelf;
        //                   [_self.navigationController popViewControllerAnimated:YES];
        //           } otherButtonTitles:nil];
        //           [alert show];
        //   });
}

@end
