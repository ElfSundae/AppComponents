//
//  NSMutableURLRequest+ACNetworking.h
//  AppComponents
//
//  Created by Elf Sundae on 16/03/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (ACNetworking)

/**
 * Sets userAgent for "User-Agent" HTTP header field.
 */
- (void)setUserAgent:(NSString *)userAgent;

/**
 * Sets CSRF token for HTTP header field.
 *
 * The value of CSRF token is got from Cookie which named `ACConfigGet(kACConfigKey_ACNetworking_CSRFTokenCookieName)`, 
 * default name is "XSRF-TOKEN".
 *
 * The name of HTTP header field is got from `ACConfigGet(kACConfigKey_ACNetworking_RequestHeaderCSRFTokenName)`, 
 * default name is "X-CSRF-TOKEN". And if the value of kACConfigKey_ACNetworking_RequestHeaderCSRFTokenName is
 * [NSNull null], CSRF token header will not be set.
 */
- (void)setCSRFTokenForHTTPHeaderField;

/**
 * Sets API token for HTTP header field.
 *
 * The name of HTTP header field is got from `ACConfigGet(kACConfigKey_ACNetworking_RequestHeaderApiTokenName)`,
 * default name is "X-API-TOKEN".
 *
 * If the `token` is nil or the value of kACConfigKey_ACNetworking_RequestHeaderApiTokenName is [NSNull null],
 * API token will not be set.
 */
- (void)setAPITokenForHTTPHeaderField:(NSString *)token;

@end
