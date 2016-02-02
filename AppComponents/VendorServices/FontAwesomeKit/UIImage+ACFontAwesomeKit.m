//
//  UIImage+ACFontAwesomeKit.m
//  AppComponents
//
//  Created by Elf Sundae on 16/2/2.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "UIImage+ACFontAwesomeKit.h"
#import <ESFramework/ESDefines.h>
#import <FontAwesomeKit/FAKIcon.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation UIImage (ACFontAwesomeKit)

+ (UIImage *)FAImageWithIconIdentifier:(NSString *)identifier color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor fontSize:(CGFloat)fontSize
{
        Class FAKFontAwesomeClass = NSClassFromString(@"FAKFontAwesome");
        if (FAKFontAwesomeClass) {
                void *result;
                if (ESInvokeSelector(FAKFontAwesomeClass, @selector(iconWithIdentifier:size:error:), &result, identifier, fontSize, NULL)) {
                        FAKIcon *icon = (__bridge FAKIcon *)result;
                        [icon addAttribute:NSForegroundColorAttributeName value:color];
                        icon.drawingBackgroundColor = backgroundColor;
                        return [icon imageWithSize:CGSizeMake(fontSize, fontSize)];
                }
        }
        return nil;
}

@end

#pragma clang diagnostic pop