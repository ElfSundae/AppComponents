//
//  ACWebViewController+Private.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACWebViewController+Subclassing.h"
#import <ESFramework/ESFrameworkStoreKit.h>

@implementation ACWebViewController (Private)

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

- (void)showNetworkActivityIndicator:(BOOL)show
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        Class AFNetworkActivityIndicatorManagerClass = NSClassFromString(@"AFNetworkActivityIndicatorManager");
        if (AFNetworkActivityIndicatorManagerClass) {
                id manager = [AFNetworkActivityIndicatorManagerClass performSelector:@selector(sharedManager)];
                if (show) {
                        [manager performSelector:@selector(incrementActivityCount)];
                } else {
                        [manager performSelector:@selector(decrementActivityCount)];
                }
        }
        
#pragma clang diagnostic pop
}

- (void)showActivityOverlay
{
        if (!self.isViewLoaded) {
                return;
        }
        
        if (!self.activityOverlay) {
                self.activityOverlay = [[UIView alloc] initWithFrame:self.view.bounds];
                self.activityOverlay.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
                self.activityOverlay.backgroundColor = [UIColor clearColor];
                self.activityOverlay.alpha = 0.f;
                [self.view addSubview:self.activityOverlay];
                
                self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                [self.activityIndicatorView startAnimating];
                self.activityIndicatorView.center = CGPointMake(self.activityOverlay.width / 2.f, self.activityOverlay.height / 2.f);
                self.activityIndicatorView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin);
                if ([self.webView.backgroundColor es_isLightColor]) {
                        self.activityIndicatorView.color = [UIColor colorWithWhite:0.08 alpha:1.0];
                } else {
                        self.activityIndicatorView.color = [UIColor colorWithWhite:0.8 alpha:1.0];
                }
                [self.activityOverlay addSubview:self.activityIndicatorView];
        }
        
        self.activityOverlay.alpha = 1.f;
        [self.activityOverlay bringToFront];
}

- (void)hideActivityOverlay
{
        if (!self.isViewLoaded) {
                return;
        }
        
        if (self.activityOverlay) {
                self.activityOverlay.alpha = 0.f;
                if (!self.isActivityOverlayEnabeld) {
                        [self.activityOverlay removeFromSuperview];
                        self.activityOverlay = nil;
                }
        }
}

- (ESErrorView *)showErrorViewWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image tag:(NSInteger)tag actionButtonTitle:(NSString *)actionButtonTitle actionButtonHandle:(ESUIControlHandler)actionButtonHandler
{
        if (self.errorView && tag == self.errorView.tag) {
                return self.errorView;
        }
        
        [self hideErrorView];
        self.errorView = [[ESErrorView alloc] initWithFrame:self.view.bounds title:title subtitle:subtitle image:image];
        self.errorView.backgroundColor = self.view.backgroundColor;
        self.errorView.tag = tag;
        if ([self.errorView.backgroundColor es_isLightColor]) {
                self.errorView.titleLabel.textColor = [UIColor colorWithRed:0.376 green:0.404 blue:0.435 alpha:1.000];
        } else {
                self.errorView.titleLabel.textColor = [UIColor es_lightBorderColor];
        }
        if (actionButtonTitle) {
                ESButton *button = [ESButton buttonWithStyle:ESButtonStyleRoundedRect];
                [button setTitle:actionButtonTitle forState:UIControlStateNormal];
                [button setButtonColor:[UIColor es_successButtonColor]];
                [button sizeToFit];
                button.width = fmaxf(button.width, self.view.width * 0.4f);
                [button addEventHandler:actionButtonHandler forControlEvents:UIControlEventTouchUpInside];
                self.errorView.actionButton = button;
        }
        [self.view addSubview:self.errorView];
        return self.errorView;
}

