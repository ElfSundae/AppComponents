//
//  ESApp+ACAlertAdditions.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ESApp (ACAlertAdditions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ProgressHUD

/**
 * 返回keyWindow上的progressHUD
 */
- (MBProgressHUD *)progressHUD;
/**
 * 移除keyWindow上的progressHUD
 */
- (void)hideProgressHUD:(BOOL)animated;
/**
 * 加到keyWindow上的一个progressHUD, 默认样式菊花(MBProgressHUDModeIndeterminate)。
 * 可对返回的MBProgressHUD进一步设置。
 */
- (MBProgressHUD *)showProgressHUDWithTitle:(NSString *)title animated:(BOOL)animated;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ProgressHUD CustomView

/**
 * 设置并显示keyWindow上的progressHUD为checkmark样式，timeInterval后自动隐藏.
 */
- (MBProgressHUD *)showCheckmarkHUDWithTitle:(NSString *)title timeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Tips

/**
 * 显示Tips，自动隐藏。text和detail至少有一个不为nil或空串，其他参数都可以传nil或0
 */
- (MBProgressHUD *)showTips:(NSString *)text detail:(NSString *)detail addToView:(UIView *)view timeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated;
/**
 * 显示Tips，自动隐藏。默认添加到keyWindow上，1秒后隐藏，显示或隐藏时有Zoom动画
 */
- (MBProgressHUD *)showTips:(NSString *)text;
/**
 * 显示Tips，自动隐藏。添加到view上，1秒后隐藏，显示或隐藏时有Zoom动画
 */
- (MBProgressHUD *)showTips:(NSString *)text addToView:(UIView *)view;
/**
 * 强制隐藏view上的所有Tips。view为nil时隐藏keyWindow上的所有tips.
 */
- (void)hideTipsOnView:(UIView *)view animated:(BOOL)animated;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Common Alert

- (MBProgressHUD *)showLocalNetworkErrorTipsWithSuperview:(UIView *)superview;
- (UIAlertView *)showLocalNetworkErrorAlertWithCompletion:(dispatch_block_t)completion;

@end
