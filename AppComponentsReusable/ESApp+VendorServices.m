//
//  ESApp+VendorServices.m
//  Sample
//
//  Created by Elf Sundae on 16/04/03.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+VendorServices.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

// 友盟统计：http://www.umeng.com/
// pod 'APIService-UmengAnalytics'
#ifdef kUmengAppKey
#import <APIService-UmengAnalytics/MobClick.h>
#endif

// TalkingData统计：https://www.talkingdata.com/
// pod 'APIService-TalkingData'
#ifdef kTalkingDataAppKey
#import <APIService-TalkingData/TalkingData.h>
#endif

// Mob短信验证码：http://sms.mob.com/#/sms
// pod 'MOBFoundation_IDFA'
// pod 'SMSSDK'
#if defined(kMobSMSAppKey) && defined(kMobSMSAppSecret)
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#endif

// 腾讯信鸽推送：http://xg.qq.com
// pod 'APIService-XGPush'
#if defined(kXGPushAppID) && defined(kXGPushAppKey)
#import <APIService-XGPush/XGSetting.h>
#import <APIService-XGPush/XGPush.h>
#endif

@implementation ESApp (VendorServices)

- (void)setupVendorServices
{
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
#ifdef kUmengAppKey
        [MobClick setAppVersion:[self.class appVersionWithBuildVersion]];
        [MobClick setLogSendInterval:120];
        [MobClick setCrashReportEnabled:NO];
        [MobClick startWithAppkey:kUmengAppKey reportPolicy:SEND_INTERVAL channelId:self.appChannel];
#endif
        
#ifdef kTalkingDataAppKey
        [TalkingData setVersionWithCode:[self.class appVersionWithBuildVersion] name:self.appDisplayName];
        [TalkingData setExceptionReportEnabled:NO];
        [TalkingData sessionStarted:kTalkingDataAppKey withChannelId:self.appChannel];
#endif
        
#if defined(kMobSMSAppKey) && defined(kMobSMSAppSecret)
        [SMSSDK enableAppContactFriends:NO];
        [SMSSDK registerApp:kMobSMSAppKey withSecret:kMobSMSAppSecret];
#endif
        
#if defined(kXGPushAppID) && defined(kXGPushAppKey)
        [[XGSetting getInstance] setChannel:self.appChannel];
        [XGPush startApp:ESUIntValue(kXGPushAppID) appKey:kXGPushAppKey];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ESAppDidReceiveRemoteNotificationNotification_XGPushHandler:) name:ESAppDidReceiveRemoteNotificationNotification object:nil];
#endif
}

#ifdef kTalkingDataAppKey
+ (NSString *)talkingDataDeviceID
{
        return [TalkingData getDeviceID];
}
#endif

#if defined(kXGPushAppID) && defined(kXGPushAppKey)
- (void)ESAppDidReceiveRemoteNotificationNotification_XGPushHandler:(NSNotification *)notification
{
        if (notification.userInfo[UIApplicationLaunchOptionsRemoteNotificationKey]) {
                [XGPush handleLaunching:notification.userInfo[UIApplicationLaunchOptionsRemoteNotificationKey]];
        } else if (notification.userInfo[ESAppRemoteNotificationKey]) {
                [XGPush handleReceiveNotification:notification.userInfo[ESAppRemoteNotificationKey]];
        }
}
#endif

@end

#if defined(kXGPushAppID) && defined(kXGPushAppKey)
@implementation ACRemoteNotificationXGPushService

+ (void)load
{
        [ACRemoteNotificationServiceRegister registerClass:self forServiceType:ACRemoteNotificationServiceTypeXGPush];
}

- (void)registerDevice:(NSData *)deviceToken deviceTokenString:(NSString *)deviceTokenString account:(NSString *)account tags:(NSArray *)tags completion:(void (^)(BOOL succeed))completion
{
        [XGPush initForReregister:^{
                [XGPush setAccount:account];
                [XGPush registerDevice:deviceToken successCallback:^{
                        [[self class] setTags:tags];
                        completion(YES);
                } errorCallback:^{
                        completion(NO);
                }];
        }];
}

- (void)unregisterDevice:(void (^)(BOOL succeed))completion
{
        [XGPush unRegisterDevice:^{
                if (completion) completion(YES);
        } errorCallback:^{
                if (completion) completion(NO);
        }];
}

+ (void)setTags:(NSArray *)tags
{
        [tags enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]] && [(NSString *)obj length] > 0) {
                        NSString *t = (NSString *)obj;
                        [XGPush setTag:t successCallback:^{
                                printf("%s setTag \"%s\" succeed.\n", NSStringFromClass([self class]).UTF8String, t.UTF8String);
                        } errorCallback:^{
                                printf("%s setTag \"%s\" failed.\n", NSStringFromClass([self class]).UTF8String, t.UTF8String);
                        }];
                }
        }];
}

@end
#endif /* ACRemoteNotificationXGPushService */
