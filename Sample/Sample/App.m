//
//  App.m
//  Sample
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "App.h"

@implementation App
@dynamic rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        [super application:application didFinishLaunchingWithOptions:launchOptions];
        self.window.rootViewController = self.rootViewController =
        [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];
        
        [self.window makeKeyAndVisible];
        return YES;
}

@end
