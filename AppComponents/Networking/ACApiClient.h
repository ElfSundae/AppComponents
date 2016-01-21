//
//  ACApiClient.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AppComponents/ACHTTPSessionManager.h>

/**
 * baseURL is ACConfigGet(kACConfigKey_ACNetworking_BaseURL)
 * requestTimeout is 45.0
 * maxConcurrentOperationCount is 3
 */
@interface ACApiClient : ACHTTPSessionManager

+ (instancetype)defaultClient;

@end
