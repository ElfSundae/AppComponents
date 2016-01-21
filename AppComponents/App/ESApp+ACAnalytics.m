//
//  ESApp+ACAnalytics.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACAnalytics.h"
#import <AppComponents/ACConfig.h>

@implementation ESApp (ACAnalytics)

- (BOOL)setupUmengAnalyticsWithAppKey:(NSString *)appKey reportPolicy:(ReportPolicy)policy logSendInterval:(double)seconds
{
        if (ESIsStringWithAnyText(appKey)) {
                [MobClick setAppVersion:[self.class appVersionWithBuildVersion]];
                [MobClick setLogSendInterval:seconds];
                [MobClick setCrashReportEnabled:YES];
                [MobClick startWithAppkey:appKey reportPolicy:policy channelId:self.appChannel];
                return YES;
        }
        return NO;
}

- (BOOL)setupTalkingDataAnalyticsWithAppKey:(NSString *)appKey
{
        if (ESIsStringWithAnyText(appKey)) {
                [TalkingData setVersionWithCode:[self.class appVersionWithBuildVersion] name:[self appDisplayName]];
                [TalkingData setExceptionReportEnabled:NO];
                [TalkingData sessionStarted:appKey withChannelId:self.appChannel];
                return YES;
        }
        return NO;
}

- (NSString *)talkingDataDeviceID
{
        return [TalkingData getDeviceID];
}

@end
