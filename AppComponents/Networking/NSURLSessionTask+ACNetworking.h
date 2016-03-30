//
//  NSURLSessionTask+ACNetworkingAdditions.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

struct ACURLSessionTaskConfig {
        /// Determines whether to parse received response data.
        BOOL parseResponse;
        /// Determines whether to alert responseMessage and responseErrors when response code is not success.
        BOOL alertFailedResponseCode;
        /// Indicates using UIAlertView or -[ESApp showTips:] to alert responseMessage and responseErrors.
        BOOL alertFailedResponseCodeUsingTips;
        /// Determines whether to alert local network error.
        BOOL alertNetworkError;
        /// Indicates using UIAlertView or -[ESApp showTips:] to alert local network error.
        BOOL alertNetworkErrorUsingTips;
};
typedef struct ACURLSessionTaskConfig ACURLSessionTaskConfig;

/**
 * parseResponseObject: YES
 * alertFailedResponseCode: YES
 * alertFailedResponseCodeUsingTips: NO
 * alertNetworkError: YES
 * alertNetworkErrorUsingTips: YES
 */
FOUNDATION_EXTERN const ACURLSessionTaskConfig ACURLSessionTaskConfigDefault;

@interface NSURLSessionTask (ACNetworking)

/**
 * Returns config for task.
 */
@property (nonatomic) ACURLSessionTaskConfig taskConfig;

/**
 * Returns response code parsed from response data.
 *
 * @see enum ACNetworkingResponseCode 
 */
@property (nonatomic) NSInteger responseCode;

/**
 * Returns response message parsed from response data.
 */
@property (nonatomic, copy) NSString *responseMessage;

/**
 * Returns response errors parsed from response data.
 */
@property (nonatomic, copy) NSString *responseErrors;

@end
