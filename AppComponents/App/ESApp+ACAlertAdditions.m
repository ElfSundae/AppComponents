//
//  ESApp+ACAlertAdditions.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACAlertAdditions.h"
#import <AppComponents/ACConfig.h>

ESDefineAssociatedObjectKey(timeIntervalForAutoHide);

@implementation MBProgressHUD (ACAlertAdditions)

+ (void)load
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Wdeprecated"
        if ([self instancesRespondToSelector:@selector(hideAnimated:afterDelay:)]) {
                ESSwizzleInstanceMethod(self, @selector(hideAnimated:afterDelay:), @selector(ACAlert_hideAnimated:afterDelay:));
        } else {
                ESSwizzleInstanceMethod(self, @selector(hide:afterDelay:), @selector(ACAlert_hideAnimated:afterDelay:));
        }
#pragma clang diagnostic push
}

- (void)hideIfNotAutoHidden:(BOOL)animated
{
        if (self.timeIntervalForAutoHide > 0) {
                return;
        }
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Wdeprecated"
        if ([self respondsToSelector:@selector(hideAnimated:)]) {
                ESInvokeSelector(self, @selector(hideAnimated:), NULL, animated);
        } else {
                [self hide:animated];
        }
#pragma clang diagnostic pop

}

- (void)ACAlert_hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
        self.timeIntervalForAutoHide = delay;
        [self ACAlert_hideAnimated:animated afterDelay:delay];
}

- (NSTimeInterval)timeIntervalForAutoHide
{
        return [self es_getAssociatedDoubleWithKey:timeIntervalForAutoHideKey defaultValue:0.];
}

- (void)setTimeIntervalForAutoHide:(NSTimeInterval)timeIntervalForAutoHide
{
        [self es_setAssociatedDoubleWithKey:timeIntervalForAutoHideKey value:timeIntervalForAutoHide];
}

@end

@implementation ESApp (ACAlertAdditions)

- (MBProgressHUD *)progressHUD
{
        return [MBProgressHUD HUDForView:[ESApp keyWindow]];
}

+ (MBProgressHUD *)progressHUD
{
        return [[self sharedApp] progressHUD];
}

- (void)hideProgressHUD:(BOOL)animated
{
        [MBProgressHUD hideHUDForView:[ESApp keyWindow] animated:animated];
}

+ (void)hideProgressHUD:(BOOL)animated
{
        [[self sharedApp] hideProgressHUD:animated];
}

- (void)hideProgressHUDIfNotAutoHidden:(BOOL)animated
{
        MBProgressHUD *current = [self progressHUD];
        if (current) {
                current.removeFromSuperViewOnHide = YES;
                [current hideIfNotAutoHidden:animated];
        }
}

+ (void)hideProgressHUDIfNotAutoHidden:(BOOL)animated
{
        [[self sharedApp] hideProgressHUDIfNotAutoHidden:animated];
}

- (MBProgressHUD *)showProgressHUDWithTitle:(NSString *)title animated:(BOOL)animated
{
        [self hideProgressHUD:NO];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[ESApp keyWindow] animated:animated];
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

+ (MBProgressHUD *)showProgressHUDWithTitle:(NSString *)title animated:(BOOL)animated
{
        return [[self sharedApp] showProgressHUDWithTitle:title animated:animated];
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Wdeprecated"
        if ([hud respondsToSelector:@selector(hideAnimated:afterDelay:)]) {
                ESInvokeSelector(hud, @selector(hideAnimated:afterDelay:), NULL, animated, timeInterval);
        } else {
                hud.customView.tintColor = hud.labelColor;
                [hud hide:animated afterDelay:timeInterval];
        }
#pragma clang diagnostic pop
        return hud;
}

+ (MBProgressHUD *)showCheckmarkHUDWithTitle:(NSString *)title timeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated
{
        return [[self sharedApp] showCheckmarkHUDWithTitle:title timeInterval:timeInterval animated:animated];
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([hud respondsToSelector:@selector(label)]) {
                [(UILabel *)[hud valueForKey:@"label"] setText:text];
                [(UILabel *)[hud valueForKey:@"detailsLabel"] setText:detail];
                ESInvokeSelector(hud, @selector(hideAnimated:afterDelay:), NULL, animated, timeInterval);
        } else {
#pragma clang diagnostic ignored "-Wdeprecated"
                hud.labelText = text;
                hud.detailsLabelText = detail;
                [hud hide:animated afterDelay:timeInterval];
        }
#pragma clang diagnostic pop
        return hud;
}

+ (MBProgressHUD *)showTips:(NSString *)text detail:(NSString *)detail addToView:(UIView *)view timeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated
{
        return [[self sharedApp] showTips:text detail:detail addToView:view timeInterval:timeInterval animated:animated];
}

- (MBProgressHUD *)showTips:(NSString *)text addToView:(UIView *)view
{
        return [self showTips:text detail:nil addToView:view timeInterval:0 animated:YES];
}

+ (MBProgressHUD *)showTips:(NSString *)text addToView:(UIView *)view
{
        return [[self sharedApp] showTips:text addToView:view];
}

- (MBProgressHUD *)showTips:(NSString *)text
{
        return [self showTips:text addToView:nil];
}

+ (MBProgressHUD *)showTips:(NSString *)text
{
        return [[self sharedApp] showTips:text];
}

- (void)hideTipsOnView:(UIView *)view animated:(BOOL)animated
{
        if (![view isKindOfClass:[UIView class]]) {
                view = [ESApp keyWindow];
        }
        [MBProgressHUD hideHUDForView:view animated:animated];
}

+ (void)hideTipsOnView:(UIView *)view animated:(BOOL)animated
{
        [[self sharedApp] hideTipsOnView:view animated:animated];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Common Tips

+ (NSString *)localNetworkErrorAlertTitle
{
        return ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACApp_LocalNetworkErrorAlertTitle), kACAppLocalNetworkErrorAlertTitle);
}

- (MBProgressHUD *)showLocalNetworkErrorTipsWithSuperview:(UIView *)superview
{
        return [self showTips:[[self class] localNetworkErrorAlertTitle] addToView:superview];
}

+ (MBProgressHUD *)showLocalNetworkErrorTipsWithSuperview:(UIView *)superview
{
        return [[self sharedApp] showLocalNetworkErrorTipsWithSuperview:superview];
}

- (UIAlertView *)showLocalNetworkErrorAlertWithCompletion:(dispatch_block_t)completion
{
        UIAlertView *alert = [UIAlertView alertViewWithTitle:[[self class] localNetworkErrorAlertTitle]
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

+ (UIAlertView *)showLocalNetworkErrorAlertWithCompletion:(dispatch_block_t)completion
{
        return [[self sharedApp] showLocalNetworkErrorAlertWithCompletion:completion];
}

@end
