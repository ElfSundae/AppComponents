//
//  AFHTTPSessionManager+ACNetworkingAdditions.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AFHTTPSessionManager+ACNetworking.h"
#import <ESFramework/ESFrameworkCore.h>

ESDefineAssociatedObjectKey(extraRequestSerializer);

@implementation AFHTTPSessionManager (ACNetworking)

+ (void)load
{
        ESSwizzleInstanceMethod(self, @selector(setRequestSerializer:), @selector(ac_setRequestSerializer:));
}

- (void)ac_setRequestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer
{
        AFHTTPRequestSerializer *old = [self valueForKey:@"requestSerializer"];
        if (old && old.extraRequestSerializer) {
                old.extraRequestSerializer = nil;
        }
        [self ac_setRequestSerializer:requestSerializer];
        AFHTTPRequestSerializer *new = [self valueForKey:@"requestSerializer"];
        if (new) {
                new.extraRequestSerializer = self.extraRequestSerializer;
        }
}

- (void (^)(AFHTTPRequestSerializer *, NSMutableURLRequest *, id, NSError *__autoreleasing *))extraRequestSerializer
{
        return ESGetAssociatedObject(self, extraRequestSerializerKey);
}

- (void)setExtraRequestSerializer:(void (^)(AFHTTPRequestSerializer *, NSMutableURLRequest *, id, NSError *__autoreleasing *))extraRequestSerializer
{
        ESSetAssociatedObject(self, extraRequestSerializerKey, extraRequestSerializer, OBJC_ASSOCIATION_COPY_NONATOMIC);
        self.requestSerializer.extraRequestSerializer = extraRequestSerializer;
}

- (NSURL *)fullURL:(NSString *)path
{
        return [NSURL URLWithString:path relativeToURL:self.baseURL];
}

- (NSArray<NSURLSessionTask *> *)tasksWithURL:(NSString *)URLString method:(NSString *)method
{
        NSMutableArray *result = [NSMutableArray array];
        if ([URLString isKindOfClass:[NSString class]]) {
                NSString *fullURLString = [self fullURL:URLString].absoluteString;
                for (NSURLSessionTask *t in self.tasks) {
                        if ([t.originalRequest.URL.absoluteString isEqualToString:fullURLString]) {
                                if (!method || [method isEqualToString:t.originalRequest.HTTPMethod]) {
                                        [result addObject:t];
                                }
                        }
                }
        } else if (method) {
                for (NSURLSessionTask *t in self.tasks) {
                        if ([method isEqualToString:t.originalRequest.HTTPMethod]) {
                                [result addObject:t];
                        }
                }
        } else {
                return self.tasks;
        }
        return [result copy];
}

- (void)cancelTasksWithURL:(NSString *)URLString method:(NSString *)method
{
        [[self tasksWithURL:URLString method:method] makeObjectsPerformSelector:@selector(cancel)];
}

- (void)cancelAllTasks
{
        [self.tasks makeObjectsPerformSelector:@selector(cancel)];
}

@end
