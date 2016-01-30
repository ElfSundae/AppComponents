//
//  ACTableViewController+TableViewDataSource.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACTableViewController+Private.h"

@implementation ACTableViewController (TableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        if (_flags.configureIconCellWithTableData) {
                return self.tableData.count;
        }
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (_flags.configureIconCellWithTableData) {
                return [self.tableData[section] count];
        }
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (_flags.configureIconCellWithTableData) {
                return ESFloatValueWithDefault([self iconCellDataForIndexPath:indexPath][@"cell_height"], ACTableViewCellDefaultHeight);
        }
        return tableView.rowHeight ?: ACTableViewCellDefaultHeight;
}

- (Class)tableView:(UITableView *)tableView cellClassForRowAtIndexPath:(NSIndexPath *)indexPath cellData:(id)cellData
{
        return NSClassFromString([self iconCellClassNameForIndexPath:indexPath]);
}

- (id)tableView:(UITableView *)tableView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (_flags.configureIconCellWithTableData) {
                return [self iconCellDataForIndexPath:indexPath];
        }
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        if (tableView.style == UITableViewStyleGrouped) {
                return (0 == section) ? 15.f : 2.f;
        }
        return 0;
}

@end
