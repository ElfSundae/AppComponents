//
//  RootViewController.m
//  Sample
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "RootViewController.h"
#import "DemoTableViewController.h"

@implementation RootViewController

- (void)viewDidLoad
{
        [super viewDidLoad];
        ESWeakSelf;
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"Table" handler:^(UIBarButtonItem *barButtonItem) {
                ESStrongSelf;
                DemoTableViewController *tableVC = [[DemoTableViewController alloc] init];
                [self.navigationController pushViewController:tableVC animated:YES];
        }];
}

@end
