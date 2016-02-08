//
//  WebViewJavascriptBridge+ACMessageHandler.m
//  AppComponents
//
//  Created by Elf Sundae on 16/2/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "WebViewJavascriptBridge+ACMessageHandler.h"
#import <ESFramework/ESFrameworkCore.h>

ESDefineAssociatedObjectKey(ac_messageHandler);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation WebViewJavascriptBridge (ACMessageHandler)

- (WebViewJavascriptBridgeBase *)ac_base
{
        return (WebViewJavascriptBridgeBase *)[self valueForKey:@"_base"];
}

- (ACWVJBMessageHandler)ac_messageHandler
{
        return [[self ac_base] performSelector:@selector(ac_messageHandler)];
}

- (void)setAc_messageHandler:(ACWVJBMessageHandler)handler
{
        [[self ac_base] performSelector:@selector(setAc_messageHandler:) withObject:handler];
}

@end

#ifdef supportsWKWebKit
@implementation WKWebViewJavascriptBridge (ACMessageHandler)

- (WebViewJavascriptBridgeBase *)ac_base
{
        return (WebViewJavascriptBridgeBase *)[self valueForKey:@"_base"];
}

- (ACWVJBMessageHandler)ac_messageHandler
{
        return [[self ac_base] performSelector:@selector(ac_messageHandler)];
}

- (void)setAc_messageHandler:(ACWVJBMessageHandler)handler
{
        [[self ac_base] performSelector:@selector(setAc_messageHandler:) withObject:handler];
}

@end
#endif

@implementation WebViewJavascriptBridgeBase (ACMessageHandler)

+ (void)load
{
        ESSwizzleInstanceMethod(self, @selector(flushMessageQueue:), @selector(ac_flushMessageQueue:));
}

- (ACWVJBMessageHandler)ac_messageHandler
{
        return ESGetAssociatedObject(self, ac_messageHandlerKey);
}

- (void)setAc_messageHandler:(ACWVJBMessageHandler)handler
{
        ESSetAssociatedObject(self, ac_messageHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)ac_flushMessageQueue:(NSString *)messageQueueString
{
        if (ESIsStringWithAnyText(messageQueueString)) {
                id messages = [self performSelector:@selector(_deserializeMessageJSON:) withObject:messageQueueString];
                for (WVJBMessage* message in messages) {
                        if (![message isKindOfClass:[WVJBMessage class]]) {
                                NSLog(@"WebViewJavascriptBridge: WARNING: Invalid %@ received: %@", [message class], message);
                                continue;
                        }
                        ESInvokeSelector(self, @selector(_log:json:), NO, NULL, @"RCVD", message);
                        
                        NSString* responseId = message[@"responseId"];
                        if (responseId) {
                                WVJBResponseCallback responseCallback = [self valueForKey:@"_responseCallbacks"][responseId];
                                responseCallback(message[@"responseData"]);
                                [self.responseCallbacks removeObjectForKey:responseId];
                        } else {
                                WVJBResponseCallback responseCallback = NULL;
                                NSString* callbackId = message[@"callbackId"];
                                if (callbackId) {
                                        responseCallback = ^(id responseData) {
                                                if (responseData == nil) {
                                                        responseData = [NSNull null];
                                                }
                                                
                                                WVJBMessage* msg = @{ @"responseId":callbackId, @"responseData":responseData };
                                                [self performSelector:@selector(_queueMessage:) withObject:msg];
                                        };
                                } else {
                                        responseCallback = ^(id ignoreResponseData) {
                                                // Do nothing
                                        };
                                }
                                
                                WVJBHandler handler = self.messageHandlers[message[@"handlerName"]];
                                
                                if (!handler) {
                                        if (self.ac_messageHandler) {
                                                self.ac_messageHandler(message[@"handlerName"], message[@"data"], responseCallback);
                                                continue;
                                        }
                                        NSLog(@"WVJBNoHandlerException, No handler for message from JS: %@", message);
                                        continue;
                                }
                                
                                handler(message[@"data"], responseCallback);
                        }
                }
        }
        
        // invoke the original implementation
        [self ac_flushMessageQueue:messageQueueString];
}

@end

#pragma clang diagnostic pop