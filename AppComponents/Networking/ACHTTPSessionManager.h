//
//  ACHTTPSessionManager.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>
#import <ESFramework/ESFrameworkCore.h>
#import "ACHTTPRequestSerializer.h"
#import "NSURLSessionTask+ACNetworkingAdditions.h"

/**
 * 支持 CSRF Token 和 API Token的HTTPSessionManager.
 * 解析responseObject为NSDictionary.
 *
 * App的ApiClient可以直接继承ACHTTPSessionManager.
 */
@interface ACHTTPSessionManager : AFHTTPSessionManager

@property (nonatomic, strong) ACHTTPRequestSerializer *requestSerializer;

/**
 * Process completion of task.
 */
- (void)ac_sessionTaskCompletionHandler:(NSURLSessionTask *)task
                            response:(NSURLResponse *)response
                      responseObject:(id)responseObject
                               error:(NSError *)error
                     originalHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))originalHandler;

@end
