//
//  HWFDocumentWebViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/11/10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDocumentWebViewController.h"

@interface HWFDocumentWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (strong, nonatomic) NSURLRequest *webRequest;

@end

@implementation HWFDocumentWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // View
    [self addBackBarButtonItem];
    
    // Content WebView
    self.contentWebView.scalesPageToFit = YES;
    self.contentWebView.delegate = self;
    
    // Load
    self.webRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:REQUEST_TIMEOUT_INTERVAL];
    @try {
        [self.contentWebView loadRequest:self.webRequest];
    }
    @catch (NSException *exception) {
        DDLogWarn(@"DocumentWebView:%@", exception);
    }
    @finally {
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [self loadingViewShow];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self loadingViewShow];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self loadingViewAllHide];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self loadingViewAllHide];
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
