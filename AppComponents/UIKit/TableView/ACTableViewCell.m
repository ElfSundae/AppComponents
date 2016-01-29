//
//  ACTableViewCell.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACTableViewCell.h"

@implementation ACTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
                _cellStyle = (ACTableViewCellStyle)style;
                self.iconImageViewEdgeInsets = [[self class] defaultIconImageEdgeInsets];
                self.iconImageViewBorderColor = [[self class] defaultBorderColor];
                self.detailImageViewEdgeInsets = [[self class] defaultDetailImageEdgeInsets];
                self.detailImageViewBorderColor = [[self class] defaultBorderColor];
        }
        return self;
}

- (UIImageView *)iconImageView
{
        if (!_iconImageView) {
                _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
                _iconImageView.backgroundColor = [UIColor clearColor];
        }
        
        if (!_iconImageView.superview) {
                [self.contentView addSubview:_iconImageView];
        }
        return _iconImageView;
}

- (UIImageView *)detailImageView
{
        if (!_detailImageView) {
                _detailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
                _detailImageView.backgroundColor = [UIColor clearColor];
        }
        if (!_detailImageView.superview) {
                [self.contentView addSubview:_detailImageView];
        }
        return _detailImageView;
}

- (void)setLeftBadgeView:(UIView *)leftBadgeView
{
        if (_leftBadgeView == leftBadgeView) {
                return;
        }
        
        [_leftBadgeView removeFromSuperview];
        _leftBadgeView = leftBadgeView;
        if (_leftBadgeView.superview != self.contentView) {
                [_leftBadgeView removeFromSuperview];
                [self.contentView addSubview:_leftBadgeView];
        }
}

- (void)setRightBadgeView:(UIView *)rightBadgeView
{
        if (_rightBadgeView == rightBadgeView) {
                return;
        }
        [_rightBadgeView removeFromSuperview];
        _rightBadgeView = rightBadgeView;
        if (_rightBadgeView.superview != self.contentView) {
                [_rightBadgeView removeFromSuperview];
                [self.contentView addSubview:_rightBadgeView];
        }
}

