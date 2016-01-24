//
//  ESApp+ACXGPush.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACXGPush.h"
#import <QQ_XGPush/XGSetting.h>
#import <QQ_XGPush/XGPush.h>

@implementation ESApp (ACXGPush)

- (BOOL)setupXGPushWithAppID:(uint32_t)appID appKey:(NSString *)appKey
{
        if (appID > 0 && ESIsStringWithAnyText(appKey)) {
                [[XGSetting getInstance] setChannel:self.appChannel];
                [XGPush startApp:appID appKey:appKey];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ESAppDidReceiveRemoteNotificationNotification_XGPushHandler:) name:ESAppDidReceiveRemoteNotificationNotification object:nil];
                return YES;
        }
        return NO;
}

- (void)ESAppDidReceiveRemoteNotificationNotification_XGPushHandler:(NSNotification *)notification
{
        if (notification.userInfo[UIApplicationLaunchOptionsRemoteNotificationKey]) {
                [XGPush handleLaunching:notification.userInfo[UIApplicationLaunchOptionsRemoteNotificationKey]];
        } else if (notification.userInfo[ESAppRemoteNotificationKey]) {
                [XGPush handleReceiveNotification:notification.userInfo[ESAppRemoteNotificationKey]];
        }
}

@end
