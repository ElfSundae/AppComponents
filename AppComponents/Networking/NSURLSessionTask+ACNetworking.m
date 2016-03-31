//
//  NSURLSessionTask+ACNetworkingAdditions.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NSURLSessionTask+ACNetworking.h"
#import <ESFramework/ESFrameworkCore.h>

const ACURLSessionTaskConfig ACURLSessionTaskConfigDefault = { YES, YES, NO, YES, YES };

ESDefineAssociatedObjectKey(taskConfig);
ESDefineAssociatedObjectKey(responseCode);
ESDefineAssociatedObjectKey(responseMessage);
ESDefineAssociatedObjectKey(responseErrors);

@implementation NSURLSessionTask (ACNetworking)

+ (void)load
{
        ESSwizzleInstanceMethod(self, @selector(copyWithZone:), @selector(ac_copyWithZone:));
}

- (id)ac_copyWithZone:(NSZone *)zone
{
        NSURLSessionTask *task = [self ac_copyWithZone:zone];
        if ([task isKindOfClass:[NSURLSessionTask class]]) {
                task.taskConfig = self.taskConfig;
                task.responseCode = self.responseCode;
                task.responseMessage = [self.responseMessage copyWithZone:zone];
                task.responseErrors = [self.responseErrors copyWithZone:zone];
        }
        return task;
}

- (ACURLSessionTaskConfig)taskConfig
{
        NSValue *value = ESGetAssociatedObject(self, taskConfigKey);
        if ([value isKindOfClass:[NSValue class]]) {
                ACURLSessionTaskConfig config = ACURLSessionTaskConfigDefault;
                [value getValue:&config];
                return config;
        }
        return ACURLSessionTaskConfigDefault;
}

- (void)setTaskConfig:(ACURLSessionTaskConfig)config
{
        NSValue *value = [NSValue value:&config withObjCType:@encode(ACURLSessionTaskConfig)];
        ESSetAssociatedObject(self, taskConfigKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)responseCode
{
        return [self es_getAssociatedIntegerWithKey:responseCodeKey defaultValue:0];
}

- (void)setResponseCode:(NSInteger)responseCode
{
        [self es_setAssociatedIntegerWithKey:responseCodeKey value:responseCode];
}

- (NSString *)responseMessage
{
        return [self es_getAssociatedStringWithKey:responseMessageKey defaultValue:nil];
}

- (void)setResponseMessage:(NSString *)responseMessage
{
        [self es_setAssociatedStringWithKey:responseMessageKey value:responseMessage];
}

- (NSString *)responseErrors
{
        return [self es_getAssociatedStringWithKey:responseErrorsKey defaultValue:nil];
}

- (void)setResponseErrors:(NSString *)responseErrors
{
        [self es_setAssociatedStringWithKey:responseErrorsKey value:responseErrors];
}

@end
