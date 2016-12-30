//
//  ACConfig.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESFrameworkCore.h>
#import "AppComponentsDefines.h"

/**
 * 各个组件的配置信息。
 */

FOUNDATION_EXTERN NSMutableDictionary *ACConfig(void);
FOUNDATION_EXTERN id ACConfigGet(NSString *keyPath);
FOUNDATION_EXTERN BOOL ACConfigSet(NSString *keyPath, id object);
FOUNDATION_EXTERN void ACConfigSetDictionary(NSDictionary *dictionary);
