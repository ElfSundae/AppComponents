//
//  ACAuthBaseViewController.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACAuthBaseViewController : UIViewController

@property (nonatomic, copy) NSString *titleForNavigationBar;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Subclassing

- (void)_dismissBarButtonItemAction:(id)sender;

@end
