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
#define kACConfigKey_ACUDID_IDFADisabled        kACConfigKey_ACUDID@ ".IDFADisabled" // default: NO
#define kACConfigKey_ACUDID_KeychainAccessGroup kACConfigKey_ACUDID@ ".KeychainAccessGroup" // default: nil, e.g. @"TeamID.*"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ACApp
#define kACConfigKey_ACApp @"ACApp"
/// Default is kACAppDefaultTipsTimeInterval
#define kACConfigKey_ACApp_DefaultTipsTimeInterval              kACConfigKey_ACApp@ ".DefaultTipsTimeInterval"
/// Default is MBProgressHUDAnimationFade
#define kACConfigKey_ACApp_DefaultTipsAnimationType             kACConfigKey_ACApp@ ".DefaultTipsAnimationType"
/// 网络连接失败时的弹窗title, default is kACNetworkingLocalNetworkErrorAlertTitle
#define kACConfigKey_ACApp_LocalNetworkErrorAlertTitle          kACConfigKey_ACApp@ ".LocalNetworkErrorAlertTitle"

#define kACAppLocalNetworkErrorAlertTitle       @"网络异常，请检查网络连接"
#define kACAppDefaultTipsTimeInterval           1.3

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ACAdViewManager
#define kACConfigKey_ACAdViewManager    @"ACAdViewManager"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner         kACConfigKey_ACAdViewManager@ ".AdConfigKey.Banner" // @"banner"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_Image   kACConfigKey_ACAdViewManager@ ".AdConfigKey.Banner_Image" // @"image"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_URL     kACConfigKey_ACAdViewManager@ ".AdConfigKey.Banner_URL" // @"url"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_UmengEventID kACConfigKey_ACAdViewManager@ ".AdConfigKey.Banner_UmengEventID" // "umeng_event_id"
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_Width   kACConfigKey_ACAdViewManager@ ".AdConfigKey.Banner_Width" // "width", 默认使用keyWindow的宽度
#define kACConfigKey_ACAdViewManager_AdConfigKey_Banner_Height  kACConfigKey_ACAdViewManager@ ".AdConfigKey.Banner_Height" // "height"

#define kACConfigKey_ACAdViewManager_AdConfigValue_Banner_Height kACConfigKey_ACAdViewManager@ ".AdConfigValue.Banner_Height" // @(50.f)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ACAppUpdater
#define kACConfigKey_ACAppUpdater @"ACAppUpdater"
#define kACConfigKey_ACAppUpdater_VersionDataKey_LatestVersion  kACConfigKey_ACAppUpdater@ ".AppVersion.LatestVersion" // version
#define kACConfigKey_ACAppUpdater_VersionDataKey_UpdateWay      kACConfigKey_ACAppUpdater@ ".AppVersion.UpdateWay" // way
#define kACConfigKey_ACAppUpdater_VersionDataKey_Description    kACConfigKey_ACAppUpdater@ ".AppVersion.Description" // desc
#define kACConfigKey_ACAppUpdater_VersionDataKey_DownloadURL    kACConfigKey_ACAppUpdater@ ".AppVersion.DownloadURL" // url
#define kACConfigKey_ACAppUpdater_DefaultAppStoreContryCode     kACConfigKey_ACAppUpdater@ ".DefaultAppStoreContryCode" // default is nil
