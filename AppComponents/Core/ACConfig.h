//
//  ACConfig.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 各个组件的配置信息。
 */
@interface ACConfig : NSObject

+ (NSMutableDictionary *)config;
+ (id)get:(NSString *)keyPath;
+ (BOOL)set:(id)object forKeyPath:(NSString *)keyPath;
/**
 * @param dictionary { keyPath => object }
 */
+ (void)setWithDictionary:(NSDictionary *)dictionary;

@end
