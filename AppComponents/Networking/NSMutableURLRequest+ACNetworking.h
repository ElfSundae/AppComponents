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
 * The value of CSRF token is got from Cookie which named `ACConfigGet(kACConfigKey_ACNetworking_CSRFTokenCookieName)`.
 * default name is kACNetworkingCSRFTokenCookieName ("XSRF-TOKEN").
 * The name of HTTP header field is got from `ACConfigGet(kACConfigKey_ACNetworking_RequestHeaderCSRFTokenName)`, 
 * if the value of kACConfigKey_ACNetworking_RequestHeaderCSRFTokenName is not set, CSRF token header will not be set.
 */
- (void)setCSRFTokenForHTTPHeaderField;

/**
 * Sets API token for HTTP header field.
 *
 * The name of HTTP header field is got from `ACConfigGet(kACConfigKey_ACNetworking_RequestHeaderApiTokenName)`,
 * If the value of kACConfigKey_ACNetworking_RequestHeaderApiTokenName is not set, API token header will not be set.
 */
- (void)setAPITokenForHTTPHeaderField:(NSString *)token;

@end
