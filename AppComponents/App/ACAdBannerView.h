//
//  ACAdBannerView.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ACAdBannerView;

typedef void (^ACAdBannerViewBlock)(ACAdBannerView *adBannerView);

/**
 * bannerView
 * 如果需要支持gif图片，请在项目中添加SDWebImage
 *
 * 自动检测是否添加了友盟统计SDK并发送友盟点击事件。
 *
 */
@interface ACAdBannerView : UIView

@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *clickToURL;

/**
 * 友盟的点击事件ID， 为nil时不调用友盟统计.
 */
@property (nonatomic, copy) NSString *umengEventID;

@property (nonatomic, strong, readonly) UIImageView *imageView;

/**
 * 点击banner的回调， 如果没有设置则调用 -[UIApplication openURL:] 打开clickToURL
 */
@property (nonatomic, copy) ACAdBannerViewBlock clickAction;

@end
