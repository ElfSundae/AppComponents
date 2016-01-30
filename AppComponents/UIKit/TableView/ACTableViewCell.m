//
//  ACTableViewCell.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACTableViewCell.h"

CGFloat const ACTableViewCellDefaultHeight = 44.f;
CGFloat const ACTableViewCellDefaultIconSize = 24.f;

@implementation ACTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
                _cellStyle = (ACTableViewCellStyle)style;
                self.iconImageViewInset = [[self class] defaultIconImageViewInset];
                self.iconImageViewBorderColor = [[self class] defaultBorderColor];
                self.detailImageViewInset = [[self class] defaultDetailImageViewInset];
                self.detailImageViewBorderColor = [[self class] defaultBorderColor];
                self.cellPadding = 5.f;
                self.cellMarginLeft = 10.f;
                self.cellMarginRight = 10.f;
        }
        return self;
}

- (UIImageView *)iconImageView
{
        if (!_iconImageView) {
                _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
                _iconImageView.backgroundColor = [UIColor clearColor];
                [self.contentView addSubview:_iconImageView];
        }
        return _iconImageView;
}

- (UIImageView *)detailImageView
{
        if (!_detailImageView) {
                _detailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
                _detailImageView.backgroundColor = [UIColor clearColor];
                [self.contentView addSubview:_detailImageView];
        }
        return _detailImageView;
}

- (void)setLeftBadgeView:(UIView *)view
{
        if (_leftBadgeView != view) {
                [_leftBadgeView removeFromSuperview];
        }
        _leftBadgeView = view;
        if (_leftBadgeView && _leftBadgeView.superview != self.contentView) {
                [_leftBadgeView removeFromSuperview];
                [self.contentView addSubview:_leftBadgeView];
        }
}

- (void)setRightBadgeView:(UIView *)view
{
        if (_rightBadgeView != view) {
                [_rightBadgeView removeFromSuperview];
        }
        _rightBadgeView = view;
        if (_rightBadgeView && _rightBadgeView.superview != self.contentView) {
                [_rightBadgeView removeFromSuperview];
                [self.contentView addSubview:_rightBadgeView];
        }
}