- (ESErrorView *)showErrorViewForLoadingFailed:(NSString *)title
{
        ESWeakSelf;
        ESErrorView *errorView = [self showErrorViewWithTitle:title ?: @"加载失败" subtitle:nil image:nil tag:0 actionButtonTitle:@"刷新" actionButtonHandle:^(id sender, UIControlEvents controlEvent) {
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

- (NSMutableURLRequest *)requestWithURL:(NSURL *)URL
{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                               cachePolicy:self.requestCachePolicy
                                                           timeoutInterval:self.requestTimeoutInterval];
        return request;
}

- (void)openURL:(NSURL *)URL closeOnCompleted:(BOOL)closeOnCompleted
{
        ESWeakSelf;
        ESDispatchOnMainThreadAsynchrony(^{
                ESStrongSelf;
                if (closeOnCompleted) {
                        [_self.navigationController popViewControllerAnimated:NO];
                }
                [ESApp openURL:URL];
        });
}

- (void)openInAppStoreWithItemURL:(NSURL *)URL showNetworkActivityIndicator:(BOOL)showNetworkActivityIndicator closeOnCompleted:(BOOL)closeOnCompleted
{
        ESWeakSelf;
        ESDispatchOnMainThreadAsynchrony(^{
                ESStrongSelf;
                if (showNetworkActivityIndicator) {
                        [self showNetworkActivityIndicator:YES];
                }
                
                if (closeOnCompleted) {
                        [_self.navigationController popViewControllerAnimated:NO];
                }
                
                [[ESStoreProductViewControllerManager sharedManager] presentStoreWithProductURL:URL
                                                                       shouldOpenURLWhenFailure:YES
                                                                                     willAppear:^
                 {
                         ESStrongSelf;
                         if (showNetworkActivityIndicator) {
                                 [_self showNetworkActivityIndicator:NO];
                         }
                 } parameters:nil];
        });
}

- (void)injectJavascriptForOpenningImageLink:(UIWebView *)webView
{
        NSString *checkObject = NSStringWith(@"typeof %@ == \'object\';", ACWebViewImageBrowserJavascriptObjectName);
        if (![[webView stringByEvaluatingJavaScriptFromString:checkObject] isEqualToString:@"true"]) {
                NSString *injectJS =
                NSStringWith(@";(function() {           \
                             if(window.%@) { return }   \
                             %@ = {                     \
                             open: function(e) {        \
                             e.preventDefault();        \
                             var rect = this.getElementsByTagName('img')[0].getBoundingClientRect();   \
                             window.location.href=\'%@://\' +'image?url='+encodeURIComponent(this.href) +'&rect='+encodeURIComponent(rect.left+','+rect.top+','+rect.width+','+rect.height);        \
                             }  \
                             }; \
                             \
                             Array.prototype.slice.call(document.getElementsByTagName('a'), 0).filter(function(el) {    \
                             return /\\.(png|jpg|jpeg|tiff|gif)$/i.test((el.getElementsByTagName('img') || []).length > 0 && el.href !== 'undefined' ? el.href : '')    \
                             }).forEach(function(el) {  \
                             el.addEventListener('click', %@.open);     \
                             }); \
                             \
                             })();",
                             ACWebViewImageBrowserJavascriptObjectName,
                             ACWebViewImageBrowserJavascriptObjectName,
                             ACWebViewCustomScheme,
                             ACWebViewImageBrowserJavascriptObjectName);
                [webView stringByEvaluatingJavaScriptFromString:injectJS];
        }
}

- (BOOL)isITunesLinkURL:(NSURL *)URL
{
        // 只匹配http(s)开头的iTunes链接， itms-app的协议用openURL打开
        if ([URL.host isEqualToStringCaseInsensitive:@"itunes.apple.com"] &&
            [URL.scheme.lowercaseString hasPrefix:@"http"]) {
                NSString *itemID = [ESStoreHelper itemIDFromURL:URL];
                return !!itemID;
        }
        return NO;
}

- (BOOL)shouldOpenURL:(NSURL *)URL
{
        if (!([URL.scheme isEqualToStringCaseInsensitive:@"http"] ||
              [URL.scheme isEqualToStringCaseInsensitive:@"https"] ||
              [URL.scheme isEqualToStringCaseInsensitive:@"tel"] ||
              [URL.scheme isEqualToStringCaseInsensitive:@"ftp"])) {
                return YES;
        }
        
        if ([URL.absoluteString isMatch:@"^https?://.+\\.mobileprovision" caseInsensitive:YES]) {
                return YES;
        }
        
        return NO;
}

- (void)networkReachabilityDidChangeNotification:(NSNotification *)notification
{
        if (self.automaticallyReloadWhenNetworkBecomesReachable &&
            _flags.currentLoadingErrorIsLocalNetworkError &&
            [UIDevice currentNetworkReachabilityStatus] != ESNetworkReachabilityStatusNotReachable) {
                [self reload];
        }
}

@end
