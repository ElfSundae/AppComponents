//
//  ACSettings.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACSettings.h"
#import "NSDictionary+ACCoreAdditions.h"
#import <ESFramework/ESFrameworkCore.h>
#import "ACSettings+Private.h"

NSString *const ACSettingsUserDefaultsKeyPrefix = @"com.0x123.ACSettings.";
NSString *const ACSettingsIdentifierKey = @"__ACSettingsIdentifierKey__";

@implementation ACSettings

+ (instancetype)settingsWithIdentifier:(NSString *)identifier defaultValues:(NSDictionary *)defaultValues
{
        NSString *userDefaultsKey = [self userDefaultsKeyForSettingsIdentifier:identifier];
        ACSettings *settings = (ACSettings *)[self ac_dictionaryFromUserDefaultsWithKey:userDefaultsKey defaultValues:defaultValues];
        [settings _setSettingsIdentifier:identifier];
        return settings;
}

- (NSString *)settingsIdentifier
{
        return ESStringValueWithDefault(self[ACSettingsIdentifierKey], nil);
}

- (NSString *)settingsUserDefaultsKey
{
        return [[self class] userDefaultsKeyForSettingsIdentifier:self.settingsIdentifier];
}

- (void)cleanUpSettings
{
        NSString *identifier = [self settingsIdentifier];
        [self removeAllObjects];
        [self _setSettingsIdentifier:identifier];
}

- (void)saveSettings
{
        NSString *userDefaultsKey = self.settingsUserDefaultsKey;
        if (self.count == 0 ||
            (self.count == 1 && [self.allKeys.firstObject isKindOfClass:[NSString class]] && [self.allKeys.firstObject isEqualToString:ACSettingsIdentifierKey])) {
                // 只剩下settingsIdentifier
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:userDefaultsKey];
        } else {
                [[NSUserDefaults standardUserDefaults] setObject:self forKey:userDefaultsKey];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteSettingsWithIdentifier:(NSString *)identifier
{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self userDefaultsKeyForSettingsIdentifier:identifier]];
}

+ (NSString *)userDefaultsKeyForSettingsIdentifier:(NSString *)identifier
{
        return [NSString stringWithFormat:@"%@%@",
                ACSettingsUserDefaultsKeyPrefix,
                ESIsStringWithAnyText(identifier) ? identifier : @""];
}

@end
