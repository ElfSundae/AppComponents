//
//  ACWebViewController+Helper.m
//  AppComponents
//
//  Created by Elf Sundae on 16/3/28.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACWebViewController+Private.h"

@implementation ACWebViewController (Helper)

- (void)setNetworkActivityIndicatorVisible:(BOOL)visible
{
    [self _setNetworkActivityIndicatorVisible:visible];
}

- (void)setActivityOverlayVisible:(BOOL)visible
{
    if (!self.isViewLoaded) {
        return;
    }

    if (visible && self.isActivityOverlayEnabeld) {
        if (!self.activityOverlay) {
            self.activityOverlay = [[UIView alloc] initWithFrame:self.view.bounds];
            self.activityOverlay.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            self.activityOverlay.backgroundColor = [UIColor clearColor];
            self.activityOverlay.hidden = YES;

            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicatorView.center = CGPointMake(self.activityOverlay.width / 2., self.activityOverlay.height / 2.);
            indicatorView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin);
            if ([self.webView.backgroundColor es_isLightColor]) {
                indicatorView.color = [UIColor colorWithWhite:0.333 alpha:1.000];
            } else {
                indicatorView.color = [UIColor colorWithWhite:0.888 alpha:1.0];
            }
            [indicatorView startAnimating];
            [self.activityOverlay addSubview:indicatorView];
        }

        if (self.activityOverlay.superview != self.view) {
            [self.activityOverlay removeFromSuperview];
            [self.view addSubview:self.activityOverlay];
        }

        self.activityOverlay.hidden = NO;
        [self.activityOverlay bringToFront];
    } else {
        if (self.activityOverlay) {
            self.activityOverlay.hidden = YES;
            [self.activityOverlay removeFromSuperview];

            if (!self.isActivityOverlayEnabeld) {
                [self.activityOverlay removeFromSuperview];
                self.activityOverlay = nil;
            }
        }
    }
}

- (UIView *)showErrorViewWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image tag:(NSInteger)tag actionButtonTitle:(NSString *)actionButtonTitle actionButtonHandle:(ESUIControlHandler)actionButtonHandler
{
    if (!self.isViewLoaded) {
        return nil;
    }

    if (self.errorView && tag == self.errorView.tag) {
        return self.errorView;
    }

    [self hideErrorView];
    ESErrorView *errorView = [[ESErrorView alloc] initWithFrame:self.view.bounds title:title subtitle:subtitle image:image];
    errorView.backgroundColor = self.view.backgroundColor;
    errorView.tag = tag;
    if ([errorView.backgroundColor es_isLightColor]) {
        errorView.titleLabel.textColor = [UIColor colorWithRed:0.376 green:0.404 blue:0.435 alpha:1.000];
    } else {
        errorView.titleLabel.textColor = [UIColor es_lightBorderColor];
    }
    if (actionButtonTitle) {
        ESButton *button = [ESButton buttonWithStyle:ESButtonStyleRoundedRect];
        [button setTitle:actionButtonTitle forState:UIControlStateNormal];
        [button setButtonColor:[UIColor es_successButtonColor]];
        [button sizeToFit];
        button.width = fmaxf(button.width, self.view.width * 0.4f);
        [button addEventHandler:actionButtonHandler forControlEvents:UIControlEventTouchUpInside];
        errorView.actionButton = button;
    }
    [self.view addSubview:errorView];
    self.errorView = errorView;
    return errorView;
}

- (UIView *)showErrorViewForLoadingFailedWithTitle:(NSString *)title
{
    ESWeakSelf;
    UIView *errorView = [self showErrorViewWithTitle:title ?: @"加载失败" subtitle:nil image:nil tag:1 actionButtonTitle:@"刷新" actionButtonHandle:^(id sender, UIControlEvents controlEvent) {
        ESStrongSelf;
        [_self reload];
    }];
    return errorView;
}

- (void)hideErrorView
{
    if (self.errorView) {
        [self.errorView removeFromSuperview];
        self.errorView = nil;
    }
}

