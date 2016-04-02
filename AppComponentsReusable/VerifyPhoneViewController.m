//
//  VerifyPhoneViewController.m
//  Sample
//
//  Created by Elf Sundae on 16/04/03.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "VerifyPhoneViewController.h"
#import <AppComponents/AppComponentsApp.h>
#import "ESApp+VendorServices.h"
#if defined(kMobSMSAppKey) && defined(kMobSMSAppSecret)
#import <SMS_SDK/SMSSDK.h>
#endif

@implementation VerifyPhoneViewController

- (void)sendCodeToPhone:(NSString *)phoneNumber codeType:(ACAuthVerifyPhoneCodeType)codeType
{
        [self.view endEditing:YES]; // 关闭键盘, 键盘可能挡住progressHUD
        
#if defined(kMobSMSAppKey) && defined(kMobSMSAppSecret)
        [ESApp showProgressHUDWithTitle:@"发送中..." animated:YES];
        ESWeakSelf;
        [SMSSDK getVerificationCodeByMethod:(SMSGetCodeMethod)codeType
                                phoneNumber:phoneNumber
                                       zone:@"86"
                           customIdentifier:kMobSMSSignature
                                     result:^(NSError *error)
         {
                 [ESApp hideProgressHUD:YES];
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
                         NSString *tipsString = ((ACAuthVerifyPhoneCodeTypeSMS == codeType) ? @"短信发送成功，请查收😀" :
                                                 (ACAuthVerifyPhoneCodeTypePhoneCall == codeType ? @"发送成功，请接听来电😀" :
                                                  @"发送成功"));
                         [ESApp showTips:tipsString detail:nil addToView:nil timeInterval:2 animated:YES];
                         ESDispatchAfter(2, ^{
                                 [ESApp hideProgressHUD:YES];
                                 ESStrongSelf;
                                 [_self.codeTextFiled becomeFirstResponder];
                         });
                 }
         }];
#endif
}

- (void)sendSecondaryCodeToPhone:(NSString *)phoneNumber codeType:(ACAuthVerifyPhoneCodeType)codeType
{
        [self.view endEditing:YES]; // 关闭键盘, 键盘可能挡住progressHUD
        
#if defined(kMobSMSAppKey) && defined(kMobSMSAppSecret)
        [ESApp showProgressHUDWithTitle:@"发送中..." animated:YES];
        ESWeakSelf;
        [SMSSDK getVerificationCodeByMethod:(SMSGetCodeMethod)codeType
                                phoneNumber:phoneNumber
                                       zone:@"86"
                           customIdentifier:kMobSMSSignature
                                     result:^(NSError *error)
         {
                 [ESApp hideProgressHUD:YES];
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
                         NSString *tipsString = ((ACAuthVerifyPhoneCodeTypeSMS == codeType) ? @"短信发送成功，请查收😀" :
                                                 (ACAuthVerifyPhoneCodeTypePhoneCall == codeType ? @"发送成功，请接听来电😀" : @"发送成功"));
                         [ESApp showTips:tipsString detail:nil addToView:nil timeInterval:2 animated:YES];
                         ESDispatchAfter(2, ^{
                                 [ESApp hideProgressHUD:YES];
                                 ESStrongSelf;
                                 [_self.codeTextFiled becomeFirstResponder];
                         });
                 }
         }];
#endif
}

- (void)verifyPhone:(NSString *)phone phoneZone:(NSString *)phoneZone code:(NSString *)code
{
        [self.view endEditing:YES]; // 关闭键盘, 键盘可能挡住progressHUD
        
        [ESApp showProgressHUDWithTitle:nil animated:YES];
        ESWeakSelf;
        ESDispatchOnDefaultQueue(^{
                // verify phone and code
                [NSThread sleepForTimeInterval:2];
                BOOL verifyOK = ESRandomNumber(0, 1);
                
                ESDispatchOnMainThreadAsynchrony(^{
                        [ESApp hideProgressHUD:YES];
                        ESStrongSelf;
                        if (verifyOK) {
                                [[_self class] cleanUp];
                                [_self dismissViewControllerAnimated:YES completion:^{
                                        [UIAlertView showWithTitle:@"Welcome" message:@"Successfully login."];
                                }];
                        } else {
                                _self.codeTextFiled.text = nil;
                                [_self updateUI];
                        }
                        
                });
        });
}

@end
