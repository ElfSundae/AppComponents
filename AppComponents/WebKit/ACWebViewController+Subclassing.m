//
//  ACWebViewController+Subclassing.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACWebViewController+Private.h"
#import <AppComponents/ACConfig.h>

@implementation ACWebViewController (Subclassing)

- (UIWebView *)createWebView
{
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        webView.scalesPageToFit = YES;
        webView.allowsInlineMediaPlayback = YES;
        webView.mediaPlaybackRequiresUserAction = NO;
        webView.mediaPlaybackAllowsAirPlay = YES;
        webView.suppressesIncrementalRendering = NO;
        webView.keyboardDisplayRequiresUserAction = NO;
        // Fix issue: UIWebView will appear a blank area on bottom, because of webview.scrollView.contentInset.top
        webView.opaque = NO;
        webView.backgroundColor = self.view.backgroundColor;
        webView.scrollView.delaysContentTouches = NO;
        return webView;
}

- (WebViewJavascriptBridge *)createJSBridgeForWebView:(UIWebView *)webView
{
        ESWeakSelf;
        WebViewJavascriptBridge *bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:webView.delegate handler:^(id data, WVJBResponseCallback responseCallback) {
                ESStrongSelf;
                [_self handleJSBridgeData:data responseCallback:responseCallback];
        }];
        return bridge;
}

- (void)handleJSBridgeData:(id)data responseCallback:(void (^)(id))responseCallback
{
        
}


- (BOOL)handleWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
        if ([request.URL.scheme isEqualToString:kCustomProtocolScheme]) {
                return NO;
        }
        
        if ([self isITunesLinkURL:request.URL]) {
                if (self.isInAppStoreEnabled) {
                        [self openInAppStoreWithItemURL:request.URL
                           showNetworkActivityIndicator:self.isNetworkActivityIndicatorEnabeld
                                       closeOnCompleted:_flags.isFirstLoading];
                } else {
                        [self openURL:request.URL closeOnCompleted:_flags.isFirstLoading];
                }
                return NO;
        }
        
        if ([self shouldOpenURL:request.URL] && [ESApp canOpenURL:request.URL]) {
                [self openURL:request.URL closeOnCompleted:_flags.isFirstLoading];
                return NO;
        }
        
        return YES;
}

- (void)handleWebViewDidStartLoad:(UIWebView *)webView
{
        // nop
}

- (void)handleWebViewDidFinishLoad:(UIWebView *)webView
{
        self.currentPageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if (self.showsPageTitle) {
                self.navigationItem.title = self.currentPageTitle;
        }
}

- (void)handleWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error isFirstLoading:(BOOL)isFirstLoading
{
        // File Download:
        // Error Domain=WebKitErrorDomain Code=102 "帧框加载已中断" UserInfo=0x2207fd50 {NSErrorFailingURLKey=http://kanpian.elfsundae.com/downloads/downloads/2013/05/2e03ecd62ccf74b7cf28801d6a0afe74.zip, NSErrorFailingURLStringKey=http://kanpian.elfsundae.com/downloads/downloads/2013/05/2e03ecd62ccf74b7cf28801d6a0afe74.zip, NSLocalizedDescription=帧框加载已中断}
        if ([error.domain isEqualToString:@"WebKitErrorDomain"] && 102 == error.code) {
                NSURL *url = error.userInfo[NSURLErrorFailingURLErrorKey];
                [self handleWebViewDidFailLoadWithDocumentFrameHasBeenInterrupted:webView failingURL:url error:error isFirstLoading:isFirstLoading];
                return;
        }
        
        // Bad URL
        if (([error.domain isEqualToString:@"WebKitErrorDomain"] && 101 == error.code) ||
            ([error.domain isEqualToString:NSURLErrorDomain] && (NSURLErrorBadURL == error.code || NSURLErrorUnsupportedURL == error.code))) {
                [self handleWebViewDidFailLoadWithBadURL:webView failingURL:error.userInfo[NSURLErrorFailingURLErrorKey] error:error isFirstLoading:isFirstLoading];
                return;
        }
        
        // Local network issue
        if (error.isLocalNetworkError) {
                [self handleWebViewDidFailLoadWithLocalNetworkIsNotReachable:webView failingURL:error.userInfo[NSURLErrorFailingURLErrorKey] error:error isFirstLoading:isFirstLoading];
                return;
        }
        
        // Unauthorized resource
        if ([error.domain isEqualToString:NSURLErrorDomain] && kCFURLErrorNoPermissionsToReadFile == error.code) {
                [self handleWebViewDidFailLoadWithNoPermissionsToRead:webView failingURL:error.userInfo[NSURLErrorFailingURLErrorKey] error:error isFirstLoading:isFirstLoading];
                return;
        }
}

