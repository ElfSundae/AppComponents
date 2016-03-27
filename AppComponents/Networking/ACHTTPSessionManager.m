//
//  ACHTTPSessionManager.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACHTTPSessionManager.h"
#import "ACNetworkingDefines.h"
#import "ACNetworkingHelper.h"
#import <ESFramework/ESFrameworkCore.h>
#import <AppComponents/ESApp+ACAlertAdditions.h>

@implementation ACHTTPSessionManager
@dynamic requestSerializer;

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
        self = [super initWithBaseURL:url sessionConfiguration:configuration];
        if (self) {
                self.requestSerializer = [ACHTTPRequestSerializer serializer];
        }
        return self;
}

- (void)ac_sessionTaskCompletionHandler:(NSURLSessionTask *)task
                            response:(NSURLResponse *)response
                      responseObject:(id)responseObject
                               error:(NSError *)error
                     originalHandler:(void (^)(NSURLResponse *, id, NSError *))originalHandler
{
        if (!error) {
                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        [ACNetworkingHelper parseResponseAPIToken:(NSHTTPURLResponse *)response];
                }
                
                if (![task.originalRequest.HTTPMethod isEqualToString:@"HEAD"] &&
                    !task.acInfo.dontParseResponseObject) {
                        ACNetworkingResponseCode code;
                        NSString *msg, *errorsString;
                        responseObject = [ACNetworkingHelper parseResponseObject:responseObject code:&code message:&msg errorsString:&errorsString];
                        
                        task.acInfo.responseCode = code;
                        task.acInfo.responseMessage = msg;
                        task.acInfo.responseErrors = errorsString;
                        
                        if (ACNetworkingResponseCodeSuccess != code && !task.acInfo.dontAlertWhenResponseCodeIsNotSuccess) {
                                if (msg || errorsString) {
                                        ESDispatchOnMainThreadAsynchrony(^{
                                                if (task.acInfo.alertUseTipsWhenResponseCodeIsNotSuccess) {
                                                        [[ESApp sharedApp] showTips:msg detail:errorsString addToView:nil timeInterval:0 animated:YES];
                                                } else {
                                                        [UIAlertView showWithTitle:msg message:errorsString];
                                                }
                                        });
                                }
                        }
                }
        } else {
                if (!task.acInfo.dontAlertNetworkError && error.isLocalNetworkError) {
                        NSString *title, *message;
                        if ([ACNetworkingHelper parseResponseFailedError:error title:&title message:&message] &&
                            (title || message)) {
                                ESDispatchOnMainThreadAsynchrony(^{
                                        if (task.acInfo.alertNetworkErrorUseAlertView) {
                                                [UIAlertView showWithTitle:title message:message];
                                        } else {
                                                [[ESApp sharedApp] showTips:title detail:message addToView:nil timeInterval:0 animated:YES];
                                        }
                                });
                        }
                }
        }
        
        if (originalHandler) {
                originalHandler(response, responseObject, error);
        }
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                             downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                            completionHandler:(void (^)(NSURLResponse *response, id responseObject,  NSError *error))completionHandler
{
        ESWeakSelf;
        __block NSURLSessionDataTask *task =
        [super dataTaskWithRequest:request uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:^(NSURLResponse *response, id responseObject,  NSError *error)
         {
                 ESStrongSelf;
                 [_self ac_sessionTaskCompletionHandler:task response:response responseObject:responseObject error:error originalHandler:completionHandler];
         }];
        return task;
}

- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromFile:(NSURL *)fileURL
                                         progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                                completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
        ESWeakSelf;
        __block NSURLSessionUploadTask *task =
        [super uploadTaskWithRequest:request fromFile:fileURL progress:uploadProgressBlock completionHandler:^(NSURLResponse *response, id responseObject,  NSError *error)
         {
                 ESStrongSelf;
                 [_self ac_sessionTaskCompletionHandler:task response:response responseObject:responseObject error:error originalHandler:completionHandler];
         }];
        return task;
}

- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromData:(NSData *)bodyData
                                         progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                                completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
        ESWeakSelf;
        __block NSURLSessionUploadTask *task =
        [super uploadTaskWithRequest:request fromData:bodyData progress:uploadProgressBlock completionHandler:^(NSURLResponse *response, id responseObject,  NSError *error)
         {
                 ESStrongSelf;
                 [_self ac_sessionTaskCompletionHandler:task response:response responseObject:responseObject error:error originalHandler:completionHandler];
         }];
        return task;
}

- (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                 progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                                        completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
        ESWeakSelf;
        __block NSURLSessionUploadTask *task =
        [super uploadTaskWithStreamedRequest:request progress:uploadProgressBlock completionHandler:^(NSURLResponse *response, id responseObject,  NSError *error)
         {
                 ESStrongSelf;
                 [_self ac_sessionTaskCompletionHandler:task response:response responseObject:responseObject error:error originalHandler:completionHandler];
         }];
        return task;
}

@end
