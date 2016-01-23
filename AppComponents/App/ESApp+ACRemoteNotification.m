//
//  ESApp+ACRemoteNotification.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACRemoteNotification.h"

NSString *const ACRemoteNotificationServiceDefaultAccountIdentifier = @"NULL";

@implementation ESApp (ACRemoteNotification)

- (void)registerForRemoteNotificationsWithTypes:(ESUserNotificationType)types
                                     categories:(NSSet *)categories
                                   serviceType:(ACRemoteNotificationServiceType)serviceType
                             deviceTokenHandler:(void (^)(NSData *deviceToken, NSString *deviceTokenString, NSError *error))deviceTokenHandler
                   shouldRegisterServiceHandler:(BOOL (^)(NSString **account, NSDictionary **tags))shouldRegisterServiceHandler
                      didRegisterServiceHandler:(void (^)(NSString *serviceClientID, NSError *error))didRegisterServiceHandler
{
        ESWeakSelf;
        void (^deviceTokenBlock)(NSData *deviceToken, NSString *deviceTokenString, NSError *error) = ^(NSData *deviceToken, NSString *deviceTokenString, NSError *error) {
                ESStrongSelf;
                if (deviceTokenHandler) {
                        deviceTokenHandler(deviceToken, deviceTokenString, error);
                }
                if (!deviceToken) return;
                if (!shouldRegisterServiceHandler) return;
                
                NSString *account = nil;
                NSDictionary *tags = nil;

                
                for (id st in serviceTypes) {
                        ACRemoteNotificationServiceType currentType = ESUIntegerValue(st);
                        if (!shouldRegisterServiceHandler(currentType, &account, &tags)) {
                                return;
                        }
                }
                
        };
        
        [self registerForRemoteNotificationsWithTypes:types categories:categories success:^(NSData *deviceToken, NSString *deviceTokenString) {
                deviceTokenBlock(deviceToken, deviceTokenString, nil);
        } failure:^(NSError *error) {
                deviceTokenBlock(nil, nil, error);
        }];
}

- (void)unregisterForRemoteNotificationsWithServiceType:(ACRemoteNotificationServiceType)serviceType
{
        if (ACRemoteNotificationServiceTypeXGPush == serviceType) {
                Class XGPushClass = NSClassFromString(@"XGPush");
                if (XGPushClass) {
                        ESInvokeSelector(XGPushClass, @selector(setAccount:), NULL, ACRemoteNotificationServiceDefaultAccountIdentifier);
                        // Note: 信鸽的[XGPush unRegisterDevice]可能会执行 [UIApplication unregisterForRemoteNotifications],
                        // 导致用户在app运行时打开推送开关后appDelegate收不到DidRegisterDeviceToken的回调。
                }
        }
}

//- (void)ac_registerRemoteNotificationWithCompletion:(void (^)(NSString *deviceToken, NSError *error))completion
//{
//        [self registerForRemoteNotificationsWithTypes:(ESUserNotificationTypeBadge|ESUserNotificationTypeAlert|ESUserNotificationTypeSound)
//                                           categories:nil
//                                              success:^(NSData *deviceToken, NSString *deviceTokenString)
//         {
//                 
//         } failure:^(NSError *error) {
//                 if (completion) completion(nil, error);
//         }];
//        
//}
//
////- (void)ac_register
//
//- (void)registerPushWithCompletion:(void (^)(NSString *deviceToken, NSError *error))completion
//{
//#if !TARGET_IPHONE_SIMULATOR
//        if (self.registerRemoteNotificationWithVendorPushServiceCompletion) {
//                // 正在注册
//                return;
//        }
//        
//        NSLog(@"开始注册推送");
//        self.hasRegisteredPushToVendorService = NO;
//        ESWeakSelf;
//        BOOL (^shouldRegisterVendor)(NSString **, NSDictionary **) = ^(NSString **account, NSDictionary **tags) {
//                AppUser *user = [AppUser me];
//                *account = user.userID;
//                *tags = @{@"user": user.isLoggedIn ? (user.isVIP ? @"vip" : @"user") : @"guest"};
//                return YES;
//        };
//        
//        void (^deviceTokenCallback)(NSString *deviceToken, NSError *error) = ^(NSString *deviceToken, NSError *error) {
//                ESStrongSelf;
//                NSLog(@"DeviceToken: %@", deviceToken);
//                if (deviceToken) {
//                        [_self registerPushDeviceToAppServer:deviceToken];
//                } else {
//                        [_self unregisterPushDeviceToAppServer];
//                        if (completion) {
//                                completion(nil, error);
//                        }
//                }
//        };
//        
//        void (^registerVendorCompletion)(NSString *clientID, NSError *error) = ^(NSString *clientID, NSError *error) {
//                ESStrongSelf;
//                NSLog(@"注册第三方推送服务结束. error:%@", error);
//                _self.hasRegisteredPushToVendorService = !error;
//                [_self resetRemoteNotificationRegisterCallbacks];
//                if (completion) {
//                        completion(_self.remoteNotificationsDeviceToken, error);
//                }
//        };
//        
//#if _Vendor_XGPush_
//        [self registerForRemoteNotificationsWithXGPush:deviceTokenCallback shouldRegisterVendorService:shouldRegisterVendor vendorServiceCompletion:registerVendorCompletion];
//#elif _Vendor_JPush_
//        [self registerForRemoteNotificationsWithJPush:shouldRegister completion:registerCompletion];
//#endif
//#endif
//}

@end
