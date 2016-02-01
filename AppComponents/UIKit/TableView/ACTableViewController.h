//
//  ACTableViewController.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESTableViewController.h>

typedef struct {
        unsigned int loadingMoreViewHasTopLine:1;
        /// tableData是二维数组，包含用与设置 ACTableViewCell 的dictionary.
        /// tableView的sectionNumber是tableData.count.
        unsigned int configuresCellWithTableData:1;
        /// 用tableView.tableFooterView来显示loadingMoreView, default is YES
        unsigned int useTableFooterViewAsLoadingMoreView:1;
} ACTableViewControllerInitializationFlags;

@interface ACTableViewController : ESTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style initializationFlags:(ACTableViewControllerInitializationFlags)initializationFlags;

@property (nonatomic, strong, readonly) NSMutableArray *tableData;
@property (nonatomic, readonly) ACTableViewControllerInitializationFlags initializationFlags;

@property (nonatomic) BOOL showsRefreshControl;

@end
