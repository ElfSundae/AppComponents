//
//  ACApiClient.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AppComponents/NSMutableURLRequest+ACNetworking.h>
#import <AppComponents/NSHTTPURLResponse+ACNetworking.h>
#import <AppComponents/NSURLSessionTask+ACNetworking.h>
#import <AppComponents/AFHTTPRequestSerializer+ACNetworking.h>
#import <AppComponents/AFURLSessionManager+ACNetworking.h>
#import <AppComponents/AFHTTPSessionManager+ACNetworking.h>
#import <ESFramework/ESFrameworkCore.h>

/**
 * The default response code, you can assign new values in your Api Client.
 */

/// 0: General error.
FOUNDATION_EXTERN NSInteger ACApiResponseCodeError;
/// 1: Requesting succeed and response data is OK.
FOUNDATION_EXTERN NSInteger ACApiResponseCodeSuccess;
/// 401: User authorization failure, e.g. requesting resouce is not public to Guest user.
FOUNDATION_EXTERN NSInteger ACApiResponseCodeUserAuthFailed;
/// 403: API request is not authorized, e.g. CSRF token is not correct.
FOUNDATION_EXTERN NSInteger ACApiResponseCodeRequestAuthFailed;
/// 500: Server Internal Error. e.g. JSON decoded response object is not a dictionary.
FOUNDATION_EXTERN NSInteger ACApiResponseCodeServerInternalError;
/// 503: Server is maintaining.
FOUNDATION_EXTERN NSInteger ACApiResponseCodeServerIsMaintaining;

/**
 * `ACApiClient` is an example for using `AFHTTPSessionManager` to communicate JSON API Server.
 *
 * Before requesting:
 *      + `ACApiClient` set User Agent header using `-[ESApp userAgent]`.
 *      + Set CSRF Token if the value of `kACConfigKey_ACNetworking_RequestHeaderCSRFTokenName` is not nil.
 *      + Set API Token using name of `kACConfigKey_ACNetworking_RequestHeaderApiTokenName`, and value of `-[ACApiClient generateApiToken]`.
 *      
 * Before `completionHandler` callback:
 *      + Parse JSON response decoded by `AFJSONResponseSerializer`.
 *      + Set `responseCode`, `responseMessage` and `responseErrors` to `dataTask`.
 *      + According dataTask's configurations, alert user when there are errors exist.
 */
@interface ACApiClient : AFHTTPSessionManager

/**
 * The shared client instance, you can overwrite -init method to return different client. 
 * If there are more than one Api Client, you define a different global static variable.
 */
+ (instancetype)client;

- (instancetype)initWithBaseURL:(NSURL *)url timeoutIntervalForRequest:(NSTimeInterval)timeoutIntervalForRequest maxConcurrentRequestCount:(NSInteger)maxConcurrentRequestCount;
- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

/**
 * The timestamp offset between server and local.
 * offset = (serverTimestamp - localTimestamp)
 */
@property (nonatomic) NSTimeInterval timestampOffsetToServer;

@end


@interface ACApiClient (Subclassing)

/**
 * Generates API Token.
 */
- (NSString *)generateApiToken;

/**
 * Parses response and responseObject, gets informations that needed to generate API Token.
 */
- (void)parseResponseForApiToken:(NSHTTPURLResponse *)response responseObject:(id)responseObject;

/**
 * Parses responseObject, gets code, message and errors values.
 * If the responseObject can be parsed, returns YES, otherwise returns NO.
 */
- (NSDictionary *)parseResponseObject:(id)responseObject code:(NSInteger *)outCode message:(NSString *__autoreleasing *)outMessage errors:(NSString *__autoreleasing *)outErrors;

/**
 * Handler for self.extraRequestSerializer
 */
- (void)_extraRequestSerializerHandler:(AFHTTPRequestSerializer *)serializer request:(NSMutableURLRequest *)request parameters:(id)parameters error:(NSError *__autoreleasing *)error;

/**
 * Handler for self.dataTaskWillCompleteBlock
 */
- (void)_dataTaskWillCompleteBlockHandler:(NSURLSessionDataTask *)dataTask response:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;


@end