- (void)handleWebViewDidFailLoadWithDocumentFrameHasBeenInterrupted:(UIWebView *)webView failingURL:(NSURL *)failingURL error:(NSError *)error isFirstLoading:(BOOL)isFirstLoading
{
        if ([ESApp canOpenURL:failingURL]) {
                [self openURL:failingURL closeOnCompleted:isFirstLoading];
        } else {
                if (self.showsErrorViewWhenFailedLoading) {
                        [self showErrorViewForLoadingFailed:nil];
                }
        }
}

- (void)handleWebViewDidFailLoadWithBadURL:(UIWebView *)webView failingURL:(NSURL *)failingURL error:(NSError *)error isFirstLoading:(BOOL)isFirstLoading
{
        if (self.showsErrorViewWhenFailedLoading) {
                [self showErrorViewForLoadingFailed:nil];
                return;
        }
        
        ESWeakSelf;
        UIAlertView *alertView = [UIAlertView alertViewWithTitle:_e(@"无法打开网页") message:_e(@"网址无效") cancelButtonTitle:@"OK" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                ESStrongSelf;
                if (isFirstLoading) {
                        [_self.navigationController popViewControllerAnimated:YES];
                }
        } otherButtonTitles:nil];
        [alertView show];
}

- (void)handleWebViewDidFailLoadWithLocalNetworkIsNotReachable:(UIWebView *)webView failingURL:(NSURL *)failingURL error:(NSError *)error isFirstLoading:(BOOL)isFirstLoading
{
        NSString *localNetworkErrorAlertTitle = ESStringValueWithDefault(ACConfigGet(kACConfigKey_ACNetworking_LocalNetworkErrorAlertTitle), kACNetworkingLocalNetworkErrorAlertTitle);
        if (self.showsErrorViewWhenFailedLoading) {
                [self showErrorViewForLoadingFailed:localNetworkErrorAlertTitle];
                return;
        }
        
        [UIAlertView showWithTitle:_e(@"无法打开网页") message:localNetworkErrorAlertTitle];
}

- (void)handleWebViewDidFailLoadWithNoPermissionsToRead:(UIWebView *)webView failingURL:(NSURL *)failingURL error:(NSError *)error isFirstLoading:(BOOL)isFirstLoading
{
        if (self.showsErrorViewWhenFailedLoading) {
                [self showErrorViewForLoadingFailed:nil];
                return;
        }
        
        // Error Domain=NSURLErrorDomain Code=-1102 "您没有访问所请求的资源的权限。"
        // UserInfo=0x1742edb80 {
        //      NSUnderlyingError=0x170645190 "您没有访问所请求的资源的权限。",
        //      NSErrorFailingURLStringKey=ftp://elfsundae@192.168.3.100/Volumes/AppleHD/Downloads/AndroidTrainingCHS.pdf,
        //      NSErrorFailingURLKey=ftp://elfsundae@192.168.3.100/Volumes/AppleHD/Downloads/AndroidTrainingCHS.pdf,
        //      NSLocalizedDescription=您没有访问所请求的资源的权限。
        //}
        [UIAlertView showWithTitle:_e(@"无法打开网页") message:error.userInfo[NSLocalizedDescriptionKey]];
}

@end
