//
//  RootViewController.m
//  Sample
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "RootViewController.h"
#import "DemoTableViewController.h"
#import <FontAwesomeKit/FAKFontAwesome.h>

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
        
        self.view.backgroundColor = [UIColor blueColor];
        
        UIImage *image = [FAKFontAwesome imageWithIconIdentifier:@"fa-mobile" color:[UIColor redColor] fontSize:45];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(100, 200);
        [self.view addSubview:imageView];
}

@end
