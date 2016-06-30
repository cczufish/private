//
//  HWFWebViewController.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/24.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFViewController.h"

typedef NS_ENUM(NSInteger, HTTPMethod) {
    HTTPMethodGet = 0,
    HTTPMethodPost = 1,
};


@interface HWFWebViewController : HWFViewController

@property (strong, nonatomic) NSString *URL;
@property (assign, nonatomic) HTTPMethod HTTPMethod;
@property (strong, nonatomic) NSDictionary *paramDict;

- (BOOL)hwf_webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)hwf_webViewDidStartLoad:(UIWebView *)webView;
- (void)hwf_webViewDidFinishLoad:(UIWebView *)webView;
- (void)hwf_webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end