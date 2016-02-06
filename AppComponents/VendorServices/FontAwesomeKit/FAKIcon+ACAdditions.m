//
//  FAKIcon+ACAdditions.m
//  AppComponents
//
//  Created by Elf Sundae on 16/2/2.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "FAKIcon+ACAdditions.h"
#import <ESFramework/ESFrameworkCore.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation FAKIcon (ACAdditions)

+ (UIImage *)imageWithIconIdentifier:(NSString *)identifier
                               color:(UIColor *)color
                     backgroundColor:(UIColor *)backgroundColor
                  positionAdjustment:(UIOffset)positionAdjustment
                          attributes:(NSDictionary *)attributes
                            fontSize:(CGFloat)fontSize
                           imageSize:(CGSize)imageSize
{
        FAKIcon *__autoreleasing icon;
        if ([self invokeSelector:@selector(iconWithIdentifier:size:error:) retainArguments:NO result:&icon, identifier, fontSize, NULL] && icon) {
                if (color) {
                        [icon addAttribute:NSForegroundColorAttributeName value:color];
                }
                icon.drawingBackgroundColor = backgroundColor;
                icon.drawingPositionAdjustment = positionAdjustment;
                if (ESIsDictionaryWithItems(attributes)) {
                        [icon addAttributes:attributes];
                }
                return [icon imageWithSize:imageSize];
        }
        return nil;
}

+ (UIImage *)imageWithIconIdentifier:(NSString *)identifier
                               color:(UIColor *)color
                            fontSize:(CGFloat)fontSize
{
        return [self imageWithIconIdentifier:identifier
                                       color:color
                             backgroundColor:nil
                          positionAdjustment:UIOffsetZero
                                  attributes:nil
                                    fontSize:fontSize
                                   imageSize:CGSizeMake(fontSize, fontSize)];
}

+ (UIImage *)imageWithIconIdentifier:(NSString *)identifier
                               color:(UIColor *)color
                           imageSize:(CGSize)imageSize
{
        CGFloat fontSize = fminf(imageSize.width, imageSize.height);
        return [self imageWithIconIdentifier:identifier
                                       color:color
                             backgroundColor:nil
                          positionAdjustment:UIOffsetZero
                                  attributes:nil
                                    fontSize:fontSize
                                   imageSize:imageSize];
}


@end

#pragma clang diagnostic pop