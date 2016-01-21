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
 */
@interface ACHTTPSessionManager : AFHTTPSessionManager

@property (nonatomic, strong) ACHTTPRequestSerializer *requestSerializer;

/**
 * Process completion of dataTask.
 */
- (void)ac_dataTaskCompletionHandler:(NSURLSessionTask *)task
                            response:(NSURLResponse *)response
                      responseObject:(id)responseObject
                               error:(NSError *)error
                     originalHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))originalHandler;

@end
