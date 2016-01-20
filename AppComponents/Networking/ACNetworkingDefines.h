//
//  ACNetworkingDefines.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AppComponents/ACConfig.h>

#define kACConfigKey_ACNetworking @"ACNetworking"
#define kACConfigKey_ACNetworking_BaseURL kACConfigKey_ACNetworking@".baseURL" // NSURL or NSString, default is nil

/// 发送请求时设置Api Token到request的header, name为nil时不传Api Token, default is nil, e.g. @"X-API-TOKEN"
#define kACConfigKey_ACNetworking_RequestHeaderApiTokenName kACConfigKey_ACNetworking@".RequestHeaderApiTokenName"
/// 发送请求时将Cookie中的CSRF Token传到request的header，name为nil时不传CSRF Token. default is nil, e.g. @"X-CSRF-TOKEN"
#define kACConfigKey_ACNetworking_RequestHeaderCSRFTokenName kACConfigKey_ACNetworking@".RequestHeaderCSRFTokenName"
/// 加密Api Token时用的密码, default is nil
#define kACConfigKey_ACNetworking_ApiTokenPassword kACConfigKey_ACNetworking@".ApiTokenPassword"
/// Cookie中CSRF Token的名字, default is @"XSRF-TOKEN"
#define kACConfigKey_ACNetworking_CSRFTokenCookieName    kACConfigKey_ACNetworking@".CSRFTokenCookieName"
/// 网络连接失败时的弹窗title, default is kACNetworkingLocalNetworkErrorAlertTitle
#define kACConfigKey_ACNetworking_LocalNetworkErrorAlertTitle kACConfigKey_ACNetworking@".LocalNetworkErrorAlertTitle"

/// default is @"code"
#define kACConfigKey_ACNetworking_ResponseKeyCode kACConfigKey_ACNetworking@".ResponseKeyCode"
/// default is @"msg"
#define kACConfigKey_ACNetworking_ResponseKeyMessage kACConfigKey_ACNetworking@".ResponseKeyMessage"
/// default is @"errors"
#define kACConfigKey_ACNetworking_ResponseKeyErrors kACConfigKey_ACNetworking@".ResponseKeyErrors"

#define kACNetworkingRequestHeaderApiTokenName  @"X-API-TOKEN"
#define kACNetworkingRequestHeaderCSRFTokenName @"X-CSRF-TOKEN"
#define kACNetworkingCSRFTokenCookieName        @"XSRF-TOKEN"

#define kACNetworkingResponseCodeKey    @"code"
#define kACNetworkingResponseMessageKey @"msg"
#define kACNetworkingResponseErrorsKey  @"errors"

#define kACNetworkingLocalNetworkErrorAlertTitle NSLocalizedString(@"Network is not connected.", nil)

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
