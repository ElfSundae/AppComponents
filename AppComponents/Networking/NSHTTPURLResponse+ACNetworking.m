//
//  NSHTTPURLResponse+ACNetworking.m
//  AppComponents
//
//  Created by Elf Sundae on 16/03/30.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NSHTTPURLResponse+ACNetworking.h"
#import <ESFramework/ESFrameworkCore.h>

@implementation NSHTTPURLResponse (ACNetworking)

- (NSDate *)dateOfHeaderField
{
        NSString *dateString = ESStringValue(self.allHeaderFields[@"Date"]);
        return [NSDate dateWithRFC1123String:dateString];
}

@end
