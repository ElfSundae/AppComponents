//
//  ACURLSessionTaskInfo.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppComponents/ACNetworkingDefines.h>

@interface ACURLSessionTaskInfo : NSObject <NSCopying>

/**
 * 默认为NO: 不要解析responseObject.
 */
@property (nonatomic) BOOL dontParseResponseObject;
/**
 * 默认为NO: responseObject.code不为success时，不要弹窗提示
 */
@property (nonatomic) BOOL dontAlertWhenResponseCodeIsNotSuccess;
/**
 * 默认为NO: 弹窗提示responseObject.code不为success时，使用tips的方式而不是UIAlertView
 */
@property (nonatomic) BOOL alertUseTipsWhenResponseCodeIsNotSuccess;
/**
 * 默认为NO: 不要弹窗提示网络异常导致的请求失败
 */
@property (nonatomic) BOOL dontAlertNetworkError;
/**
 * 默认为NO: 弹窗提示网络异常时使用UIAlertView而不是tips
 */
@property (nonatomic) BOOL alertNetworkErrorUseAlertView;

@property (nonatomic) ACNetworkingResponseCode responseCode;
@property (nonatomic, copy) NSString *responseMessage;
@property (nonatomic, copy) NSString *responseErrors;

@end
