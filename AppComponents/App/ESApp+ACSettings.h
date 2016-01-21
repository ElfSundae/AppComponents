//
//  ESApp+ACSettings.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>
#import <AppComponents/ACSettings.h>

FOUNDATION_EXTERN NSString *const ACAppUserSettingsIdentifierPrefix;

@interface ESApp (ACSettings)

/**
 * 针对某用户的settings, App可以重写getter方法返回跟用户相关的ACSettings.
 */
- (ACSettings *)userSettings;

/**
 * Returns the shared ACSettings instance.
 */
- (ACSettings *)sharedUserSettingsWithUserIdentifier:(NSString *)uid defaultValues:(NSDictionary *)defaultValues;
/**
 * Returns settingsIdentifier for uid: "ACAppUserSettingsIdentifierPrefix + uid"
 */
- (NSString *)userSettingsIdentifierForUserIdentifier:(NSString *)uid;

@end
