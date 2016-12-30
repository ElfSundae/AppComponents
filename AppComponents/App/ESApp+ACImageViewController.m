//
//  ESApp+ACImageViewController.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp+ACImageViewController.h"
#import <ESFramework/ESFrameworkCore.h>
#import "ESApp+ACHelper.h"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - JTSImageInfo (ACAdditions)

ESDefineAssociatedObjectKey(canSaveToPhotoLibrary);
ESDefineAssociatedObjectKey(canCopy);

@implementation JTSImageInfo (ACAdditions)

- (BOOL)canSaveToPhotoLibrary
{
    return [self es_getAssociatedBooleanWithKey:canSaveToPhotoLibraryKey defaultValue:YES];
}

- (void)setCanSaveToPhotoLibrary:(BOOL)can
{
    [self es_setAssociatedBooleanWithKey:canSaveToPhotoLibraryKey value:can];
}

- (BOOL)canCopy
{
    return [self es_getAssociatedBooleanWithKey:canCopyKey defaultValue:NO];
}

- (void)setCanCopy:(BOOL)can
{
    [self es_setAssociatedBooleanWithKey:canCopyKey value:can];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESApp (ACImageViewController)

ESDefineAssociatedObjectKey(imageViewControler);
ESDefineAssociatedObjectKey(imageViewControllerDefaultBackgroundOptions);

@implementation ESApp (ACImageViewController)

- (JTSImageViewController *)imageViewControler
{
    return ESGetAssociatedObject(self, imageViewControlerKey);
}

- (void)setImageViewControler:(JTSImageViewController *)imageViewControler
{
    ESSetAssociatedObject(self, imageViewControlerKey, imageViewControler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JTSImageViewControllerBackgroundOptions)imageViewControllerDefaultBackgroundOptions
{
    return [self es_getAssociatedIntegerWithKey:imageViewControllerDefaultBackgroundOptionsKey defaultValue:JTSImageViewControllerBackgroundOption_Blurred];
}

- (void)setImageViewControllerDefaultBackgroundOptions:(JTSImageViewControllerBackgroundOptions)value
{
    [self es_setAssociatedIntegerWithKey:imageViewControllerDefaultBackgroundOptionsKey value:value];
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
    } else {
        // TODO: 检查rect是否在view中间. 如果view是scrollView, 检查是否在contentSize范围内，并且把scrollView的contentInset.top加上
        if ([imageInfo.referenceView isKindOfClass:[UIWebView class]]) {
            CGRect fixedRect = imageInfo.referenceRect;
            if (!CGRectIsEmpty(fixedRect)) {
                fixedRect.origin.y += [(UIWebView *) imageInfo.referenceView scrollView].contentInset.top;
                imageInfo.referenceRect = fixedRect;
            }
        }
    }

    JTSImageViewController *imageViewControler = [[JTSImageViewController alloc] initWithImageInfo:imageInfo
                                                                                              mode:(imageInfo.altText ? JTSImageViewControllerMode_AltText : JTSImageViewControllerMode_Image)
                                                                                   backgroundStyle:backgroundOptions];

    ESWeakSelf;
    [self dismissImageViewController:NO completion:^{
        ESStrongSelf;
        imageViewControler.dismissalDelegate = _self;
        imageViewControler.interactionsDelegate = _self;
        [imageViewControler showFromViewController:_self.rootViewController
                                        transition:JTSImageViewControllerTransition_FromOriginalPosition];
    }];

    return self.imageViewControler = imageViewControler;
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

- (JTSImageViewController *)showImageViewControllerWithImageInfo:(JTSImageInfo *)imageInfo
{
    return [self showImageViewControllerWithImageInfo:imageInfo backgroundOptions:self.imageViewControllerDefaultBackgroundOptions];
}

- (JTSImageViewController *)showImageViewControllerFromView:(UIView *)view
                                                      image:(UIImage *)image
                                          backgroundOptions:(JTSImageViewControllerBackgroundOptions)backgroundOptions
                                     imageInfoCustomization:(void (^)(JTSImageInfo *imageInfo))imageInfoCustomization
{
    return [self ac_showImageViewControllerFromView:view image:image imageURL:nil placeholderImage:nil backgroundOptions:backgroundOptions imageInfoCustomization:imageInfoCustomization];
}

- (JTSImageViewController *)showImageViewControllerFromView:(UIView *)view
                                                      image:(UIImage *)image
{
    return [self showImageViewControllerFromView:view image:image backgroundOptions:self.imageViewControllerDefaultBackgroundOptions imageInfoCustomization:nil];
}

- (JTSImageViewController *)showImageViewControllerFromView:(UIView *)view
                                                   imageURL:(NSURL *)imageURL
                                           placeholderImage:(UIImage *)placeholderImage
                                          backgroundOptions:(JTSImageViewControllerBackgroundOptions)backgroundOptions
                                     imageInfoCustomization:(void (^)(JTSImageInfo *imageInfo))imageInfoCustomization
{
    return [self ac_showImageViewControllerFromView:view image:nil imageURL:imageURL placeholderImage:placeholderImage backgroundOptions:backgroundOptions imageInfoCustomization:imageInfoCustomization];
}

- (JTSImageViewController *)showImageViewControllerFromView:(UIView *)view
                                                   imageURL:(NSURL *)imageURL
                                           placeholderImage:(UIImage *)placeholderImage
{
    return [self showImageViewControllerFromView:view imageURL:imageURL placeholderImage:placeholderImage backgroundOptions:self.imageViewControllerDefaultBackgroundOptions imageInfoCustomization:nil];
}

- (JTSImageViewController *)showImageViewController:(id)imageOrURL
{
    if ([imageOrURL isKindOfClass:[UIImage class]]) {
        return [self showImageViewControllerFromView:nil image:imageOrURL];
    }

    NSURL *imageURL = ESURLValue(imageOrURL);
    if (imageURL) {
        return [self showImageViewControllerFromView:nil imageURL:imageURL placeholderImage:nil];
    }

    return nil;
}

- (void)dismissImageViewController:(BOOL)animated completion:(dispatch_block_t)completion
{
    if (self.imageViewControler) {
        [self.imageViewControler dismiss:animated];
        self.imageViewControler = nil;

        if (completion) {
            ESDispatchAfter(0.5, completion);
        }
    } else {
        if (completion) {
            completion();
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - JTSImageViewController Delegate

- (void)imageViewerDidDismiss:(JTSImageViewController *)imageViewer
{
    if (imageViewer == self.imageViewControler) {
        self.imageViewControler = nil;
    }
}

- (void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer atRect:(CGRect)rect
{
    if (!imageViewer.image) {
        return;
    }
#define kSaveTitle @"保存图片"
#define kCopyTitle @"复制"
    NSMutableArray *titles = [NSMutableArray array];
    if (imageViewer.imageInfo.canSaveToPhotoLibrary) {
        [titles addObject:kSaveTitle];
    }
    if (imageViewer.imageInfo.canCopy) {
        [titles addObject:kCopyTitle];
    }

    if (titles.count == 0) {
        return;
    }

    ESWeak(imageViewer);
    UIActionSheet *action = [UIActionSheet actionSheetWithTitle:nil cancelButtonTitle:nil didDismissBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        ESStrong(imageViewer);
        NSString *actionTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([actionTitle isEqualToString:kSaveTitle]) {
            [[ESApp sharedApp] saveImageToPhotoLibrary:_imageViewer.image showsProgress:YES userInfo:nil completion:nil];
        } else if ([actionTitle isEqualToString:kCopyTitle]) {
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
