//
//  AFHTTPSessionManager+ACNetworkingAdditions.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AFHTTPSessionManager+ACNetworkingAdditions.h"

@implementation AFHTTPSessionManager (ACNetworkingAdditions)

- (NSArray <NSURLSessionTask *> *)tasksWithURL:(NSString *)URLString method:(NSString *)method
{
        NSMutableArray *result = [NSMutableArray array];
        if ([URLString isKindOfClass:[NSString class]]) {
                NSString *fullURLString = [NSURL URLWithString:URLString relativeToURL:self.baseURL].absoluteString;
                NSArray *allTasks = self.tasks;
                for (NSURLSessionTask *t in allTasks) {
                        if ([t.originalRequest.URL.absoluteString isEqualToString:fullURLString]) {
                                if (!method || [method isEqualToString:t.originalRequest.HTTPMethod]) {
                                        [result addObject:t];
                                }
                        }
                }
        }
        return result;
}

- (void)cancelTasksWithURL:(NSString *)URLString method:(NSString *)method
{
        dispatch_async(dispatch_get_main_queue(), ^{
                [[self tasksWithURL:URLString method:method] makeObjectsPerformSelector:@selector(cancel)];
        });
}

- (void)cancelAllTasks:(BOOL)cancelPendingTasks
{
        [self invalidateSessionCancelingTasks:cancelPendingTasks];
}

@end
