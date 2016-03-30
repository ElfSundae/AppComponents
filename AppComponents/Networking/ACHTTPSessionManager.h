//
//  ACHTTPSessionManager.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>
#import <AppComponents/NSURLSessionTask+ACNetworking.h>

@interface ACHTTPSessionManager : AFHTTPSessionManager

/**
 * Process completion of task.
 */
//- (void)ac_sessionTaskCompletionHandler:(NSURLSessionTask *)task
//                            response:(NSURLResponse *)response
//                      responseObject:(id)responseObject
//                               error:(NSError *)error
//                     originalHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))originalHandler;

@end
