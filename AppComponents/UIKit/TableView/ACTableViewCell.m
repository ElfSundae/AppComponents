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
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const ACTableViewCellConfigKeyAccessoryType               = @"accessoryType";
NSString *const ACTableViewCellConfigKeySelectionStyle              = @"selectionStyle";
NSString *const ACTableViewCellConfigKeyText                        = @"text";
NSString *const ACTableViewCellConfigKeyDetailText                  = @"detailText";
NSString *const ACTableViewCellConfigKeyLeftBadgeView               = @"leftBadgeView";
NSString *const ACTableViewCellConfigKeyRightBadgeView              = @"rightBadgeView";
NSString *const ACTableViewCellConfigKeyIconImage                   = @"iconImage";
NSString *const ACTableViewCellConfigKeyIconImagePlaceholder        = @"iconImagePlaceholder";
NSString *const ACTableViewCellConfigKeyAlwaysShowsIconImageView    = @"alwaysShowsIconImageView";
NSString *const ACTableViewCellConfigKeyIconImageViewSize           = @"iconImageViewSize";
NSString *const ACTableViewCellConfigKeyIconImageViewInset          = @"iconImageViewInset";
NSString *const ACTableViewCellConfigKeyIconImageViewCornerRadius   = @"iconImageViewCornerRadius";
NSString *const ACTableViewCellConfigKeyIconImageViewBorderWidth    = @"iconImageViewBorderWidth";
NSString *const ACTableViewCellConfigKeyIconImageViewBorderColor    = @"iconImageViewBorderColor";
NSString *const ACTableViewCellConfigKeyDetailImage                 = @"detailImage";
NSString *const ACTableViewCellConfigKeyDetailImagePlaceholder      = @"detailImagePlaceholder";
NSString *const ACTableViewCellConfigKeyAlwaysShowsDetailImageView  = @"alwaysShowsDetailImageView";
NSString *const ACTableViewCellConfigKeyDetailImageViewSize         = @"detailImageViewSize";
NSString *const ACTableViewCellConfigKeyDetailImageViewInset        = @"detailImageViewInset";
NSString *const ACTableViewCellConfigKeyDetailImageViewCornerRadius = @"detailImageViewCornerRadius";
NSString *const ACTableViewCellConfigKeyDetailImageViewBorderWidth  = @"detailImageViewBorderWidth";
NSString *const ACTableViewCellConfigKeyDetailImageViewBorderColor  = @"detailImageViewBorderColor";
NSString *const ACTableViewCellConfigKeyDetailImageViewMostRight    = @"detailImageViewMostRight";
NSString *const ACTableViewCellConfigKeyCellPadding                 = @"cellPadding";
NSString *const ACTableViewCellConfigKeyCellMarginLeft              = @"cellMarginLeft";
NSString *const ACTableViewCellConfigKeyCellMarginRight             = @"cellMarginRight";

