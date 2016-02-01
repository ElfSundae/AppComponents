//
//  WebViewJavascriptBridge+ACMessageHandler.h
//  AppComponents
//
//  Created by Elf Sundae on 16/2/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>

typedef void (^ACWVJBMessageHandler)(NSString *handlerName, id data, WVJBResponseCallback responseCallback);

@interface WebViewJavascriptBridge (ACMessageHandler)
@property (nonatomic, copy) ACWVJBMessageHandler ac_messageHandler;
@end

#ifdef supportsWKWebKit
@interface WKWebViewJavascriptBridge (ACMessageHandler)
@property (nonatomic, copy) ACWVJBMessageHandler ac_messageHandler;
@end
#endif

@interface WebViewJavascriptBridgeBase (ACMessageHandler)
@property (nonatomic, copy) ACWVJBMessageHandler ac_messageHandler;
@end
