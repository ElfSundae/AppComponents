//
//  ACWebViewController+Private.m
//  AppComponents
//
//  Created by Elf Sundae on 16/3/28.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACWebViewController+Private.h"
#import <ESFramework/ESStoreProductViewControllerManager.h>

@implementation ACWebViewController (Private)

- (id)_AFNetworkActivityIndicatorSharedManager
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        Class AFNetworkActivityIndicatorManagerClass = NSClassFromString(@"AFNetworkActivityIndicatorManager");
        return [AFNetworkActivityIndicatorManagerClass performSelector:@selector(sharedManager)];
#pragma clang diagnostic pop
}

- (BOOL)_getAFNetworkActivityIndicatorManagerEnabled
{
        BOOL enabled = NO;
        ESInvokeSelector([self _AFNetworkActivityIndicatorSharedManager], @selector(isEnabled), NO, &enabled);
        return enabled;
}

- (void)_setAFNetworkActivityIndicatorManagerEnabled:(BOOL)enabled
{
        ESInvokeSelector([self _AFNetworkActivityIndicatorSharedManager], @selector(setEnabled:), NO, NULL, enabled);
}

- (void)_setNetworkActivityIndicatorVisible:(BOOL)visible
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if (visible) {
                [[self _AFNetworkActivityIndicatorSharedManager] performSelector:@selector(incrementActivityCount)];
        } else {
                [[self _AFNetworkActivityIndicatorSharedManager] performSelector:@selector(decrementActivityCount)];
        }
#pragma clang diagnostic pop
}

@end
