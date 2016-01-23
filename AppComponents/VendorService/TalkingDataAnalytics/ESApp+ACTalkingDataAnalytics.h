//
//  ESApp+ACTalkingDataAnalytics.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>

@interface ESApp (ACTalkingDataAnalytics)

/**
 * 初始化TalkingData.
 * https://www.talkingdata.com/
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

@end
