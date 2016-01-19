//
//  ACConfig.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESFrameworkCore.h>

/**
 * 各个组件的配置信息。
 */

ES_EXTERN NSMutableDictionary *ACConfig(void);
ES_EXTERN id ACConfigGet(NSString *keyPath);
ES_EXTERN BOOL ACConfigSet(NSString *keyPath, id object);
ES_EXTERN void ACConfigSetDictionary(NSDictionary *dictionary);
