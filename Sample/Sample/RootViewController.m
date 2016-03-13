//
//  RootViewController.m
//  Sample
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "RootViewController.h"

@interface Dict : NSDictionary
@end

@implementation Dict

@end

@implementation RootViewController

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.view.backgroundColor = [UIColor es_viewBackgroundColor];
        self.navigationItem.title = [ESApp sharedApp].appDisplayName;
        
        ESWeakSelf;
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"Table" handler:^(UIBarButtonItem *barButtonItem) {
                ESStrongSelf;
        }];
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"Feedback" handler:^(UIBarButtonItem *barButtonItem) {
                ESStrongSelf;
                ACFeedbackViewController *feedback = [[ACFeedbackViewController alloc] init];
                [_self.navigationController pushViewController:feedback animated:YES];
        }];
}

@end
