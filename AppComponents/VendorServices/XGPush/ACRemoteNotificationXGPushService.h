//
//  ACRemoteNotificationXGPushService.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppComponents/ACRemoteNotificationServiceRegister.h>

@interface ACRemoteNotificationXGPushService : NSObject <ACRemoteNotificationServiceProtocol>

+ (void)setTags:(NSArray *)tags;

@end
