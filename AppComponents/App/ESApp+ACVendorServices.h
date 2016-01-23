//
//  ESApp+ACVendorServices.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>

@interface ESApp (ACVendorServices)

/**
 * 初始化友盟. 
 * http://www.umeng.com/
 *
 * @code
 * pod 'APIService-UmengAnalytics'
 * @endcode
 *
 * @param reportPolicy 发送策略, 建议 SEND_INTERVAL
 * @param logSendInterval 当reportPolicy == SEND_INTERVAL 时设定log发送间隔，单位为秒,最小90秒,最大86400秒(24hour).
 * @param enableCrashReport 是否开启crash日志收集
 *
 * @warning App只能开启一家的Crash日志收集服务。
 */
- (BOOL)setupUmengAnalyticsWithAppKey:(NSString *)appKey reportPolicy:(int)reportPolicy logSendInterval:(double)seconds enableCrashReport:(BOOL)enableCrashReport;

/**
 * 初始化TalkingData.
 * https://www.talkingdata.com/
 *
 * @code
 * pod 'APIService-TalkingData'
 * @endcode
 *
 * @param enableCrashReport 是否开启crash日志收集
 *
 * @warning App只能开启一家的Crash日志收集服务。
 */
- (BOOL)setupTalkingDataAnalyticsWithAppKey:(NSString *)appKey enableCrashReport:(BOOL)enableCrashReport;

/**
 * TalkingData的设备UDID.
 */
- (NSString *)talkingDataDeviceID;

/**
 * 初始化信鸽推送. 
 * http://xg.qq.com
 *
 * @code
 * pod 'APIService-XGPush'
 * @endcode
 */
- (BOOL)setupXGPushWithAppID:(uint32_t)appID appKey:(NSString *)appKey;

- (void)_ac_ESAppDidReceiveRemoteNotificationNotification_XGPushHandler:(NSNotification *)notification;

/**
 * 初始化MobSMS.
 * http://sms.mob.com/#/sms
 *
 * @code
 * pod 'MOBFoundation_IDFA'
 * pod 'SMSSDK'
 * @endcode
 */
- (BOOL)setupMobSMSWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret enableContactFriends:(BOOL)enableContactFriends;

@end
