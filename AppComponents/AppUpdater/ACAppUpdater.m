//
//  ACAppUpdater.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACAppUpdater.h"
#import <ESFramework/ESApp.h>
#import <ESFramework/ESStoreHelper.h>
#import <ESFramework/ESFrameworkAdditions.h>

NSString *const ACAppUpdaterNewVersionDidChangeNotification = @"ACAppUpdaterNewVersionDidChangeNotification";

static NSString *__sharedNewVersion = nil;

@implementation ACAppUpdater

+ (NSString *)newVersion
{
        return __sharedNewVersion;
}

+ (void)setNewVersion:(NSString *)newVersion
{
        if (ESIsStringWithAnyText(newVersion) &&
            (!__sharedNewVersion || ![__sharedNewVersion isEqualToString:newVersion])) {
                __sharedNewVersion = newVersion;
                [[NSNotificationCenter defaultCenter] postNotificationName:ACAppUpdaterNewVersionDidChangeNotification object:self];
        }
}

+ (BOOL)newVersionExists
{
        return (ESIsStringWithAnyText([self newVersion]) &&
                ![[self newVersion] isEqualToString:[ESApp appVersion]]);
}

+ (void)checkNewVersionWithData:(NSDictionary *)serverData alertByMinWay:(ACAppUpdateWay)minWay completion:(dispatch_block_t)completion
{
        NSAssert([NSThread isMainThread], @"Please call %s on main thread.", __PRETTY_FUNCTION__);
        if (!ESIsDictionaryWithItems(serverData)) {
                if (completion) completion();
        }
        
        NSString *newVersion = ESStringValue(serverData[ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACAppUpdater_VersionDataKey_LatestVersion), @"version")]);
        if (!newVersion) {
                printf("%s: 数据错误\n", __PRETTY_FUNCTION__);
                if (completion) completion();
                return;
        }
        
        [self setNewVersion:newVersion];
        
        BOOL hasUpdate = [self newVersionExists];
        ACAppUpdateWay way = ESIntValueWithDefault(serverData[ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACAppUpdater_VersionDataKey_UpdateWay), @"way")], ACAppUpdateWayOptional);
        
        BOOL shouldAlert = NO;
        if (ACAppUpdateWayNone == minWay) {
                shouldAlert = YES;
        } else if (hasUpdate && way >= minWay) {
                shouldAlert = YES;
        }
        if (!shouldAlert) {
                if (completion) completion();
                return;
        }
        
        NSString *title = hasUpdate ? @"发现新版本" : @"检查更新";
        NSString *okTitle = hasUpdate ? @"立即更新" : nil;
        NSString *cancelTitle = hasUpdate ? (ACAppUpdateWayForce == way ? nil : @"取消") : @"确定";
        NSString *desc = ESStringValue(serverData[ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACAppUpdater_VersionDataKey_Description), @"desc")]);
        desc = hasUpdate ? desc : @"\n恭喜，当前已经是最新版本！\n";
        NSString *urlString = ESStringValue(serverData[ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACAppUpdater_VersionDataKey_DownloadURL), @"url")]);
        NSURL *url = [NSURL URLWithString:urlString];
        if (!url) {
                // 默认打开AppStore
                url = [ESStoreHelper appStoreLinkForAppID:[ESApp sharedApp].appStoreID
                                         storeCountryCode:ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACAppUpdater_DefaultAppStoreContryCode), ESAppStoreCountryCodeChina)];
        }
        
        ESWeakSelf;
        UIAlertView *alert = [UIAlertView alertViewWithTitle:title message:desc cancelButtonTitle:cancelTitle didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                ESStrongSelf;
                if (buttonIndex != alertView.cancelButtonIndex) {
                        [ESApp openURL:url];
                        if (ACAppUpdateWayForce == way) {
                                exit(0);
                        }
                }
                if (completion) completion();
        } otherButtonTitles:okTitle, nil];
        [alert show];
}

@end
