//
//  ESApp+ACAuthAdditions.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACAuthAdditions.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+AddressBookMethods.h>

@implementation ESApp (ACAuthAdditions)

+ (void)setupMobSMSWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret enableContactFriends:(BOOL)enableContactFriends
{
        [SMSSDK enableAppContactFriends:enableContactFriends];
        [SMSSDK registerApp:appKey withSecret:appSecret];
}

@end
