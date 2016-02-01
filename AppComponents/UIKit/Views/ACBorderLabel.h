//
//  ACBorderLabel.h
//  gupiao
//
//  Created by Elf Sundae on 15/9/11.
//  Copyright (c) 2015年 www.0x123.com . All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * TODO: based on UIButton, into ESButton.
 * https://github.com/ElfSundae/YHRoundBorderedButton
 */
@interface ACBorderLabel : UILabel

@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat borderCornerRadius;
@property (nonatomic) UIEdgeInsets contentInset;

@end
