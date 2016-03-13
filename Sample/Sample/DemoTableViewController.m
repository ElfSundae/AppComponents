//
//  DemoTableViewController.m
//  Sample
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "DemoTableViewController.h"
#import <AppComponents/ACTableViewController+Subclassing.h>

@implementation DemoTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style initializationFlags:(ACTableViewControllerInitializationFlags)initializationFlags
{
        initializationFlags.configuresCellWithTableData = YES;
        self = [super initWithStyle:style initializationFlags:initializationFlags];
        self.showsRefreshControl = YES;
        return self;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        [self.tableData addObject:@[@{ACTableViewCellConfigKeyText: @"Cell Title"}]];
}

@end
