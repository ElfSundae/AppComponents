//
//  ACTableViewCell.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACTableViewCell.h"
#import <ESFramework/UIView+ESShortcut.h>
#import <ESFramework/UIView+ESAdditions.h>
#import <ESFramework/UIColor+ESAdditions.h>
#import <ESFramework/ESValue.h>
#import <ESFramework/ESTableViewController.h>
#import <UIImageView+WebCache.h>

@implementation ACTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
        return [self initWithCellStyle:(ACTableViewCellStyle)style reuseIdentifier:reuseIdentifier];
}

- (instancetype)initWithCellStyle:(ACTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
        self = [super initWithStyle:(UITableViewCellStyle)style reuseIdentifier:reuseIdentifier];
        if (self) {
                _cellStyle = style;
                [self applyDefaults];
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

- (void)setCellData:(id)cellData
{
        [super setCellData:cellData];
        if (self.configuresCellWithDictionaryUsingCellData) {
                [self configureCellWithDictionary:cellData];
        }
}

- (void)applyDefaults
{
        self.iconImageViewInset = [[self class] defaultIconImageViewInset];
        self.iconImageViewBorderColor = [[self class] defaultBorderColor];
        self.detailImageViewInset = [[self class] defaultDetailImageViewInset];
        self.detailImageViewBorderColor = [[self class] defaultBorderColor];
        self.cellPadding = [[self class] defaultCellPadding];
        self.cellMarginLeft = [[self class] defaultCellMarginLeft];
        self.cellMarginRight = [[self class] defaultCellMarginRight];
}

- (void)configureCellWithDictionary:(NSDictionary *)cellData
{
        if (!ESIsDictionaryWithItems(cellData)) {
                return;
        }
        
        self.accessoryType = ESIntegerValueWithDefault(cellData[@"accessoryType"], UITableViewCellAccessoryNone);
        self.selectionStyle = ESIntegerValueWithDefault(cellData[@"selectionStyle"], UITableViewCellSelectionStyleDefault);
        self.leftBadgeView = [cellData[@"leftBadgeView"] isKindOfClass:[UIView class]] ? cellData[@"leftBadgeView"] : nil;
        self.rightBadgeView = [cellData[@"rightBadgeView"] isKindOfClass:[UIView class]] ? cellData[@"rightBadgeView"] : nil;
        id text = cellData[@"text"];
        if ([text isKindOfClass:[NSAttributedString class]]) {
                self.textLabel.text = nil;
                self.textLabel.attributedText = text;
        } else if ([text isKindOfClass:[NSString class]]) {
                self.textLabel.text = text;
                self.textLabel.attributedText = nil;
        } else {
                self.textLabel.text = nil;
                self.textLabel.attributedText = nil;
        }
        id detailText = cellData[@"detailText"];
        if ([detailText isKindOfClass:[NSAttributedString class]]) {
                self.detailTextLabel.text = nil;
                self.detailTextLabel.attributedText = detailText;
        } else if ([detailText isKindOfClass:[NSString class]]) {
                self.detailTextLabel.text = detailText;
                self.detailTextLabel.attributedText = nil;
        } else {
                self.detailTextLabel.text = nil;
                self.detailTextLabel.attributedText = nil;
        }
        
        self.alwaysShowsIconImageView = ESBoolValue(cellData[@"alwaysShowsIconImageView"]);
        self.iconImageViewSize = ([cellData[@"iconImageViewSize"] isKindOfClass:[NSValue class]] ?
                                  [(NSValue *)cellData[@"iconImageViewSize"] CGSizeValue] :
                                  CGSizeZero);
        self.iconImageViewInset = ([cellData[@"iconImageViewInset"] isKindOfClass:[NSValue class]] ?
                                   [(NSValue *)cellData[@"iconImageViewInset"] UIEdgeInsetsValue] :
                                   [[self class] defaultIconImageViewInset]);
        self.iconImageViewCornerRadius = ESFloatValue(cellData[@"iconImageViewCornerRadius"]);
        self.iconImageViewBorderWidth = ESFloatValue(cellData[@"iconImageViewBorderWidth"]);
        self.iconImageViewBorderColor = ([cellData[@"iconImageViewBorderColor"] isKindOfClass:[UIColor class]] ?
                                         cellData[@"iconImageViewBorderColor"] :
                                         [[self class] defaultBorderColor]);

        self.alwaysShowsDetailImageView = ESBoolValue(cellData[@"alwaysShowsDetailImageView"]);
        self.detailImageViewSize = ([cellData[@"detailImageViewSize"] isKindOfClass:[NSValue class]] ?
                                    [(NSValue *)cellData[@"detailImageViewSize"] CGSizeValue] :
                                    CGSizeZero);
        self.detailImageViewInset = ([cellData[@"detailImageViewInset"] isKindOfClass:[NSValue class]] ?
                                     [(NSValue *)cellData[@"detailImageViewInset"] UIEdgeInsetsValue] :
                                     [[self class] defaultDetailImageViewInset]);
        self.detailImageViewCornerRadius = ESFloatValue(cellData[@"detailImageViewCornerRadius"]);
        self.detailImageViewBorderWidth = ESFloatValue(cellData[@"detailImageViewBorderWidth"]);
        self.detailImageViewBorderColor = ([cellData[@"detailImageViewBorderColor"] isKindOfClass:[UIColor class]] ?
                                           cellData[@"detailImageViewBorderColor"] :
                                           [[self class] defaultBorderColor]);
        self.detailImageViewMostRight = ESBoolValue(cellData[@"detailImageViewMostRight"]);
        self.cellPadding = ESFloatValueWithDefault(cellData[@"cellPadding"], [[self class] defaultCellPadding]);
        self.cellMarginLeft = ESFloatValueWithDefault(cellData[@"cellMarginLeft"], [[self class] defaultCellMarginLeft]);
        self.cellMarginRight = ESFloatValueWithDefault(cellData[@"cellMarginRight"], [[self class] defaultCellMarginRight]);
        
        UIImage *iconImagePlaceholder = [cellData[@"iconImagePlaceholder"] isKindOfClass:[UIImage class]] ? cellData[@"iconImagePlaceholder"] : nil;
        UIImage *detailImagePlaceholder = [cellData[@"detailImagePlaceholder"] isKindOfClass:[UIImage class]] ? cellData[@"detailImagePlaceholder"] : nil;
        
        NSURL *iconImageURL = ESURLValue(cellData[@"iconImage"]);
        if (iconImageURL) {
                ESWeakSelf;
                [self.iconImageView sd_setImageWithURL:iconImageURL placeholderImage:iconImagePlaceholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        ESStrongSelf;
                        if (!_self.alwaysShowsIconImageView) {
                                [_self setNeedsLayout];
                        }
                }];
        } else {
                [self.iconImageView sd_cancelCurrentImageLoad];
                self.iconImageView.image = ([cellData[@"iconImage"] isKindOfClass:[UIImage class]] ? cellData[@"iconImage"] : iconImagePlaceholder);
        }
        
        NSURL *detailImageURL = ESURLValue(cellData[@"detailImage"]);
        if (detailImageURL) {
                ESWeakSelf;
                [self.detailImageView sd_setImageWithURL:detailImageURL placeholderImage:detailImagePlaceholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        ESStrongSelf;
                        if (!_self.alwaysShowsDetailImageView) {
                                [_self setNeedsLayout];
                        }
                }];
        } else {
                [self.detailImageView sd_cancelCurrentImageLoad];
                self.detailImageView.image = ([cellData[@"detailImage"] isKindOfClass:[UIImage class]] ? cellData[@"detailImage"] : detailImagePlaceholder);
        }
                
        [self setNeedsLayout];
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

+ (CGFloat)defaultCellPadding
{
        return 5.f;
}
+ (CGFloat)defaultCellMarginLeft
{
        return 10.f;
}
+ (CGFloat)defaultCellMarginRight
{
        return 10.f;
}

@end
