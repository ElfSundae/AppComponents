//
//  ESApp+ACImageViewController.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>
#import <JTSImageViewController/JTSImageViewController.h>
#import <AppComponents/JTSImageInfo+ACAdditions.h>

@interface ESApp (ACImageViewController)
<JTSImageViewControllerDismissalDelegate, JTSImageViewControllerInteractionsDelegate>

@property (nonatomic, strong) JTSImageViewController *imageViewControler;
@property (nonatomic) JTSImageViewControllerBackgroundOptions defaultImageViewControllerBackgroundOptions;

- (JTSImageViewController *)showImageViewControllerWithImageInfo:(JTSImageInfo *)imageInfo
                                               backgroundOptions:(JTSImageViewControllerBackgroundOptions)backgroundOptions;

/// with [self defaultImageViewControllerBackgroundOptions]
- (JTSImageViewController *)showImageViewControllerWithImageInfo:(JTSImageInfo *)imageInfo;

- (JTSImageViewController *)showImageViewControllerFromView:(UIView *)view
                                                      image:(UIImage *)image
                                          backgroundOptions:(JTSImageViewControllerBackgroundOptions)backgroundOptions
                                     imageInfoCustomization:(void (^)(JTSImageInfo *imageInfo))imageInfoCustomization;

- (JTSImageViewController *)showImageViewControllerFromView:(UIView *)view
                                                   imageURL:(NSURL *)imageURL
                                           placeholderImage:(UIImage *)placeholderImage
                                          backgroundOptions:(JTSImageViewControllerBackgroundOptions)backgroundOptions
                                     imageInfoCustomization:(void (^)(JTSImageInfo *imageInfo))imageInfoCustomization;

- (void)dismissImageViewController:(BOOL)animated;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - JTSImageViewController Delegate Methods

// 这里列出了ESApp实现了的delegate方法，如果你在调用了 -showImageViewController... 方法后设置了相关delegate，可以在你的实现中调用这里的实现。

/**
 * 清理 self.imageViewController
 */
- (void)imageViewerDidDismiss:(JTSImageViewController *)imageViewer;

/**
 * 根据imageInfo里的 -canCopy 等属性判断是否弹窗ActionSheet
 */
- (void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer atRect:(CGRect)rect;

@end
