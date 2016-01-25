//
//  ESApp+ACImageViewController.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACImageViewController.h"
#import <ESFramework/UIView+ESShortcut.h>
#import <ESFramework/UIActionSheet+ESBlock.h>
#import <AppComponents/ESApp+ACHelper.h>

ESDefineAssociatedObjectKey(imageViewControler);

@implementation ESApp (ACImageViewController)

- (JTSImageViewController *)imageViewControler
{
        return ESGetAssociatedObject(self, imageViewControlerKey);
}

- (void)setImageViewControler:(JTSImageViewController *)imageViewControler
{
        ESSetAssociatedObject(self, imageViewControlerKey, imageViewControler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JTSImageViewController *)showImageViewControllerWithImageInfo:(JTSImageInfo *)imageInfo
                                               backgroundOptions:(JTSImageViewControllerBackgroundOptions)backgroundOptions
{
        if (![imageInfo isKindOfClass:[JTSImageInfo class]]) {
                return nil;
        }
        if (!imageInfo.image && !imageInfo.imageURL && !imageInfo.canonicalImageURL) {
                return nil;
        }
        
        if (!imageInfo.referenceView) {
                imageInfo.referenceView = self.rootViewController.view;
                imageInfo.referenceRect = CGRectMake(self.rootViewController.view.centerX, self.rootViewController.view.centerY, 0, 0);
        }
        
        [self dismissImageViewController:NO];
        self.imageViewControler = [[JTSImageViewController alloc] initWithImageInfo:imageInfo
                                                                               mode:(imageInfo.altText ? JTSImageViewControllerMode_AltText : JTSImageViewControllerMode_Image)
                                                                    backgroundStyle:backgroundOptions];
        self.imageViewControler.dismissalDelegate = self;
        self.imageViewControler.interactionsDelegate = self;
        [self.imageViewControler showFromViewController:self.rootViewController transition:JTSImageViewControllerTransition_FromOriginalPosition];
        return self.imageViewControler;
}

- (JTSImageViewController *)showImageViewControllerWithImageInfo:(JTSImageInfo *)imageInfo
{
        return [self showImageViewControllerWithImageInfo:imageInfo backgroundOptions:JTSImageViewControllerBackgroundOption_Blurred];
}

- (JTSImageViewController *)ac_showImageViewControllerFromView:(UIView *)view
                                                         image:(UIImage *)image
                                                      imageURL:(NSURL *)imageURL
                                              placeholderImage:(UIImage *)placeholderImage
                                             backgroundOptions:(JTSImageViewControllerBackgroundOptions)backgroundOptions
                                        imageInfoCustomization:(void (^)(JTSImageInfo *imageInfo))imageInfoCustomization
{
        JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
        imageInfo.image = image;
        imageInfo.imageURL = imageURL;
        imageInfo.placeholderImage = placeholderImage;
        // TODO: 检查rect是否在view中间. 如果view是scrollView, 检查是否在contentSize范围内，并且把scrollView的contentInset.top加上
        imageInfo.referenceView = view.superview ?: self.rootViewController.view;
        imageInfo.referenceRect = view ? view.frame : CGRectMake(self.rootViewController.view.centerX, self.rootViewController.view.centerY, 0, 0);
        if (view) {
                imageInfo.referenceContentMode = view.contentMode;
                imageInfo.referenceCornerRadius = view.layer.cornerRadius;
        }
        if (imageInfoCustomization) {
                imageInfoCustomization(imageInfo);
        }
        return [self showImageViewControllerWithImageInfo:imageInfo backgroundOptions:backgroundOptions];
}

- (JTSImageViewController *)showImageViewControllerFromView:(UIView *)view
                                                      image:(UIImage *)image
                                          backgroundOptions:(JTSImageViewControllerBackgroundOptions)backgroundOptions
                                     imageInfoCustomization:(void (^)(JTSImageInfo *imageInfo))imageInfoCustomization
{
        return [self ac_showImageViewControllerFromView:view image:image imageURL:nil placeholderImage:nil backgroundOptions:backgroundOptions imageInfoCustomization:imageInfoCustomization];
}

- (JTSImageViewController *)showImageViewControllerFromView:(UIView *)view
                                                   imageURL:(NSURL *)imageURL
                                           placeholderImage:(UIImage *)placeholderImage
                                          backgroundOptions:(JTSImageViewControllerBackgroundOptions)backgroundOptions
                                     imageInfoCustomization:(void (^)(JTSImageInfo *imageInfo))imageInfoCustomization
{
        return [self ac_showImageViewControllerFromView:view image:nil imageURL:imageURL placeholderImage:placeholderImage backgroundOptions:backgroundOptions imageInfoCustomization:imageInfoCustomization];
}

- (void)dismissImageViewController:(BOOL)animated
{
        if (self.imageViewControler) {
                self.imageViewControler.dismissalDelegate = nil;
                self.imageViewControler.optionsDelegate = nil;
                self.imageViewControler.interactionsDelegate = nil;
                self.imageViewControler.accessibilityDelegate = nil;
                self.imageViewControler.animationDelegate = nil;
                [self.imageViewControler dismiss:animated];
                self.imageViewControler = nil;
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Delegate

- (void)imageViewerDidDismiss:(JTSImageViewController *)imageViewer
{
        [self dismissImageViewController:NO];
}

- (void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer atRect:(CGRect)rect
{
        if (!imageViewer.image) {
                return;
        }
        NSMutableArray *titles = [NSMutableArray array];
        if (imageViewer.imageInfo.canSaveToPhotoLibrary) {
                [titles addObject:@"保存到手机"];
        }
        if (imageViewer.imageInfo.canCopy) {
                [titles addObject:@"复制"];
        }
        
        if (titles.count == 0) {
                return;
        }
        
        ESWeak_(imageViewer);
        UIActionSheet *action = [UIActionSheet actionSheetWithTitle:nil cancelButtonTitle:nil didDismissBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                ESStrong_(imageViewer);
                NSString *actionTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
                if ([actionTitle isEqualToString:@"保存到手机"]) {
                        [[ESApp sharedApp] saveImageToPhotoLibrary:_imageViewer.image showsProgress:YES userInfo:nil completion:nil];
                } else if ([actionTitle isEqualToString:@"复制"]) {
                        [[UIPasteboard generalPasteboard] setImage:_imageViewer.image];
                }
        } otherButtonTitles:nil];
        for (NSString *t in titles) {
                [action addButtonWithTitle:t];
        }
        [action addButtonWithTitle:@"取消"];
        action.cancelButtonIndex = action.numberOfButtons - 1;
        [action showInView:self.keyWindow];
}

@end
