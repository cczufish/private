//
//  HWFWebViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/24.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFWebViewController.h"

#import <AFNetworking/UIWebView+AFNetworking.h>

@interface HWFWebViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *contentWebView;
@property (strong, nonatomic) NSMutableURLRequest *webRequest;

@end

@implementation HWFWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // View
    [self addBackBarButtonItem];
    
    // Content WebView
    self.contentWebView = [[UIWebView alloc] init];
    [self.view addSubview:self.contentWebView];
    self.contentWebView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.contentWebView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.contentWebView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.contentWebView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.contentWebView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.view addConstraints:@[topConstraint,bottomConstraint,leadingConstraint,trailingConstraint]];
    self.contentWebView.scalesPageToFit = YES;
    self.contentWebView.delegate = self;
    
    // Load
    self.webRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    
    NSMutableData *paramData = [[NSMutableData alloc] init];
    NSArray *paramKeys = [self.paramDict allKeys];
    BOOL headFlag = YES;
    for (NSString *paramkey in paramKeys) {
        if (headFlag) {
            headFlag = NO;
            [paramData appendData:[[NSString stringWithFormat:@"%@=%@", paramkey, [self.paramDict objectForKey:paramkey]] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        } else {
            [paramData appendData:[[NSString stringWithFormat:@"&%@=%@", paramkey, [self.paramDict objectForKey:paramkey]] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        }
    }
    
    switch (self.HTTPMethod) {
        case HTTPMethodPost:
        {
            [self.webRequest setHTTPMethod:@"POST"];
        }
            break;
        case HTTPMethodGet:
        default:
        {
            [self.webRequest setHTTPMethod:@"GET"];
        }
            break;
    }
    
    [self.webRequest setHTTPBody:paramData];

    [self loadingViewShow];
    [self.contentWebView loadRequest:self.webRequest progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        // Nothing.
    } success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
        [self loadingViewHide];
        DDLogInfo(@"WebView Load Success: %@", response);
        return HTML;
    } failure:^(NSError *error) {
        [self loadingViewHide];
        
        DDLogError(@"WebView Load Failed [%ld]: %@", (long)error.code, error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return [self hwf_webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self hwf_webViewDidStartLoad:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Title
    NSString *webTitle = [self.contentWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ((!self.title || IS_STRING_EMPTY(self.title)) && (webTitle && !IS_STRING_EMPTY(webTitle))) {
        self.title = webTitle;
    }
    
    [self hwf_webViewDidFinishLoad:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hwf_webView:webView didFailLoadWithError:error];
}

#pragma mark - Abstract Functions
- (BOOL)hwf_webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    DDLogVerbose(@"To Be Override...");
    return YES;
}

- (void)hwf_webViewDidStartLoad:(UIWebView *)webView {
    DDLogVerbose(@"To Be Override...");
}

- (void)hwf_webViewDidFinishLoad:(UIWebView *)webView {
    DDLogVerbose(@"To Be Override...");
}

- (void)hwf_webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DDLogVerbose(@"To Be Override...");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
