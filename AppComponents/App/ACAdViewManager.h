//
//  ACAdViewManager.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ESFramework/ESFrameworkCore.h>
#import "ACConfig.h"
#import "ACAdBannerView.h"

/**
 * Posted when bannerView is showing or hidden.
 */
FOUNDATION_EXTERN NSString *ACAdBannerViewDidUpdateNotification;

@interface ACAdViewManager : NSObject

    ES_SINGLETON_DEC(sharedManager);

@property (nonatomic, strong) ACAdBannerView *bannerView;
/**
 * 要显示bannerView到哪个view上。默认为[ESApp keyWindow]
 * 传过来的bannerView是按keyWindow计算的frame(最底部），可以更改bannerView的frame然后返回一个superview
 */
@property (nonatomic, copy) UIView * (^superviewForBannerView)(ACAdBannerView *bannerView);
/**
 * 广告配置
 */
@property (nonatomic, strong) NSDictionary *config;

- (void)showAdBanner;
- (void)hideAdBanner;
- (void)stopAdBanner;
- (BOOL)isAdBannerShown;

@end
