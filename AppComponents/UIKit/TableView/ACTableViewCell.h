//
//  ACTableViewCell.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ESFramework/UIView+ESShortcut.h>
#import <ESFramework/UIView+ESAdditions.h>
#import <ESFramework/UIColor+ESAdditions.h>

FOUNDATION_EXTERN CGFloat const ACTableViewCellDefaultHeight; // 44.f
FOUNDATION_EXTERN CGFloat const ACTableViewCellDefaultIconSize; // 24.f (44-10-10)


typedef NS_ENUM(NSInteger, ACTableViewCellStyle) {
        /// Simple cell with text label and optional image view (behavior of UITableViewCell in iPhoneOS 2.x)
        ACTableViewCellStyleSimple = UITableViewCellStyleDefault,
        /// Left aligned label on left and right aligned label on right with blue text (Used in Settings)
        ACTableViewCellStyleDefault = UITableViewCellStyleValue1,
        /// Left aligned label on top and left aligned label on bottom with gray text (Used in iPod).
        ACTableViewCellStyleSubtitle = UITableViewCellStyleSubtitle,
        /// Right aligned label on left with blue text and left aligned label on right (Used in Phone/Contacts)
        ACTableViewCellStyleCenterLabel = UITableViewCellStyleValue2,
};

/*!
 * Cell struct:
 *
 * @code
 * [iconImageView] textLabel [leftBadgeView] [rightBadgeView] [detailImageView] [detailTextLabel]
 * @endcode
 *
 * TODO: 支持系统的imageView（代替iconImageView）
 */
@interface ACTableViewCell : UITableViewCell
{
@protected
        UIImageView *_iconImageView;
        UIImageView *_detailImageView;
        UIView *_leftBadgeView;
        UIView *_rightBadgeView;
}

@property (nonatomic, readonly) ACTableViewCellStyle cellStyle;

/// default is nil. iconImageView will be created if necessary.
@property (nonatomic, strong, readonly) UIImageView *iconImageView;
/// default is nil. detailImageView will be created if necessary.
@property (nonatomic, strong, readonly) UIImageView *detailImageView;

/// if leftBadgeView is not nil, it will be right aligned to iconImageView or textLabel
@property (nonatomic, strong) UIView *leftBadgeView;
/// if rightBadgeView is not nil, it will be left aligned to detailImageView or detailTextLabel
@property (nonatomic, strong) UIView *rightBadgeView;

/// default is NO
@property (nonatomic) BOOL alwaysShowsIconImageView;
/// 如果不设置，则size是由iconImageViewInset约束在contentView里的正方形
@property (nonatomic) CGSize iconImageViewSize;
/// default is +[ACTableViewCell defaultIconImageEdgeInsets]
@property (nonatomic) UIEdgeInsets iconImageViewInset;
/// default is 0. when it is not zero, the iconImageView's layer's mask will be set
@property (nonatomic) CGFloat iconImageViewCornerRadius;
/// default is 0, 注意：borderWidth是通过layer.borderWidth设置的，在大数据的tableView中会影响滑动效率
@property (nonatomic) CGFloat iconImageViewBorderWidth;
/// default is +[ACTableViewCell defaultBorderColor]
@property (nonatomic, strong) UIColor *iconImageViewBorderColor;

/// default is NO
@property (nonatomic) BOOL alwaysShowsDetailImageView;
/// 如果不设置的话自动根据detailImageViewEdgeInsets计算，正方形
@property (nonatomic) CGSize detailImageViewSize;
/// default is +[ACTableViewCell defaultDetailImageEdgeInsets]
@property (nonatomic) UIEdgeInsets detailImageViewInset;
/// default is 0. when it is not zero, the iconImageView's layer's mask will be set
@property (nonatomic) CGFloat detailImageViewCornerRadius;
/// default is 0, 注意：borderWidth是通过layer.borderWidth设置的，在大数据的tableView中会影响滑动效率
@property (nonatomic) CGFloat detailImageViewBorderWidth;
/// default is +[ACTableViewCell defaultBorderColor]
@property (nonatomic, strong) UIColor *detailImageViewBorderColor;

/// Determines the detailImageView is on the mostright of contentView, defaults to NO.
@property (nonatomic, getter=isDetailImageViewMostRight) BOOL detailImageViewMostRight;

/// default is 5.f, contentView中各个view的padding
@property (nonatomic) CGFloat cellPadding;
/// defualt is 10.f
@property (nonatomic) CGFloat cellMarginLeft;
/// defualt is 10.f
@property (nonatomic) CGFloat cellMarginRight;

/// [UIColor es_lightBorderColor]
+ (UIColor *)defaultBorderColor;
/// (10.f, 10.f, 10.f, 10.f)
+ (UIEdgeInsets)defaultIconImageViewInset;
/// (10.f, 5.f, 10.f, 5.f)
+ (UIEdgeInsets)defaultDetailImageViewInset;

@end
