//
//  NSDate+ACAppAdditions.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NSDate+ACAppAdditions.h"
#import <ESFramework/ESFrameworkCore.h>
#import "ESApp+ACHelper.h"

@implementation NSDate (ACAppAdditions)

- (NSString *)ac_relativeDateString
{
        NSTimeInterval elapsed = [self timeIntervalSinceNow];
        if (elapsed > 0 || -elapsed <= ES_MINUTE) {
                return @"刚刚";
        }
        elapsed = -elapsed;
        if (elapsed < ES_HOUR) {
                return NSStringWith(@"%d分钟前", (int)(elapsed / ES_MINUTE));
        } else if (elapsed < ES_HOUR * 1.5) {
                return @"1小时前";
        } else if (elapsed < ES_YEAR) {
                return [[[ESApp sharedApp] appWebServerDateFormatterWithShortStyle] stringFromDate:self];
        } else {
                return [[[ESApp sharedApp] appWebServerDateFormatterWithFullDateStyle] stringFromDate:self];
        }
}

@end
