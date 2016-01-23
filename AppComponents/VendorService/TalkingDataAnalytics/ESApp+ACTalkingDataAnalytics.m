//
//  ESApp+ACTalkingDataAnalytics.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACTalkingDataAnalytics.h"
#import <APIService-TalkingData/TalkingData.h>

@implementation ESApp (ACTalkingDataAnalytics)

- (BOOL)setupTalkingDataAnalyticsWithAppKey:(NSString *)appKey enableCrashReport:(BOOL)enableCrashReport;
{
        if (ESIsStringWithAnyText(appKey)) {
                [TalkingData setVersionWithCode:[self.class appVersionWithBuildVersion] name:self.appDisplayName];
                [TalkingData setExceptionReportEnabled:enableCrashReport];
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
