//
//  ESApp+ACUmengAnalytics.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACUmengAnalytics.h"

@implementation ESApp (ACUmengAnalytics)

- (BOOL)setupUmengAnalyticsWithAppKey:(NSString *)appKey reportPolicy:(ReportPolicy)reportPolicy logSendInterval:(double)seconds enableCrashReport:(BOOL)enableCrashReport
{
        if (ESIsStringWithAnyText(appKey)) {
                [MobClick setAppVersion:[self.class appVersionWithBuildVersion]];
                [MobClick setLogSendInterval:seconds];
                [MobClick setCrashReportEnabled:enableCrashReport];
                [MobClick startWithAppkey:appKey reportPolicy:reportPolicy channelId:self.appChannel];
                return YES;
        }
        return NO;
}

@end
