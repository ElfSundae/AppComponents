//
//  AFHTTPSessionManager+ACNetworkingAdditions.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>

@interface AFHTTPSessionManager (ACNetworkingAdditions)

/**
 * 返回指定URLString和method的任务， 没有对应task时返回空数组。
 *
 * @param URLString 如果self.baseURL不为nil，URLString可只传路径path。
 * @param method 如果method为nil，返回该URL上的所有请求
 */
- (NSArray <NSURLSessionTask *> *)tasksWithURL:(NSString *)URLString method:(NSString *)method;

/**
 * 取消指定URLString和method的任务。
 *
 * @param URLString 如果self.baseURL不为nil，URLString可只传路径path。
 * @param method 如果method为nil，取消该URL上的所有请求
 */
- (void)cancelTasksWithURL:(NSString *)URLString method:(NSString *)method;

/**
 * 取消所有网络任务。
 *
 * @param cancelPendingTasks 是否取消正在等待的task.
 */
- (void)cancelAllTasks:(BOOL)cancelPendingTasks;

@end
