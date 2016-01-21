//
//  NSDictionary+ACCoreAdditions.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ACCoreAdditions)

/**
 * keyPath支持小数点分割的字符串。例如 @"a.b.c" 对应 self[@"a"][@"b"][@"c"] 的值
 */
- (id)ac_valueForKeyPath:(NSString *)keyPath;

@end

@interface NSMutableDictionary (ACCoreAdditions)

/**
 * Returns dictionary which backed on NSUserDefaults with the given key.
 */
+ (NSMutableDictionary *)ac_dictionaryFromUserDefaultsWithKey:(NSString *)key defaultValues:(NSDictionary *)defaultValues;

/**
 * keyPath支持小数点分割的字符串。例如 @"a.b.c" 对应 self[@"a"][@"b"][@"c"] 的值
 */
- (BOOL)ac_setValue:(id)object forKeyPath:(NSString *)keyPath;

@end