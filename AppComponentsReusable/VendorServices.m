//
//  VendorServices.m
//  Sample
//
//  Created by Elf Sundae on 16/04/03.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "VendorServices.h"
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

// ShareSDK: http://mob.com
// pod 'MOBFoundation_IDFA'
// pod 'ShareSDK3'
// pod 'ShareSDK3/ShareSDKUI'
// pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
// pod 'ShareSDK3/ShareSDKPlatforms/QQ'
#if defined(kShareSDKAppKey)
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDK3/WXApi.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#endif

@implementation ESApp (VendorServices)

- (void)setupVendorServices
{
#define _DISPATCH_ONCE_BEGIN    static dispatch_once_t onceToken; dispatch_once(&onceToken,^{
#define _DISPATCH_ONCE_END      });
        
        _DISPATCH_ONCE_BEGIN
        
        // 配置AppComponents
        NSDictionary *config =
        @{ kACConfigKey_ACUDID_KeychainAccessGroup: @"B2A67GNGYE.*",
           kACConfigKey_ACAppUpdater_DefaultAppStoreContryCode: ESAppStoreCountryCodeChina
           };
        ACConfigSetDictionary(config);
        
        // 开启状态栏菊花
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
        [XGPush startApp:kXGPushAppID appKey:kXGPushAppKey];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ESAppDidReceiveRemoteNotificationNotification_XGPushHandler:) name:ESAppDidReceiveRemoteNotificationNotification object:nil];
#endif
        
#if defined(kShareSDKAppKey)
        [ShareSDK registerApp:kShareSDKAppKey
              activePlatforms:@[@(SSDKPlatformTypeWechat),
                                @(SSDKPlatformTypeQQ),
                                @(SSDKPlatformTypeSMS),
                                @(SSDKPlatformTypeCopy),
                                @(SSDKPlatformTypeMail)]
                     onImport:^(SSDKPlatformType platformType)
         {
                 switch (platformType) {
                         case SSDKPlatformTypeWechat:
                                 [ShareSDKConnector connectWeChat:[WXApi class]];
                                 break;
                         case SSDKPlatformTypeQQ:
                                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                 break;
                         default:
                                 break;
                 }
         } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                 switch (platformType) {
                         case SSDKPlatformTypeWechat:
                                 [appInfo SSDKSetupWeChatByAppId:kWeChatAppID appSecret:kWeChatAppSecret];
                                 break;
                         case SSDKPlatformTypeQQ:
                                 [appInfo SSDKSetupQQByAppId:kQQAppID appKey:kQQAppKey authType:SSDKAuthTypeBoth];
                                 break;
                         default:
                                 break;
                 }
         }];
#endif
        _DISPATCH_ONCE_END
}

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

