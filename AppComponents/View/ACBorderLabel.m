//
//  ACBorderLabel.m
//  gupiao
//
//  Created by Elf Sundae on 15/9/11.
//  Copyright (c) 2015年 www.0x123.com . All rights reserved.
//

#import "ACBorderLabel.h"

@implementation ACBorderLabel

- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                [self setupDefaults];
        }
        return self;
}

- (instancetype)init
{
        return [self initWithFrame:CGRectZero];
}

- (void)setupDefaults
{
        self.borderWidth = 2.f;
        self.borderCornerRadius = 4.f;
        self.contentInset = UIEdgeInsetsMake(2, 5, 2, 5);
        self.textColor = [UIColor es_defaultButtonColor];
        self.textAlignment = NSTextAlignmentCenter;
}

- (void)setTextColor:(UIColor *)textColor
{
        [super setTextColor:textColor];
        [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
        if (_borderWidth != borderWidth) {
                _borderWidth = borderWidth;
                [self setNeedsDisplay];
        }
}

- (void)setBorderCornerRadius:(CGFloat)borderCornerRadius
{
        if (_borderCornerRadius != borderCornerRadius) {
                _borderCornerRadius = borderCornerRadius;
                [self setNeedsDisplay];
        }
}

- (void)setFrame:(CGRect)frame
{
        [super setFrame:frame];
        [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
        [super setText:text];
        [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
        [super setAttributedText:attributedText];
        [self setNeedsDisplay];
}

- (CGSize)intrinsicContentSize
{
        return [self sizeThatFits:self.bounds.size];
}

- (CGSize)sizeThatFits:(CGSize)size
{
        CGSize result = [super sizeThatFits:size];
        result.height += self.contentInset.top + self.contentInset.bottom;
        result.width += self.contentInset.left + self.contentInset.right;
        return result;
}

- (void)drawRect:(CGRect)rect
{
        [super drawRect:rect];
        
        UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, self.borderWidth/2.f, self.borderWidth/2.f)
                                                              cornerRadius:self.borderCornerRadius];
        borderPath.lineWidth = self.borderWidth;
        [self.textColor setStroke];
        [borderPath stroke];
}

@end
