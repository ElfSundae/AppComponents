//
//  ACTableViewController.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESTableViewController.h>
#import <ESFramework/ESFrameworkCore.h>
#import <ESFramework/ESFrameworkAdditions.h>
#import <ESFramework/ESErrorView.h>
#import <ESFramework/ESActivityLabel.h>
#import <ESFramework/ESButton.h>
#import <AppComponents/ACTableViewCell.h>

/// NSString with class name
FOUNDATION_EXTERN NSString *const ACTableViewCellConfigKeyCellClassName;
/// NSString
FOUNDATION_EXTERN NSString *const ACTableViewCellConfigKeyCellReuseIdentifier;

@interface ACTableViewController : ESTableViewController
{
        /// use it for tableView.tableFooterView
        UIView *_loadingMoreView;
        /// store the original tableFooterView
        UIView *_originalTableFooterView;
        
        ESErrorView *_errorView;

        struct {
                /** KVO flags */
                unsigned int isObserveredTableViewsContentSize:1;
                unsigned int isObserveredTableViewsContentOffset:1;
        } _flags;
}

@property (nonatomic, strong) NSMutableArray *tableData;

///=============================================
/// @name Configuration
///=============================================

/**
 * Determines whether to show the refreshControl.
 */
@property (nonatomic) BOOL showsRefreshControl;
/**
 * self.tableData是二维数组，用于在 -tableView:cellForRowAtIndexPath: 设置给ACTableViewCell的configDictionary.
 * tableView的sectionNumber是tableData.count.
 */
@property (nonatomic) BOOL configuresCellWithTableData;
/**
 * Uses tableView.tableFooterView to display loadingMoreView, default is YES.
 */
@property (nonatomic) BOOL usesTableFooterViewAsLoadingMoreView;
/**
 * Determines whether to show the top border of loadingMoreView
 */
@property (nonatomic) BOOL showsLoadingMoreViewTopBorder;

///=============================================
/// @name Data Loading
///=============================================

@property (nonatomic, getter=isRefreshingData, readonly) BOOL refreshingData;
@property (nonatomic, getter=isLoadingMoreData, readonly) BOOL loadingMoreData;

/**
 * 是否还有更多数据，用于显示或隐藏loadingMoreView
 */
@property (nonatomic) BOOL hasMoreData;

/**
 * 刷新(请求)数据，子类必须调用super并检查返回值。如果返回NO表示当前不应该刷新（例如当前正在刷新）.
 */
- (BOOL)refreshData __attribute__((objc_requires_super));
/**
 * 取消刷新
 */
- (void)cancelRefreshingData __attribute__((objc_requires_super));
/**
 * 刷新数据完成，设置hasMoreData
 */
- (void)refreshingDataDidFinish:(id)data __attribute__((objc_requires_super));
/**
 * 加载更多数据，子类必须调用super并检查返回值。如果返回NO表示当前不应该加载（例如当前正在加载数据，或者hasMoreData为NO）.
 */
- (BOOL)loadMoreData __attribute__((objc_requires_super));
/**
 * 取消加载更多
 */
- (void)cancelLoadingMoreData __attribute__((objc_requires_super));
/**
 * 加载更多数据完成，设置hasMoreData
 */
- (void)loadingMoreDataDidFinish:(id)data __attribute__((objc_requires_super));

///=============================================
/// @name ErrorView
///=============================================

- (ESErrorView *)showErrorViewWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image tag:(NSInteger)tag actionButtonTitle:(NSString *)actionButtonTitle actionButtonHandle:(ESUIControlHandler)actionButtonHandler;
- (ESErrorView *)showErrorViewForNoData:(NSString *)title;
- (void)hideErrorView;

@end

@interface ACTableViewController (Private)

/**
 * Creates or removes tableView.refreshControl according self.showsRefreshControl.
 */
- (void)ac_checkRefreshControl;

/**
 * Creates or removes loadingMoreView according self.hasMoreData.
 */
- (void)ac_checkLoadingMoreView;

/**
 * Creates a view for loadingMoreView.
 */
- (UIView *)ac_createLoadingMoreView;

- (void)ac_addTableViewsObserversForLoadingMoreView;
- (void)ac_removeTableViewsObservers;

@end

@interface ACTableViewController (TableViewDataSource)

/**
 * 该方法仅在self.configuresCellWithTableData为YES时有效.
 */
- (NSDictionary *)cellConfigDictionaryForIndexPath:(NSIndexPath *)indexPath;
/**
 * Returns cell class via ACTableViewCellConfigKeyCellClassName.
 * Default is ACTableViewDetailCell (self.configuresCellWithTableData is YES) or UITableViewCell.
 */
- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath;
/** 
 * Returns cell reuse identifier via ACTableViewCellConfigKeyCellReuseIdentifier.
 * Default is `NSStringFromClass([self cellClassForIndexPath:indexPath])`.
 */
- (NSString *)cellReuseIdentifierForIndexPath:(NSIndexPath *)indexPath;

// UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
