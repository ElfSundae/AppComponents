//
//  ACConfig.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACConfig.h"
#import "NSDictionary+ACCoreAdditions.h"

NSMutableDictionary *ACConfig(void)
{
        static NSMutableDictionary *__gConfig = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __gConfig = [NSMutableDictionary dictionary];
        });
        return __gConfig;
}

id ACConfigGet(NSString *keyPath)
{
        return [ACConfig() ac_valueForKeyPath:keyPath];
}

BOOL ACConfigSet(NSString *keyPath, id object)
{
        return [ACConfig() ac_setValue:object forKeyPath:keyPath];
}

void ACConfigSetDictionary(NSDictionary *dictionary)
{
        if (ESIsDictionaryWithItems(dictionary)) {
                for (NSString *key in dictionary.allKeys) {
                        ACConfigSet(key, dictionary[key]);
                }
        }
}

