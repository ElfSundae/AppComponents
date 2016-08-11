//
//  ESApp+ACSettings.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACSettings.h"

NSString *const ACAppUserSettingsIdentifierPrefix = @"User.";
NSString *const ACAppConfigIdentifier = @"AppConfig";

@implementation ESApp (ACSettings)

- (ACSettings *)userSettings
{
    static ACSettings *__gUserSettings = nil;
    NSString *identifier = [self userSettingsIdentifierForUserID:[self currentUserID]];
    if (!__gUserSettings || ![__gUserSettings.identifier ?: @"" isEqualToString:identifier ?: @""]) {
        __gUserSettings = [[ACSettings alloc] initWithIdentifier:identifier defaultValues:[self userSettingsDefaults]];
    }
    return __gUserSettings;
}

+ (NSMutableDictionary *)userSettings
{
    return [[[self sharedApp] userSettings] dictionary];
}

+ (void)saveUserSettings
{
    [[[self sharedApp] userSettings] save];
}

- (ACSettings *)appConfig
{
    static ACSettings *__gAppConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([[self class] isFreshLaunch:NULL]) {
            [ACSettings deleteWithIdentifier:ACAppConfigIdentifier];
        }
        __gAppConfig = [[ACSettings alloc] initWithIdentifier:ACAppConfigIdentifier defaultValues:[self appConfigDefaults]];
    });
    return __gAppConfig;
}

+ (NSMutableDictionary *)appConfig
{
    return [[[self sharedApp] appConfig] dictionary];
}

+ (void)saveAppConfig
{
    [[[self sharedApp] appConfig] save];
}

- (NSString *)userSettingsIdentifierForUserID:(NSString *)uid
{
    return [NSString stringWithFormat:@"%@%@", ACAppUserSettingsIdentifierPrefix, ESIsStringWithAnyText(uid) ? uid : @""];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ACSettingsSubclass

@implementation ESApp (ACSettingsSubclass)

- (NSString *)currentUserID
{
    return nil;
}

- (NSDictionary *)userSettingsDefaults
{
    return nil;
}

- (NSDictionary *)appConfigDefaults
{
    return nil;
}

@end
