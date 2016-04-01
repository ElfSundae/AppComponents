//
//  ESApp+ACUmengAnalytics.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>
#import <APIService-UmengAnalytics/MobClick.h>

@interface ESApp (ACUmengAnalytics)

/**
 * 初始化友盟.
 * http://www.umeng.com/
 *
 * @param reportPolicy 发送策略, 建议 SEND_INTERVAL
 * @param logSendInterval 当reportPolicy == SEND_INTERVAL 时设定log发送间隔，单位为秒,最小90秒,最大86400秒(24hour).
 * @param enableCrashReport 是否开启crash日志收集
 *
 * @warning App只能同时开启一家的Crash日志收集服务。
 */
- (BOOL)setupUmengAnalyticsWithAppKey:(NSString *)appKey reportPolicy:(ReportPolicy)reportPolicy logSendInterval:(double)seconds enableCrashReport:(BOOL)enableCrashReport;

@end
