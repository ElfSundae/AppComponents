//
//  RootViewController.m
//  Sample
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "RootViewController.h"
#import <IconFontsKit/IFFontAwesome.h>
#import <ESFramework/ESBadgeView.h>

#define kCellConfigKeyAction @"action"

@implementation RootViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
        self = [super initWithStyle:UITableViewStyleGrouped];
        self.showsRefreshControl = YES;
        self.configuresCellWithTableData = YES;
        return self;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.navigationItem.title = @"AppComponents";
        
        dispatch_block_t helloAction = ^(){
                [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                [[ESApp sharedApp] showCheckmarkHUDWithTitle:nil timeInterval:1 animated:YES];
        };
        
        [self.tableData addObject:
         @[@{ ACTableViewCellConfigKeyText: @"Hello",
              ACTableViewCellConfigKeyCellReuseIdentifier: @"HelloIdentifier",
              ACTableViewCellConfigKeyIconImage: [IFFontAwesome imageWithType:IFFAStar color:nil fontSize:20],
              ACTableViewCellConfigKeyAccessoryType: @(UITableViewCellAccessoryDisclosureIndicator),
              ACTableViewCellConfigKeyDetailText: [[NSAttributedString alloc] initWithString:@"world" attributes:@{NSForegroundColorAttributeName: [UIColor es_orangeColor]}],
              ACTableViewCellConfigKeyDetailImage: [IFFontAwesome imageWithType:IFFATwitter color:[UIColor es_twitterColor] fontSize:20],
              ACTableViewCellConfigKeyRightBadgeView: [ESBadgeView badgeViewWithText:@"New"],
              kCellConfigKeyAction:[helloAction copy] }]
         ];
        
         [self.tableData addObject:
          @[@{ ACTableViewCellConfigKeyText: @"WebViewController",
               ACTableViewCellConfigKeyAccessoryType: @(UITableViewCellAccessoryDetailButton),
               kCellConfigKeyAction: @"openWebViewController" }]
          ];
}

- (BOOL)refreshData
{
        if ([super refreshData]) {
                ESDispatchOnDefaultQueue(^{
                        [NSThread sleepForTimeInterval:2];
                        [self refreshingDataDidFinish:nil];
                });
                return YES;
        }
        return NO;
}

- (void)openWebViewController
{
        ACWebViewController *webController = [[ACWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://github.com/ElfSundae/AppComponents"]];
        // webController.activityOverlayEnabeld = YES;
        webController.showsErrorViewWhenLoadingFailed = YES;
        webController.JSBridgeEnabled = YES;
        [self.navigationController pushViewController:webController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        id action = [self cellConfigDictionaryForIndexPath:indexPath][kCellConfigKeyAction];
        if ([action isKindOfClass:[NSString class]]) {
                ESInvokeSelector(self, NSSelectorFromString(action), NO, NULL);
        } else if (action) {
                dispatch_block_t block = action;
                block();
        }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(nonnull NSIndexPath *)indexPath
{
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
