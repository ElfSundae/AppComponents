//
//  ACWebViewController.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACWebViewController+Private.h"
#import <ESFramework/ESNetworkReachability.h>

@implementation ACWebViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.refreshControl = nil;
}

- (instancetype)initWithURL:(NSURL *)URL
{
    return [self initWithURL:URL title:nil];
}

- (instancetype)initWithURL:(NSURL *)URL title:(NSString *)title
{
    self = [super init];
    if (self) {
        _initializationURL = ESURLValue(URL);
        _initializationTitle = title;
        _storedAFNetworkActivityIndicatorManagerEnabled = [self _getAFNetworkActivityIndicatorManagerEnabled];
        _storedUserAgent = [NSUserDefaults registeredDefaults][@"UserAgent"];
        _delegate = self;

        _firstLoading = YES;
        _shouldLoadOnViewAppeared = YES;
        _loadLocalFileURLOnViewDidLoad = YES;

        self.requestUserAgent = [ESApp sharedApp].userAgentForWebView;
        self.inAppStoreEnabled = YES;
        self.JSBridgeEnabled = NO;

        self.networkActivityIndicatorEnabeld = YES;
        self.activityOverlayEnabeld = NO;
        self.showsErrorViewWhenLoadingFailed = NO;
        self.showsPageTitle = YES;
        self.showsRefreshControl = YES;
        self.requestTimeoutInterval = 60.0;
        self.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        self.automaticallyReloadWhenNetworkBecomesReachable = YES;
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _webView.scalesPageToFit = YES;
    _webView.allowsInlineMediaPlayback = YES;
    _webView.mediaPlaybackRequiresUserAction = NO;
    _webView.keyboardDisplayRequiresUserAction = NO;
    // Fixed issue: UIWebView will appear a blank area on bottom, because of webview.scrollView.contentInset.top
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scrollView.backgroundColor = self.view.backgroundColor;
    _webView.scrollView.delaysContentTouches = NO;
    _webView.delegate = self;
    [self.view addSubview:_webView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.initializationTitle;

    // Create refreshControl if needed.
    [self checkRefreshControl];

    // Create JSBridge if needed.
    if (self.isJSBridgeEnabled) {
        _JSBridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
        [self.JSBridge setWebViewDelegate:self];
        ESWeakSelf;
        [self.JSBridge registerHandler:ACWebViewJSBridgeDefaultHandlerName handler:^(id data, WVJBResponseCallback responseCallback) {
            ESStrongSelf;
            if (_self.delegate && [_self.delegate respondsToSelector:@selector(webViewController:JSBridgeDefaultHandlerWithData:responseCallback:)]) {
                [_self.delegate webViewController:_self JSBridgeDefaultHandlerWithData:data responseCallback:responseCallback];
            }
        }];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_networkReachabilityDidChangeNotification:) name:ESNetworkReachabilityStatusDidChangeNotification object:nil];

    // 如果是本地网页,就在viewDidLoad中加载，这样一进入WebViewController就能看见网页内容.
    // 否则在viewDidAppear中加载, 让WebViewController先展示出来。
    if (_loadLocalFileURLOnViewDidLoad && [self.initializationURL isFileURL]) {
        _shouldLoadOnViewAppeared = NO;
        [self reload];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_shouldLoadOnViewAppeared) {
        _shouldLoadOnViewAppeared = NO;
        if (!self.webView.request) {
            [self reload];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isBeingDismissed || self.isMovingFromParentViewController ||
        self.navigationController.isBeingDismissed || self.navigationController.isMovingFromParentViewController)
    {
        if (self.isNetworkActivityIndicatorEnabeld) {
            [self setNetworkActivityIndicatorVisible:NO];
        }
        [self _setAFNetworkActivityIndicatorManagerEnabled:_storedAFNetworkActivityIndicatorManagerEnabled];
        [NSUserDefaults replaceRegisteredObject:_storedUserAgent forKey:@"UserAgent"];

        if (self.webView.isLoading) {
            self.webView.delegate = nil;
            [self.webView stopLoading];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIColor *barTintColor = (self.navigationController.navigationBar.barTintColor ?: [UINavigationBar appearance].barTintColor);
    if (!barTintColor || barTintColor.es_isLightColor) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Getter & Setter

- (void)setRequestUserAgent:(NSString *)userAgent
{
    // UIWebView貌似会缓存通过registerDefaults方式注册的UserAgent，
    // 一旦请求过一次后，再更改UserAgent是无效的，除非重新创建WebView
    // TODO: 以后有空可研究下如何实时更新UseAgent, https://www.cocoanetics.com/2012/06/radar-allow-overriding-of-user-agent-on-uiwebview/
    if (self.isFirstLoading && !self.webView.request) {
        _requestUserAgent = userAgent;
        [NSUserDefaults replaceRegisteredObject:userAgent forKey:@"UserAgent"];
    }
}

- (void)setInAppStoreEnabled:(BOOL)inAppStoreEnabled
{
    if (self.isFirstLoading && !self.webView.request) {
        _inAppStoreEnabled = inAppStoreEnabled;
    }
}

- (void)setJSBridgeEnabled:(BOOL)value
{
    if (self.isFirstLoading && !self.isViewLoaded) {
        _JSBridgeEnabled = value;
    }
}

- (void)setNetworkActivityIndicatorEnabeld:(BOOL)enabled
{
    if (enabled == _networkActivityIndicatorEnabeld) {
        return;
    }
    _networkActivityIndicatorEnabeld = enabled;
    if (enabled && ![self _getAFNetworkActivityIndicatorManagerEnabled]) {
        [self _setAFNetworkActivityIndicatorManagerEnabled:YES];
    }
    // 确保ActivityCount数目平衡
    if (self.isLoading) {
        [self setNetworkActivityIndicatorVisible:enabled];
    }
}

- (void)setActivityOverlayEnabeld:(BOOL)enabled
{
    if (enabled == _activityOverlayEnabeld) {
        return;
    }
    _activityOverlayEnabeld = enabled;
    if (self.isLoading) {
        [self setActivityOverlayVisible:enabled];
    }
}

- (void)setshowsErrorViewWhenLoadingFailed:(BOOL)shows
{
    _showsErrorViewWhenLoadingFailed = shows;
    if (!_showsErrorViewWhenLoadingFailed) {
        [self hideErrorView];
    }
}

- (void)setShowsPageTitle:(BOOL)shows
{
    if (shows == _showsPageTitle) {
        return;
    }
    _showsPageTitle = shows;
    if (_showsPageTitle) {
        self.navigationItem.title = self.currentPageTitle;
    } else {
        self.navigationItem.title = self.initializationTitle;
    }
}

- (void)setShowsRefreshControl:(BOOL)shows
{
    if (shows == _showsRefreshControl) {
        return;
    }
    _showsRefreshControl = shows;
    [self checkRefreshControl];
}

- (ESRefreshControl *)refreshControl
{
    return _webView.scrollView.refreshControl;
}

- (void)setRefreshControl:(ESRefreshControl *)refreshControl
{
    _webView.scrollView.refreshControl = refreshControl;
}

- (void)setActivityOverlay:(UIView *)view
{
    if (view != _activityOverlay) {
        if (_activityOverlay) {
            [_activityOverlay removeFromSuperview];
        }
        _activityOverlay = view;
    }
}

- (void)setLoading:(BOOL)loading
{
    if (_loading != loading) {
        _loading = loading;

        if (self.isNetworkActivityIndicatorEnabeld) {
            [self setNetworkActivityIndicatorVisible:_loading];
        }
        [self setActivityOverlayVisible:_loading];
    }

    [self.webView.scrollView.refreshControl endRefreshing];
    [self hideErrorView];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notification Handlers

- (void)_networkReachabilityDidChangeNotification:(NSNotification *)notification
{
    if ([ESNetworkReachability defaultReachability].isReachable &&
        _currentLoadingErrorIsLocalNetworkError &&
        self.automaticallyReloadWhenNetworkBecomesReachable)
    {
        [self reload];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public Methods

- (void)loadURL:(NSURL *)URL
{
    NSURLRequest *request = [self requestWithURL:URL];
    if (request) {
        [self.webView loadRequest:request];
    }
}

- (void)stopLoading
{
    [self.webView stopLoading];
}

- (void)reload
{
    self.loading = NO;

    if (self.webView.request.URL.absoluteString.length) {
        [self.webView reload];
    } else if (self.initializationURL) {
        [self loadURL:self.initializationURL];
    }
}

- (NSURL *)currentURL
{
    return self.webView.request.URL.absoluteString.length ? self.webView.request.URL : self.initializationURL;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    _currentLoadingErrorIsLocalNetworkError = NO;

    if ([request.URL.scheme isEqualToStringCaseInsensitive:kCustomProtocolScheme]) {
        // JSBridge
        return NO;
    } else if ([self.customScheme isKindOfClass:[NSString class]] && [request.URL.scheme isEqualToStringCaseInsensitive:self.customScheme]) {
        // Custom scheme
        if (self.delegate && [self.delegate respondsToSelector:@selector(webViewController:handleCustomScheme:request:navigationType:)]) {
            [self.delegate webViewController:self handleCustomScheme:webView request:request navigationType:navigationType];
        }
        return NO;
    }

    // iTunes download link
    if ([ESStoreHelper itemIDFromURL:request.URL]) {
        if ([request.URL.scheme.lowercaseString hasPrefix:@"http"]) {
            if (self.isInAppStoreEnabled) {
                [self openInAppStoreWithItemURL:request.URL closeMe:self.isFirstLoading];
                return NO;
            }
        }
        // openURL for "itms-app"
        [self openURL:request.URL closeMe:self.isFirstLoading];
        return NO;
    }

    // [UIApplication openURL:]
    if ([self shouldOpenURL:request.URL] && [[UIApplication sharedApplication] canOpenURL:request.URL]) {
        [self openURL:request.URL closeMe:self.isFirstLoading];
        return NO;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewController:webView:shouldStartLoadWithRequest:navigationType:)]) {
        BOOL shouldStart = [self.delegate webViewController:self webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
        if (!shouldStart) {
            _firstLoading = NO;
            return NO;
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.loading = YES;

    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewController:webViewDidStartLoad:)]) {
        [self.delegate webViewController:self webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loading = NO;

    _currentPageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (self.showsPageTitle) {
        self.navigationItem.title = self.currentPageTitle;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewController:webViewDidFinishLoad:)]) {
        [self.delegate webViewController:self webViewDidFinishLoad:webView];
    }

    _firstLoading = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.loading = NO;

    if (error.isLocalNetworkError) {
        _currentLoadingErrorIsLocalNetworkError = YES;
    }
    if (self.showsPageTitle) {
        self.navigationItem.title = nil;
    }

    [self handleWebViewLoadingFailure:webView error:error failingURL:error.userInfo[NSURLErrorFailingURLErrorKey]];

    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewController:webView:didFailLoadWithError:)]) {
        [self.delegate webViewController:self webView:webView didFailLoadWithError:error];
    }

    _firstLoading = NO;
}

@end