- (void)layoutSubviews
{
        [super layoutSubviews];
        
        // iconImageView, on the most Left
        CGRect imageFrame = CGRectZero;
        if (self.alwaysShowIconImageView || self.iconImageView.image) {
                imageFrame.origin.x = self.iconImageViewEdgeInsets.left;
                imageFrame.size.height = self.contentView.height - self.iconImageViewEdgeInsets.top - self.iconImageViewEdgeInsets.bottom;
                imageFrame.size.width = imageFrame.size.height;
                imageFrame.origin.y = (self.contentView.height - imageFrame.size.height) / 2.f;
        }
        self.iconImageView.frame = imageFrame;
        
        // iconImageView's corner and border
        if (self.iconImageView.width > 0 && self.iconImageViewCornerRadius > 0 && self.iconImageViewBorderWidth > 0) {
                self.iconImageView.layer.mask = nil;
                [self.iconImageView setCornerRadius:self.iconImageViewCornerRadius borderWidth:self.iconImageViewBorderWidth borderColor:self.iconImageViewBorderColor];
        } else if (self.iconImageView.width > 0  && self.iconImageViewCornerRadius > 0) {
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
        
        // textLabel, right aligned to iconImageView
        if (self.iconImageView.width > 0 && ACTableViewCellStyleCenterLabel != self.cellStyle) {
                self.textLabel.left = self.iconImageView.right + self.iconImageViewEdgeInsets.right;
        }
        
        // detailTextLabel
        if (ACTableViewCellStyleSubtitle == self.cellStyle) {
                self.detailTextLabel.left = self.textLabel.left;
        }
        
        // leftBadgeView, right aligned to iconImageView or textLabel
        CGRect leftBadgeFrame = CGRectZero;
        if (self.leftBadgeView) {
                leftBadgeFrame.size = self.leftBadgeView.size;
        }
        leftBadgeFrame.origin.y = (self.contentView.height - leftBadgeFrame.size.height) / 2.f;
        if (ACTableViewCellStyleCenterLabel != self.cellStyle) {
                if (self.textLabel.width > 0) {
                        leftBadgeFrame.origin.x = self.textLabel.right + self.detailImageViewEdgeInsets.left;
                } else if (self.iconImageView.width > 0) {
                        leftBadgeFrame.origin.x = self.iconImageView.right + self.iconImageViewEdgeInsets.right;
                } else {
                        leftBadgeFrame.origin.x = self.iconImageViewEdgeInsets.left;
                }
        } else {
                if (self.iconImageView.width > 0) {
                        leftBadgeFrame.origin.x = self.iconImageView.right + self.iconImageViewEdgeInsets.right;
                } else {
                        leftBadgeFrame.origin.x = self.iconImageViewEdgeInsets.left;
                }
        }
        self.leftBadgeView.frame = leftBadgeFrame;
        
        // detailImageView, on the most right, or left aligned to detailTextLabel(cellStyleValue1)
        CGRect detailImageFrame = CGRectZero;
        if (self.alwaysShowDetailImageView || self.detailImageView.image) {
                detailImageFrame.size.height = (self.detailImageSize.height > 0.f && self.detailImageSize.height <= self.contentView.height ?
                                                self.detailImageSize.height :
                                                self.contentView.height - self.detailImageViewEdgeInsets.top - self.detailImageViewEdgeInsets.bottom);
                detailImageFrame.size.width = (self.detailImageSize.width > 0.f ? self.detailImageSize.width :
                                               detailImageFrame.size.height);
        }
        detailImageFrame.origin.y = (self.contentView.height - detailImageFrame.size.height) / 2.f;
        if (UITableViewCellStyleValue1 == self.cellStyle && self.detailTextLabel.width > 0) {
                detailImageFrame.origin.x = self.detailTextLabel.left - self.detailImageViewEdgeInsets.right - detailImageFrame.size.width;
        } else if (UITableViewCellAccessoryNone == self.accessoryType) {
                detailImageFrame.origin.x = self.contentView.width - self.iconImageViewEdgeInsets.left - detailImageFrame.size.width;
        } else {
                detailImageFrame.origin.x = self.contentView.width - detailImageFrame.size.width;
        }
        self.detailImageView.frame = detailImageFrame;
        
        // detailImageView's corner and border
        if (detailImageFrame.size.width > 0 && self.detailImageViewCornerRadius > 0 && self.detailImageViewBorderWidth > 0) {
                self.detailImageView.layer.mask = nil;
                [self.detailImageView setCornerRadius:self.detailImageViewCornerRadius borderWidth:self.detailImageViewBorderWidth borderColor:self.detailImageViewBorderColor];
        } else if (detailImageFrame.size.width > 0 && self.detailImageViewCornerRadius > 0) {
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
        
        // rightBadgeView, left aligned to detailImageView
        CGRect rightBadgeFrame = CGRectZero;
        if (self.rightBadgeView) {
                rightBadgeFrame.size = self.rightBadgeView.frame.size;
                
                if (self.rightBadgeView.superview != self.contentView) {
                        [self.rightBadgeView removeFromSuperview];
                        [self.contentView addSubview:self.rightBadgeView];
                }
        }
        rightBadgeFrame.origin.y = (self.contentView.height - rightBadgeFrame.size.height) / 2.f;
        rightBadgeFrame.origin.x = detailImageFrame.origin.x - rightBadgeFrame.size.width;
        if (detailImageFrame.size.width > 0) {
                rightBadgeFrame.origin.x -= self.detailImageViewEdgeInsets.left;
        }
        self.rightBadgeView.frame = rightBadgeFrame;
}

+ (UIColor *)defaultBorderColor
{
        return [UIColor es_lightBorderColor];
}

+ (UIEdgeInsets)defaultIconImageEdgeInsets
{
        return UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
}

+ (UIEdgeInsets)defaultDetailImageEdgeInsets
{
        return UIEdgeInsetsMake(10.f, 5.f, 10.f, 5.f);
}

@end
