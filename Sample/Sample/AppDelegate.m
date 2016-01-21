//
//  AppDelegate.m
//  Sample
//
//  Created by Elf Sundae on 16/1/19.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        [self.window addTapGestureHandler:^(UITapGestureRecognizer *gestureRecognizer, UIView *view, CGPoint locationInView) {
                [[ESApp sharedApp] showLocalNetworkErrorTipsWithSuperview:nil];
        }];
        return YES;
}

@end
