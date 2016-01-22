//
//  ACAuthVerifyPhoneViewController+Private.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACAuthVerifyPhoneViewController+Private.h"

@implementation ACAuthVerifyPhoneViewController (Private)

/// 更新各个UI控件的状态
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

- (void)setTextFieldRightButtonTitle:(ESButton *)button title:(NSString *)title enabled:(BOOL)enabled
{
        UITextField *textField = nil;
        if (button == self.sendCodeButton) {
                textField = self.phoneTextField;
        } else if (button == self.sendSecondaryCodeButton) {
                textField = self.codeTextFiled;
        } else {
                NSAssert(0, @"button参数错误");
                return;
        }
        
        if (!ESIsStringWithAnyText(title)) {
                if (textField.rightView) {
                        [button setTitle:nil forState:UIControlStateNormal];
                        [button removeFromSuperview];
                        textField.rightView = nil;
                        textField.rightViewMode = UITextFieldViewModeNever;
                }
                return;
        }
        
        [button setTitle:title forState:UIControlStateNormal];
        if (button.isEnabled != enabled) {
                button.enabled = enabled;
        }
        CGSize buttonSize = [button sizeThatFits:CGSizeMake(textField.width, 0)];
        CGRect buttonFrame = CGRectMake(0.f, 0.f, buttonSize.width, buttonSize.height);
        CGRect rightViewFrame = CGRectZero;
        
        rightViewFrame.size.width = kUAVPSendCodeButtonRightMargin + buttonFrame.size.width;
        rightViewFrame.size.height = textField.height;
        buttonFrame.origin.y = (rightViewFrame.size.height - buttonFrame.size.height) / 2.f;
        button.frame = buttonFrame;
        if (textField.rightView) {
                // 如果当前已经有rightView，设置rightViewFrame时就不能从 originX(0) 开始了
                rightViewFrame.origin.x = textField.rightView.right - rightViewFrame.size.width;
                textField.rightView.frame = rightViewFrame;
        } else {
                UIView *view = [[UIView alloc] initWithFrame:rightViewFrame];
                [view addSubview:button];
                textField.rightView = view;
                textField.rightViewMode = UITextFieldViewModeAlways;
        }
        
}

/// 当前禁止发送的剩余时间（秒）， 如果为0或者负数则可以发送验证码
- (NSTimeInterval)currentTimeRemainsToEnableSendingCode
{
        if (![self.class sharedDateOfPreviousSendingCode]) {
                return 0.0;
        }
        NSTimeInterval total = self.timeIntervalForRetrySendingCode;
        if (total <= 0.0) {
                return 0.0;
        }
        
        NSTimeInterval passed = fabs([[self.class sharedDateOfPreviousSendingCode] timeIntervalSinceNow]);
        return total - passed;
}

- (int)currentTimeRemainsToEnableSendingCodeAsInt
{
        return (int)ceil([self currentTimeRemainsToEnableSendingCode]);
}

- (BOOL)canSendCode:(NSString **)phoneNumber timeRemains:(int *)timeRemains
{
        NSString *currentPhone = [[self class] validatePhoneNumber:self.phoneTextField.text];
        if (phoneNumber) {
                *phoneNumber = [currentPhone copy];
        }
        int currentTimeRemains = self.currentTimeRemainsToEnableSendingCodeAsInt;
        if (timeRemains) {
                *timeRemains = currentTimeRemains;
        }
        
        return (currentPhone && currentTimeRemains <= 0);
}

- (void)startTimerIfNeeded
{
        [self stopTimer];
        
        NSString *phoneNumber = nil;
        int timeRemains = 0;
        if (![self canSendCode:&phoneNumber timeRemains:&timeRemains] &&
            phoneNumber &&
            timeRemains > 0) {
                ESWeakSelf;
                self.retrySendingCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 userInfo:nil repeats:YES block:^(NSTimer *timer) {
                        ESStrongSelf;
                        [_self updateUI];
                }];
                [self.retrySendingCodeTimer fire];
                NSLog(@"retrySendingCodeTimer started.");
        } else {
                [self updateUI];
        }
}

- (void)stopTimer
{
        if (self.retrySendingCodeTimer) {
                [self.retrySendingCodeTimer invalidate];
                self.retrySendingCodeTimer = nil;
                NSLog(@"retrySendingCodeTimer stopped.");
        }
}

@end