@implementation ACTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellStyle = style;
        [self applyDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _cellStyle = [aDecoder decodeIntegerForKey:@"cellStyle"];
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

- (void)setConfigDictionary:(NSDictionary *)configDictionary
{
    _configDictionary = configDictionary;
    [self configureWithDictionary:_configDictionary ?: @{}];
    [self setNeedsLayout];
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

- (void)configureWithDictionary:(NSDictionary *)configDictionary
{
    self.accessoryType = ESIntegerValueWithDefault(configDictionary[ACTableViewCellConfigKeyAccessoryType], UITableViewCellAccessoryNone);
    self.selectionStyle = ESIntegerValueWithDefault(configDictionary[ACTableViewCellConfigKeySelectionStyle], UITableViewCellSelectionStyleDefault);
    self.leftBadgeView = [configDictionary[ACTableViewCellConfigKeyLeftBadgeView] isKindOfClass:[UIView class]] ? configDictionary[ACTableViewCellConfigKeyLeftBadgeView] : nil;
    self.rightBadgeView = [configDictionary[ACTableViewCellConfigKeyRightBadgeView] isKindOfClass:[UIView class]] ? configDictionary[ACTableViewCellConfigKeyRightBadgeView] : nil;
    id text = configDictionary[ACTableViewCellConfigKeyText];
    if ([text isKindOfClass:[NSAttributedString class]]) {
        self.textLabel.text = nil;
        self.textLabel.attributedText = text;
    } else if ([text isKindOfClass:[NSString class]]) {
        self.textLabel.attributedText = nil;
        self.textLabel.text = text;
    } else {
        self.textLabel.text = nil;
        self.textLabel.attributedText = nil;
    }
    id detailText = configDictionary[ACTableViewCellConfigKeyDetailText];
    if ([detailText isKindOfClass:[NSAttributedString class]]) {
        self.detailTextLabel.text = nil;
        self.detailTextLabel.attributedText = detailText;
    } else if ([detailText isKindOfClass:[NSString class]]) {
        self.detailTextLabel.attributedText = nil;
        self.detailTextLabel.text = detailText;
    } else {
        self.detailTextLabel.text = nil;
        self.detailTextLabel.attributedText = nil;
    }

    self.alwaysShowsIconImageView = ESBoolValue(configDictionary[ACTableViewCellConfigKeyAlwaysShowsIconImageView]);
    self.iconImageViewSize = ([configDictionary[ACTableViewCellConfigKeyIconImageViewSize] isKindOfClass:[NSValue class]] ?
                              [(NSValue *) configDictionary[ACTableViewCellConfigKeyIconImageViewSize] CGSizeValue] :
                              CGSizeZero);
    self.iconImageViewInset = ([configDictionary[ACTableViewCellConfigKeyIconImageViewInset] isKindOfClass:[NSValue class]] ?
                               [(NSValue *) configDictionary[ACTableViewCellConfigKeyIconImageViewInset] UIEdgeInsetsValue] :
                               [[self class] defaultIconImageViewInset]);
    self.iconImageViewCornerRadius = ESFloatValue(configDictionary[ACTableViewCellConfigKeyIconImageViewCornerRadius]);
    self.iconImageViewBorderWidth = ESFloatValue(configDictionary[ACTableViewCellConfigKeyIconImageViewBorderWidth]);
    self.iconImageViewBorderColor = ([configDictionary[ACTableViewCellConfigKeyIconImageViewBorderColor] isKindOfClass:[UIColor class]] ?
                                     configDictionary[ACTableViewCellConfigKeyIconImageViewBorderColor] :
                                     [[self class] defaultBorderColor]);

    self.alwaysShowsDetailImageView = ESBoolValue(configDictionary[ACTableViewCellConfigKeyAlwaysShowsDetailImageView]);
    self.detailImageViewSize = ([configDictionary[ACTableViewCellConfigKeyDetailImageViewSize] isKindOfClass:[NSValue class]] ?
                                [(NSValue *) configDictionary[ACTableViewCellConfigKeyDetailImageViewSize] CGSizeValue] :
                                CGSizeZero);
    self.detailImageViewInset = ([configDictionary[ACTableViewCellConfigKeyDetailImageViewInset] isKindOfClass:[NSValue class]] ?
                                 [(NSValue *) configDictionary[ACTableViewCellConfigKeyDetailImageViewInset] UIEdgeInsetsValue] :
                                 [[self class] defaultDetailImageViewInset]);
    self.detailImageViewCornerRadius = ESFloatValue(configDictionary[ACTableViewCellConfigKeyDetailImageViewCornerRadius]);
    self.detailImageViewBorderWidth = ESFloatValue(configDictionary[ACTableViewCellConfigKeyDetailImageViewBorderWidth]);
    self.detailImageViewBorderColor = ([configDictionary[ACTableViewCellConfigKeyDetailImageViewBorderColor] isKindOfClass:[UIColor class]] ?
                                       configDictionary[ACTableViewCellConfigKeyDetailImageViewBorderColor] :
                                       [[self class] defaultBorderColor]);
    self.detailImageViewMostRight = ESBoolValue(configDictionary[ACTableViewCellConfigKeyDetailImageViewMostRight]);
    self.cellPadding = ESFloatValueWithDefault(configDictionary[ACTableViewCellConfigKeyCellPadding], [[self class] defaultCellPadding]);
    self.cellMarginLeft = ESFloatValueWithDefault(configDictionary[ACTableViewCellConfigKeyCellMarginLeft], [[self class] defaultCellMarginLeft]);
    self.cellMarginRight = ESFloatValueWithDefault(configDictionary[ACTableViewCellConfigKeyCellMarginRight], [[self class] defaultCellMarginRight]);

    UIImage *iconImagePlaceholder = configDictionary[ACTableViewCellConfigKeyIconImagePlaceholder];
    [iconImagePlaceholder isKindOfClass:[UIImage class]] || (iconImagePlaceholder = nil);
    UIImage *iconImage = configDictionary[ACTableViewCellConfigKeyIconImage];
    [iconImage isKindOfClass:[UIImage class]] || (iconImage = iconImagePlaceholder);
    UIImage *detailImagePlaceholder = configDictionary[ACTableViewCellConfigKeyDetailImagePlaceholder];
    [detailImagePlaceholder isKindOfClass:[UIImage class]] || (detailImagePlaceholder = nil);
    UIImage *detailImage = configDictionary[ACTableViewCellConfigKeyDetailImage];
    [detailImage isKindOfClass:[UIImage class]] || (detailImage = nil);
    NSURL *iconImageURL = ESURLValue(configDictionary[ACTableViewCellConfigKeyIconImage]);
    NSURL *detailImageURL = ESURLValue(configDictionary[ACTableViewCellConfigKeyDetailImage]);

    if (self.alwaysShowsIconImageView || iconImage) {
        [self iconImageView];
    }
    if (self.alwaysShowsDetailImageView || detailImage) {
        [self detailImageView];
    }

    if (iconImageURL) {
        ESWeakSelf;
        [self.iconImageView sd_setImageWithURL:iconImageURL placeholderImage:iconImagePlaceholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            ESStrongSelf;
            if (!_self.alwaysShowsIconImageView) {
                [_self setNeedsLayout];
            }
        }];
    } else if (_iconImageView) {
        [self.iconImageView sd_cancelCurrentImageLoad];
        self.iconImageView.image = iconImage;
    }

    if (detailImageURL) {
        ESWeakSelf;
        [self.detailImageView sd_setImageWithURL:detailImageURL placeholderImage:detailImagePlaceholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            ESStrongSelf;
            if (!_self.alwaysShowsDetailImageView) {
                [_self setNeedsLayout];
            }
        }];
    } else if (_detailImageView) {
        [self.detailImageView sd_cancelCurrentImageLoad];
        self.detailImageView.image = detailImage;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // iconImageView, on the most Left
    CGRect iconImageFrame = CGRectZero;
    if (self.alwaysShowsIconImageView || _iconImageView.image) {
        CGSize iconSize = _iconImageView.image.size;
        iconImageFrame.origin.x = self.iconImageViewInset.left;
        if (self.iconImageViewSize.width > 0 && self.iconImageViewSize.height > 0) {
            iconImageFrame.size = self.iconImageViewSize;
        } else if (iconSize.width > 0 && iconSize.width <= (self.contentView.width - self.iconImageViewInset.left - self.iconImageViewInset.right) &&
                   iconSize.height > 0 && iconSize.height <= (self.contentView.height - self.iconImageViewInset.top - self.iconImageViewInset.bottom))
        {
            iconImageFrame.size = iconSize;
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
        } else if (!CGRectIsEmpty(self.iconImageView.frame) && self.iconImageViewCornerRadius > 0) {
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
    if (_iconImageView && !CGRectIsEmpty(self.iconImageView.frame) && UITableViewCellStyleValue2 != self.cellStyle) {
        self.textLabel.left = self.iconImageView.right + self.iconImageViewInset.right;
    }

    // detailTextLabel
    if (UITableViewCellStyleSubtitle == self.cellStyle) {
        self.detailTextLabel.left = self.textLabel.left;
    } else if (self.detailTextLabel.left < self.textLabel.right) {
        CGFloat diff = self.textLabel.right - self.detailTextLabel.left;
        self.detailTextLabel.left += diff;
        self.detailTextLabel.width -= diff;
    }

    // leftBadgeView, right aligned to iconImageView or textLabel
    CGRect leftBadgeFrame = CGRectZero;
    if (_leftBadgeView) {
        leftBadgeFrame.size = self.leftBadgeView.size;
        leftBadgeFrame.origin.y = (self.contentView.height - leftBadgeFrame.size.height) / 2.f;
        if (UITableViewCellStyleValue2 != self.cellStyle && !CGRectIsEmpty(self.textLabel.frame)) {
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
        CGSize detailSize = _detailImageView.image.size;
        if (self.detailImageViewSize.width > 0 && self.detailImageViewSize.height > 0) {
            detailImageFrame.size = self.detailImageViewSize;
        } else if (detailSize.width > 0 && detailSize.width <= (self.contentView.width - self.detailImageViewInset.left - self.detailImageViewInset.right) &&
                   detailSize.height > 0 && detailSize.height <= (self.contentView.height - self.detailImageViewInset.top - self.detailImageViewInset.bottom))
        {
            detailImageFrame.size = detailSize;
        } else {
            detailImageFrame.size.height = (self.contentView.height - self.detailImageViewInset.top - self.detailImageViewInset.bottom);
            detailImageFrame.size.width = detailImageFrame.size.height;
        }
        detailImageFrame.origin.y = (self.contentView.height - detailImageFrame.size.height) / 2.f;
        if (!self.isDetailImageViewMostRight && UITableViewCellStyleValue1 == self.cellStyle && !CGRectIsEmpty(self.detailTextLabel.frame)) {
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
        } else if (UITableViewCellStyleValue1 == self.cellStyle && !CGRectIsEmpty(self.detailTextLabel.frame)) {
            rightBadgeFrame.origin.x = self.detailTextLabel.left - self.cellPadding - rightBadgeFrame.size.width;
        } else if (self.contentView.right == self.width) {
            rightBadgeFrame.origin.x = self.contentView.width - self.cellMarginRight - rightBadgeFrame.size.width;
        } else if (self.accessoryType != UITableViewCellAccessoryNone && !self.accessoryView) {
            // standard accessory view already has margin
            rightBadgeFrame.origin.x = self.contentView.width - rightBadgeFrame.size.width;
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
    return UIEdgeInsetsMake(8., 10., 8., 10.);
}

+ (UIEdgeInsets)defaultDetailImageViewInset
{
    return UIEdgeInsetsMake(8., 5., 8., 5.);
}

+ (CGFloat)defaultCellPadding
{
    return 4.f;
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


@implementation ACTableViewDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    return self;
}

@end

@implementation ACTableViewCenterLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    return self;
}

@end

@implementation ACTableViewSubtitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    return self;
}

@end
