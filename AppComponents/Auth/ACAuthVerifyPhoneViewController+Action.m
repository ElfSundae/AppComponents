//
//  ACAuthVerifyPhoneViewController+Action.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACAuthVerifyPhoneViewController+Private.h"
#import <SMS_SDK/SMSSDK.h>
#import <AppComponents/ESApp+ACAlertAdditions.h>

@implementation ACAuthVerifyPhoneViewController (Action)

- (void)confirmSendCodeToPhone:(NSString *)phoneNumber codeType:(ACAuthVerifyPhoneCodeType)codeType fromSecondaryButton:(BOOL)fromSecondaryButton
{
        if (!ESIsStringWithAnyText(phoneNumber)) return;
        
        NSString *askTitle = nil;
        NSString *askMessage = nil;
        NSString *askOKTitle = nil;
        NSString *askCancelTitle = @"取消";
        if (ACAuthVerifyPhoneCodeTypeSMS == codeType && !fromSecondaryButton) {
                askTitle = NSStringWith(@"我们将发送验证码短信到手机：\n%@", phoneNumber);
                askOKTitle = @"好";
        } else if (ACAuthVerifyPhoneCodeTypeSMS == codeType && fromSecondaryButton) {
                askTitle = @"没有接听到来电？\n\n我们可以发送验证码短信到您的手机。";
                askOKTitle = @"接收验证码短信";
        } else if (ACAuthVerifyPhoneCodeTypePhoneCall == codeType && !fromSecondaryButton) {
                askTitle = NSStringWith(@"我们将致电：\n%@\n语音播报验证码，请接听来电", phoneNumber);
                askOKTitle = @"好";
        } else if (ACAuthVerifyPhoneCodeTypePhoneCall == codeType && fromSecondaryButton) {
                askTitle = @"收不到验证码短信？\n\n我们可以致电您的手机，语音播报验证码。如不希望被来电打扰请继续等待短信验证码。";
                askOKTitle = @"接听语音验证码";
        }
        if (!askTitle || !askOKTitle) {
                return;
        }
        
        ESWeakSelf;
        // 第一次询问时用cancelButtonTitle，以明显确认按钮
        UIAlertView *alert = [UIAlertView alertViewWithTitle:askTitle message:askMessage cancelButtonTitle:(fromSecondaryButton ? askCancelTitle : askOKTitle) didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                ESStrongSelf;
                if (!fromSecondaryButton && buttonIndex == alertView.cancelButtonIndex) {
                        [_self sendCodeToPhone:phoneNumber codeType:codeType];
                } else if (fromSecondaryButton && buttonIndex != alertView.cancelButtonIndex) {
                        [_self sendSecondaryCodeToPhone:phoneNumber codeType:codeType];
                }
        } otherButtonTitles:(fromSecondaryButton ? askOKTitle : askCancelTitle), nil];
        [alert show];
}

- (void)sendCodeToPhone:(NSString *)phoneNumber codeType:(ACAuthVerifyPhoneCodeType)codeType
{
        [[self class] setSharedDateOfPreviousSendingCode:[NSDate date]];
        [self startTimerIfNeeded];
        
        [self.view endEditing:YES]; // 关闭键盘, 键盘可能挡住progressHUD
        
        
        ESWeakSelf;
        void (^resultHandler)(NSError *) = ^(NSError *error) {
                [[ESApp sharedApp] hideProgressHUD:YES];
                ESStrongSelf;
                
                if (error) {
                        [[_self class] setSharedDateOfPreviousSendingCode:nil];
                        [_self stopTimer];
                        [_self updateUI];
                        NSString *errorMessage = nil;
                        if (457 == error.code) {
                                errorMessage = @"请输入正确的手机号！";
                        } else {
                                errorMessage = NSStringWith(@"%@[%@]", error.localizedDescription, @(error.code));
                        }
                        UIAlertView *errorAlert = [UIAlertView alertViewWithTitle:@"验证码发送失败" message:errorMessage cancelButtonTitle:@"OK" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                ESStrongSelf;
                                [_self.phoneTextField becomeFirstResponder];
                        } otherButtonTitles: nil];
                        [errorAlert show];
                } else {
                        [[_self class] setSharedPhoneNumber:phoneNumber];
                        _self.canShowSendSecondaryCodeButton = YES;
                        [_self updateUI];
                        NSString *tipsString = (ACAuthVerifyPhoneCodeTypeSMS == codeType) ? @"短信发送成功，请查收😀" :
                        (ACAuthVerifyPhoneCodeTypePhoneCall == codeType ? @"发送成功，请接听来电😀" : @"发送成功");
                        [[ESApp sharedApp] showTips:tipsString detail:nil addToView:nil timeInterval:2 animated:YES];
                        ESDispatchAfter(2, ^{
                                ESStrongSelf;
                                [[ESApp sharedApp] hideProgressHUD:YES];
                                [_self.codeTextFiled becomeFirstResponder];
                        });
                }
        };
        
        [[ESApp sharedApp] showProgressHUDWithTitle:@"发送中..." animated:YES];
        [SMSSDK getVerificationCodeByMethod:(SMSGetCodeMethod)codeType phoneNumber:phoneNumber zone:@"86" customIdentifier:self.SMSSignature result:resultHandler];
}

