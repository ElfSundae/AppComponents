//
//  ACConfig.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACConfig.h"
#import <ESFramework/ESFrameworkCore.h>
#import "NSDictionary+ACCoreAdditions.h"

@implementation ACConfig

+ (NSMutableDictionary *)config
{
        static NSMutableDictionary *__gConfig = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __gConfig = [NSMutableDictionary dictionary];
        });
        return __gConfig;
}

+ (id)get:(NSString *)keyPath
{
        return [[self config] ac_valueForKeyPath:keyPath];
}

+ (BOOL)set:(id)object forKeyPath:(NSString *)keyPath
{
        return [[self config] ac_setValue:object forKeyPath:keyPath];
}

+ (void)setWithDictionary:(NSDictionary *)dictionary
{
        if (ESIsDictionaryWithItems(dictionary)) {
                [dictionary enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        [self set:obj forKeyPath:key];
                }];
        }
}

@end
