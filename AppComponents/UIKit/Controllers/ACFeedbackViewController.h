//
//  ACFeedbackViewController.h
//  AppComponents
//
//  Created by Elf Sundae on 16/2/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ESFramework/ESButton.h>

@interface ACFeedbackViewController : UIViewController

@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UITextField *contactTextField;
@property (nonatomic, strong) ESButton *sendButton;

- (void)commitAction:(id)sender;

// subclassing
- (void)commitFeedbackWithContent:(NSString *)content contact:(NSString *)contact;

@end
