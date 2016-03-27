//
//  ACAuthBaseViewController.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACAuthBaseViewController.h"
#import <ESFramework/ESFrameworkCore.h>

@implementation ACAuthBaseViewController

- (void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.view.backgroundColor = [UIColor es_viewBackgroundColor];
        self.navigationItem.title = self.titleForNavigationBar;
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

- (void)viewWillAppear:(BOOL)animated
{
        [super viewWillAppear:animated];
        // 如果是present进来的，添加"返回“按钮
        if (self.navigationController.isBeingPresented && !self.navigationItem.leftBarButtonItem) {
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(_dismissBarButtonItemAction:)];
        }
}

- (void)viewWillDisappear:(BOOL)animated
{
        [super viewWillDisappear:animated];
        if (self.navigationController.isBeingDismissed || self.isMovingFromParentViewController) {
                // Dismiss the keyboard
                [self.view endEditing:NO];
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Subclassing

- (void)_dismissBarButtonItemAction:(id)sender
{
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
