//
//  NSURLSessionTask+ACNetworkingAdditions.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NSURLSessionTask+ACNetworkingAdditions.h"
#import <ESFramework/ESFrameworkCore.h>

ESDefineAssociatedObjectKey(acInfo);

@implementation NSURLSessionTask (ACNetworkingAdditions)

+ (void)load
{
        ESSwizzleInstanceMethod(self, @selector(copyWithZone:), @selector(AC_copyWithZone:));
}

- (ACURLSessionTaskInfo *)acInfo
{
        ACURLSessionTaskInfo *info = ESGetAssociatedObject(self, acInfoKey);
        if (![info isKindOfClass:[ACURLSessionTaskInfo class]]) {
                info = [[ACURLSessionTaskInfo alloc] init];
                self.acInfo = info;
        }
        return info;
}

- (void)setAcInfo:(ACURLSessionTaskInfo *)acInfo
{
        ESSetAssociatedObject(self, acInfoKey, acInfo, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)AC_copyWithZone:(NSZone *)zone
{
        NSURLSessionTask *task = [self AC_copyWithZone:zone];
        if ([task isKindOfClass:[NSURLSessionTask class]]) {
                task.acInfo = self.acInfo;
        }
        return task;
}

@end
