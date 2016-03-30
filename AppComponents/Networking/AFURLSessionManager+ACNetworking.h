//
//  AFURLSessionManager+ACNetworking.h
//  AppComponents
//
//  Created by Elf Sundae on 16/03/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AFNetworking/AFURLSessionManager.h>

@interface AFURLSessionManager (ACNetworking)

@property (nonatomic, copy) void (^dataTaskWillCompleteBlock)(NSURLSessionDataTask *dataTask, NSURLResponse *response, id responseObject, NSError *error, void (^completionHandler)(NSURLResponse *response, id responseObject, NSError *error));

@end
