//
//  ACApiClient.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACApiClient.h"
#import <AppComponents/AppComponentsCore.h>
#import <AppComponents/AppComponentsApp.h>

NSInteger ACApiResponseCodeError                = 0;
NSInteger ACApiResponseCodeSuccess              = 1;
NSInteger ACApiResponseCodeUserAuthFailed       = 401;
NSInteger ACApiResponseCodeRequestAuthFailed    = 403;
NSInteger ACApiResponseCodeServerInternalError  = 500;
NSInteger ACApiResponseCodeServerIsMaintaining  = 503;


@implementation ACApiClient

ES_SINGLETON_IMP(client);

- (instancetype)init
{
        return [self initWithBaseURL:nil timeoutIntervalForRequest:45. maxConcurrentRequestCount:3];
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


@implementation ACApiClient (Subclassing)

- (NSString *)generateApiToken
{
        NSString *password = ESStringValue(ACConfigGet(kACConfigKey_ACNetworking_ApiTokenPassword));
        if (password) {
                NSTimeInterval timestamp = [NSDate timeIntervalSince1970] + self.timestampOffsetToServer;
                NSString *string = [NSString stringWithFormat:@"%.0f", timestamp];
                return [ACEncryptor sampleEncrypt:string password:password];
        }
        return nil;
}

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
        NSString *ResponseCodeKey = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_ResponseKeyCode), kACNetworkingResponseCodeKey);
        NSString *ResponseMessageKey = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_ResponseKeyMessage), kACNetworkingResponseMessageKey);
        NSString *ResponseErrorsKey = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_ResponseKeyErrors), kACNetworkingResponseErrorsKey);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
                responseObject = @{ ResponseCodeKey: @(ACApiResponseCodeServerInternalError),
                                    ResponseMessageKey: _e(@"Internal Server Error") };
        }
        
        if (outCode) {
                *outCode = ESIntegerValueWithDefault(responseObject[ResponseCodeKey], ACApiResponseCodeError);
        }
        if (outMessage) {
                *outMessage = ESStringValue(responseObject[ResponseMessageKey]);
        }
        if (outErrors) {
                id errors = responseObject[ResponseErrorsKey];
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
        [request setUserAgent:[ESApp sharedApp].userAgent];
        
        // Set CSRF Token if your API server verify it.
        // [request setCSRFTokenForHTTPHeaderField];
        
        NSString *apiToken = [self generateApiToken];
        [request setAPITokenForHTTPHeaderField:apiToken];
}

- (void)_dataTaskWillCompleteBlockHandler:(NSURLSessionDataTask *)dataTask response:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (!error) {
                        [self parseResponseForApiToken:httpResponse responseObject:responseObject];
                        
                        if (dataTask.shouldParseResponse && responseObject/* HEAD has no responseObject */) {
                                NSInteger code = 0;
                                NSString *message = nil;
                                NSString *errorsString = nil;
                                
                                responseObject = [self parseResponseObject:responseObject code:&code message:&message errors:&errorsString];
                                dataTask.responseCode = code;
                                dataTask.responseMessage = message;
                                dataTask.responseErrors = errorsString;
                                
                                if (ACApiResponseCodeSuccess != code && !dataTask.alertFailedResponseCode) {
                                        if (message || errorsString) {
                                                ESDispatchOnMainThreadAsynchrony(^{
                                                        if (dataTask.alertFailedResponseCodeUsingTips) {
                                                                [[ESApp sharedApp] showTips:message detail:errorsString addToView:nil timeInterval:0 animated:YES];
                                                        } else {
                                                                [UIAlertView showWithTitle:message message:errorsString];
                                                        }
                                                });
                                        }
                                }
                        }
                } else {
                        if (dataTask.alertNetworkError && [error isLocalNetworkError]) {
                                NSString *title = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_LocalNetworkErrorAlertTitle), kACNetworkingLocalNetworkErrorAlertTitle);
                                ESDispatchOnMainThreadAsynchrony(^{
                                        if (dataTask.alertNetworkErrorUsingTips) {
                                                [[ESApp sharedApp] showTips:title];
                                        } else {
                                                [UIAlertView showWithTitle:title message:nil];
                                        }
                                });
                        }
                }
        }
        
        if (completionHandler) {
                completionHandler(response, responseObject, error);
        }        
}

@end