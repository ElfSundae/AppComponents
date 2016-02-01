//
//  ACTableViewCell.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/29.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

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

- (instancetype)initWithCellStyle:(ACTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readonly) ACTableViewCellStyle cellStyle;

/// Uses self.cellData as NSDictionary to configure cell, defaults to NO.
@property (nonatomic) BOOL configuresCellWithDictionaryUsingCellData;

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

/**
 * Applies defaults value for properties
 */
- (void)applyDefaults;

/**
 * cellData: {
 *      leftBadgeView:                  UIView instance
 *      rightBadgeView:                 UIView instance
 *      text:                           NSString/NSAttributedString
 *      detailText:                     NSString/NSAttributedString
 *      iconImage:                      UIImage/NSURL/NSString
 *      detailImage:                    UIImage/NSURL/NSString 
 *      iconImagePlaceholder:           UIImage
 *      detailImagePlaceholder:         UIImage
 *
 *      accessoryType:                  NSNumber with UITableViewCellAccessoryType
 *      selectionStyle:                 NSNumber with UITableViewCellSelectionStyle
 *      alwaysShowsIconImageView:       NSNumber with BOOL
 *      iconImageViewSize:              NSValue with CGSize
 *      iconImageViewInset:             NSValue with UIEdgeInsets
 *      iconImageViewCornerRadius:      NSNumber with CGFloat
 *      iconImageViewBorderWidth:       NSNumber with CGFloat
 *      iconImageViewBorderColor:       UIColor
 *      alwaysShowsDetailImageView:     NSNumber with BOOL
 *      detailImageViewSize:            NSValue with CGSize
 *      detailImageViewInset:           NSValue with UIEdgeInsets
 *      detailImageViewCornerRadius:    NSNumber with CGFloat
 *      detailImageViewBorderWidth:     NSNumber with CGFloat
 *      detailImageViewBorderColor:     UIColor
 *      detailImageViewMostRight:       NSNumber with BOOL
 *      cellPadding:                    NSNumber with CGFloat
 *      cellMarginLeft:                 NSNumber with CGFloat
 *      cellMarginRight:                NSNumber with CGFloat
 * }
 */
- (void)configureCellWithDictionary:(NSDictionary *)cellData;

/// [UIColor es_lightBorderColor]
+ (UIColor *)defaultBorderColor;
/// (10.f, 10.f, 10.f, 10.f)
+ (UIEdgeInsets)defaultIconImageViewInset;
/// (10.f, 5.f, 10.f, 5.f)
+ (UIEdgeInsets)defaultDetailImageViewInset;
/// 5.f
+ (CGFloat)defaultCellPadding;
/// 10.f
+ (CGFloat)defaultCellMarginLeft;
/// 10.f
+ (CGFloat)defaultCellMarginRight;

@end
