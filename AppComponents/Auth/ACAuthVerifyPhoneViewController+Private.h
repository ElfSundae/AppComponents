//
//  ACAuthVerifyPhoneViewController+Private.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACAuthVerifyPhoneViewController.h"
#import <ESFramework/ESFrameworkCore.h>
#import <ESFramework/ESFrameworkAdditions.h>

// “发送验证码”的按钮相对于 textFiled 的 rightView 的右边距
#define kUAVPSendCodeButtonRightMargin      20.f

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

@interface ACAuthVerifyPhoneViewController (Action)

///=============================================
/// @name Action Handlers
///=============================================

- (void)sendCodeButtonAction:(id)sender;
- (void)commitButtonAction:(id)sender;

///=============================================
/// @name Private methods
///=============================================

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


@end
