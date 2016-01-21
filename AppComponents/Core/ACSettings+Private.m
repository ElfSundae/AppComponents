//
//  ACSettings+Private.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACSettings+Private.h"
#import <ESFramework/ESFrameworkCore.h>

@implementation ACSettings (Private)

- (void)_setSettingsIdentifier:(NSString *)identifier
{
        if (ESIsStringWithAnyText(identifier)) {
                self[ACSettingsIdentifierKey] = identifier;
        } else {
                [self removeObjectForKey:ACSettingsIdentifierKey];
        }
}


@end
