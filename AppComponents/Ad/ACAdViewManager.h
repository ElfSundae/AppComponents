//
//  ACAdViewManager.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ESFramework/ESFrameworkCore.h>
#import <AppComponents/ACConfig.h>
#import "ACAdBannerView.h"


#define kACConfigKey_ACAdViewManager    @"ACAdViewManager"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner         kACConfigKey_ACAdViewManager@".AdConfigKey.Banner" // @"banner"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_Image   kACConfigKey_ACAdViewManager@".AdConfigKey.Banner_Image" // @"image"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_URL     kACConfigKey_ACAdViewManager@".AdConfigKey.Banner_URL" // @"url"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_UmengEventID kACConfigKey_ACAdViewManager@".AdConfigKey.Banner_UmengEventID" // "umeng_event_id"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_Width   kACConfigKey_ACAdViewManager@".AdConfigKey.Banner_Width" // "width", 默认使用keyWindow的宽度
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_Height  kACConfigKey_ACAdViewManager@".AdConfigKey.Banner_Height" // "height"

#define kACConfigKey_ACAdViewManager_AdConfigValue_Banner_Height kACConfigKey_ACAdViewManager@".AdConfigValue.Banner_Height" // @(50.f)

/**
 * Posted when bannerView is showing or hidden.
 */
ES_EXTERN NSString *ACAdBannerViewDidUpdateNotification;

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
