//
//  ACNetworkingHelper.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACNetworkingHelper.h"
#import <ESFramework/ESFrameworkCore.h>
#import <ESFramework/ESFrameworkAdditions.h>
#import <ESFramework/ESApp.h>
#import <AppComponents/ACEncryptor.h>
#import "ACURLSessionTaskInfo.h"

@implementation ACNetworkingHelper

+ (double)timestampFromURLResponse:(NSHTTPURLResponse *)response
{
        double timestamp = 0.0;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSString *dateString = ESStringValue(response.allHeaderFields[@"Date"]);
                timestamp = [[NSDate dateWithRFC1123String:dateString] timeIntervalSince1970];
        }
        return timestamp;
}

+ (void)setUserAgentForURLRequest:(NSMutableURLRequest *)request
{
        [request setValue:[ESApp sharedApp].userAgent forHTTPHeaderField:@"User-Agent"];
}

+ (void)setCSRFTokenForURLRequest:(NSMutableURLRequest *)request
{
        NSString *CSRFTokenCookieName = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_CSRFTokenCookieName), kACNetworkingCSRFTokenCookieName);
        NSString *CSRFTokenNameForRequestHeader = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_RequestHeaderCSRFTokenName), kACNetworkingRequestHeaderCSRFTokenName);
        if (CSRFTokenCookieName && CSRFTokenNameForRequestHeader) {
                NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
                if (cookies) {
                        for (NSHTTPCookie *c in cookies) {
                                if ([c.name isEqualToString:CSRFTokenCookieName]) {
                                        [request setValue:c.value forHTTPHeaderField:CSRFTokenNameForRequestHeader];
                                        break;
                                }
                        }
                }
        }
}

+ (void)setAPIToken:(NSString *)token forURLRequest:(NSMutableURLRequest *)request
{
        NSString *APITokenNameForRequestHeader = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_RequestHeaderApiTokenName), kACNetworkingRequestHeaderApiTokenName);
        if (APITokenNameForRequestHeader && [token isKindOfClass:[NSString class]]) {
                [request setValue:token forHTTPHeaderField:APITokenNameForRequestHeader];
        }
}

+ (NSDictionary *)parseResponseObject:(id)responseObject code:(ACNetworkingResponseCode *)outCode message:(NSString **)outMessage errors:(NSArray **)outErrors
{
        NSString *ResponseCodeKey = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_ResponseKeyCode), kACNetworkingResponseCodeKey);
        NSString *ResponseMessageKey = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_ResponseKeyMessage), kACNetworkingResponseMessageKey);
        NSString *ResponseErrorsKey = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_ResponseKeyErrors), kACNetworkingResponseErrorsKey);
        
        NSDictionary *result = responseObject;
        ACNetworkingResponseCode code = ACNetworkingResponseCodeError;
        if (!ESIsDictionaryWithItems(result) ||
            !ESIntegerVal(&code, result[ResponseCodeKey])) {
                code = ACNetworkingResponseCodeServerInternalError;
                result = @{ ResponseCodeKey: @(code),
                                    ResponseMessageKey: _e(@"500 Internal Server Error") };
        }
        
        NSString *message = ESStringValue(result[ResponseMessageKey]);
        if (code != ACNetworkingResponseCodeSuccess && !ESIsStringWithAnyText(message)) {
                switch (code) {
                        case ACNetworkingResponseCodeUserAuthFailed:
                                message = _e(@"Unauthorized");
                                break;
                        case ACNetworkingResponseCodeRequestAuthFailed:
                                message = _e(@"Forbidden");
                                break;
                        case ACNetworkingResponseCodeServerInternalError:
                                message = _e(@"Internal Server Error");
                                break;
                        case ACNetworkingResponseCodeServerIsMaintaining:
                                message = _e(@"Service Temporarily Unavailable");
                                break;
                        case ACNetworkingResponseCodeError:
                                message = _e(@"Error");
                                break;
                        case ACNetworkingResponseCodeUnknown:
                        default:
                                message = _e(@"Unknown Error");
                }
        }
        
        NSArray *errors = result[ResponseErrorsKey];
        if ([errors isKindOfClass:[NSArray class]]) {
                errors = [errors matchesObjects:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                        return ESIsStringWithAnyText(obj);
                }];
        } else if (ESIsStringWithAnyText(errors)) {
                errors = @[errors];
        } else {
                errors = nil;
        }
        
        if (outCode) *outCode = code;
        if (outMessage) *outMessage = message;
        if (outErrors) *outErrors = errors;

        return result;
}

+ (NSDictionary *)parseResponseObject:(id)responseObject code:(ACNetworkingResponseCode *)outCode message:(NSString **)outMessage errorsString:(NSString **)outErrorsString
{
        NSArray *errors = nil;
        NSDictionary *result = [self parseResponseObject:responseObject code:outCode message:outMessage errors:&errors];
        if (outErrorsString) {
                if (ESIsArrayWithItems(errors)) {
                        NSMutableString *tmpErrors = [NSMutableString string];
                        for (NSString *str in errors) {
                                if (ESIsStringWithAnyText(str)) {
                                        [tmpErrors appendFormat:@"%@\n", str];
                                }
                        }
                        *outErrorsString = [tmpErrors trim];
                } else {
                        *outErrorsString = nil;
                }
        }
        return result;
}

+ (BOOL)parseResponseFailedError:(NSError *)error title:(NSString **)outTitle message:(NSString **)outMessage
{
        NSString *title = nil;
        NSString *message = nil;
        
        if ([error isKindOfClass:[NSError class]]) {
                if (error.isLocalNetworkError) {
                        title = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_LocalNetworkErrorAlertTitle), kACNetworkingLocalNetworkErrorAlertTitle);
                } else if (error.localizedDescription && error.localizedRecoverySuggestion) {
                        title = error.localizedDescription;
                        message = error.localizedRecoverySuggestion;
                } else if (error.localizedDescription && error.localizedFailureReason) {
                        title = error.localizedDescription;
                        message = error.localizedFailureReason;
                } else if (error.localizedDescription) {
                        title = @"Error";
                        message = error.localizedDescription;
                } else {
                        title = @"Error";
                        message = NSStringWith(@"%@ Error: %@", error.domain, @(error.code));
                }
                
                if (outTitle) *outTitle = title;
                if (outMessage) *outMessage = message;
                return YES;
        }
        return NO;
}

+ (void)parseResponseAPIToken:(NSHTTPURLResponse *)response
{
        double timestamp = [self timestampFromURLResponse:response];
        if (timestamp > 1453000000.0) {
                [self setTimestampOffset:(timestamp - [NSDate timeIntervalSince1970])];
        }
}

+ (NSString *)generateAPIToken
{
        NSString *password = ESStringValue(ACConfigGet(kACConfigKey_ACNetworking_ApiTokenPassword));
        if (password) {
                double timestamp = [NSDate timeIntervalSince1970] + [self timestampOffset];
                NSString *text = [NSString stringWithFormat:@"%.0f", timestamp];
                return [ACEncryptor sampleEncrypt:text password:password];
        }
        return nil;
}


static double __sharedTimestampOffset = 0.0;
+ (double)timestampOffset
{
        return __sharedTimestampOffset;
}

+ (void)setTimestampOffset:(double)offset
{
        __sharedTimestampOffset = offset;
}

@end
