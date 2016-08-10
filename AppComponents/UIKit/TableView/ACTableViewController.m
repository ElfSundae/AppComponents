//
//  ACTableViewController.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACTableViewController.h"

NSString *const ACTableViewCellConfigKeyCellClass = @"cellClass";
NSString *const ACTableViewCellConfigKeyCellReuseIdentifier = @"cellReuseIdentifier";
NSString *const ACTableViewCellConfigKeyCellHeight = @"cellHeight";
NSString *const ACTableViewCellConfigKeyCellSelector = @"cellSelector";

@implementation ACTableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self ac_removeTableViewsObservers];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableData = [NSMutableArray array];
        self.usesTableFooterViewAsLoadingMoreView = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor es_viewBackgroundColor];
    [self ac_checkRefreshControl];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isBeingDismissed || self.isMovingFromParentViewController ||
        self.navigationController.isBeingDismissed || self.navigationController.isMovingFromParentViewController)
    {
        [self ac_removeTableViewsObservers];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIColor *barTintColor = (self.navigationController.navigationBar.barTintColor ?: [UINavigationBar appearance].barTintColor);
    if (!barTintColor || barTintColor.es_isLightColor) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.tableView &&
        ([keyPath isEqualToString:@"contentOffset"] || [keyPath isEqualToString:@"contentSize"]) &&
        _loadingMoreView &&
        self.tableView.tableFooterView == _loadingMoreView &&
        self.hasMoreData &&
        !self.isLoadingMoreData)
    {
        if ((self.tableView.contentOffset.y + self.tableView.bounds.size.height) > (self.tableView.contentSize.height + _loadingMoreView.height)) {
            [self loadMoreData];
        }
    }
}

- (void)setShowsRefreshControl:(BOOL)showsRefreshControl
{
    if (_showsRefreshControl != showsRefreshControl) {
        _showsRefreshControl = showsRefreshControl;
        [self ac_checkRefreshControl];
    }
}

- (void)setUsesTableFooterViewAsLoadingMoreView:(BOOL)use
{
    if (_usesTableFooterViewAsLoadingMoreView != use) {
        _usesTableFooterViewAsLoadingMoreView = use;
        [self ac_checkLoadingMoreView];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Data Loading

- (BOOL)refreshData
{
    if (self.isRefreshingData) {
        return NO;
    }

    if (self.refreshControl && !self.refreshControl.isRefreshing) {
        [self.refreshControl beginRefreshing];
        return NO;
    }
    if (self.isLoadingMoreData) {
        [self cancelLoadingMoreData];
    }
    [self hideErrorView];
    self.hasMoreData = NO;
    _refreshingData = YES;
    return YES;
}

- (void)_ac_refreshingDataDidFinish
{
    _refreshingData = NO;
    ESDispatchOnMainThreadAsynchrony(^{
        if (self.refreshControl && self.refreshControl.isRefreshing) {
            [self.refreshControl endRefreshing];
        }
    });
}

- (void)cancelRefreshingData
{
    [self _ac_refreshingDataDidFinish];
}

- (void)refreshingDataDidFinish:(id)data
{
    [self _ac_refreshingDataDidFinish];
}

- (BOOL)loadMoreData
{
    if (self.isRefreshingData || self.isLoadingMoreData || !self.hasMoreData) {
        return NO;
    }
    _loadingMoreData = YES;
    return YES;
}

- (void)ac_loadingMoreDataDidFinish
{
    _loadingMoreData = NO;
}

- (void)cancelLoadingMoreData
{
    [self ac_loadingMoreDataDidFinish];
}

- (void)loadingMoreDataDidFinish:(id)data
{
    [self ac_loadingMoreDataDidFinish];
}

- (void)setHasMoreData:(BOOL)hasMoreData
{
    _hasMoreData = hasMoreData;
    [self ac_checkLoadingMoreView];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ErrorView

- (ESErrorView *)showErrorViewWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image tag:(NSInteger)tag actionButtonTitle:(NSString *)actionButtonTitle actionButtonHandle:(ESUIControlHandler)actionButtonHandler
{
    if (!self.isViewLoaded) {
        return nil;
    }

    if (_errorView && tag == _errorView.tag) {
        return _errorView;
    }

    [self hideErrorView];
    _errorView = [[ESErrorView alloc] initWithFrame:self.view.bounds title:title subtitle:subtitle image:image];
    _errorView.backgroundColor = self.tableView.backgroundColor;
    _errorView.tag = tag;
    if ([_errorView.backgroundColor es_isLightColor]) {
        _errorView.titleLabel.textColor = [UIColor colorWithRed:0.376 green:0.404 blue:0.435 alpha:1.000];
    } else {
        _errorView.titleLabel.textColor = [UIColor es_lightBorderColor];
    }
    if (actionButtonTitle) {
        ESButton *button = [ESButton buttonWithStyle:ESButtonStyleRoundedRect];
        [button setTitle:actionButtonTitle forState:UIControlStateNormal];
        [button setButtonColor:[UIColor es_successButtonColor]];
        [button sizeToFit];
        button.width = fmaxf(button.width, self.view.width * 0.4f);
        [button addEventHandler:actionButtonHandler forControlEvents:UIControlEventTouchUpInside];
        _errorView.actionButton = button;
    }
    [self.view addSubview:_errorView];
    return _errorView;
}

- (ESErrorView *)showErrorViewForNoData:(NSString *)title
{
    ESWeakSelf;
    ESErrorView *errorView = [self showErrorViewWithTitle:title subtitle:nil image:nil tag:0 actionButtonTitle:@"刷新" actionButtonHandle:^(id sender, UIControlEvents controlEvent) {
        ESStrongSelf;
        [_self hideErrorView];
        [_self refreshData];
    }];
    return errorView;
}

- (void)hideErrorView
{
    if (_errorView) {
        [_errorView removeFromSuperview];
        _errorView = nil;
    }
}

@end
