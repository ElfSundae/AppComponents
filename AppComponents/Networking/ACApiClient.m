//
//  ACApiClient.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACApiClient.h"

@implementation ACApiClient

//+ (instancetype)defaultClient
//{
//        static ACApiClient *__gDefaultClient = nil;
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//                NSURL *url = ESURLValue(ACConfigGet(kACConfigKey_ACNetworking_BaseURL));
//                NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//                sessionConfig.timeoutIntervalForRequest = ESDoubleValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_RequestTimeout), 45.0);
//                __gDefaultClient = [[self alloc] initWithBaseURL:url
//                                            sessionConfiguration:sessionConfig];
//                __gDefaultClient.operationQueue.maxConcurrentOperationCount = ESIntegerValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_MaxConcurrentRequestCount), 3);
//        });
//        return __gDefaultClient;
//}

@end
