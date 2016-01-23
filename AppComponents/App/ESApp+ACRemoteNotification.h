//
//  ESApp+ACRemoteNotification.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>

FOUNDATION_EXTERN NSString *const ACRemoteNotificationServiceDefaultAccountIdentifier;

typedef NS_OPTIONS(NSUInteger, ACRemoteNotificationServiceType) {
        /// 腾讯信鸽
        ACRemoteNotificationServiceTypeXGPush = 1,
};

@interface ESApp (ACRemoteNotification)

@end
