//
//  NSDictionary+ACCoreAdditions.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NSDictionary+ACCoreAdditions.h"
#import <ESFramework/ESFrameworkAdditions.h>

@implementation NSDictionary (ACCoreAdditions)

- (id)ac_valueForKeyPath:(NSString *)keyPath
{
        if (![keyPath isKindOfClass:[NSString class]]) {
                return nil;
        }
        return [self valueForKeyPath:keyPath];
}

@end


@implementation NSMutableDictionary (ACCoreAdditions)

+ (NSMutableDictionary *)ac_dictionaryFromUserDefaultsWithKey:(NSString *)key defaultValues:(NSDictionary *)defaultValues
{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        if (ESIsDictionaryWithItems(defaultValues)) {
                [result setDictionary:defaultValues];
        }
        NSDictionary *cached = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if (ESIsDictionaryWithItems(cached)) {
                [result setValuesForKeysWithDictionary:cached];
        }
        return result;
}

- (BOOL)ac_setValue:(id)object forKeyPath:(NSString *)keyPath
{
        if (![keyPath isKindOfClass:[NSString class]]) {
                return NO;
        }
        if (![keyPath contains:@"."]) {
                self[keyPath] = object;
                return YES;
        }
        NSArray *keys = [keyPath componentsSeparatedByString:@"."];
        if (keys.count < 2) {
                return NO;
        }
        
        NSUInteger maxIndex = keys.count - 1;
        __block NSMutableString *currentKeyPath = [NSMutableString string];
        __block NSMutableDictionary *mutableCopy = self.mutableCopy;
        [keys each:^(id subKey, NSUInteger idx, BOOL *stop) {
                [currentKeyPath appendFormat:@"%@%@", (currentKeyPath.length > 0 ? @"." : @""), subKey];
                if (idx == maxIndex) {
                        [mutableCopy setValue:object forKeyPath:currentKeyPath];
                        return;
                }
                id currentValue = [mutableCopy valueForKeyPath:currentKeyPath];
                if (!currentValue) {
                        [mutableCopy setValue:[NSMutableDictionary dictionary] forKeyPath:currentKeyPath];
                } else if ([currentValue isKindOfClass:[NSDictionary class]] &&
                           ![currentValue isKindOfClass:[NSMutableDictionary class]]) {
                        [mutableCopy setValue:[currentValue mutableCopy] forKeyPath:currentKeyPath];
                } else if (![currentValue isKindOfClass:[NSDictionary class]]) {
                        mutableCopy = nil;
                        *stop = YES;
                }
        }];
        if (mutableCopy) {
                [self setDictionary:mutableCopy];
                return YES;
        }
        return NO;
}

@end