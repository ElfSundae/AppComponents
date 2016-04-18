//
//  ApiClient.m
//  Sample
//
//  Created by Elf Sundae on 16/04/01.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ApiClient.h"
#import <AppComponents/AppComponentsApp.h>

@implementation ApiClient

ES_SINGLETON_IMP_AS(client, __defaultClient);

- (instancetype)init
{
        return [self initWithBaseURL:[NSURL URLWithString:kApiClientBaseURL] timeoutIntervalForRequest:45. maxConcurrentRequestCount:3];
}

- (instancetype)initWithBaseURL:(NSURL *)url timeoutIntervalForRequest:(NSTimeInterval)timeoutIntervalForRequest maxConcurrentRequestCount:(NSInteger)maxConcurrentRequestCount
{
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = timeoutIntervalForRequest;
        self = [self initWithBaseURL:url sessionConfiguration:sessionConfig];
        if (self) {
                self.operationQueue.maxConcurrentOperationCount = maxConcurrentRequestCount;
        }
        return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
        self = [super initWithBaseURL:url sessionConfiguration:configuration];
        if (self) {
                ESWeakSelf;
                self.extraRequestSerializer = ^(AFHTTPRequestSerializer *serializer, NSMutableURLRequest *request, id parameters, NSError *__autoreleasing *error) {
                        ESStrongSelf;
                        [_self _extraRequestSerializerHandler:serializer request:request parameters:parameters error:error];
                };
                self.dataTaskWillCompleteBlock = ^(NSURLSessionDataTask *dataTask, NSURLResponse *response, id responseObject, NSError *error, void (^completionHandler)(NSURLResponse *response, id responseObject, NSError *error)) {
                        ESStrongSelf;
                        [_self _dataTaskWillCompleteBlockHandler:dataTask response:response responseObject:responseObject error:error completionHandler:completionHandler];
                };
        }
        return self;
}

@end

@implementation ApiClient (Subclassing)

- (void)parseResponseForApiToken:(NSHTTPURLResponse *)response responseObject:(id)responseObject
{
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSDate *date = [response dateOfHeaderField];
                if (date) {
                        self.timestampOffsetToServer = ([date timeIntervalSinceNow]);
                }
        }
}

- (NSDictionary *)parseResponseObject:(id)responseObject code:(NSInteger *)outCode message:(NSString *__autoreleasing *)outMessage errors:(NSString *__autoreleasing *)outErrors
{
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
                responseObject = @{ kApiClientResponseCodeKey: @(ApiResponseCodeServerInternalError),
                                    kApiClientResponseMessageKey: _e(@"Internal Server Error") };
        }
        
        if (outCode) {
                *outCode = ESIntegerValueWithDefault(responseObject[kApiClientResponseCodeKey], ApiResponseCodeError);
        }
        if (outMessage) {
                *outMessage = ESStringValue(responseObject[kApiClientResponseMessageKey]);
        }
        if (outErrors) {
                id errors = responseObject[kApiClientResponseErrorsKey];
                if ([errors isKindOfClass:[NSArray class]]) {
                        errors = [(NSArray *)errors matchesObjects:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                                return ESIsStringWithAnyText(obj);
                        }];
                        if ([(NSArray *)errors count]) {
                                *outErrors = [(NSArray *)errors componentsJoinedByString:@"\n"];
                        } else {
                                *outErrors = nil;
                        }
                } else {
                        *outErrors = ESStringValue(errors);
                }
        }
        return responseObject;
}

- (void)_extraRequestSerializerHandler:(AFHTTPRequestSerializer *)serializer request:(NSMutableURLRequest *)request parameters:(id)parameters error:(NSError *__autoreleasing *)error
{
        // Set User Agnet if the userAgent string is variable, for example there is a value stands for the current network type.
        // If your userAgent string is static, you can set user agent in ApiClient's requestSerializer.
        [request setUserAgentForHTTPHeaderField:[ESApp sharedApp].userAgent];
        
        // Set CSRF Token if your API server verify it.
        // [request setCSRFTokenForHTTPHeaderField];
}

- (void)_dataTaskWillCompleteBlockHandler:(NSURLSessionDataTask *)dataTask response:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
        if ([response isKindOfClass:[NSHTTPURLResponse class]] && !error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                [self parseResponseForApiToken:httpResponse responseObject:responseObject];
                
                if (responseObject/* HEAD has no responseObject */ && dataTask.shouldParseResponse) {
                        NSInteger code = 0;
                        NSString *message = nil;
                        NSString *errorsString = nil;
                        
                        responseObject = [self parseResponseObject:responseObject code:&code message:&message errors:&errorsString];
                        dataTask.responseCode = code;
                        dataTask.responseMessage = message;
                        dataTask.responseErrors = errorsString;
                        
                        if (ApiResponseCodeSuccess != code && dataTask.alertFailedResponseCode) {
                                if (message || errorsString) {
                                        ESDispatchOnMainThreadAsynchrony(^{
                                                if (dataTask.alertFailedResponseCodeUsingTips) {
                                                        [ESApp showTips:message detail:errorsString addToView:nil timeInterval:0 animated:YES];
                                                } else {
                                                        [UIAlertView showWithTitle:message message:errorsString];
                                                }
                                        });
                                }
                        }
                }
        } else if (error){
                if (dataTask.alertNetworkError && [error isLocalNetworkError]) {
                        ESDispatchOnMainThreadAsynchrony(^{
                                if (dataTask.alertNetworkErrorUsingTips) {
                                        [ESApp showLocalNetworkErrorTipsWithSuperview:nil];
                                } else {
                                        [ESApp showLocalNetworkErrorAlertWithCompletion:nil];
                                }
                        });
                }
        }
        
        if (completionHandler) {
                completionHandler(response, responseObject, error);
        }
}

@end

@implementation NSMutableURLRequest (ApiClient)

- (void)setUserAgentForHTTPHeaderField:(NSString *)userAgent
{
        [self setValue:userAgent forHTTPHeaderField:@"User-Agent"];
}

- (void)setCSRFTokenForHTTPHeaderField
{
        for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:self.URL]) {
                if ([cookie.name isEqualToString:kApiClientCSRFTokenCookieName]) {
                        [self setValue:cookie.value forHTTPHeaderField:kApiClientCSRFTokenHTTPHeaderName];
                        break;
                }
        }
}

@end
