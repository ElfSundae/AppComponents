//
//  ACTableViewController+Private.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AppComponents/ACTableViewController.h>
#import <ESFramework/ESFrameworkCore.h>
#import <ESFramework/ESFrameworkAdditions.h>
#import <ESFramework/ESActivityLabel.h>
#import <ESFramework/ESButton.h>
#import <ESFramework/ESErrorView.h>

@interface ACTableViewController ()
{
@protected
        CGFloat _loadingMoreViewHeight; // default is 44.f
        
        struct {
                /** 实例化TableViewController是的flag，在实例化之后不要设置这些值 */
                unsigned int hasRefreshControl:1; // default is NO
                unsigned int loadingMoreViewHasTopLine:1; // default is NO
                /// tableData是包含设置XXIconTableViewCell的字典, tableData是二维数组，其中tableData.count是tableView.section
                unsigned int configureIconCellWithTableData:1;
                unsigned int useTableFooterViewAsLoadingMoreView:1; // default is YES, 用tableFooterView来显示loadingMoreView
                
                /** KVO flags */
                unsigned int isObserveredTableViewsContentSize:1;
                unsigned int isObserveredTableViewsContentOffset:1;
        } _flags;
}

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, getter=isRefreshingData) BOOL refreshingData;
@property (nonatomic) BOOL hasMoreData;
@property (nonatomic, getter=isLoadingMoreData) BOOL loadingMoreData;

@property (nonatomic, strong) ESErrorView *errorView;
@property (nonatomic, strong) UIView *loadingMoreView; // used to tableView.tableFooterView
@property (nonatomic, strong) UIView *oldTableFooterView; // stored the old tableFooterView
@property (nonatomic, strong) ESActivityLabel *loadingMoreActivityLabel;

/// 开始刷新数据, 调用[refreshControl beginRefreshing], 检查状态并调用 -refreshData
- (void)startRefreshData;
/// 开始加载更多, 检查状态并调用 -loadMoreData
- (void)startLoadMoreData;

- (ESErrorView *)showErrorViewWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image tag:(NSInteger)tag actionButtonTitle:(NSString *)actionButtonTitle actionButtonHandle:(ESUIControlHandler)actionButtonHandler;
- (ESErrorView *)showErrorViewForNoData:(NSString *)title;
- (void)hideErrorView;

- (void)scrollTableViewToTop:(BOOL)animated;
- (void)setVisibleCellsNeedDisplay;
- (void)setVisibleCellsNeedLayout;

/// 该方法仅在 _flags.configureIconCellWithTableData 为true时有效
- (NSDictionary *)iconCellDataForIndexPath:(NSIndexPath *)indexPath;
/// 该方法仅在 _flags.configureIconCellWithTableData 为true时有效, 如果"cell_class"没设置，默认是XXIconDefaultStyleTableViewCell
- (NSString *)iconCellClassNameForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)iconCellTitleForIndexPath:(NSIndexPath *)indexPath;
@end


@interface ACTableViewController (Subclassing)
/// 刷新(请求)数据
- (void)refreshData;
/// 取消刷新
- (void)cancelRefreshingData;
/// 刷新数据完成，设置hasMore
- (void)refreshingDataDidFinish:(id)data;

/// 加载更多数据
- (void)loadMoreData;
/// 取消加载更多
- (void)cancelLoadingMoreData;
/// 加载更多数据完成，设置hasMore
- (void)loadingMoreDataDidFinish:(id)data;

- (ESActivityLabel *)createLoadingMoreActivityLabel;
@end

@interface ACTableViewController (TableViewDataSource)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (Class)tableView:(UITableView *)tableView cellClassForRowAtIndexPath:(NSIndexPath *)indexPath cellData:(id)cellData;
- (id)tableView:(UITableView *)tableView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
@end
