//
//  ACTableViewController+Private.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/31.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACTableViewController.h"

@implementation ACTableViewController (Private)

- (void)ac_checkRefreshControl
{
        if (!self.isViewLoaded) {
                return;
        }
        if (self.showsRefreshControl && !self.refreshControl) {
                ESWeakSelf;
                self.refreshControl = [ESRefreshControl refreshControlWithDidStartRefreshingBlock:^(ESRefreshControl *refreshControl) {
                        ESStrongSelf;
                        [_self refreshData];
                }];
        } else if (!self.showsRefreshControl && self.refreshControl) {
                [self.refreshControl endRefreshing];
                self.refreshControl = nil;
        }
}

- (void)ac_checkLoadingMoreView
{
        if (!self.isViewLoaded) {
                return;
        }
        
        if (self.usesTableFooterViewAsLoadingMoreView && self.hasMoreData) {
                if (!_loadingMoreView) {
                        _loadingMoreView = [self ac_createLoadingMoreView];
                        NSAssert(_loadingMoreView, @"-ac_createLoadingMoreView must return a view.");
                }
                if (self.tableView.tableFooterView != _loadingMoreView) {
                        _originalTableFooterView = self.tableView.tableFooterView;
                        self.tableView.tableFooterView = _loadingMoreView;
                        [self ac_addTableViewsObserversForLoadingMoreView];
                }
        } else if (self.usesTableFooterViewAsLoadingMoreView && !self.hasMoreData) {
                if (_loadingMoreView && self.tableView.tableFooterView == _loadingMoreView) {
                        self.tableView.tableFooterView = _originalTableFooterView;
                }
        } else if (!self.usesTableFooterViewAsLoadingMoreView && _loadingMoreView) {
                if (self.tableView.tableFooterView == _loadingMoreView) {
                        self.tableView.tableFooterView = _originalTableFooterView;
                }
                [_loadingMoreView removeFromSuperview];
                _loadingMoreView = nil;
                _originalTableFooterView = nil;
        }
}

- (UIView *)ac_createLoadingMoreView
{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 44.)];
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"加载中..." attributes:[ESActivityLabel defaultTextAttributes]];
        ESActivityLabel *activityLabel = [[ESActivityLabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 0)
                                          activityIndicatorViewStyle:UIActivityIndicatorViewStyleGray
                                                                 attributedText:text];
        [activityLabel sizeToFit];
        activityLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        activityLabel.center = CGPointMake(view.width / 2., view.height / 2.);
        activityLabel.tag = 100;
        [view addSubview:activityLabel];
        
        if (self.showsLoadingMoreViewTopBorder) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, 0.7)];
                line.backgroundColor = [UIColor es_lightBorderColor];
                line.tag = 101;
                [view addSubview:line];
        }
        return view;
}

- (void)ac_addTableViewsObserversForLoadingMoreView
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

- (void)ac_removeTableViewsObservers
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

@end
