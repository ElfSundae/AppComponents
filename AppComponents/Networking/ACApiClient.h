//
//  ACApiClient.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AppComponents/ACHTTPSessionManager.h>

typedef NS_ENUM(NSInteger, ACNetworkingResponseCode) {
        ACNetworkingResponseCodeUnknown                 = -999999,
        /// 一般错误
        ACNetworkingResponseCodeError                   = 0,
        /// 请求成功
        ACNetworkingResponseCodeSuccess                 = 1,
        /// 用户验证失败，例如未登录
        ACNetworkingResponseCodeUserAuthFailed          = 401,
        /// API验证失败，例如非法请求，ApiToken验证失败
        ACNetworkingResponseCodeRequestAuthFailed       = 403,
        /// 服务端内部错误
        ACNetworkingResponseCodeServerInternalError     = 500,
        /// 服务器正在维护
        ACNetworkingResponseCodeServerIsMaintaining     = 503,
};


/**
 * baseURL is ACConfigGet(kACConfigKey_ACNetworking_BaseURL)
 * requestTimeout is 45.0
 * maxConcurrentOperationCount is 3
 */
@interface ACApiClient : ACHTTPSessionManager

+ (instancetype)defaultClient;

@end
