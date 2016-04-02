//
//  ApiClient.h
//  Sample
//
//  Created by Elf Sundae on 16/04/01.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AppComponents/AppComponentsNetworking.h>
#import <ESFramework/ESFrameworkCore.h>

#define kApiClientApiTokenEncryptionKey         @"" // Your secret password for encrypting Api Token.

#define kApiClientResponseCodeKey               @"code"
#define kApiClientResponseMessageKey            @"msg"
#define kApiClientResponseErrorsKey             @"errors"

#define kApiClientCSRFTokenCookieName           @"XSRF-TOKEN"
#define kApiClientCSRFTokenHTTPHeaderName       @"X-CSRF-TOKEN"
#define kApiClientApiTokenHTTPHeaderName        @"X-API-TOKEN"


typedef NS_ENUM(NSInteger, ApiResponseCode) {
        /// General error.
        ApiResponseCodeError                    = 0,
        /// Requesting succeed and response data is OK.
        ApiResponseCodeSuccess                  = 1,
        /// User authorization failure, e.g. requesting resouce is not public to Guest user.
        ApiResponseCodeUserAuthFailed           = 401,
        /// API request is not authorized, e.g. CSRF token is not correct.
        ApiResponseCodeRequestAuthFailed        = 403,
        /// Server Internal Error. e.g. JSON decoded response object is not a dictionary.
        ApiResponseCodeServerInternalError      = 500,
        /// Server is maintaining.
        ApiResponseCodeServerIsMaintaining      = 503,
};

/**
 * `ApiClient` is an example for using `AFHTTPSessionManager` to communicate to JSON API Server.
 *
 * Before requesting:
 *      + Set User Agent header using `-[ESApp userAgent]`.
 *      + Set CSRF Token to HTTP header field
 *      + Manage API Token
 *
 * Before `completionHandler` callback:
 *      + Parse JSON response decoded by `AFJSONResponseSerializer`.
 *      + Set `responseCode`, `responseMessage` and `responseErrors` to `dataTask`.
 *      + According dataTask's configurations, alert user when there are errors exist.
 */
@interface ApiClient : AFHTTPSessionManager

/**
 * The shared client instance, you can overwrite -init method to return different client.
 *
 * If there are more than one ApiClient, you must define a different global static variable 
 * for each shared client. e.g. `ES_SINGLETON_IMP_AS(client, __ItemsClient);`
 */
+ (instancetype)client;

- (instancetype)initWithBaseURL:(NSURL *)url timeoutIntervalForRequest:(NSTimeInterval)timeoutIntervalForRequest maxConcurrentRequestCount:(NSInteger)maxConcurrentRequestCount;

/**
 * The timestamp offset between server and local.  
 * offset = (serverTimestamp - localTimestamp)
 */
@property (nonatomic) NSTimeInterval timestampOffsetToServer;

@end

@interface ApiClient (Subclassing)

/**
 * Generates API Token using kApiClientApiTokenEncryptionKey.
 */
- (NSString *)generateApiToken;

/**
 * Parses response and responseObject, gets informations that needed to generate API Token.
 */
- (void)parseResponseForApiToken:(NSHTTPURLResponse *)response responseObject:(id)responseObject;

/**
 * Parses responseObject, gets code, message and errors values.  
 * Returns parsed responseObject.
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


@interface NSMutableURLRequest (ApiClient)

/**
 * Sets user agent string for HTTP header "User-Agent" field.
 */
- (void)setUserAgentForHTTPHeaderField:(NSString *)userAgent;

/**
 * Sets CSRF token for HTTP header field.
 */
- (void)setCSRFTokenForHTTPHeaderField;

/**
 * Sets API token for HTTP header field.
 */
- (void)setAPITokenForHTTPHeaderField:(NSString *)apiToken;

@end
