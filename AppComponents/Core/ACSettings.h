//
//  ACSettings.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppComponents/NSDictionary+ACCoreAdditions.h>

FOUNDATION_EXTERN NSString *const ACSettingsIdentifierKey;

/**
 * `ACSettings`封装了`NSDictionary`的持久化操作，数据保存在`[NSUserDefaults standardUserDefaults]`。
 *
 * 例如用`ACSettings`保存和设置用户资料信息、App配置信息等。
 */
@interface ACSettings : NSObject

- (instancetype)initWithIdentifier:(NSString *)identifier defaultValues:(NSDictionary *)defaultValues;

- (NSString *)identifier;
- (NSString *)key;
/**
 * Returns all settings values.
 */
- (NSMutableDictionary *)dictionary;

- (void)cleanUp;
- (void)save;
/**
 * Deletes ACSettings from storage.
 */
+ (void)deleteWithIdentifier:(NSString *)identifier;

/**
 * Returns the full key which used to store ACSettings object, e.g. NSUserDefaults' defaultName, file's filename.
 */
+ (NSString *)keyForIdentifier:(NSString *)identifier;

@end

@interface ACSettings (Subclassing)
+ (NSDictionary<NSString *,id> *)savedDictionaryForKey:(NSString *)key;
+ (void)saveDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;
+ (void)deleteDictionaryForKey:(NSString *)key;
@end