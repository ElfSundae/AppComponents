//
//  AppComponentsDefines.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ACUDID
#define kACConfigKey_ACUDID     @"ACUDID"
#define kACConfigKey_ACUDID_IDFADisabled        kACConfigKey_ACUDID@".IDFADisabled" // default: NO
#define kACConfigKey_ACUDID_KeychainAccessGroup kACConfigKey_ACUDID@".KeychainAccessGroup" // default: nil, e.g. @"TeamID.*"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ACAdViewManager
#define kACConfigKey_ACAdViewManager    @"ACAdViewManager"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner         kACConfigKey_ACAdViewManager@".AdConfigKey.Banner" // @"banner"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_Image   kACConfigKey_ACAdViewManager@".AdConfigKey.Banner_Image" // @"image"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_URL     kACConfigKey_ACAdViewManager@".AdConfigKey.Banner_URL" // @"url"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_UmengEventID kACConfigKey_ACAdViewManager@".AdConfigKey.Banner_UmengEventID" // "umeng_event_id"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_Width   kACConfigKey_ACAdViewManager@".AdConfigKey.Banner_Width" // "width", 默认使用keyWindow的宽度
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_Height  kACConfigKey_ACAdViewManager@".AdConfigKey.Banner_Height" // "height"

#define kACConfigKey_ACAdViewManager_AdConfigValue_Banner_Height kACConfigKey_ACAdViewManager@".AdConfigValue.Banner_Height" // @(50.f)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ACNetworking
#define kACConfigKey_ACNetworking @"ACNetworking"
#define kACConfigKey_ACNetworking_BaseURL               kACConfigKey_ACNetworking@".baseURL" // NSURL or NSString, default is nil
#define kACConfigKey_ACNetworking_RequestTimeout        kACConfigKey_ACNetworking@".RequestTimeout" // default is 45.0
#define kACConfigKey_ACNetworking_MaxConcurrentRequestCount     kACConfigKey_ACNetworking@".MaxConcurrentRequestCount" // default is 3

/// 网络连接失败时的弹窗title, default is kACNetworkingLocalNetworkErrorAlertTitle
#define kACConfigKey_ACNetworking_LocalNetworkErrorAlertTitle   kACConfigKey_ACNetworking@".LocalNetworkErrorAlertTitle"
/// 发送请求时设置ApiToken到request的header, name为nil时不传ApiToken, default is kACNetworkingRequestHeaderApiTokenName
#define kACConfigKey_ACNetworking_RequestHeaderApiTokenName     kACConfigKey_ACNetworking@".RequestHeaderApiTokenName"
/// 发送请求时将Cookie中的CSRF-Token传到request的header，name为nil时不传CSRF-Token. default is kACNetworkingRequestHeaderCSRFTokenName
#define kACConfigKey_ACNetworking_RequestHeaderCSRFTokenName    kACConfigKey_ACNetworking@".RequestHeaderCSRFTokenName"
/// 加密Api Token时用的密码, default is nil
#define kACConfigKey_ACNetworking_ApiTokenPassword              kACConfigKey_ACNetworking@".ApiTokenPassword"
/// Cookie中CSRF Token的名字, default is kACNetworkingCSRFTokenCookieName
#define kACConfigKey_ACNetworking_CSRFTokenCookieName           kACConfigKey_ACNetworking@".CSRFTokenCookieName"
/// default is @"code"
#define kACConfigKey_ACNetworking_ResponseKeyCode               kACConfigKey_ACNetworking@".ResponseKeyCode"
/// default is @"msg"
#define kACConfigKey_ACNetworking_ResponseKeyMessage            kACConfigKey_ACNetworking@".ResponseKeyMessage"
/// default is @"errors"
#define kACConfigKey_ACNetworking_ResponseKeyErrors             kACConfigKey_ACNetworking@".ResponseKeyErrors"


#define kACNetworkingRequestHeaderApiTokenName  @"X-API-TOKEN"
#define kACNetworkingRequestHeaderCSRFTokenName @"X-CSRF-TOKEN"
#define kACNetworkingCSRFTokenCookieName        @"XSRF-TOKEN"
#define kACNetworkingResponseCodeKey    @"code"
#define kACNetworkingResponseMessageKey @"msg"
#define kACNetworkingResponseErrorsKey  @"errors"
#define kACNetworkingLocalNetworkErrorAlertTitle NSLocalizedString(@"Network is not connected.", nil)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ACAppUpdater
#define kACConfigKey_ACAppUpdater @"ACAppUpdater"
#define kACConfigKey_ACAppUpdater_VersionDataKey_LatestVersion  kACConfigKey_ACAppUpdater@".AppVersion.LatestVersion" // version
#define kACConfigKey_ACAppUpdater_VersionDataKey_UpdateWay      kACConfigKey_ACAppUpdater@".AppVersion.UpdateWay" // way
#define kACConfigKey_ACAppUpdater_VersionDataKey_Description    kACConfigKey_ACAppUpdater@".AppVersion.Description" // desc
#define kACConfigKey_ACAppUpdater_VersionDataKey_DownloadURL    kACConfigKey_ACAppUpdater@".AppVersion.DownloadURL" // url
#define kACConfigKey_ACAppUpdater_DefaultAppStoreContryCode     kACConfigKey_ACAppUpdater@".DefaultAppStoreContryCode" // default is nil

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ACApp
#define kACConfigKey_ACApp @"ACApp"
/// Default is 1.2
#define kACConfigKey_ACApp_DefaultTipsTimeInterval              kACConfigKey_ACApp@".DefaultTipsTimeInterval"
/// Default is MBProgressHUDAnimationFade
#define kACConfigKey_ACApp_DefaultTipsAnimationType             kACConfigKey_ACApp@".DefaultTipsAnimationType"

#define kACAppDefaultTipsTimeInterval   1.3

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ACAuth
#define kACConfigKey_ACAuth @"ACAuth"

