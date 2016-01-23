//
//  ESApp+ACMobSMS.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>

@interface ESApp (ACMobSMS)
/**
 * 初始化MobSMS.
 * http://sms.mob.com/#/sms
 */
- (BOOL)setupMobSMSWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret enableContactFriends:(BOOL)enableContactFriends;

@end
