//
//  NSURLSessionTask+ACNetworkingAdditions.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * NSURLSessionTask (ACNetworking) can be used to provide task configurations and to store useful
 * decoded response objects. 
 * In general, these additional properties will be managed by URLSessionManager like `AFHTTPSessionManager`.
 */
@interface NSURLSessionTask (ACNetworking)

///=============================================
/// @name Configurations
///=============================================

/// Determines whether to parse received response data, YES by default.
@property (nonatomic) BOOL shouldParseResponse;
/// Determines whether to alert responseMessage when response code is not success, YES by default.
@property (nonatomic) BOOL alertFailedResponseCode;
/// Indicates using UIAlertView or -[ESApp showTips:] to alert responseMessage, NO by default.
@property (nonatomic) BOOL alertFailedResponseCodeUsingTips;
/// Determines whether to alert local network error, YES by default.
@property (nonatomic) BOOL alertNetworkError;
/// Indicates using UIAlertView or -[ESApp showTips:] to alert local network error, YES by default.
@property (nonatomic) BOOL alertNetworkErrorUsingTips;

///=============================================
/// @name Parsed Response Data
///=============================================

/**
 * Returns response code parsed from response data.
 */
@property (nonatomic) NSInteger responseCode;

/**
 * Returns response message parsed from response data.
 */
@property (nonatomic, copy) NSString *responseMessage;

@end
