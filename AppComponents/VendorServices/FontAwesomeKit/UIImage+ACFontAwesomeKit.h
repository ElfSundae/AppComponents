//
//  UIImage+ACFontAwesomeKit.h
//  AppComponents
//
//  Created by Elf Sundae on 16/2/2.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ACFontAwesomeKit)

// pod 'FontAwesomeKit/FontAwesome'
+ (UIImage *)FAImageWithIconIdentifier:(NSString *)identifier color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor fontSize:(CGFloat)fontSize;

@end
