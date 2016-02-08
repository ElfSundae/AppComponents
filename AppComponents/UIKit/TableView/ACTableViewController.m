//
//  ACTableViewController.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACTableViewController+Subclassing.h"

NSString *const ACTableViewCellConfigKeyCellClass = @"cellClass";
NSString *const ACTableViewCellConfigKeyCellStyle = @"cellStyle";

@implementation ACTableViewController

- (void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self _removeTableViewsObservers];
}

- (instancetype)initWithStyle:(UITableViewStyle)style initializationFlags:(ACTableViewControllerInitializationFlags)initializationFlags
{
        self = [super initWithStyle:style];
        if (self) {
                _tableData = [NSMutableArray array];
                _initializationFlags = initializationFlags;
                _loadingMoreViewHeight = 44.f;
        }
        return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
        ACTableViewControllerInitializationFlags flags;
        flags.loadingMoreViewHasTopLine = NO;
        flags.configuresCellWithTableData = NO;
        flags.useTableFooterViewAsLoadingMoreView = YES;
        return [self initWithStyle:style initializationFlags:flags];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
        if (!self.navigationController.navigationBar.barTintColor ||
            self.navigationController.navigationBar.barTintColor.es_isLightColor) {
                return UIStatusBarStyleDefault;
        } else {
                return UIStatusBarStyleLightContent;
        }
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.view.backgroundColor = [UIColor es_viewBackgroundColor];
        [self _checkRefreshControl];
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Getter / Setter

- (void)setShowsRefreshControl:(BOOL)showsRefreshControl
{
        if (_showsRefreshControl != showsRefreshControl) {
                _showsRefreshControl = showsRefreshControl;
                [self _checkRefreshControl];
        }
}

- (UIView *)originalTableFooterView
{
        _originalTableFooterView || (_originalTableFooterView = self.tableView.tableFooterView);
        return _originalTableFooterView;
}

- (void)setRefreshingData:(BOOL)refreshing
{
        _refreshingData = refreshing;
        if (!_refreshingData && self.tableView.refreshControl && self.tableView.refreshControl.isRefreshing) {
                [self.tableView.refreshControl endRefreshing];
        }
}

- (UIView *)loadingMoreView
{
        if (!_loadingMoreView) {
                _loadingMoreView = [[UIView alloc] initWithFrame:CGRectZero];
        }
        return _loadingMoreView;
}

- (void)setHasMoreData:(BOOL)hasMoreData
{
        _hasMoreData = hasMoreData;
        
        if (!self.initializationFlags.useTableFooterViewAsLoadingMoreView) {
                return;
        }
        
        if (!_hasMoreData) {
                self.tableView.tableFooterView = self.originalTableFooterView;
                [self _removeTableViewsObservers];
                return;
        }
        
        self.loadingMoreView.width = self.tableView.width;
        self.loadingMoreView.height = _loadingMoreViewHeight;
        
        if (!self.loadingMoreActivityLabel) {
                ESActivityLabel *label = [self createLoadingMoreActivityLabel];
                if (!label) {
                        label = [[ESActivityLabel alloc] initWithFrame:CGRectMake(0, 0, self.loadingMoreView.width, 0)
                                            activityIndicatorViewStyle:UIActivityIndicatorViewStyleGray
                                                        attributedText:[[NSAttributedString alloc] initWithString:@"加载中..." attributes:[ESActivityLabel defaultTextAttributes]]];
                }
                [label sizeToFit];
                label.center = CGPointMake(self.loadingMoreView.width / 2.f, self.loadingMoreView.height / 2.f);
                self.loadingMoreActivityLabel = label;
                [self.loadingMoreView addSubview:self.loadingMoreActivityLabel];
                
                if (self.initializationFlags.loadingMoreViewHasTopLine) {
                        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0.7f, self.loadingMoreView.width - 40.f, 0.7f)];
                        line.centerX = self.loadingMoreView.width / 2.f;
                        line.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
                        line.backgroundColor = [UIColor es_lightBorderColor];
                        [self.loadingMoreView addSubview:line];
                }
        }
        
        if (self.tableView.tableFooterView != self.loadingMoreView) {
                self.originalTableFooterView = self.tableView.tableFooterView;
        }
        self.tableView.tableFooterView = self.loadingMoreView;
        [self _addTableViewsObservers];
}

@end