- (void)layoutSubviews
{
        [super layoutSubviews];
        
        // iconImageView, on the most Left
        CGRect iconImageFrame = CGRectZero;
        if (self.alwaysShowsIconImageView || _iconImageView.image) {
                iconImageFrame.origin.x = self.iconImageViewInset.left;
                if (self.iconImageViewSize.width > 0 && self.iconImageViewSize.height > 0) {
                        iconImageFrame.size = self.iconImageViewSize;
                } else {
                        iconImageFrame.size.height = self.contentView.height - self.iconImageViewInset.top - self.iconImageViewInset.bottom;
                        iconImageFrame.size.width = iconImageFrame.size.height;
                }
                iconImageFrame.origin.y = (self.contentView.height - iconImageFrame.size.height) / 2.f;
                self.iconImageView.frame = iconImageFrame;
        } else if (_iconImageView) {
                self.iconImageView.frame = CGRectZero;
        }
        
        // iconImageView's corner and border
        if (_iconImageView) {
                if (!CGRectIsEmpty(self.iconImageView.frame) && self.iconImageViewCornerRadius > 0 && self.iconImageViewBorderWidth > 0) {
                        self.iconImageView.layer.mask = nil;
                        [self.iconImageView setCornerRadius:self.iconImageViewCornerRadius borderWidth:self.iconImageViewBorderWidth borderColor:self.iconImageViewBorderColor];
                } else if (!CGRectIsEmpty(self.iconImageView.frame)  && self.iconImageViewCornerRadius > 0) {
                        self.iconImageView.layer.masksToBounds = NO;
                        self.iconImageView.layer.cornerRadius = 0.f;
                        self.iconImageView.layer.borderWidth = 0.f;
                        [self.iconImageView setMaskLayerWithCornerRadius:self.iconImageViewCornerRadius];
                } else {
                        self.iconImageView.layer.mask = nil;
                        self.iconImageView.layer.masksToBounds = NO;
                        self.iconImageView.layer.cornerRadius = 0.f;
                        self.iconImageView.layer.borderWidth = 0.f;
                }
        }
        
        
        // textLabel, right aligned to iconImageView
        if (_iconImageView && !CGRectIsEmpty(self.iconImageView.frame) && ACTableViewCellStyleCenterLabel != self.cellStyle) {
                self.textLabel.left = self.iconImageView.right + self.iconImageViewInset.right;
        }
        
        // detailTextLabel
        if (ACTableViewCellStyleSubtitle == self.cellStyle) {
                self.detailTextLabel.left = self.textLabel.left;
        }
        
        // leftBadgeView, right aligned to iconImageView or textLabel
        CGRect leftBadgeFrame = CGRectZero;
        if (_leftBadgeView) {
                leftBadgeFrame.size = self.leftBadgeView.size;
                leftBadgeFrame.origin.y = (self.contentView.height - leftBadgeFrame.size.height) / 2.f;
                if (ACTableViewCellStyleCenterLabel != self.cellStyle && !CGRectIsEmpty(self.textLabel.frame)) {
                        leftBadgeFrame.origin.x = self.textLabel.right + self.cellPadding;
                } else if (!CGRectIsEmpty(iconImageFrame)) {
                        leftBadgeFrame.origin.x = iconImageFrame.origin.x + iconImageFrame.size.width + self.iconImageViewInset.right;
                } else {
                       leftBadgeFrame.origin.x = self.cellMarginLeft;
                }
                self.leftBadgeView.frame = leftBadgeFrame;
        }
        
        // detailImageView, on the most right, or left aligned to detailTextLabel
        CGRect detailImageFrame = CGRectZero;
        if (self.alwaysShowsDetailImageView || _detailImageView.image) {
                if (self.detailImageViewSize.width > 0 && self.detailImageViewSize.height > 0) {
                        detailImageFrame.size = self.detailImageViewSize;
                } else {
                        detailImageFrame.size.height = (self.contentView.height - self.detailImageViewInset.top - self.detailImageViewInset.bottom);
                        detailImageFrame.size.width = detailImageFrame.size.height;
                }
                detailImageFrame.origin.y = (self.contentView.height - detailImageFrame.size.height) / 2.f;
                if (!self.isDetailImageViewMostRight && ACTableViewCellStyleDefault == self.cellStyle && !CGRectIsEmpty(self.detailTextLabel.frame)) {
                        detailImageFrame.origin.x = self.detailTextLabel.left - self.detailImageViewInset.right - detailImageFrame.size.width;
                } else if (self.contentView.right == self.width) {
                        detailImageFrame.origin.x = self.contentView.width - self.cellMarginRight - detailImageFrame.size.width;
                } else {
                        detailImageFrame.origin.x = self.contentView.width - self.cellPadding - detailImageFrame.size.width;
                }
                self.detailImageView.frame = detailImageFrame;
        } else if (_detailImageView) {
                _detailImageView.frame = CGRectZero;
        }
        
        // detailImageView's corner and border
        if (_detailImageView) {
                if (!CGRectIsEmpty(detailImageFrame) && self.detailImageViewCornerRadius > 0 && self.detailImageViewBorderWidth > 0) {
                        self.detailImageView.layer.mask = nil;
                        [self.detailImageView setCornerRadius:self.detailImageViewCornerRadius borderWidth:self.detailImageViewBorderWidth borderColor:self.detailImageViewBorderColor];
                } else if (!CGRectIsEmpty(detailImageFrame) && self.detailImageViewCornerRadius > 0) {
                        self.detailImageView.layer.masksToBounds = NO;
                        self.detailImageView.layer.cornerRadius = 0.f;
                        self.detailImageView.layer.borderWidth = 0.f;
                        [self.detailImageView setMaskLayerWithCornerRadius:self.detailImageViewCornerRadius];
                } else {
                        self.detailImageView.layer.mask = nil;
                        self.detailImageView.layer.masksToBounds = NO;
                        self.detailImageView.layer.cornerRadius = 0.f;
                        self.detailImageView.layer.borderWidth = 0.f;
                }
        }
        
        // rightBadgeView, left aligned to detailImageView or detailTextLabel
        CGRect rightBadgeFrame = CGRectZero;
        if (_rightBadgeView) {
                rightBadgeFrame.size = self.rightBadgeView.frame.size;
                rightBadgeFrame.origin.y = (self.contentView.height - rightBadgeFrame.size.height) / 2.f;
                if (!self.isDetailImageViewMostRight && !CGRectIsEmpty(detailImageFrame)) {
                        rightBadgeFrame.origin.x = detailImageFrame.origin.x - self.detailImageViewInset.left - rightBadgeFrame.size.width;
                } else if (ACTableViewCellStyleDefault == self.cellStyle && !CGRectIsEmpty(self.detailTextLabel.frame)) {
                        rightBadgeFrame.origin.x = self.detailTextLabel.left - self.cellPadding - rightBadgeFrame.size.width;
                } else if (self.contentView.right == self.width) {
                        rightBadgeFrame.origin.x = self.contentView.width - self.cellMarginRight - rightBadgeFrame.size.width;
                } else {
                        rightBadgeFrame.origin.x = self.contentView.width - self.cellPadding - rightBadgeFrame.size.width;
                }
                self.rightBadgeView.frame = rightBadgeFrame;
        }
}

+ (UIColor *)defaultBorderColor
{
        return [UIColor es_lightBorderColor];
}

+ (UIEdgeInsets)defaultIconImageViewInset
{
        return UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
}

+ (UIEdgeInsets)defaultDetailImageViewInset
{
        return UIEdgeInsetsMake(10.f, 5.f, 10.f, 5.f);
}

@end
