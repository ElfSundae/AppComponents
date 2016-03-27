//
//  ESApp+ACAlertAdditions.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACAlertAdditions.h"
#import <AppComponents/ACConfig.h>

@implementation ESApp (ACAlertAdditions)

- (MBProgressHUD *)progressHUD
{
        return [MBProgressHUD HUDForView:[ESApp keyWindow]];
}

- (void)hideProgressHUD:(BOOL)animated
{
        [MBProgressHUD hideHUDForView:[ESApp keyWindow] animated:animated];
}

- (MBProgressHUD *)showProgressHUDWithTitle:(NSString *)title animated:(BOOL)animated
{
        [self hideProgressHUD:NO];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[ESApp keyWindow] animated:animated];
        // TODO: remove -respondsToSelector: after MBProgressHUD released new Pod version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([hud respondsToSelector:@selector(label)]) {
                [(UILabel *)[hud valueForKey:@"label"] setText:title];
        } else {
#pragma clang diagnostic ignored "-Wdeprecated"
                hud.labelText = title;
        }
#pragma clang diagnostic pop
        return hud;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CustomView

- (MBProgressHUD *)showCheckmarkHUDWithTitle:(NSString *)title timeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated
{
        MBProgressHUD *hud = [self showProgressHUDWithTitle:title animated:animated];
        hud.mode = MBProgressHUDModeCustomView;
        UIImage *image = [[UIImage imageNamed:@"AppComponentsApp.bundle/Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        hud.customView = [[UIImageView alloc] initWithImage:image];
        hud.square = YES;        
        if (timeInterval <= 0.0) {
                timeInterval = ESDoubleValueWithDefault(ACConfigGet(kACConfigKey_ACApp_DefaultTipsTimeInterval), kACAppDefaultTipsTimeInterval);
        }
        // TODO: remove -respondsToSelector: after MBProgressHUD released new Pod version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Wdeprecated"
        if ([hud respondsToSelector:@selector(hideAnimated:afterDelay:)]) {
                ESInvokeSelector(hud, @selector(hideAnimated:afterDelay:), NO, NULL, animated, timeInterval);
        } else {
                hud.customView.tintColor = hud.labelColor;
                [hud hide:animated afterDelay:timeInterval];
        }
#pragma clang diagnostic pop
        return hud;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Tips

- (MBProgressHUD *)showTips:(NSString *)text detail:(NSString *)detail addToView:(UIView *)view timeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated
{
        if (!ESIsStringWithAnyText(text) && !ESIsStringWithAnyText(detail)) {
                return nil;
        }
        if (![view isKindOfClass:[UIView class]]) {
                view = [ESApp keyWindow];
        }
        if (timeInterval <= 0.0) {
                timeInterval = ESDoubleValueWithDefault(ACConfigGet(kACConfigKey_ACApp_DefaultTipsTimeInterval), kACAppDefaultTipsTimeInterval);
        }
        
        [self hideTipsOnView:view animated:NO];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
        hud.mode = MBProgressHUDModeText;
        hud.animationType = ESIntegerValueWithDefault(ACConfigGet(kACConfigKey_ACApp_DefaultTipsAnimationType), MBProgressHUDAnimationFade);
        // TODO: remove -respondsToSelector: after MBProgressHUD released new Pod version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([hud respondsToSelector:@selector(label)]) {
                [(UILabel *)[hud valueForKey:@"label"] setText:text];
                [(UILabel *)[hud valueForKey:@"detailsLabel"] setText:detail];
                ESInvokeSelector(hud, @selector(hideAnimated:afterDelay:), NO, NULL, animated, timeInterval);
        } else {
#pragma clang diagnostic ignored "-Wdeprecated"
                hud.labelText = text;
                hud.detailsLabelText = detail;
                [hud hide:animated afterDelay:timeInterval];
        }
#pragma clang diagnostic pop
        return hud;
}

- (MBProgressHUD *)showTips:(NSString *)text addToView:(UIView *)view
{
        return [self showTips:text detail:nil addToView:view timeInterval:0 animated:YES];
}

- (MBProgressHUD *)showTips:(NSString *)text
{
        return [self showTips:text addToView:nil];
}

- (void)hideTipsOnView:(UIView *)view animated:(BOOL)animated
{
        if (![view isKindOfClass:[UIView class]]) {
                view = [ESApp keyWindow];
        }
        [MBProgressHUD hideHUDForView:view animated:animated];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Common Tips

- (MBProgressHUD *)showLocalNetworkErrorTipsWithSuperview:(UIView *)superview
{
        return [self showTips:ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_LocalNetworkErrorAlertTitle), kACNetworkingLocalNetworkErrorAlertTitle) addToView:superview];
}

- (UIAlertView *)showLocalNetworkErrorAlertWithCompletion:(dispatch_block_t)completion
{
        UIAlertView *alert = [UIAlertView alertViewWithTitle:ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_LocalNetworkErrorAlertTitle), kACNetworkingLocalNetworkErrorAlertTitle)
                                                     message:nil
                                           cancelButtonTitle:@"OK"
                                             didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
                              {
                                      if (completion) {
                                              completion();
                                      }
                              } otherButtonTitles:nil];
        [alert show];
        return alert;
}

@end