- (void)sendSecondaryCodeToPhone:(NSString *)phoneNumber codeType:(ACAuthVerifyPhoneCodeType)codeType
{
        [self.view endEditing:YES]; // 关闭键盘, 键盘可能挡住progressHUD
        
        ESWeakSelf;
        void (^resultHandler)(NSError *) = ^(NSError *error) {
                [[ESApp sharedApp] hideProgressHUD:YES];
                ESStrongSelf;
                
                if (error) {
                        NSString *errorMessage = nil;
                        if (457 == error.code) {
                                errorMessage = @"请输入正确的手机号！";
                        } else {
                                errorMessage = NSStringWith(@"%@[%@]", error.localizedDescription, @(error.code));
                        }
                        UIAlertView *errorAlert = [UIAlertView alertViewWithTitle:@"验证码发送失败" message:errorMessage cancelButtonTitle:@"OK" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                ESStrongSelf;
                                [_self.phoneTextField becomeFirstResponder];
                        } otherButtonTitles: nil];
                        [errorAlert show];
                } else {
                        _self.canShowSendSecondaryCodeButton = NO;
                        [_self updateUI];
                        NSString *tipsString = (ACAuthVerifyPhoneCodeTypeSMS == codeType) ? @"短信发送成功，请查收😀" :
                        (ACAuthVerifyPhoneCodeTypePhoneCall == codeType ? @"发送成功，请接听来电😀" : @"发送成功");
                        [[ESApp sharedApp] showTips:tipsString detail:nil addToView:nil timeInterval:2 animated:YES];
                        ESDispatchAfter(2, ^{
                                ESStrongSelf;
                                [[ESApp sharedApp] hideProgressHUD:YES];
                                [_self.codeTextFiled becomeFirstResponder];
                        });
                }
        };
        
        [[ESApp sharedApp] showProgressHUDWithTitle:@"发送中..." animated:YES];
        [SMSSDK getVerificationCodeByMethod:(SMSGetCodeMethod)codeType phoneNumber:phoneNumber zone:@"86" customIdentifier:self.SMSSignature result:resultHandler];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Action Handler

- (void)sendCodeButtonAction:(id)sender
{
        BOOL fromSecondarySendButton = (sender == self.sendSecondaryCodeButton);
        NSString *phoneNumber = nil;
        
        if (!fromSecondarySendButton && ![self canSendCode:&phoneNumber timeRemains:NULL]) {
                return;
        } else if (fromSecondarySendButton && !(phoneNumber = [[self class] validatePhoneNumber:self.phoneTextField.text])) {
                return;
        }
        
        ACAuthVerifyPhoneCodeType codeType = ACAuthVerifyPhoneCodeTypeSMS;
        if (!fromSecondarySendButton) {
                codeType = (ACAuthVerifyPhoneCodeType)[self.supportedCodeTypes.firstObject integerValue];
        } else if (self.supportedCodeTypes.count > 1) {
                codeType = (ACAuthVerifyPhoneCodeType)[self.supportedCodeTypes[1] integerValue];
        } else {
                return;
        }
        
        [self confirmSendCodeToPhone:phoneNumber codeType:codeType fromSecondaryButton:fromSecondarySendButton];
}

- (void)commitButtonAction:(id)sender
{
        NSString *phone = /*[[self class] sharedPhoneNumber] ?: */[[self class] validatePhoneNumber:self.phoneTextField.text];
        if (!phone) return;
        
        NSString *code = self.codeTextFiled.text.trim;
        if (![code isKindOfClass:[NSString class]] || code.length < 4) {
                return;
        }
        NSDictionary *data = @{ @"phone" : phone,
                                @"zone" : [[self class] sharedPhoneZone] ?: @"86",
                                @"code": code};
        if (self.verifyHandler) {
                self.verifyHandler(self, data);
        }
}

@end
