//
//  ESApp+ACMobSMS.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACMobSMS.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+AddressBookMethods.h>

@implementation ESApp (ACMobSMS)

- (BOOL)setupMobSMSWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret enableContactFriends:(BOOL)enableContactFriends
{
        if (ESIsStringWithAnyText(appKey) && ESIsStringWithAnyText(appSecret)) {
                [SMSSDK enableAppContactFriends:enableContactFriends];
                [SMSSDK registerApp:appKey withSecret:appSecret];
                return YES;
        }
        return NO;
}

@end
