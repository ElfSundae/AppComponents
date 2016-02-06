//
//  FAKIcon+ACAdditions.h
//  AppComponents
//
//  Created by Elf Sundae on 16/2/2.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <FontAwesomeKit/FAKIcon.h>

@interface FAKIcon (ACAdditions)

+ (UIImage *)imageWithIconIdentifier:(NSString *)identifier
                               color:(UIColor *)color
                     backgroundColor:(UIColor *)backgroundColor
                  positionAdjustment:(UIOffset)positionAdjustment
                          attributes:(NSDictionary *)attributes
                            fontSize:(CGFloat)fontSize
                           imageSize:(CGSize)imageSize;

/**
 * imageSize is {fontSize, fontSize}
 */
+ (UIImage *)imageWithIconIdentifier:(NSString *)identifier
                               color:(UIColor *)color
                            fontSize:(CGFloat)fontSize;

/**
 * fontSize is fminf(imageSize.width, imageSize.height)
 */
+ (UIImage *)imageWithIconIdentifier:(NSString *)identifier
                               color:(UIColor *)color
                           imageSize:(CGSize)imageSize;

@end
