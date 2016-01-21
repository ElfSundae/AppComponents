//
//  ESApp+ACAnalytics.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>
#import <APIService-UmengAnalytics/MobClick.h>
#import <APIService-TalkingData/TalkingData.h>

@interface ESApp (ACAnalytics)

/**
 * 初始化友盟.
 *
 * @param policy 发送策略, 建议 SEND_INTERVAL
 * @param logSendInterval 当reportPolicy == SEND_INTERVAL 时设定log发送间隔，单位为秒,最小90秒,最大86400秒(24hour). 
 */
- (BOOL)setupUmengAnalyticsWithAppKey:(NSString *)appKey reportPolicy:(ReportPolicy)policy logSendInterval:(double)logSendInterval;

/**
 * 初始化TalkingData.
 */
- (BOOL)setupTalkingDataAnalyticsWithAppKey:(NSString *)appKey;

/**
 * TalkingData的设备UDID.
 */
- (NSString *)talkingDataDeviceID;

@end
