//
//  ACWebViewController+Private.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//


#import "ACWebViewController.h"
#import <ESFramework/ESFrameworkCore.h>
#import <ESFramework/ESFrameworkAdditions.h>
#import <ESFramework/ESFrameworkUIKit.h>
#import <ESFramework/ESApp.h>

FOUNDATION_EXTERN NSString *const ACWebViewImageBrowserJavascriptObjectName;

@interface ACWebViewController ()
{
@protected
        struct {
                // 是否第一次加载
                unsigned int isFirstLoading:1;
                // viewAppear时是否需要加载
                unsigned int shouldLoadOnViewAppeared:1;
                // 在viewDidLoad中加载本地网页（file:///....) 默认值为YES
                unsigned int loadFileURLOnViewLoaded:1;
                
                // 当前加载失败的网页是因为本地网络异常
                unsigned int currentLoadingErrorIsLocalNetworkError:1;
        } _flags;
        
        NSInteger _numberOfRequest;
}

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic, copy) NSURL *initializationURL;
@property (nonatomic, copy) NSString *initializationTitle;
@property (nonatomic, copy) NSString *currentPageTitle;
@property (nonatomic, strong) WebViewJavascriptBridge *JSBridge;

@property (nonatomic, strong) UIView *activityOverlay;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView; // it is on activityOverlay
@property (nonatomic, strong) ESErrorView *errorView;

@end

@interface ACWebViewController (Private)

/// 根据配置showsRefreshControl创建或销毁refreshControl
- (void)checkRefreshControl;

/// Shows or Hides the network activyIndicator
- (void)showNetworkActivityIndicator:(BOOL)show;

- (void)showActivityOverlay;
- (void)hideActivityOverlay;

- (ESErrorView *)showErrorViewForLoadingFailed:(NSString *)title;
- (ESErrorView *)showErrorViewWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image tag:(NSInteger)tag actionButtonTitle:(NSString *)actionButtonTitle actionButtonHandle:(ESUIControlHandler)actionButtonHandler;
- (void)hideErrorView;

/// 根据URL创建request
- (NSMutableURLRequest *)requestWithURL:(NSURL *)URL;

/// 打开外部链接，如果closeOnCompleted为YES, 操作完成后当前界面会被关闭(pop/dismiss)
- (void)openURL:(NSURL *)URL closeOnCompleted:(BOOL)closeOnCompleted;
/// 打开应用内iTunes Store, 如果closeOnCompleted为YES, 操作完成后当前界面会被关闭(pop/dismiss)
- (void)openInAppStoreWithItemURL:(NSURL *)URL showNetworkActivityIndicator:(BOOL)showNetworkActivityIndicator closeOnCompleted:(BOOL)closeOnCompleted;

/// 用imageBrowser打开图片.
/// URL格式：xx-image:url=xxx&rect=urlEncoded(1,2,3,4)，其中url为必须参数，rect用docElement.getBoundingClientRect()获得。
/// 或者只是一个图片地址url: xx-image:urlEncoded(imageURL)
- (BOOL)openImageClickedLinkWithWebView:(UIWebView *)webView request:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

/// 注入打开img链接的js代码
- (void)injectJavascriptForOpenningImageClickedLink:(UIWebView *)webView;

/// 返回是否iTunes链接， 用于打开SKStoreProductViewController
- (BOOL)isITunesLinkURL:(NSURL *)URL;
/// 返回是否需要调用 -[UIApplication openURL:]打开外部链接
- (BOOL)shouldOpenURL:(NSURL *)URL;

- (void)networkReachabilityDidChangeNotification:(NSNotification *)notification;

@end

/*!
 * 子类重载这里的方法，不要直接实现UIWebViewDelegaet，因为基类做了一些状态处理，比如_flag.isFirstLoading, loading等。
 */
@interface ACWebViewController (Subclassing)

- (UIWebView *)createWebView;

- (WebViewJavascriptBridge *)createJSBridgeForWebView:(UIWebView *)webView;

- (void)handleJSBridgeData:(id)data responseCallback:(void (^)(id))responseCallback;

/**
 * 基类实现：
 *      检查是否需要打开InAppStore
 *      检查是否需要调用OpenURL打开外部链接
 */
- (BOOL)handleWebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
/**
 * 基类实现：无
 */
- (void)handleWebViewDidStartLoad:(UIWebView *)webView;
/**
 * 基类实现：
 *      设置pageTitle属性
 *      如果showsPageTitle为YES, 设置navigationItem.title
 */
- (void)handleWebViewDidFinishLoad:(UIWebView *)webView;
/**
 * 基类实现：
 *      检查是否文件下载并调用openURL；
 *      检查是否Bad URL，并弹窗提示；
 *      检查是否本地网络连接错误，并弹窗提示；
 *      检查是否无权访问资源，并弹窗提示；
 */
- (void)handleWebView:(UIWebView *)webView didFailLoadWithError:(NSError *)error isFirstLoading:(BOOL)isFirstLoading;

/// File Download: WebKitErrorDomain(102).
/// Error Domain=WebKitErrorDomain Code=102 "帧框加载已中断" UserInfo=0x2207fd50 {NSErrorFailingURLKey=http://kanpian.elfsundae.com/downloads/downloads/2013/05/2e03ecd62ccf74b7cf28801d6a0afe74.zip, NSErrorFailingURLStringKey=http://kanpian.elfsundae.com/downloads/downloads/2013/05/2e03ecd62ccf74b7cf28801d6a0afe74.zip, NSLocalizedDescription=帧框加载已中断}
/// 基类实现：[self openURL:failingURL closeOnCompleted:isFirstLoading]; 或者在showsErrorViewWhenFailedLoading时showErrorView:nil
- (void)handleWebViewDidFailLoadWithDocumentFrameHasBeenInterrupted:(UIWebView *)webView failingURL:(NSURL *)failingURL error:(NSError *)error isFirstLoading:(BOOL)isFirstLoading;

/// Bad URL.
/// 基类实现：show UIAlertView; 或者在showsErrorViewWhenFailedLoading时showErrorView:nil
- (void)handleWebViewDidFailLoadWithBadURL:(UIWebView *)webView failingURL:(NSURL *)failingURL error:(NSError *)error isFirstLoading:(BOOL)isFirstLoading;

/// Network error.
/// 基类实现：show UIAlertView; 或者在showsErrorViewWhenFailedLoading时showErrorView:_e(@"网络连接异常")
- (void)handleWebViewDidFailLoadWithLocalNetworkIsNotReachable:(UIWebView *)webView failingURL:(NSURL *)failingURL error:(NSError *)error isFirstLoading:(BOOL)isFirstLoading;

/// Unauthorized to read resource, e.g. ftp:// that needs authorization.
/// 基类实现：show UIAlertView; 或者在showsErrorViewWhenFailedLoading时showErrorView:nil
- (void)handleWebViewDidFailLoadWithNoPermissionsToRead:(UIWebView *)webView failingURL:(NSURL *)failingURL error:(NSError *)error isFirstLoading:(BOOL)isFirstLoading;

@end
