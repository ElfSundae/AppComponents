//
//  ESApp+ACVendorServices.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACVendorServices.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation ESApp (ACVendorServices)

- (BOOL)setupUmengAnalyticsWithAppKey:(NSString *)appKey reportPolicy:(int)reportPolicy logSendInterval:(double)seconds enableCrashReport:(BOOL)enableCrashReport
{
        Class MobClickClass = NSClassFromString(@"MobClick");
        if (MobClickClass && ESIsStringWithAnyText(appKey)) {
                ESInvokeSelector(MobClickClass, @selector(setAppVersion:), NULL, [self.class appVersionWithBuildVersion]);
                ESInvokeSelector(MobClickClass, @selector(setLogSendInterval:), NULL, seconds);
                ESInvokeSelector(MobClickClass, @selector(setCrashReportEnabled:), NULL, enableCrashReport);
                ESInvokeSelector(MobClickClass, @selector(startWithAppkey:reportPolicy:channelId:), NULL, appKey, reportPolicy, self.appChannel);
                return YES;
        }
        return NO;
}

- (BOOL)setupTalkingDataAnalyticsWithAppKey:(NSString *)appKey enableCrashReport:(BOOL)enableCrashReport;
{
        Class TalkingDataClass = NSClassFromString(@"TalkingData");
        if (TalkingDataClass && ESIsStringWithAnyText(appKey)) {
                ESInvokeSelector(TalkingDataClass, @selector(setVersionWithCode:name:), NULL, [self.class appVersionWithBuildVersion], self.appDisplayName);
                ESInvokeSelector(TalkingDataClass, @selector(setExceptionReportEnabled:), NULL, enableCrashReport);
                ESInvokeSelector(TalkingDataClass, @selector(sessionStarted:withChannelId:), NULL, appKey, self.appChannel);
                return YES;
        }
        return NO;
}

- (NSString *)talkingDataDeviceID
{
        return [NSClassFromString(@"TalkingData") performSelector:@selector(getDeviceID)];
}

- (BOOL)setupXGPushWithAppID:(uint32_t)appID appKey:(NSString *)appKey
{
        Class XGSettingClass = NSClassFromString(@"XGSetting");
        Class XGPushClass = NSClassFromString(@"XGPush");
        if (XGSettingClass && XGPushClass) {
                [[XGSettingClass performSelector:@selector(getInstance)] performSelector:@selector(setChannel:) withObject:self.appChannel];
                ESInvokeSelector(XGPushClass, @selector(startApp:appKey:), NULL, appID, appKey);
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_ac_ESAppDidReceiveRemoteNotificationNotification_XGPushHandler:) name:ESAppDidReceiveRemoteNotificationNotification object:nil];
                return YES;
        }
        return NO;
}

- (void)_ac_ESAppDidReceiveRemoteNotificationNotification_XGPushHandler:(NSNotification *)notification
{
        Class XGPushClass = NSClassFromString(@"XGPush");
        if (XGPushClass) {
                if (notification.userInfo[UIApplicationLaunchOptionsRemoteNotificationKey]) {
                        ESInvokeSelector(XGPushClass, @selector(handleLaunching:), NULL, notification.userInfo[UIApplicationLaunchOptionsRemoteNotificationKey]);
                } else if (notification.userInfo[ESAppRemoteNotificationKey]) {
                        ESInvokeSelector(XGPushClass, @selector(handleReceiveNotification:), NULL, notification.userInfo[ESAppRemoteNotificationKey]);
                }
        }
}

- (BOOL)setupMobSMSWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret enableContactFriends:(BOOL)enableContactFriends
{
        Class SMSSDKClass = NSClassFromString(@"SMSSDK");
        if (SMSSDKClass) {
                ESInvokeSelector(SMSSDKClass, @selector(enableAppContactFriends:), NULL, enableContactFriends);
                ESInvokeSelector(SMSSDKClass, @selector(registerApp:withSecret:), NULL, appKey, appSecret);
                return YES;
        }
        return NO;
}


@end

#pragma clang diagnostic pop