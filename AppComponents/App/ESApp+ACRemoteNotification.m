//
//  ESApp+ACRemoteNotification.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACRemoteNotification.h"
#import <ESFramework/NSError+ESAdditions.h>

NSString *const ACRemoteNotificationServiceDefaultAccountIdentifier = @"NULL";

@implementation ESApp (ACRemoteNotification)

- (void)registerForRemoteNotificationsWithTypes:(ESUserNotificationType)types
                                     categories:(NSSet *)categories
                                    serviceType:(ACRemoteNotificationServiceType)serviceType
                             deviceTokenHandler:(void (^)(NSData *deviceToken, NSString *deviceTokenString, NSError *error))deviceTokenHandler
                   shouldRegisterServiceHandler:(BOOL (^)(NSString **account, NSArray **tags))shouldRegisterServiceHandler
                      didRegisterServiceHandler:(void (^)(NSError *error))didRegisterServiceHandler
{
        ESWeakSelf;
        void (^deviceTokenBlock)(NSData *deviceToken, NSString *deviceTokenString, NSError *error) = ^(NSData *deviceToken, NSString *deviceTokenString, NSError *error) {
                ESStrongSelf;
                if (deviceTokenHandler) {
                        deviceTokenHandler(deviceToken, deviceTokenString, error);
                }
                
                if (!deviceToken) return;
                if (0 == serviceType) return;
                if (!shouldRegisterServiceHandler) return;
                
                Class serviceClass = [ACRemoteNotificationServiceRegister classForServiceType:serviceType];
                if (!serviceClass) {
                        if (didRegisterServiceHandler) {
                                didRegisterServiceHandler([NSError errorWithDomain:@"ACRemoteNotificationErrorDomain" code:-1 description:NSStringWith(@"There is no service provider for type %@", @(serviceType))]);
                        }
                        return;
                }
                
                if (![serviceClass instancesRespondToSelector:@selector(registerDevice:deviceTokenString:account:tags:completion:)]) {
                        if (didRegisterServiceHandler) {
                                didRegisterServiceHandler([NSError errorWithDomain:@"ACRemoteNotificationErrorDomain" code:-2 description:NSStringWith(@"%@ instance is not respond to selector -registerDevice:deviceTokenString:account:tags:completion:", serviceClass)]);
                        }
                        return;
                }
                
                NSString *account = nil;
                NSArray *tags = nil;
                if (!shouldRegisterServiceHandler(&account, &tags)) {
                        return;
                }
                
                id<ACRemoteNotificationServiceProtocol> service = [[serviceClass alloc] init];
                [service registerDevice:deviceToken deviceTokenString:deviceTokenString account:account tags:tags completion:^(BOOL succeed) {
                        ESDispatchOnMainThreadAsynchrony(^{
                                ESStrongSelf;
                                if (didRegisterServiceHandler) {
                                        NSError *error = nil;
                                        if (!succeed) {
                                                error = [NSError errorWithDomain:@"ACRemoteNotificationErrorDomain" code:-2 description:NSStringWith(@"%@ can not be registered.", serviceClass)];
                                        }
                                        didRegisterServiceHandler(error);
                                }
                        });
                }];
                
        };
        
        [self registerForRemoteNotificationsWithTypes:types categories:categories success:^(NSData *deviceToken, NSString *deviceTokenString) {
                deviceTokenBlock(deviceToken, deviceTokenString, nil);
        } failure:^(NSError *error) {
                deviceTokenBlock(nil, nil, error);
        }];
}

- (void)unregisterForRemoteNotificationsWithServiceType:(ACRemoteNotificationServiceType)serviceType completion:(void (^)(BOOL))completion
{
        Class serviceClass = [ACRemoteNotificationServiceRegister classForServiceType:serviceType];
        if (serviceClass && [serviceClass instancesRespondToSelector:@selector(unregisterDevice:)]) {
                id<ACRemoteNotificationServiceProtocol> service = [[serviceClass alloc] init];
                [service unregisterDevice:completion];
        }
}

@end
