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
 * [iconImageView] textLabel [leftBadgeView] [rightBadgeView] [detailImageView] detailTextLabel
 *
 * 支持左边的iconImage和右边的detailImage.
 * 支持textLabel后的BadgeView、contentView最右侧的BadgeView.
 *
 * TODO: 支持系统原来的imageView（分隔符左边）
 */
@interface ACTableViewCell : UITableViewCell
{
@protected
        UIImageView *_iconImageView;
        UIImageView *_detailImageView;
}

@property (nonatomic, readonly) ACTableViewCellStyle cellStyle;

@property (nonatomic, strong, readonly) UIImageView *iconImageView;
@property (nonatomic, strong, readonly) UIImageView *detailImageView;

/// ESBadgeView or some other UIView, with correct size, right aligned to iconImageView or textLabel
@property (nonatomic, strong) UIView *leftBadgeView;
/// ESBadgeView or some other UIView, with correct size, left aligned to detailImageView
@property (nonatomic, strong) UIView *rightBadgeView;

/// default is NO
@property (nonatomic) BOOL alwaysShowIconImageView;
/// default is 0. when it is not zero, the iconImageView's layer's mask will be set
@property (nonatomic) CGFloat iconImageViewCornerRadius;
/// default is 0, 注意：borderWidth是通过layer.borderWidth设置的，在大数据的tableView中会影响滑动效率
@property (nonatomic) CGFloat iconImageViewBorderWidth;
/// default is +[ACTableViewCell defaultBorderColor]
@property (nonatomic, strong) UIColor *iconImageViewBorderColor;
/// default is +[ACTableViewCell defaultIconImageEdgeInsets], iconImageViewEdgeInsets.left同时也作为默认的cell最左侧或最右侧的间距(margin)
@property (nonatomic) UIEdgeInsets iconImageViewEdgeInsets;

/// default is NO
@property (nonatomic) BOOL alwaysShowDetailImageView;
/// default is 0. when it is not zero, the iconImageView's layer's mask will be set
@property (nonatomic) CGFloat detailImageViewCornerRadius;
// default is 0, 注意：borderWidth是通过layer.borderWidth设置的，在大数据的tableView中会影响滑动效率
@property (nonatomic) CGFloat detailImageViewBorderWidth;
/// default is +[ACTableViewCell defaultBorderColor]
@property (nonatomic, strong) UIColor *detailImageViewBorderColor;
/// default is +[ACTableViewCell defaultDetailImageEdgeInsets], detailImageViewEdgeInsets.left同时也作为contentView中各控件之间的默认间距(padding)
@property (nonatomic) UIEdgeInsets detailImageViewEdgeInsets;
/// 如果不设置的话自动根据detailImageViewEdgeInsets计算，正方形
@property (nonatomic) CGSize detailImageSize;

/// [UIColor es_lightBorderColor]
+ (UIColor *)defaultBorderColor;
/// (10.f, 10.f, 10.f, 10.f)
+ (UIEdgeInsets)defaultIconImageEdgeInsets;
/// (10.f, 5.f, 10.f, 5.f)
+ (UIEdgeInsets)defaultDetailImageEdgeInsets;

@end