#if defined(kShareSDKAppKey)
- (BOOL)showShareWithData:(NSDictionary *)shareData shareStateChanged:(void (^)(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end))shareStateChanged
{
        if (!ESIsDictionaryWithItems(shareData)) {
                return NO;
        }
        
        // platforms: [...] 要显示的platformTypes
        if (!ESIsArrayWithItems(shareData[@"platforms"])) {
                return NO;
        }
        NSMutableArray *platforms = [NSMutableArray array];
        for (id pf in shareData[@"platforms"]) {
                NSInteger pfType = ESIntegerValue(pf);
                if (pfType > 0) {
                        [platforms addObject:@(pfType)];
                }
        }
        if (!ESIsArrayWithItems(platforms)) {
                return NO;
        }
        
        NSString *type = ESStringValue(shareData[@"type"]);
        SSDKContentType contentType;
        if ([type isEqualToString:@"text"]) {
                contentType = SSDKContentTypeText;
        } else if ([type isEqualToString:@"web"]) {
                contentType = SSDKContentTypeWebPage;
        } else if ([type isEqualToString:@"app"]) {
                contentType = SSDKContentTypeApp;
        } else {
                return NO;
        }
        
        NSString *title = ESStringValue(shareData[@"title"]);
        NSString *text = ESStringValue(shareData[@"text"]);
        id icon = shareData[@"icon"] ?: [UIImage imageNamed:@"AppIcon60x60@3x.png"];
        id image = shareData[@"img"];
        NSURL *url = ESURLValue(shareData[@"url"]);
        NSString *mailRecipient = ESStringValue(shareData[@"mail_recv"]);
        NSString *smsRecipient = ESStringValue(shareData[@"sms_recv"]);
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:text
                                         images:image
                                            url:url
                                          title:title
                                           type:SSDKContentTypeAuto];
        for (id _pfType in platforms) {
                SSDKPlatformType pfType = [_pfType unsignedIntegerValue];
                if (SSDKPlatformSubTypeWechatSession == pfType ||
                    SSDKPlatformSubTypeWechatTimeline == pfType ||
                    SSDKPlatformSubTypeWechatFav == pfType) {
                        [shareParams SSDKSetupWeChatParamsByText:text
                                                           title:title
                                                             url:url
                                                      thumbImage:icon
                                                           image:image
                                                    musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil
                                                            type:contentType
                                              forPlatformSubType:pfType];
                } else if (SSDKPlatformSubTypeQQFriend == pfType ||
                           SSDKPlatformSubTypeQZone == pfType) {
                        [shareParams SSDKSetupQQParamsByText:text
                                                       title:title
                                                         url:url
                                                  thumbImage:icon
                                                       image:image
                                                        type:(SSDKContentTypeApp == contentType ? SSDKContentTypeWebPage : contentType)
                                          forPlatformSubType:pfType];
                } else if (SSDKPlatformTypeMail == pfType) {
                        NSMutableString *mailContent = [NSMutableString string];
                        if (ESIsStringWithAnyText(text)) [mailContent appendFormat:@"%@\n", text];
                        if (ESIsStringWithAnyText(url.absoluteString)) [mailContent appendFormat:@"%@\n", url.absoluteString];
                        [shareParams SSDKSetupMailParamsByText:mailContent
                                                         title:title
                                                        images:image
                                                   attachments:nil
                                                    recipients:(mailRecipient ? @[mailRecipient] : nil)
                                                  ccRecipients:nil bccRecipients:nil
                                                          type:image ? SSDKContentTypeImage : SSDKContentTypeText];
                } else if (SSDKPlatformTypeSMS == pfType || SSDKPlatformTypeCopy == pfType) {
                        NSMutableString *smsContent = [NSMutableString string];
                        if (ESIsStringWithAnyText(title)) [smsContent appendFormat:@"%@\n\n", title];
                        if (ESIsStringWithAnyText(text)) [smsContent appendFormat:@"%@\n", text];
                        if (ESIsStringWithAnyText(url.absoluteString)) [smsContent appendFormat:@"%@", url.absoluteString];
                        if (SSDKPlatformTypeSMS == pfType) {
                                [shareParams SSDKSetupSMSParamsByText:smsContent title:nil images:nil attachments:nil
                                                           recipients:(smsRecipient ? @[smsRecipient] : nil)
                                                                 type:SSDKContentTypeText];
                        } else if (SSDKPlatformTypeCopy == pfType) {
                                [shareParams SSDKSetupCopyParamsByText:smsContent
                                                                images:nil url:nil type:SSDKContentTypeText];
                        }
                }
        }
        
        void (^notifyShareStateChanged)(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) =
        ^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                if (shareStateChanged) {
                        shareStateChanged(state, platformType, userData, contentEntity, error, end);
                }
        };
        
        if (platforms.count == 1) {
                SSDKPlatformType pfType = [platforms.firstObject unsignedIntegerValue];
                notifyShareStateChanged(SSDKResponseStateBegin, pfType, nil, nil, nil, YES);
                [ShareSDK share:pfType
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                         notifyShareStateChanged(state, pfType, userData, contentEntity, error, YES);
                 }];
        } else {
                SSUIShareActionSheetController *shareController =
                [ShareSDK showShareActionSheet:nil
                                         items:platforms
                                   shareParams:shareParams
                           onShareStateChanged:notifyShareStateChanged];
                [shareController.directSharePlatforms addObjectsFromArray:platforms];
        }
        
        return YES;
}
#endif

@end

@implementation UIDevice (VendorServices)

#ifdef kTalkingDataAppKey
+ (NSString *)talkingDataDeviceID
{
        return [TalkingData getDeviceID];
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
