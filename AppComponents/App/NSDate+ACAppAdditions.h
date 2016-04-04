//
//  NSDate+ACAppAdditions.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ACAppAdditions)

/**
 * 根据距今时间间隔显示不同的日期格式。
 * 11:23,  02-18 11:23,  2015-02-03 09:21
 */
- (NSString *)ac_sampleDateString;

/**
 * 相对时间字符串。
 * 刚刚、x分钟前、1小时前、08-12 23:04、2015-02-03 09:21
 */
- (NSString *)ac_relativeDateString;

@end
