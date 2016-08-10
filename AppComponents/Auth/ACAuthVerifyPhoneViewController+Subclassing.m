//
//  ACAuthVerifyPhoneViewController+Action.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACAuthVerifyPhoneViewController.h"

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
            [[_self class] setSharedDateOfPreviousSendingCode:[NSDate date]];
            [_self startTimerIfNeeded];
            [_self sendCodeToPhone:phoneNumber codeType:codeType];
        } else if (fromSecondaryButton && buttonIndex != alertView.cancelButtonIndex) {
            [_self sendSecondaryCodeToPhone:phoneNumber codeType:codeType];
        }
    } otherButtonTitles:(fromSecondaryButton ? askOKTitle : askCancelTitle), nil];
    [alert show];
}

- (void)sendCodeToPhone:(NSString *)phoneNumber codeType:(ACAuthVerifyPhoneCodeType)codeType
{
}

- (void)sendSecondaryCodeToPhone:(NSString *)phoneNumber codeType:(ACAuthVerifyPhoneCodeType)codeType
{
}

- (void)verifyPhone:(NSString *)phone phoneZone:(NSString *)phoneZone code:(NSString *)code
{
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
    NSString *phone = /*[[self class] sharedPhoneNumber] ?: */ [[self class] validatePhoneNumber:self.phoneTextField.text];
    if (!phone) return;

    NSString *phoneZone = [[self class] sharedPhoneZone] ?: @"86";

    NSString *code = self.codeTextFiled.text.trim;
    if (![code isKindOfClass:[NSString class]] || code.length < 4) {
        return;
    }

    if (self.verifyHandler) {
        self.verifyHandler(self, @{ @"phone": phone,
                                    @"zone": phoneZone,
                                    @"code": code });
    } else {
        [self verifyPhone:phone phoneZone:phoneZone code:code];
    }
}

@end
