//
//  ACRemoteNotificationServiceRegister.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, ACRemoteNotificationServiceType) {
        /// 腾讯信鸽
        ACRemoteNotificationServiceTypeXGPush = 1,
};

@protocol ACRemoteNotificationServiceProtocol <NSObject>
- (void)registerDevice:(NSData *)deviceToken deviceTokenString:(NSString *)deviceTokenString account:(NSString *)account tags:(NSArray *)tags completion:(void (^)(BOOL succeed))completion;
- (void)unregisterDevice:(void (^)(BOOL succeed))completion;
@end

/**
 * 运行时注册执行第三方推送服务的类
 */
@interface ACRemoteNotificationServiceRegister : NSObject

+ (BOOL)registerClass:(Class)serviceClass forServiceType:(ACRemoteNotificationServiceType)serviceType;
+ (Class)classForServiceType:(ACRemoteNotificationServiceType)serviceType;
+ (NSMutableDictionary *)allServiceClasses;

@end
