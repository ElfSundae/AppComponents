//
//  ESApp+ACSettings.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACSettings.h"
#import "ESApp+ACSettingsSubclass.h"

NSString *const ACAppUserSettingsIdentifierPrefix = @"user.";
NSString *const ACAppConfigIdentifier = @"appconfig";

@implementation ESApp (ACSettings)

- (ACSettings *)userSettings
{
        static ACSettings *__gUserSettings = nil;
        NSString *identifier = [self userSettingsIdentifierForUserIdentifier:[self currentUserID]];
        if (!__gUserSettings || ![__gUserSettings.settingsIdentifier isEqualToString:identifier]) {
                __gUserSettings = [ACSettings settingsWithIdentifier:identifier defaultValues:[self userSettingsDefaults]];
        }
        return __gUserSettings;
}

- (ACSettings *)appConfig
{
        static ACSettings *__gAppConfig = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                if ([[self class] isFreshLaunch:NULL]) {
                        [ACSettings deleteSettingsWithIdentifier:ACAppConfigIdentifier];
                }
                __gAppConfig = [ACSettings settingsWithIdentifier:ACAppConfigIdentifier defaultValues:[self appConfigDefaults]];
        });
        return __gAppConfig;
}

- (NSString *)userSettingsIdentifierForUserIdentifier:(NSString *)uid
{
        return [NSString stringWithFormat:@"%@%@", ACAppUserSettingsIdentifierPrefix, ESIsStringWithAnyText(uid) ? uid : @""];
}

@end
