//
//  ACNetworkingHelper.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppComponents/ACNetworkingDefines.h>

@interface ACNetworkingHelper : NSObject

/**
 * Get timestamp from response header "Date".
 */
+ (double)timestampFromURLResponse:(NSHTTPURLResponse *)response;

/**
 * Set `[ESApp sharedApp].userAgent` to HTTP header "User-Agent".
 */
+ (void)setUserAgentForURLRequest:(NSMutableURLRequest *)request;

/**
 * Set Cookie value of "XSRF-TOKEN" to HTTP header "X-CSRF-TOKEN".
 */
+ (void)setCSRFTokenForURLRequest:(NSMutableURLRequest *)request;

/**
 * Set `token` to HTTP header "X-API-TOKEN".
 */
+ (void)setAPIToken:(NSString *)token forURLRequest:(NSMutableURLRequest *)request;

+ (NSDictionary *)parseResponseObject:(id)responseObject
                                 code:(ACNetworkingResponseCode *)outCode
                              message:(NSString **)outMessage
                               errors:(NSArray **)outErrors;

+ (NSDictionary *)parseResponseObject:(id)responseObject
                                 code:(ACNetworkingResponseCode *)outCode
                              message:(NSString **)outMessage
                         errorsString:(NSString **)outErrorsString;

+ (BOOL)parseResponseFailedError:(NSError *)error
                           title:(NSString **)outTitle
                         message:(NSString **)outMessage;

+ (void)parseResponseAPIToken:(NSHTTPURLResponse *)response;

+ (NSString *)generateAPIToken;

/**
 * 服务端与本地的时间戳差异, 服务端时间戳减去本地时间戳
 */
+ (double)timestampOffset;
+ (void)setTimestampOffset:(double)offset;


@end
