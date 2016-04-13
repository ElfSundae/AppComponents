//
//  ACRemoteNotificationServiceRegister.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACRemoteNotificationServiceRegister.h"
#import <objc/runtime.h>

@implementation ACRemoteNotificationServiceRegister

+ (NSMutableDictionary *)allServiceClasses
{
        static NSMutableDictionary *__gServiceClasses = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __gServiceClasses = [NSMutableDictionary dictionary];
        });
        return __gServiceClasses;
}

+ (BOOL)registerClass:(Class)serviceClass forServiceType:(ACRemoteNotificationServiceType)serviceType
{
        if (class_conformsToProtocol(serviceClass, @protocol(ACRemoteNotificationServiceProtocol))) {
                [self allServiceClasses][@(serviceType)] = serviceClass;
                return YES;
        }
        return NO;
}

+ (Class)classForServiceType:(ACRemoteNotificationServiceType)serviceType
{
        return [self allServiceClasses][@(serviceType)];
}

@end
