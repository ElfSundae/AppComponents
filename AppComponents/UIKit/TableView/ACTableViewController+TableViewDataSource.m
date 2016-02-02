//
//  ACTableViewController+TableViewDataSource.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACTableViewController+Subclassing.h"

@implementation ACTableViewController (TableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        if (self.initializationFlags.configuresCellWithTableData) {
                return self.tableData.count;
        }
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (self.initializationFlags.configuresCellWithTableData) {
                return [self.tableData[section] count];
        }
        return 0;
}

- (id)tableView:(UITableView *)tableView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return [self ac_cellDataForIndexPath:indexPath];
}

- (Class)tableView:(UITableView *)tableView cellClassForRowAtIndexPath:(NSIndexPath *)indexPath cellData:(id)cellData
{
        return [self ac_cellClassForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellNewInstanceForRowAtIndexPath:(NSIndexPath *)indexPath cellClass:(Class)cellClass reuseIdentifier:(NSString *)reuseIdentifier
{
        if ([cellClass isSubclassOfClass:[ACTableViewCell class]]) {
                return [[cellClass alloc] initWithCellStyle:[self ac_cellStyleForIndexPath:indexPath] reuseIdentifier:reuseIdentifier];
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
