//
//  ACWebViewController.h
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESFrameworkCore.h>
#import <ESFramework/ESFrameworkUIKit.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>

@class ACWebViewController;

#define ACWebViewJSBridgeDefaultHandlerName     @"default"

@protocol ACWebViewControllerDelegate <NSObject>
@optional
/**
 * Handles request which URL scheme is ACWebViewController's customScheme.
 */
- (void)webViewController:(ACWebViewController *)controller handleCustomScheme:(UIWebView *)webView request:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

/**
 * JSBridge handler for ACWebViewJSBridgeDefaultHandlerName.
 */
- (void)webViewController:(ACWebViewController *)controller JSBridgeDefaultHandlerWithData:(id)data responseCallback:(void (^)(id))responseCallback;

/// UIWebViewDelegate Handlers
- (BOOL)webViewController:(ACWebViewController *)controller webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewController:(ACWebViewController *)controller webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewController:(ACWebViewController *)controller webViewDidFinishLoad:(UIWebView *)webView;
- (void)webViewController:(ACWebViewController *)controller webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
@end

@interface ACWebViewController : UIViewController <UIWebViewDelegate, ACWebViewControllerDelegate>

/// =============================================
/// @name Initializer
/// =============================================

- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURL:(NSURL *)URL title:(NSString *)title;

/// =============================================
/// @name WebView Loading
/// =============================================

- (void)loadURL:(NSURL *)URL;
- (void)stopLoading;
/// 刷新当前网页或加载initializedURL
- (void)reload;
- (NSURL *)currentURL;

/**
 * Indicates webView loading state.
 */
@property (nonatomic, getter = isLoading, readonly) BOOL loading;
/**
 * Indicates the coming loading is the first loading.
 */
@property (nonatomic, readonly, getter = isFirstLoading) BOOL firstLoading;

/// =============================================
/// @name Configurations
/// =============================================

/// Default is [ESApp sharedApp].userAgentForWebView, set to nil to use the system default user agent for UIWebView.
/// @warning It can only be set before the first loading.
@property (nonatomic, copy) NSString *requestUserAgent;
/// Custom scheme used to communicate to ObjC. Default is nil.
@property (nonatomic, copy) NSString *customScheme;
/// Default is YES, uses `SKStoreProductViewController` to open iTunes links like https//itunes.apple.com/xx/idxxxx
/// @warning It can only be set before the first loading.
@property (nonatomic, getter = isInAppStoreEnabled) BOOL inAppStoreEnabled;
/// Default is NO.
/// @warning It can only be set before view loaded.
@property (nonatomic, getter = isJSBridgeEnabled) BOOL JSBridgeEnabled;

/// Default is YES. Use AFNetworkActivityIndicatorManager to show or hide network activity indicator.
@property (nonatomic, getter = isNetworkActivityIndicatorEnabeld) BOOL networkActivityIndicatorEnabeld;
/// Default is NO
@property (nonatomic, getter = isActivityOverlayEnabeld) BOOL activityOverlayEnabeld;
/// Default is NO
@property (nonatomic) BOOL showsErrorViewWhenLoadingFailed;
/// Default is YES
@property (nonatomic) BOOL showsPageTitle;
/// Default is YES
@property (nonatomic) BOOL showsRefreshControl;
/// Default is 60.0
@property (nonatomic) NSTimeInterval requestTimeoutInterval;
/// Default is NSURLRequestUseProtocolCachePolicy
@property (nonatomic) NSURLRequestCachePolicy requestCachePolicy;
/// Default is YES：如果当前是因为网络错误导致的加载失败了的网页，网络正常后是否自动刷新
@property (nonatomic) BOOL automaticallyReloadWhenNetworkBecomesReachable;

/// =============================================
/// @name Properties
/// =============================================

@property (nonatomic, weak) id<ACWebViewControllerDelegate> __weak delegate; // default is self
@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, strong, readonly) WebViewJavascriptBridge *JSBridge;
@property (nonatomic, strong) ESRefreshControl *refreshControl;
@property (nonatomic, strong) UIView *activityOverlay;
@property (nonatomic, strong) UIView *errorView;

@property (nonatomic, copy, readonly) NSURL *initializationURL;
@property (nonatomic, copy) NSString *initializationTitle;
@property (nonatomic, copy, readonly) NSString *currentPageTitle;
/// Indicates the current loading failed because that network was not reachable.
@property (nonatomic, readonly) BOOL currentLoadingErrorIsLocalNetworkError;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helper

@interface ACWebViewController (Helper)

/**
 * Shows or hides the network activity indicator.
 */
- (void)setNetworkActivityIndicatorVisible:(BOOL)visible;

/**
 * Shows or hides the activity overlay if `isActivityOverlayEnabeld` is YES.
 */
- (void)setActivityOverlayVisible:(BOOL)visible;

/**
 * Shows error view, use tag to ientifier this error view.
 */
- (UIView *)showErrorViewWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image tag:(NSInteger)tag actionButtonTitle:(NSString *)actionButtonTitle actionButtonHandle:(ESUIControlHandler)actionButtonHandler;

/**
 * Shows error view for webview loading failure, with a "Refresh" action button, with tag 1.
 */
- (UIView *)showErrorViewForLoadingFailedWithTitle:(NSString *)title;

/**
 * Hides error view if there is one.
 */
- (void)hideErrorView;

/**
 * Creates or remove refresh control according self.showsRefreshControl
 */
- (void)checkRefreshControl;

/**
 * Returns a request for loading.
 */
- (NSURLRequest *)requestWithURL:(NSURL *)URL;

/**
 * Indicated whether use openURL: or load normal webView request.
 */
- (BOOL)shouldOpenURL:(NSURL *)URL;

/**
 * Open URL via `+[ESApp openURL]`.
 *
 * @param closeMe if YES, it will call `-[self closeMeAnimated:]` before openURL
 */
- (void)openURL:(NSURL *)URL closeMe:(BOOL)closeMe;

/**
 * Open in-app store (SKStoreProductViewController) via ESStoreProductViewControllerManager.
 */
- (void)openInAppStoreWithItemURL:(NSURL *)itemURL closeMe:(BOOL)closeMe;

/**
 * Dismisses or pop this ACWebViewController instance.
 */
- (void)closeMeAnimated:(BOOL)animated;

/**
 * Handles webview loading failure.
 */
- (void)handleWebViewLoadingFailure:(UIWebView *)webView error:(NSError *)error failingURL:(NSURL *)failingURL;

@end
