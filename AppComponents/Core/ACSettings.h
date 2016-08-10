//
//  ACSettings.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const ACSettingsIdentifierKey;

/**
 * `ACSettings`封装了`NSDictionary`的持久化操作.
 *
 * 例如用`ACSettings`保存和设置用户资料信息、App配置信息等。
 */
@interface ACSettings : NSObject

- (instancetype)initWithIdentifier:(NSString *)identifier defaultValues:(NSDictionary *)defaultValues;

- (NSString *)identifier;

/**
 * The key or filename saved the whole dictionary.
 */
- (NSString *)key;

/**
 * Returns all settings values.
 */
- (NSMutableDictionary *)dictionary;

/**
 * Removes all settings values except identifier.
 */
- (void)cleanUp;

/**
 * Saves dictionary to storage.
 * If there's no settings values or just identifier value, -save will delete this settings from storage by calling +[self deleteDictionaryForKey:]
 */
- (void)save;

/**
 * Deletes ACSettings from storage.
 * Its internal implementation is `[self deleteDictionaryForKey:[self keyForIdentifier:identifier]];`
 */
+ (void)deleteWithIdentifier:(NSString *)identifier;

/**
 * Returns the full key which used to store ACSettings object, e.g. NSUserDefaults' defaultName, file's filename.
 */
+ (NSString *)keyForIdentifier:(NSString *)identifier;

@end

/*!
 * The default persistence of `ACSettings` is `[NSUserDefaults standardUserDefaults]`.
 * You can subclass `ACSettings` to present a different storage.
 */
@interface ACSettings (Subclassing)
+ (NSDictionary<NSString *, id> *)savedDictionaryForKey:(NSString *)key;
+ (void)saveDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;
+ (void)deleteDictionaryForKey:(NSString *)key;
@end
