//
//  ACXGPush.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACXGPush.h"
#import <APIService-XGPush/XGSetting.h>
#import <APIService-XGPush/XGPush.h>

@implementation ACXGPush

- (void)ac_XGPushSetTags:(NSArray *)tags
{
        
}

- (void)_XGPushSetTags:(NSArray *)tagsArray
{
        __hasNotifiedVendorPushServiceCompletion = NO;
        
        ESWeakSelf;
        void (^callback)(NSString *tag, BOOL succeed) = ^(NSString *tag, BOOL succeed) {
                ESStrongSelf;
                [_self _XGPushSetTagDidFinish:succeed tags:tagsArray currentTag:tag];
        };
        
        if (!ESIsArrayWithItems(tagsArray)) {
                callback(nil, YES);
                return;
        }
        
        for (NSString *tag in tagsArray) {
                [XGPush setTag:tag successCallback:^{
                        callback(tag, YES);
                } errorCallback:^{
                        callback(tag, NO);
                }];
        }
}

- (void)_XGPushSetTagDidFinish:(BOOL)result tags:(NSArray *)tags currentTag:(NSString *)currentTag
{
        NSLog(@"XGPush set tag [%@] %@", result ? @"OK" : @"Error", currentTag);
        
        if (__hasNotifiedVendorPushServiceCompletion) {
                return;
        }
        
        if (result && (!ESIsArrayWithItems(tags) || [tags.lastObject isEqualToString:currentTag])) {
                // 所有tags设置成功后回调信鸽注册完成
                __hasNotifiedVendorPushServiceCompletion = YES;
                if (self.registerRemoteNotificationWithVendorPushServiceCompletion) {
                        self.registerRemoteNotificationWithVendorPushServiceCompletion(nil, nil);
                }
        } else if (!result) {
                __hasNotifiedVendorPushServiceCompletion = YES;
                if (self.registerRemoteNotificationWithVendorPushServiceCompletion) {
                        self.registerRemoteNotificationWithVendorPushServiceCompletion(nil, [NSError errorWithDomain:ESAppErrorDomain code:-10 description:@"Could not set tag for XGPush."]);
                }
        }
}

- (void)_unregisterXGPush
{
        [XGPush setAccount:kXGDefaultAccount];
        // Note: 信鸽的[XGPush unRegisterDevice]可能会执行 [UIApplication unregisterForRemoteNotifications], 导致用户在app运行时打开推送开关后appDelegate收不到DidRegisterDeviceToken的回调。
        // [XGPush unRegisterDevice];
}

- (void)unregisterXGPush:(dispatch_block_t)completion
{
        [self resetRemoteNotificationRegisterCallbacks];
        [self _unregisterXGPush];
        if (completion) {
                ESDispatchOnMainThreadAsynchrony(^{
                        completion();
                });
        }
}

@end
