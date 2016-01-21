//
//  ESApp+ACSettings.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACSettings.h"

NSString *const ACAppUserSettingsIdentifierPrefix = @"user.";

@implementation ESApp (ACSettings)

- (ACSettings *)sharedUserSettingsWithUserIdentifier:(NSString *)uid defaultValues:(NSDictionary *)defaultValues
{
        static ACSettings *__gUserSettings = nil;
        NSString *identifier = [self userSettingsIdentifierForUserIdentifier:uid];
        if (!__gUserSettings || ![__gUserSettings.settingsIdentifier isEqualToString:identifier]) {
                __gUserSettings = [ACSettings settingsWithIdentifier:identifier defaultValues:defaultValues];
        }
        return __gUserSettings;
}

- (NSString *)userSettingsIdentifierForUserIdentifier:(NSString *)uid
{
        return [NSString stringWithFormat:@"%@%@", ACAppUserSettingsIdentifierPrefix, ESIsStringWithAnyText(uid) ? uid : @""];
}

- (ACSettings *)userSettings
{
        return [self sharedUserSettingsWithUserIdentifier:nil defaultValues:nil];
}

@end