- (void)checkRefreshControl
{
    if (!self.isViewLoaded) {
        return;
    }

    if (self.showsRefreshControl && !self.refreshControl) {
        ESWeakSelf;
        self.refreshControl = [ESRefreshControl refreshControlWithDidStartRefreshingBlock:^(ESRefreshControl *refreshControl) {
            ESStrongSelf;
            [_self reload];
        }];
    } else if (!self.showsRefreshControl && self.refreshControl) {
        [self.refreshControl endRefreshing];
        self.refreshControl = nil;
    }
}

- (NSURLRequest *)requestWithURL:(NSURL *)URL
{
    return [NSURLRequest requestWithURL:URL cachePolicy:self.requestCachePolicy timeoutInterval:self.requestTimeoutInterval];
}

- (BOOL)shouldOpenURL:(NSURL *)URL
{
    if ([[URL pathExtension] isEqualToStringCaseInsensitive:@"mobileprovision"]) {
        return YES;
    }
    return NO;
}

- (void)openURL:(NSURL *)URL closeMe:(BOOL)closeMe
{
    ESDispatchOnMainThreadAsynchrony(^{
        if (closeMe) {
            [self closeMeAnimated:NO];
        }
        [[UIApplication sharedApplication] openURL:URL];
    });
}

- (void)openInAppStoreWithItemURL:(NSURL *)itemURL closeMe:(BOOL)closeMe
{
    ESDispatchOnMainThreadAsynchrony(^{
        if (closeMe) {
            [self closeMeAnimated:NO];
        }
        [[ESStoreProductViewControllerManager sharedManager] presentStoreWithProductURL:itemURL shouldOpenURLWhenFailure:YES willAppear:nil parameters:nil];
    });
}

- (void)closeMeAnimated:(BOOL)animated
{
    ESDispatchOnMainThreadAsynchrony(^{
        if (self.presentingViewController || self.navigationController.presentingViewController) {
            [self dismissViewControllerAnimated:animated completion:nil];
        } else if (self.navigationController.topViewController == self) {
            [self.navigationController popViewControllerAnimated:animated];
        }
    });
}

- (void)handleWebViewLoadingFailure:(UIWebView *)webView error:(NSError *)error failingURL:(NSURL *)failingURL
{
    // Bad URL
    if (([error.domain isEqualToString:@"WebKitErrorDomain"] && 101 == error.code) ||
        ([error.domain isEqualToString:NSURLErrorDomain] && (NSURLErrorBadURL == error.code || NSURLErrorUnsupportedURL == error.code)))
    {
        ESWeakSelf;
        UIAlertView *alertView = [UIAlertView alertViewWithTitle:_e(@"无法打开网页") message:_e(@"网址无效") cancelButtonTitle:@"OK" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            ESStrongSelf;
            if (_self.isFirstLoading) {
                [_self closeMeAnimated:YES];
            }
        } otherButtonTitles:nil];
        [alertView show];
        return;
    }

    // File Downloading:
    if ([error.domain isEqualToString:@"WebKitErrorDomain"] && 102 == error.code) {
        if (failingURL && [[UIApplication sharedApplication] canOpenURL:failingURL]) {
            [self openURL:failingURL closeMe:self.isFirstLoading];
            return;
        }
    }

    // Local network error
    if ([error isLocalNetworkError]) {
        NSString *alertTitle = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACApp_LocalNetworkErrorAlertTitle), kACAppLocalNetworkErrorAlertTitle);
        if (self.showsErrorViewWhenLoadingFailed) {
            [self showErrorViewForLoadingFailedWithTitle:alertTitle];
        } else {
            [UIAlertView showWithTitle:_e(@"无法打开网页") message:alertTitle];
        }
        return;
    }

    // Unauthorized resource: Error Domain=NSURLErrorDomain Code=-1102 "您没有访问所请求的资源的权限。"
    if ([error.domain isEqualToString:NSURLErrorDomain] && kCFURLErrorNoPermissionsToReadFile == error.code) {
        [UIAlertView showWithTitle:_e(@"无法打开网页") message:error.userInfo[NSLocalizedDescriptionKey]];
        return;
    }

    if (self.showsErrorViewWhenLoadingFailed) {
        [self showErrorViewForLoadingFailedWithTitle:nil];
    }
}

@end
