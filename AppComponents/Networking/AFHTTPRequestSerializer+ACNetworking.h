//
//  AFHTTPRequestSerializer+ACNetworking.h
//  AppComponents
//
//  Created by Elf Sundae on 16/03/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AFNetworking/AFURLRequestSerialization.h>

@interface AFHTTPRequestSerializer (ACNetworking)

/**
 * Extra request serializer before sending.
 *
 * For example, set user agent, CSRF token to HTTP headers.
 */
@property (nonatomic, copy) void (^extraRequestSerializer)(AFHTTPRequestSerializer *serializer, NSMutableURLRequest *request, id parameters, NSError *__autoreleasing *error);

@end
