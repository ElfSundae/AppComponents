//
//  ACAdBannerView.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/20.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACAdBannerView.h"
#import <ESFramework/ESFrameworkCore.h>

@interface ACAdBannerView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ACAdBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleBottomMargin);
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        
        [self addSubview:self.imageView];
        
        self.imageView.userInteractionEnabled = YES;
        [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adTapped:)]];
        
        return self;
}

- (void)adTapped:(id)sender
{
        if (ESIsStringWithAnyText(self.umengEventID)) {
                Class MobClickClass = NSClassFromString(@"MobClick");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                if (MobClickClass && [MobClickClass respondsToSelector:@selector(event:)]) {
                        [MobClickClass performSelector:@selector(event:) withObject:self.umengEventID];
#pragma clang diagnostic pop
                }
        }
        
        if (self.clickAction) {
                self.clickAction(self);
        } else if (ESIsStringWithAnyText(self.clickToURL)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.clickToURL]];
        }
}

- (void)setImageURL:(NSString *)imageURL
{
        if (_imageURL != imageURL) {
                _imageURL = [imageURL copy];
                [self reloadImage];
        }
}

- (void)reloadImage
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

        if ([self.imageView respondsToSelector:@selector(sd_setImageWithURL:)]) {
                [self.imageView performSelector:@selector(sd_setImageWithURL:) withObject:[NSURL URLWithString:self.imageURL]];
#pragma clang diagnostic pop
        } else {
                ESWeakSelf;
                ESDispatchOnBackgroundQueue(^{
                        ESStrongSelf;
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_self.imageURL]];
                        UIImage *image = [UIImage imageWithData:imageData scale:[[UIScreen mainScreen] scale]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                                ESStrongSelf;
                                _self.imageView.image = image;
                        });
                });
        }
}


@end
