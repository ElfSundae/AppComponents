//
//  ACTableViewController+TableViewDataSource.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACTableViewController.h"

@implementation ACTableViewController (TableViewDataSource)

- (NSDictionary *)cellConfigDictionaryForIndexPath:(NSIndexPath *)indexPath
{
        return (self.configuresCellWithTableData ? self.tableData[indexPath.section][indexPath.row]: nil);
}

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath
{
        if (self.configuresCellWithTableData) {
                NSString *className = ESStringValue([self cellConfigDictionaryForIndexPath:indexPath][ACTableViewCellConfigKeyCellClassName]);
                return className ? NSClassFromString(className) : [ACTableViewDetailCell class];
        }
        return [UITableViewCell class];
}

- (NSString *)cellReuseIdentifierForIndexPath:(NSIndexPath *)indexPath
{
        NSString *identifier = nil;
        if (self.configuresCellWithTableData) {
                identifier = ESStringValue([self cellConfigDictionaryForIndexPath:indexPath][ACTableViewCellConfigKeyCellReuseIdentifier]);
                
        }
        return identifier ?: NSStringFromClass([self cellClassForIndexPath:indexPath]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        if (self.configuresCellWithTableData) {
                return self.tableData.count;
        }
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if (self.configuresCellWithTableData) {
                return [self.tableData[section] count];
        }
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (self.configuresCellWithTableData) {
                NSString *identifier = [self cellReuseIdentifierForIndexPath:indexPath];
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                        Class cellClass = [self cellClassForIndexPath:indexPath];
                        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                if ([cell isKindOfClass:[ACTableViewCell class]]) {
                        ACTableViewCell *acCell = (ACTableViewCell *)cell;
                        acCell.configDictionary = [self cellConfigDictionaryForIndexPath:indexPath];
                }
                return cell;
        }
        return nil;
}

@end
