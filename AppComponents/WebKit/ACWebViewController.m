//
//  ACWebViewController.m
//  AppComponents
//
//  Created by Elf Sundae on 16/1/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ACWebViewController+Subclassing.h"
#import <AppComponents/AppComponentsApp.h>

NSString *const ACWebViewCustomScheme = @"acwebview";
NSString *const ACWebViewImageBrowserJavascriptObjectName = @"ACWebViewImageBrowserJavascriptObject";

@implementation ACWebViewController

- (void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        self.webView.scrollView.refreshControl = nil;
        self.webView.delegate = nil;
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
                [self setupDefaultsConfig];
        }
        return self;
}

- (void)setupDefaultsConfig
{
        _flags.isFirstLoading = YES;
        _flags.shouldLoadOnViewAppeared = YES;
        _flags.loadFileURLOnViewLoaded = YES;
        
        self.networkActivityIndicatorEnabeld = YES;
        self.activityOverlayEnabeld = NO;
        self.showsErrorViewWhenFailedLoading = NO;
        self.showsPageTitle = YES;
        self.showsRefreshControl = YES;
        self.requestTimeoutInterval = 60.0;
        self.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        self.automaticallyReloadWhenNetworkBecomesReachable = YES;
        self.requestUserAgent = [ESApp sharedApp].userAgentForWebView;
        self.inAppStoreEnabled = YES;
        self.JSBridgeEnabled = YES;
        self.imageBrowserEnabled = YES;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.view.backgroundColor = [UIColor colorWithWhite:0.980 alpha:1.000];
        self.navigationItem.title = self.initializationTitle;
        
        _webView = [self createWebView];
        NSAssert(!!self.webView, @"-createWebView returns nil.");
        if (self.webView.superview != self.view) {
                [self.webView.superview removeFromSuperview];
        }
        [self.view addSubview:self.webView];
        self.webView.delegate = self;
        
        // Create refreshControl if needed.
        [self checkRefreshControl];
        
        // Create JSBridge if needed.
        if (self.isJSBridgeEnabled) {
                _JSBridge = [self createJSBridgeForWebView:self.webView];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityDidChangeNotification:) name:ESNetworkReachabilityDidChangeNotification object:nil];
        
        // 如果是本地网页,就在viewDidLoad中加载，这样一进入WebViewController就能看见网页内容.
        // 否则在viewDidAppear中加载, 让WebViewController先展示出来。
        if (_flags.loadFileURLOnViewLoaded && self.initializationURL && self.initializationURL.isFileURL) {
                _flags.shouldLoadOnViewAppeared = NO;
                [self reload];
        }
}

- (void)viewWillLayoutSubviews
{
        [super viewWillLayoutSubviews];
        self.webView.frame = self.view.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
        if (!self.navigationController.navigationBar.barTintColor ||
            self.navigationController.navigationBar.barTintColor.es_isLightColor) {
                return UIStatusBarStyleDefault;
        } else {
                return UIStatusBarStyleLightContent;
        }
}

- (void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
        if (_flags.shouldLoadOnViewAppeared) {
                _flags.shouldLoadOnViewAppeared = NO;
                if (!self.webView.request) {
                        [self reload];
                }
        }
}

- (void)viewWillDisappear:(BOOL)animated
{
        [super viewWillDisappear:animated];
        if (self.isMovingFromParentViewController || self.isBeingDismissed) {
                if (self.webView.isLoading) {
                        self.webView.delegate = nil;
                        [self.webView stopLoading];
                        self.loading = NO; // decrementActivityCount
                }
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Getter & Setter

- (void)setLoading:(BOOL)loading
{
        if (_loading != loading) {
                _loading = loading;
                
                if (self.isNetworkActivityIndicatorEnabeld) {
                        [self showNetworkActivityIndicator:_loading];
                }
                
                if (self.isActivityOverlayEnabeld) {
                        if (_loading) {
                                [self showActivityOverlay];
                        } else {
                                [self hideActivityOverlay];
                        }
                }
        }
}

- (NSURL *)currentURL
{
        return self.webView.request.URL ?: self.initializationURL;
}

- (void)setNetworkActivityIndicatorEnabeld:(BOOL)enabled
{
        if (_networkActivityIndicatorEnabeld != enabled) {
                _networkActivityIndicatorEnabeld = enabled;
                // 确保ActivityCount数目平衡
                if (self.isLoading) {
                        [self showNetworkActivityIndicator:_networkActivityIndicatorEnabeld];
                }
        }
}

- (void)setActivityOverlayEnabeld:(BOOL)enabled
{
        _activityOverlayEnabeld = enabled;
        if (!_activityOverlayEnabeld) {
                [self hideActivityOverlay];
        }
}

- (void)setShowsErrorViewWhenFailedLoading:(BOOL)shows
{
        _showsErrorViewWhenFailedLoading = shows;
        if (!_showsErrorViewWhenFailedLoading) {
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

- (void)setRequestUserAgent:(NSString *)userAgent
{
        // UIWebView貌似会缓存通过registerDefaults方式注册的UserAgent，
        // 一旦请求过一次后，再更改UserAgent是无效的，除非重新创建WebView
        // TODO: 以后有空可研究下如何实时更新UseAgent, https://www.cocoanetics.com/2012/06/radar-allow-overriding-of-user-agent-on-uiwebview/
        if (_flags.isFirstLoading && !self.webView.request) {
                _requestUserAgent = userAgent;
                [NSUserDefaults replaceRegisteredObject:userAgent forKey:@"UserAgent"];
        }
}

- (void)setInAppStoreEnabled:(BOOL)inAppStoreEnabled
{
        if (_flags.isFirstLoading && !self.webView.request) {
                _inAppStoreEnabled = inAppStoreEnabled;
        }
}

- (void)setJSBridgeEnabled:(BOOL)value
{
        if (_flags.isFirstLoading && !self.webView.request) {
                _JSBridgeEnabled = value;
        }
}

- (void)setImageBrowserEnabled:(BOOL)value
{
        if (_flags.isFirstLoading && !self.webView.request) {
                if (!value) {
                        _imageBrowserEnabled = NO;
                }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                else if ([ESApp instancesRespondToSelector:@selector(imageViewControler)]) {
                        _imageBrowserEnabled = YES;
                }
#pragma clang diagnostic pop
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
        [self.webView.scrollView.refreshControl endRefreshing];
        [self hideErrorView];
        
        if (self.webView.request && self.webView.request.URL && !self.webView.request.URL.absoluteString.isEmpty) {
                [self.webView reload];
        } else if (self.initializationURL) {
                [self loadURL:self.initializationURL];
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
        _flags.currentLoadingErrorIsLocalNetworkError = NO;
        
        BOOL result = [self handleWebView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
        if (!result) {
                _flags.isFirstLoading = NO;
        }
        return result;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
        self.loading = YES;
        ++_numberOfRequest;
        
        [self handleWebViewDidStartLoad:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
        self.loading = NO;
        --_numberOfRequest;
        
        if (0 == _numberOfRequest && self.isImageBrowserEnabled) {
                [self injectJavascriptForOpenningImageLink:webView];
        }
        
        [self handleWebViewDidFinishLoad:webView];
        _flags.isFirstLoading = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
        self.loading = NO;
        --_numberOfRequest;
        
        if (error.isLocalNetworkError) {
                _flags.currentLoadingErrorIsLocalNetworkError = YES;
        }
        
        [self handleWebView:webView didFailLoadWithError:error isFirstLoading:_flags.isFirstLoading];
        _flags.isFirstLoading = NO;
}

@end
