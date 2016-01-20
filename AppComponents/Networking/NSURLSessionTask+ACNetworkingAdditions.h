//
//  NSURLSessionTask+ACNetworkingAdditions.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/21.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACURLSessionTaskInfo.h"

@interface NSURLSessionTask (ACNetworkingAdditions)

@property (nonatomic, copy) ACURLSessionTaskInfo *acInfo;

@end
