//
//  AFURLSessionManager+ACNetworking.m
//  AppComponents
//
//  Created by Elf Sundae on 16/03/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AFURLSessionManager+ACNetworking.h"
#import <ESFramework/ESFrameworkCore.h>

ESDefineAssociatedObjectKey(dataTaskWillCompleteBlock);

typedef void (^_ACDataTaskWillCompleteBlock)(NSURLSessionDataTask *dataTask, NSURLResponse *response, id responseObject, NSError *error, void (^completionHandler)(NSURLResponse *response, id responseObject, NSError *error));

@implementation AFURLSessionManager (ACNetworking)

+ (void)load
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        ESSwizzleInstanceMethod(self, @selector(addDelegateForDataTask:uploadProgress:downloadProgress:completionHandler:), @selector(ac_addDelegateForDataTask:uploadProgress:downloadProgress:completionHandler:));
        ESSwizzleInstanceMethod(self, @selector(addDelegateForUploadTask:progress:completionHandler:), @selector(ac_addDelegateForUploadTask:progress:completionHandler:));
        ESSwizzleInstanceMethod(self, @selector(addDelegateForDownloadTask:progress:destination:completionHandler:), @selector(acaddDelegateForDownloadTask:progress:destination:completionHandler:));
#pragma clang diagnostic pop
}

- (void (^)(NSURLSessionDataTask *, NSURLResponse *, id, NSError *, void (^)(NSURLResponse *, id, NSError *)))dataTaskWillCompleteBlock
{
        return ESGetAssociatedObject(self, dataTaskWillCompleteBlockKey);
}

- (void)setDataTaskWillCompleteBlock:(void (^)(NSURLSessionDataTask *, NSURLResponse *, id, NSError *, void (^)(NSURLResponse *, id, NSError *)))dataTaskWillCompleteBlock
{
        ESSetAssociatedObject(self, dataTaskWillCompleteBlockKey, dataTaskWillCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)ac_addDelegateForDataTask:(NSURLSessionDataTask *)dataTask
                   uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                 downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
        if (self.dataTaskWillCompleteBlock) {
                ESWeakSelf;
                [self ac_addDelegateForDataTask:dataTask uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                        ESStrongSelf;
                        if (_self.dataTaskWillCompleteBlock) {
                                _self.dataTaskWillCompleteBlock(dataTask, response, responseObject, error, completionHandler);
                        }
                }];
        } else {
                [self ac_addDelegateForDataTask:dataTask uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completionHandler];
        }
}

- (void)ac_addDelegateForUploadTask:(NSURLSessionUploadTask *)uploadTask
                           progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                  completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
        if (self.dataTaskWillCompleteBlock) {
                ESWeakSelf;
                [self ac_addDelegateForUploadTask:uploadTask progress:uploadProgressBlock completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                        ESStrongSelf;
                        if (_self.dataTaskWillCompleteBlock) {
                                _self.dataTaskWillCompleteBlock(uploadTask, response, responseObject, error, completionHandler);
                        }
                }];
        } else {
                [self ac_addDelegateForUploadTask:uploadTask progress:uploadProgressBlock completionHandler:completionHandler];
        }
}

@end
