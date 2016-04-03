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
                id cellClass = [self cellConfigDictionaryForIndexPath:indexPath][ACTableViewCellConfigKeyCellClass];
                if (cellClass && class_isMetaClass(object_getClass(cellClass))) {
                        return (Class)cellClass;
                } else if ([cellClass isKindOfClass:[NSString class]]) {
                        return NSClassFromString((NSString *)cellClass);
                } else {
                        return [ACTableViewDetailCell class];
                }
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

- (NSString *)cellTitleForIndexPath:(NSIndexPath *)indexPath
{
        NSString *title = [self cellConfigDictionaryForIndexPath:indexPath][ACTableViewCellConfigKeyText];
        if ([title isKindOfClass:[NSAttributedString class]]) {
                return [(NSAttributedString *)title string];
        } else if ([title isKindOfClass:[NSString class]]) {
                return title;
        }
        return nil;
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
