//
//  NSMutableURLRequest+ACNetworking.m
//  AppComponents
//
//  Created by Elf Sundae on 16/03/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NSMutableURLRequest+ACNetworking.h"
#import <AppComponents/ACConfig.h>

@implementation NSMutableURLRequest (ACNetworking)

- (void)setUserAgent:(NSString *)userAgent
{
        [self setValue:userAgent forHTTPHeaderField:@"User-Agent"];
}

- (void)setCSRFTokenForHTTPHeaderField
{
        NSString *CSRFTokenNameForRequestHeader = ESStringValue(ACConfigGet(kACConfigKey_ACNetworking_RequestHeaderCSRFTokenName));
        if (CSRFTokenNameForRequestHeader) {
                NSString *CSRFTokenCookieName = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_CSRFTokenCookieName), kACNetworkingCSRFTokenCookieName);
                NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:self.URL];
                if (cookies) {
                        for (NSHTTPCookie *c in cookies) {
                                if ([c.name isEqualToString:CSRFTokenCookieName]) {
                                        [self setValue:c.value forHTTPHeaderField:CSRFTokenNameForRequestHeader];
                                        break;
                                }
                        }
                }
        }
}

- (void)setAPITokenForHTTPHeaderField:(NSString *)token
{
        NSString *APITokenNameForRequestHeader = ESStringValue(ACConfigGet(kACConfigKey_ACNetworking_RequestHeaderApiTokenName));
        if (APITokenNameForRequestHeader) {
                [self setValue:token forHTTPHeaderField:APITokenNameForRequestHeader];
        }
}

@end
