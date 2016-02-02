//
//  ACTableViewController+Private.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/31.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AppComponents/ACTableViewController.h>
#import <ESFramework/ESFrameworkCore.h>
#import <ESFramework/ESFrameworkAdditions.h>
#import <ESFramework/ESErrorView.h>
#import <ESFramework/ESActivityLabel.h>
#import <ESFramework/ESButton.h>
#import <AppComponents/ACTableViewCell.h>

@interface ACTableViewController ()
{
@protected
        CGFloat _loadingMoreViewHeight; // default is 44.f
        
        struct {
                /** KVO flags */
                unsigned int isObserveredTableViewsContentSize:1;
                unsigned int isObserveredTableViewsContentOffset:1;
        } _flags;
}

@property (nonatomic, getter=isRefreshingData) BOOL refreshingData;
@property (nonatomic, getter=isLoadingMoreData) BOOL loadingMoreData;
@property (nonatomic) BOOL hasMoreData;

@property (nonatomic, strong) ESErrorView *errorView;
/// used for tableView.tableFooterView
@property (nonatomic, strong) UIView *loadingMoreView;
/// stored the original tableFooterView
@property (nonatomic, strong) UIView *originalTableFooterView;

@property (nonatomic, strong) ESActivityLabel *loadingMoreActivityLabel;

@end

@interface ACTableViewController (Private)
/// 开始刷新数据, 调用[refreshControl beginRefreshing], 检查状态并调用 -refreshData
- (void)startRefreshData;
/// 开始加载更多, 检查状态并调用 -loadMoreData
- (void)startLoadMoreData;

- (ESErrorView *)showErrorViewWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image tag:(NSInteger)tag actionButtonTitle:(NSString *)actionButtonTitle actionButtonHandle:(ESUIControlHandler)actionButtonHandler;
- (ESErrorView *)showErrorViewForNoData:(NSString *)title;
- (void)hideErrorView;

- (void)_checkRefreshControl;

// 该方法仅在self.initializationFlags.configuresCellWithTableData为true时有效，
- (NSDictionary *)ac_cellDataForIndexPath:(NSIndexPath *)indexPath;
// 该方法仅在self.initializationFlags.configuresCellWithTableData为true时有效，取ACTableViewCellConfigurationKeyCellClass，默认[ACTableViewCell class]
- (Class)ac_cellClassForIndexPath:(NSIndexPath *)indexPath;
// 该方法仅在self.initializationFlags.configuresCellWithTableData为true时有效，取ACTableViewCellConfigurationKeyCellStyle，默认ACTableViewCellStyleDefault
- (ACTableViewCellStyle)ac_cellStyleForIndexPath:(NSIndexPath *)indexPath;
// 该方法仅在self.initializationFlags.configuresCellWithTableData为true时有效， 取text的值
- (NSString *)ac_cellTextForIndexPath:(NSIndexPath *)indexPath;
@end

@interface ACTableViewController (Subclassing)
/// 刷新(请求)数据
- (void)refreshData;
/// 取消刷新
- (void)cancelRefreshingData __attribute__((objc_requires_super));
/// 刷新数据完成，设置hasMore
- (void)refreshingDataDidFinish:(id)data __attribute__((objc_requires_super));

/// 加载更多数据
- (void)loadMoreData;
/// 取消加载更多
- (void)cancelLoadingMoreData __attribute__((objc_requires_super));
/// 加载更多数据完成，设置hasMore
- (void)loadingMoreDataDidFinish:(id)data __attribute__((objc_requires_super));

- (ESActivityLabel *)createLoadingMoreActivityLabel;
@end

@interface ACTableViewController (TableViewDataSource)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (id)tableView:(UITableView *)tableView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath;
- (Class)tableView:(UITableView *)tableView cellClassForRowAtIndexPath:(NSIndexPath *)indexPath cellData:(id)cellData;
- (UITableViewCell *)tableView:(UITableView *)tableView cellNewInstanceForRowAtIndexPath:(NSIndexPath *)indexPath cellClass:(Class)cellClass reuseIdentifier:(NSString *)reuseIdentifier;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
@end
