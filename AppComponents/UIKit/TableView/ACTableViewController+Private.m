//
//  ACTableViewController+Private.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/31.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACTableViewController+Private.h"

@implementation ACTableViewController (Private)

- (void)_checkRefreshControl
{
        if (!self.isViewLoaded) {
                return;
        }
        if (self.showsRefreshControl && !self.tableView.refreshControl) {
                ESWeakSelf;
                self.tableView.refreshControl = [ESRefreshControl controlWithStartRefreshingBlock:^(ESRefreshControl *refreshControl) {
                        ESStrongSelf;
                        [_self startRefreshData];
                }];
        } else if (!self.showsRefreshControl && self.tableView.refreshControl) {
                [self.tableView.refreshControl endRefreshing];
                self.tableView.refreshControl = nil;
        }
}

- (void)startRefreshData
{
        if (self.isRefreshingData) {
                return;
        }
        
        if (self.tableView.refreshControl && !self.tableView.refreshControl.isRefreshing) {
                [self.tableView.refreshControl beginRefreshing];
        } else {
                self.hasMoreData = NO;
                [self cancelLoadingMoreData];
                
                self.refreshingData = YES;
                [self hideErrorView];
                [self refreshData];
        }
}

- (void)startLoadMoreData
{
        if (self.isRefreshingData || self.isLoadingMoreData || !self.hasMoreData) {
                return;
        }
        
        self.loadingMoreData = YES;
        [self loadMoreData];
}

- (ESErrorView *)showErrorViewWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image tag:(NSInteger)tag actionButtonTitle:(NSString *)actionButtonTitle actionButtonHandle:(ESUIControlHandler)actionButtonHandler
{
        if (self.errorView && tag == self.errorView.tag) {
                return self.errorView;
        }
        
        [self hideErrorView];
        self.errorView = [[ESErrorView alloc] initWithFrame:self.view.bounds title:title subtitle:subtitle image:image];
        self.errorView.backgroundColor = self.view.backgroundColor;
        self.errorView.tag = tag;
        if ([self.errorView.backgroundColor es_isLightColor]) {
                self.errorView.titleLabel.textColor = [UIColor colorWithRed:0.376 green:0.404 blue:0.435 alpha:1.000];
        } else {
                self.errorView.titleLabel.textColor = [UIColor es_lightBorderColor];
        }
        if (actionButtonTitle) {
                ESButton *button = [ESButton buttonWithStyle:ESButtonStyleRoundedRect];
                [button setTitle:actionButtonTitle forState:UIControlStateNormal];
                [button setButtonColor:[UIColor es_successButtonColor]];
                [button sizeToFit];
                button.width = fmaxf(button.width, self.view.width * 0.4f);
                [button addEventHandler:actionButtonHandler forControlEvents:UIControlEventTouchUpInside];
                self.errorView.actionButton = button;
        }
        [self.view addSubview:self.errorView];
        return self.errorView;
}

- (ESErrorView *)showErrorViewForNoData:(NSString *)title
{
        ESWeakSelf;
        ESErrorView *errorView = [self showErrorViewWithTitle:(title?:@"暂无数据") subtitle:nil image:nil tag:0 actionButtonTitle:@"刷新" actionButtonHandle:^(id sender, UIControlEvents controlEvent) {
                ESStrongSelf;
                [_self hideErrorView];
                [_self.tableView.refreshControl beginRefreshing];
        }];
        return errorView;
}

- (void)hideErrorView
{
        if (self.errorView) {
                [self.errorView removeFromSuperview];
                self.errorView = nil;
        }
}

- (NSDictionary *)ac_cellDataForIndexPath:(NSIndexPath *)indexPath
{
        if (self.initializationFlags.configuresCellWithTableData) {
                return self.tableData[indexPath.section][indexPath.row];
        }
        return nil;
}

- (Class)ac_cellClassForIndexPath:(NSIndexPath *)indexPath
{
        if (self.initializationFlags.configuresCellWithTableData) {
                NSString *cellClass = ESStringValue([self ac_cellDataForIndexPath:indexPath][ACTableViewCellConfigurationKeyCellClass]);
                return cellClass ? NSClassFromString(cellClass) : [ACTableViewCell class];
        }
        return [UITableViewCell class];
}

- (ACTableViewCellStyle)ac_cellStyleForIndexPath:(NSIndexPath *)indexPath
{
        if (self.initializationFlags.configuresCellWithTableData) {
                NSInteger cellStyle = ESIntegerValueWithDefault([self ac_cellDataForIndexPath:indexPath][ACTableViewCellConfigurationKeyCellStyle], ACTableViewCellStyleDefault);
                return cellStyle;
        }
        return ACTableViewCellStyleDefault;
}

- (NSString *)ac_cellTextForIndexPath:(NSIndexPath *)indexPath
{
        if (self.initializationFlags.configuresCellWithTableData) {
                id text = [self ac_cellDataForIndexPath:indexPath][@"text"];
                if ([text isKindOfClass:[NSAttributedString class]]) {
                        return [(NSAttributedString *)text string];
                } else if ([text isKindOfClass:[NSString class]]) {
                        return (NSString *)text;
                }
        }
        return nil;
}

@end
