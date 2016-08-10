//
//  ACWebViewController+Private.h
//  AppComponents
//
//  Created by Elf Sundae on 16/3/28.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <AppComponents/ACWebViewController.h>
#import <AppComponents/ACConfig.h>

@interface ACWebViewController ()
{
    /// viewAppear时是否需要加载
    BOOL _shouldLoadOnViewAppeared;
    /// 在viewDidLoad中加载本地网页（file:///....) 默认值为YES
    BOOL _loadLocalFileURLOnViewDidLoad;

    BOOL _storedAFNetworkActivityIndicatorManagerEnabled;
    NSString *_storedUserAgent;
}

@property (nonatomic, getter = isLoading) BOOL loading;

@end


@interface ACWebViewController (Private)

- (id)_AFNetworkActivityIndicatorSharedManager;
- (BOOL)_getAFNetworkActivityIndicatorManagerEnabled;
- (void)_setAFNetworkActivityIndicatorManagerEnabled:(BOOL)enabled;
- (void)_setNetworkActivityIndicatorVisible:(BOOL)visible;

@end
