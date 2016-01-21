//
//  ESApp+ACSettingsSubclass.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>
#import <AppComponents/ACSettings.h>

@interface ESApp (ACSettingsSubclass)

- (NSString *)currentUserID;
- (NSDictionary *)userSettingsDefaults;
- (NSDictionary *)appConfigDefaults;

@end
