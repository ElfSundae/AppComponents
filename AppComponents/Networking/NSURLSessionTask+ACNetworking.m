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

/**
 * -[NSURLSession dataTaskWithURL:] returns different class on different OS versions.
 *
 *  iOS 7: __NSCFLocalDataTask << __NSCFLocalSessionTask << __NSCFURLSessionTask << NSObject
 *  iOS 8: __NSCFLocalDataTask << __NSCFLocalSessionTask << NSURLSessionTask << NSObject
 *  iOS 9: __NSCFLocalDataTask << __NSCFLocalSessionTask << __NSCFURLSessionTask << NSURLSessionTask << NSObject
 *
 * `_ACURLSessionTaskHacking` hacks class exactly returns from `dataTaskWithURL` to add category methods.
 */
@interface _ACURLSessionTaskHacking : NSObject
@end

@implementation _ACURLSessionTaskHacking

+ (void)load
{
    NSURLSessionDataTask *instance = [[NSURLSession sessionWithConfiguration:
                                       [NSURLSessionConfiguration ephemeralSessionConfiguration]]
                                      dataTaskWithURL:[NSURL URLWithString:@""]];

    Class cls = [instance class];

    [self _addSelector:@selector(shouldParseResponse) forClass:cls];
    [self _addSelector:@selector(setShouldParseResponse:) forClass:cls];
    [self _addSelector:@selector(alertFailedResponseCode) forClass:cls];
    [self _addSelector:@selector(setAlertFailedResponseCode:) forClass:cls];
    [self _addSelector:@selector(alertFailedResponseCodeUsingTips) forClass:cls];
    [self _addSelector:@selector(setAlertFailedResponseCodeUsingTips:) forClass:cls];
    [self _addSelector:@selector(alertNetworkError) forClass:cls];
    [self _addSelector:@selector(setAlertNetworkError:) forClass:cls];
    [self _addSelector:@selector(alertNetworkErrorUsingTips) forClass:cls];
    [self _addSelector:@selector(setAlertNetworkErrorUsingTips:) forClass:cls];
    [self _addSelector:@selector(responseCode) forClass:cls];
    [self _addSelector:@selector(setResponseCode:) forClass:cls];
    [self _addSelector:@selector(responseMessage) forClass:cls];
    [self _addSelector:@selector(setResponseMessage:) forClass:cls];
}

+ (BOOL)_addSelector:(SEL)selector forClass:(Class)cls
{
    Method method = class_getInstanceMethod(self, selector);
    return class_addMethod(cls, selector, method_getImplementation(method), method_getTypeEncoding(method));
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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-implementation"

@implementation NSURLSessionTask (ACNetworking)
@end

#pragma clang diagnostic pop
