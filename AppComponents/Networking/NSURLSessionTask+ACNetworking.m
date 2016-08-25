//
//  NSURLSessionTask+ACNetworkingAdditions.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NSURLSessionTask+ACNetworking.h"
#import <ESFramework/ESFrameworkCore.h>

ESDefineAssociatedObjectKey(shouldParseResponse);
ESDefineAssociatedObjectKey(alertFailedResponseCode);
ESDefineAssociatedObjectKey(alertFailedResponseCodeUsingTips);
ESDefineAssociatedObjectKey(alertNetworkError);
ESDefineAssociatedObjectKey(alertNetworkErrorUsingTips);
ESDefineAssociatedObjectKey(responseCode);
ESDefineAssociatedObjectKey(responseMessage);

@implementation NSURLSessionTask (ACNetworking)

+ (void)load
{
    ESSwizzleInstanceMethod(self, @selector(copyWithZone:), @selector(ac_copyWithZone:));
}

- (id)ac_copyWithZone:(NSZone *)zone
{
    NSURLSessionTask *task = [self ac_copyWithZone:zone];

    if ([task isKindOfClass:[NSURLSessionTask class]]) {
        task.shouldParseResponse = self.shouldParseResponse;
        task.alertFailedResponseCode = self.alertFailedResponseCode;
        task.alertFailedResponseCodeUsingTips = self.alertFailedResponseCodeUsingTips;
        task.alertNetworkError = self.alertNetworkError;
        task.alertNetworkErrorUsingTips = self.alertNetworkErrorUsingTips;
        task.responseCode = self.responseCode;
        task.responseMessage = [self.responseMessage copyWithZone:zone];
    }

    return task;
}

- (BOOL)shouldParseResponse
{
    return [self es_getAssociatedBooleanWithKey:shouldParseResponseKey defaultValue:YES];
}

- (void)setShouldParseResponse:(BOOL)shouldParseResponse
{
    [self es_setAssociatedBooleanWithKey:shouldParseResponseKey value:shouldParseResponse];
}

- (BOOL)alertFailedResponseCode
{
    return [self es_getAssociatedBooleanWithKey:alertFailedResponseCodeKey defaultValue:YES];
}

- (void)setAlertFailedResponseCode:(BOOL)alertFailedResponseCode
{
    [self es_setAssociatedBooleanWithKey:alertFailedResponseCodeKey value:alertFailedResponseCode];
}

- (BOOL)alertFailedResponseCodeUsingTips
{
    return [self es_getAssociatedBooleanWithKey:alertFailedResponseCodeUsingTipsKey defaultValue:NO];
}

- (void)setAlertFailedResponseCodeUsingTips:(BOOL)alertFailedResponseCodeUsingTips
{
    [self es_setAssociatedBooleanWithKey:alertFailedResponseCodeUsingTipsKey value:alertFailedResponseCodeUsingTips];
}

- (BOOL)alertNetworkError
{
    return [self es_getAssociatedBooleanWithKey:alertNetworkErrorKey defaultValue:YES];
}

- (void)setAlertNetworkError:(BOOL)alertNetworkError
{
    [self es_setAssociatedBooleanWithKey:alertNetworkErrorKey value:alertNetworkError];
}

- (BOOL)alertNetworkErrorUsingTips
{
    return [self es_getAssociatedBooleanWithKey:alertNetworkErrorUsingTipsKey defaultValue:YES];
}

- (void)setAlertNetworkErrorUsingTips:(BOOL)alertNetworkErrorUsingTips
{
    [self es_setAssociatedBooleanWithKey:alertNetworkErrorUsingTipsKey value:alertNetworkErrorUsingTips];
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

@end
