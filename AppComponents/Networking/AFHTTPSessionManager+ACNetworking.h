//
//  AFHTTPSessionManager+ACNetworkingAdditions.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>
#import "AFHTTPRequestSerializer+ACNetworking.h"

@interface AFHTTPSessionManager (ACNetworking)

/**
 * Extra request serializer before sending.
 * It will be applied to all requestSerializer managed by this HTTP session manager.
 *
 * @see -[AFHTTPRequestSerializer extraRequestSerializer]
 */
@property (nonatomic, copy) void (^extraRequestSerializer)(AFHTTPRequestSerializer *serializer, NSMutableURLRequest *request, id parameters, NSError *__autoreleasing *error);

/**
 * Returns the full URL for the given `path`.
 */
- (NSURL *)fullURL:(NSString *)path;

/**
 * 返回指定URLString和method的任务， 没有对应task时返回空数组。
 *
 * @param URLString 如果self.baseURL不为nil，URLString可只传路径path。如果URLString传nil，返回符合method的所有请求。
 * @param method 如果method为nil，返回该URL上的所有请求
 */
- (NSArray<NSURLSessionTask *> *)tasksWithURL:(NSString *)URLString method:(NSString *)method;

/**
 * 取消指定URLString和method的任务。
 *
 * @param URLString 如果self.baseURL不为nil，URLString可只传路径path。
 * @param method 如果method为nil，取消该URL上的所有请求
 */
- (void)cancelTasksWithURL:(NSString *)URLString method:(NSString *)method;

/**
 * 取消所有网络任务。
 */
- (void)cancelAllTasks;

@end
