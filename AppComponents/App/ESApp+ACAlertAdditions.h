//
//  ESApp+ACAlertAdditions.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (ACAlertAdditions)

/**
 * After this time interval, HUD will be auto hidden.
 */
@property (nonatomic) NSTimeInterval timeIntervalForAutoHide;

/**
 * Hides if timeIntervalForAutoHide equals zero.
 */
- (void)hideIfNotAutoHidden:(BOOL)animated;

@end

@interface ESApp (ACAlertAdditions)

/**
 * 返回keyWindow上的progressHUD
 */
- (MBProgressHUD *)progressHUD;
+ (MBProgressHUD *)progressHUD;

/**
 * 移除keyWindow上的progressHUD
 */
- (void)hideProgressHUD:(BOOL)animated;
+ (void)hideProgressHUD:(BOOL)animated;

/**
 * Hides only if the progressHUD of keyWindow is not auto hidden.
 */
- (void)hideProgressHUDIfNotAutoHidden:(BOOL)animated;
+ (void)hideProgressHUDIfNotAutoHidden:(BOOL)animated;

/**
 * 加到keyWindow上的一个progressHUD, 默认样式菊花(MBProgressHUDModeIndeterminate)。
 * 可对返回的MBProgressHUD进一步设置。
 */
- (MBProgressHUD *)showProgressHUDWithTitle:(NSString *)title animated:(BOOL)animated;
+ (MBProgressHUD *)showProgressHUDWithTitle:(NSString *)title animated:(BOOL)animated;

/**
 * 设置并显示keyWindow上的progressHUD为checkmark样式，timeInterval后自动隐藏.
 */
- (MBProgressHUD *)showCheckmarkHUDWithTitle:(NSString *)title timeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated;
+ (MBProgressHUD *)showCheckmarkHUDWithTitle:(NSString *)title timeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated;

/**
 * 显示Tips，自动隐藏。text和detail至少有一个不为nil或空串，其他参数都可以传nil或0
 */
- (MBProgressHUD *)showTips:(NSString *)text detail:(NSString *)detail addToView:(UIView *)view timeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated;
+ (MBProgressHUD *)showTips:(NSString *)text detail:(NSString *)detail addToView:(UIView *)view timeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated;

/**
 * 显示Tips，自动隐藏。默认添加到keyWindow上，1秒后隐藏，显示或隐藏时有Zoom动画
 */
- (MBProgressHUD *)showTips:(NSString *)text;
+ (MBProgressHUD *)showTips:(NSString *)text;

/**
 * 显示Tips，自动隐藏。添加到view上，1秒后隐藏，显示或隐藏时有Zoom动画
 */
- (MBProgressHUD *)showTips:(NSString *)text addToView:(UIView *)view;
+ (MBProgressHUD *)showTips:(NSString *)text addToView:(UIView *)view;

/**
 * 显示Tips，timeInterval 后自动隐藏。
 */
- (MBProgressHUD *)showTips:(NSString *)text timeInterval:(NSTimeInterval)timeInterval;
+ (MBProgressHUD *)showTips:(NSString *)text timeInterval:(NSTimeInterval)timeInterval;

/**
 * 强制隐藏view上的所有Tips。view为nil时隐藏keyWindow上的所有tips.
 */
- (void)hideTipsOnView:(UIView *)view animated:(BOOL)animated;
+ (void)hideTipsOnView:(UIView *)view animated:(BOOL)animated;

+ (NSString *)localNetworkErrorAlertTitle;

/**
 * Shows a tips view that title got from kACConfigKey_ACNetworking_LocalNetworkErrorAlertTitle
 */
- (MBProgressHUD *)showLocalNetworkErrorTipsWithSuperview:(UIView *)superview;
+ (MBProgressHUD *)showLocalNetworkErrorTipsWithSuperview:(UIView *)superview;

/**
 * Shows an UIAlertView that title got from kACConfigKey_ACNetworking_LocalNetworkErrorAlertTitle
 */
- (UIAlertView *)showLocalNetworkErrorAlertWithCompletion:(dispatch_block_t)completion;
+ (UIAlertView *)showLocalNetworkErrorAlertWithCompletion:(dispatch_block_t)completion;

@end
