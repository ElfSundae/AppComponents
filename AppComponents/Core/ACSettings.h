//
//  ACSettings.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppComponents/NSDictionary+ACCoreAdditions.h>

FOUNDATION_EXTERN NSString *const ACSettingsUserDefaultsKeyPrefix;
FOUNDATION_EXTERN NSString *const ACSettingsIdentifierKey;

/**
 * ACSettings 提供和持久化用户或App的配置信息。{ NSString : object }
 * 比如app“设置”里的“推送时间”、“主题颜色”等, 比如app是否正在被审核，app开启某活动的时间等。
 *
 * ACSettings 在UserDefaults中的key是 ACSettingsUserDefaultsKeyPrefix + settingsIdentifier
 */
@interface ACSettings : NSMutableDictionary

+ (instancetype)settingsWithIdentifier:(NSString *)identifier defaultValues:(NSDictionary *)defaultValues;

- (NSString *)settingsIdentifier;
- (NSString *)settingsUserDefaultsKey;

- (void)saveSettings;

+ (NSString *)userDefaultsKeyForSettingsIdentifier:(NSString *)identifier;

@end
