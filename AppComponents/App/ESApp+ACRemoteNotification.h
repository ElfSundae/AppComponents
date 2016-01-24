//
//  ESApp+ACRemoteNotification.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>
#import "ACRemoteNotificationServiceRegister.h"

FOUNDATION_EXTERN NSString *const ACRemoteNotificationServiceDefaultAccountIdentifier;

@interface ESApp (ACRemoteNotification)

- (void)registerForRemoteNotificationsWithTypes:(ESUserNotificationType)types
                                     categories:(NSSet *)categories
                                    serviceType:(ACRemoteNotificationServiceType)serviceType
                             deviceTokenHandler:(void (^)(NSData *deviceToken, NSString *deviceTokenString, NSError *error))deviceTokenHandler
                   shouldRegisterServiceHandler:(BOOL (^)(NSString **account, NSArray **tags))shouldRegisterServiceHandler
                      didRegisterServiceHandler:(void (^)(NSError *error))didRegisterServiceHandler;

- (void)unregisterForRemoteNotificationsWithServiceType:(ACRemoteNotificationServiceType)serviceType
                                             completion:(void (^)(BOOL succeed))completion;

@end
