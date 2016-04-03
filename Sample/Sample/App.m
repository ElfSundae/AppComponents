//
//  App.m
//  Sample
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "App.h"
#import "VendorServices.h"

@implementation App
@dynamic rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        [super application:application didFinishLaunchingWithOptions:launchOptions];
        
        [self setupVendorServices];
        [self setupGlobalUIAppearances];
        
        self.window.rootViewController = self.rootViewController =
        [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];
        
        [self.window makeKeyAndVisible];
        return YES;
}

- (NSString *)appStoreID
{
        return kAppStoreID;
}
- (NSString *)appChannel
{
        return kAppChannel;
}
- (NSTimeZone *)appWebServerTimeZone
{
        return [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
}

- (void)setupGlobalUIAppearances
{
        [UINavigationBar appearance].barTintColor = [UIColor es_blackNavigationBarColor];
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil].tintColor = [UIColor whiteColor];
        [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        [UITabBar appearanceWhenContainedIn:[UITabBarController class], nil].tintColor = [UIColor es_redNavigationBarColor];
}

@end
