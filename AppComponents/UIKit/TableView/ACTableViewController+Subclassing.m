//
//  ACTableViewController+Subclassing.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACTableViewController+Private.h"

@implementation ACTableViewController (Subclassing)

- (void)refreshData
{
}

- (void)cancelRefreshingData
{
        self.refreshingData = NO;
}

- (void)refreshingDataDidFinish:(id)data
{
        self.refreshingData = NO;
}

- (void)loadMoreData
{
}

- (void)cancelLoadingMoreData
{
        self.loadingMoreData = NO;
}

- (void)loadingMoreDataDidFinish:(id)data
{
        self.loadingMoreData = NO;
}

- (ESActivityLabel *)createLoadingMoreActivityLabel
{
        return nil;
}

@end
