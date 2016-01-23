//
//  ESApp+ACXGPush.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>

@interface ESApp (ACXGPush)

/**
 * 初始化信鸽推送.
 * http://xg.qq.com
 */
- (BOOL)setupXGPushWithAppID:(uint32_t)appID appKey:(NSString *)appKey;

- (void)ESAppDidReceiveRemoteNotificationNotification_XGPushHandler:(NSNotification *)notification;

@end
