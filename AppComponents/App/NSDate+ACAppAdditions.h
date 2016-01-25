//
//  NSDate+ACAppAdditions.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ACAppAdditions)

/** 相对时间字符串。
 * 刚刚、x分钟前、1小时前、08-12 23:04、2015-02-03 09:21
 */
- (NSString *)ac_relativeDateString;

@end
