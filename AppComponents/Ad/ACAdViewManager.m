//
//  ACAdViewManager.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACAdViewManager.h"
#import <ESFramework/ESApp.h>

NSString *ACAdBannerViewDidUpdateNotification = @"ACAdBannerViewDidUpdateNotification";

@implementation ACAdViewManager

ES_SINGLETON_IMP(sharedManager);

- (void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Banner

- (void)showAdBanner
{
        if (self.bannerView) {
                if (!self.bannerView.superview) {
                        UIView *superview = nil;
                        if (_superviewForBannerView) {
                                superview = _superviewForBannerView(self.bannerView);
                        } else {
                                superview = [ESApp keyWindow];
                        }
                        
                        if (superview) {
                                [superview addSubview:self.bannerView];
                                [superview bringSubviewToFront:self.bannerView];
                                [[NSNotificationCenter defaultCenter] postNotificationName:ACAdBannerViewDidUpdateNotification object:self.bannerView];
                        }
                }
                return;
        }
        
        if (!ESIsDictionaryWithItems(self.config)) {
                return;
        }
        NSDictionary *bannerConfig = self.config[ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACAdViewManager_AdConfigKey_Banner), @"banner")];
        if (!ESIsDictionaryWithItems(bannerConfig)) {
                return;
        }
        
        NSString *image = ESStringValue(bannerConfig[ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACAdViewManager_AdConfigKey_Banner_Image), @"image")]);
        if (!image) {
                return;
        }
        
        UIWindow *window = [ESApp keyWindow];
        
        NSString *url = ESStringValue(bannerConfig[ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACAdViewManager_AdConfigKey_Banner_URL), @"url")]);
        NSString *umengEventID = ESStringValue(bannerConfig[ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACAdViewManager_AdConfigKey_Banner_UmengEventID), @"umeng_event_id")]);
        CGFloat width = ESFloatValueWithDefault(bannerConfig[ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACAdViewManager_AdConfigKey_Banner_Width), @"width")],
                                                window.bounds.size.width);
        CGFloat height = ESFloatValueWithDefault(bannerConfig[ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACAdViewManager_AdConfigKey_Banner_Height), @"height")],
                                                 ESFloatValueWithDefault(ACConfigGet(kACConfigKey_ACAdViewManager_AdConfigValue_Banner_Height), 50.f));
        
        
        CGRect frame = CGRectMake(0, 0, width, height);
        frame.origin.x = floorf((window.bounds.size.width - frame.size.width) / 2.f);
        frame.origin.y = window.bounds.size.height - frame.size.height;
        if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
                frame.origin.y -= [(UITabBarController *)window.rootViewController tabBar].frame.size.height;
        }
        self.bannerView = [[ACAdBannerView alloc] initWithFrame:frame];
        self.bannerView.imageURL = image;
        self.bannerView.clickToURL = url;
        self.bannerView.umengEventID = umengEventID;
        
        [self showAdBanner];
}

- (void)hideAdBanner
{
        if (self.bannerView) {
                [self.bannerView removeFromSuperview];
                [[NSNotificationCenter defaultCenter] postNotificationName:ACAdBannerViewDidUpdateNotification object:nil];
        }
}

- (void)stopAdBanner
{
        if (self.bannerView) {
                [self.bannerView removeFromSuperview];
                self.bannerView = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:ACAdBannerViewDidUpdateNotification object:nil];
        }
}

- (BOOL)isAdBannerShown
{
        return self.bannerView && self.bannerView.superview;
}

@end
