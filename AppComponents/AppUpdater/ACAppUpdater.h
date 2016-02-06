//
//  ACAppUpdater.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ESFramework/ESFrameworkCore.h>
#import <AppComponents/ACConfig.h>

/**
 * App版本有所变化，可能发现了新版本， 用 +newVersionExists 检查是否存在新版本。
 */
FOUNDATION_EXTERN NSString *const ACAppUpdaterNewVersionDidChangeNotification;

/**
 * App更新方式： 可选，强制
 */
typedef NS_ENUM(int, ACAppUpdateWay){
        ACAppUpdateWayNone        = 0,
        ACAppUpdateWayOptional    = 1,
        ACAppUpdateWayForce       = 2
};

/*!
 * 处理App版本更新。弹窗提示，打开新版本下载地址。
 */
@interface ACAppUpdater : NSObject

/**
 * 是否有新的App版本
 */
+ (BOOL)newVersionExists;

/**
 * 最新的App版本
 */
+ (NSString *)newVersion;
+ (void)setNewVersion:(NSString *)newVersion;

/**
 * 根据服务端数据检查是否有更新，并且弹窗提示。
 *
 * @code
 * {
 *     "version": "1.2.0",
 *     "way": 1, // 1, 2
 *     "desc": "新版本描述",
 *     "url": "itms-app://xxxx" //可选, 如果没有此值，客户端默认用[ESApp sharedApp].appID生成链接并打开App Store
 * }
 * @endcode
 *
 * @param serverData 服务端数据, 可以是包含版本数据的外部字典， 例如 {version: ...} 或者 {app_version: {version: ...}}
 * @param minWay     如果有更新并且更新的way大于或等于minWay，则弹窗提示app新版本。 如果minWay为AppUpdateWayNone，则不论是否有更新都弹窗
 * @param completion 方法完成或弹窗完成后的回调
 */
+ (void)checkNewVersionWithData:(NSDictionary *)data alertByMinWay:(ACAppUpdateWay)minWay completion:(dispatch_block_t)completion;

@end
