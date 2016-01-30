//
//  ACTableViewController.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACTableViewController+Private.h"

@implementation ACTableViewController

- (void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self _removeTableViewsObservers];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
        self = [super initWithStyle:style];
        if (self) {
                self.tableData = [NSMutableArray array];
                _flags.loadingMoreViewHasTopLine = NO;
                _flags.useTableFooterViewAsLoadingMoreView = YES;
                _loadingMoreViewHeight = 44.f;
        }
        return self;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.view.backgroundColor = [UIColor es_viewBackgroundColor];
        if (_flags.hasRefreshControl) {
                ESWeakSelf;
                self.tableView.refreshControl = [ESRefreshControl controlWithStartRefreshingBlock:^(ESRefreshControl *refreshControl) {
                        ESStrongSelf;
                        [_self startRefreshData];
                }];
        }
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillDisappear:(BOOL)animated
{
        [super viewWillDisappear:animated];
        if (self.isBeingDismissed || self.isMovingFromParentViewController ||
            self.navigationController.isBeingDismissed || self.navigationController.isMovingFromParentViewController) {
                [self _removeTableViewsObservers];
        }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
        if (object == self.tableView &&
            ([keyPath isEqualToString:@"contentOffset"] || [keyPath isEqualToString:@"contentSize"]) &&
            _loadingMoreView &&
            self.tableView.tableFooterView == self.loadingMoreView &&
            !self.isLoadingMoreData && self.hasMoreData)
        {
                if ((self.tableView.contentOffset.y + self.tableView.bounds.size.height) > (self.tableView.contentSize.height + self.loadingMoreView.height)) {
                        [self startLoadMoreData];
                }
        }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
        if (self.navigationController.navigationBar.barTintColor.es_isLightColor) {
                return UIStatusBarStyleDefault;
        } else {
                return UIStatusBarStyleLightContent;
        }
}

- (UIView *)loadingMoreView
{
        if (!_loadingMoreView) {
                _loadingMoreView = [[UIView alloc] initWithFrame:CGRectZero];
        }
        return _loadingMoreView;
}

- (void)_addTableViewsObservers
{
        if (_loadingMoreView && self.tableView.tableFooterView == _loadingMoreView) {
                if (!_flags.isObserveredTableViewsContentSize) {
                        [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
                        _flags.isObserveredTableViewsContentSize = YES;
                }
                if (!_flags.isObserveredTableViewsContentOffset) {
                        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
                        _flags.isObserveredTableViewsContentOffset = YES;
                }
        }
}

- (void)_removeTableViewsObservers
{
        if (_flags.isObserveredTableViewsContentSize) {
                [self.tableView removeObserver:self forKeyPath:@"contentSize"];
                _flags.isObserveredTableViewsContentSize = NO;
        }
        if (_flags.isObserveredTableViewsContentOffset) {
                [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
                _flags.isObserveredTableViewsContentOffset = NO;
        }
}

- (UIView *)oldTableFooterView
{
        if (!_oldTableFooterView) {
                _oldTableFooterView = self.tableView.tableFooterView;
        }
        return _oldTableFooterView;
}

- (void)setHasMoreData:(BOOL)hasMoreData
{
        _hasMoreData = hasMoreData;
        
        if (!_flags.useTableFooterViewAsLoadingMoreView) {
                return;
        }
        
        if (!_hasMoreData) {
                self.tableView.tableFooterView = self.oldTableFooterView;
                [self _removeTableViewsObservers];
                return;
        }
        
        self.loadingMoreView.width = self.tableView.width;
        self.loadingMoreView.height = _loadingMoreViewHeight;
        
        if (!self.loadingMoreActivityLabel) {
                ESActivityLabel *label = [self createLoadingMoreActivityLabel];
                if (!label) {
                        label = [[ESActivityLabel alloc] initWithStyle:ESActivityLabelStyleGray text:@"加载中..."];
                }
                [label sizeToFit];
                label.center = CGPointMake(self.loadingMoreView.width / 2.f, self.loadingMoreView.height / 2.f);
                self.loadingMoreActivityLabel = label;
                [self.loadingMoreView addSubview:self.loadingMoreActivityLabel];
                
                if (_flags.loadingMoreViewHasTopLine) {
                        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.7f, self.loadingMoreView.width - 40.f, 0.7f)];
                        line.centerX = self.loadingMoreView.width / 2.f;
                        line.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
                        line.backgroundColor = [UIColor es_lightBorderColor];
                        [self.loadingMoreView addSubview:line];
                }
        }
        
        if (self.tableView.tableFooterView != self.loadingMoreView) {
                self.oldTableFooterView = self.tableView.tableFooterView;
        }
        self.tableView.tableFooterView = self.loadingMoreView;
        [self _addTableViewsObservers];
}

- (void)setRefreshingData:(BOOL)refreshing
{
        _refreshingData = refreshing;
        if (!_refreshingData && self.tableView.refreshControl && self.tableView.refreshControl.isRefreshing) {
                [self.tableView.refreshControl endRefreshing];
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
        // self.errorView.backgroundColor = self.view.backgroundColor;
        self.errorView.tag = tag;
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

- (void)scrollTableViewToTop:(BOOL)animated
{
        [self.tableView setContentOffset:CGPointZero animated:animated];
}

- (void)setVisibleCellsNeedDisplay
{
        [self.tableView.visibleCells makeObjectsPerformSelector:@selector(setNeedsDisplay)];
}

- (void)setVisibleCellsNeedLayout
{
        [self.tableView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
}

- (NSDictionary *)iconCellDataForIndexPath:(NSIndexPath *)indexPath
{
        if (_flags.configureIconCellWithTableData) {
                return self.tableData[indexPath.section][indexPath.row];
        }
        return nil;
}

- (NSString *)iconCellClassNameForIndexPath:(NSIndexPath *)indexPath
{
        if (_flags.configureIconCellWithTableData) {
                return [self iconCellDataForIndexPath:indexPath][@"cell_class"] ?: @"XXIconDefaultStyleTableViewCell";
        }
        return @"UITableViewCell";
}

- (NSString *)iconCellTitleForIndexPath:(NSIndexPath *)indexPath
{
        if (_flags.configureIconCellWithTableData) {
                return [self iconCellDataForIndexPath:indexPath][@"title"];
        }
        return nil;
}

@end
