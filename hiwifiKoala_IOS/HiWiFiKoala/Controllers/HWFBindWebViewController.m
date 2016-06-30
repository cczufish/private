//
//  HWFBindWebViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-11-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFBindWebViewController.h"

@interface HWFBindWebViewController ()

@end

@implementation HWFBindWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
}

- (void)initView {
    
}

#pragma mark - 重写父类方法
- (BOOL)hwf_webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"1=======%d",navigationType);
    NSLog(@"2=======%@",[request URL]);
    NSLog(@"3=======%@",request);
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeFormSubmitted || navigationType == UIWebViewNavigationTypeOther) {
        NSString *url = [NSString stringWithFormat:@"%@",[request URL]];
        if ([url hasPrefix:@"app://callback"]) {
            NSMutableDictionary *paramDict = [self splitParamWithURL:url];
            NSString *action = [paramDict objectForKey:@"action"];
            NSLog(@"======%@",paramDict);
            NSLog(@"++++++%@",action);
            
            if (action && [action isEqualToString:@"client_bind"]) {//绑定路由器
                NSInteger code = [paramDict objectForKey:@"code"] ? [[paramDict objectForKey:@"code"] integerValue] : -1;
                if (code == -1) {
                    return YES;
                } else if (code == 415){
                    NSString *msg = [paramDict objectForKey:@"msg"] ? [paramDict objectForKey:@"msg"] : nil;
                    NSRange range = [msg rangeOfString:@"("];
                    NSString *tempName = [msg substringFromIndex:range.location + 1];
                    NSString *name = [tempName substringToIndex:[tempName length] - 1];
                    NSString *res = [NSString stringWithFormat:@"路由器已被 %@ 绑定", [name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    [self showTipWithType:HWFTipTypeError code:code message:res];
                    [self doClose];
                } else if (code == 414) {
                    NSString *msg = [paramDict objectForKey:@"msg"] ? [paramDict objectForKey:@"msg"] : nil;
                    NSRange range = [msg rangeOfString:@"("];
                    NSString *tempName = [msg substringFromIndex:range.location + 1];
                    NSString *name = [tempName substringToIndex:[tempName length] - 1];
                    NSString *res = [NSString stringWithFormat:@"用户已经绑定%@台路由器，无法再绑定", [name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    [self showTipWithType:HWFTipTypeError code:code message:res];
                    [self doClose];
                } else if (code == 0){
                    if (self.delegate && [self.delegate respondsToSelector:@selector(bindRouterSuccessCallbackWithMAC:)]) {
                        [self.delegate performSelector:@selector(bindRouterSuccessCallbackWithMAC:) withObject:[paramDict objectForKey:@"mac"]];
                    }
                    [self doClose];
                } else if (code == 416) {// 路由器已被自己绑定
                    if (self.delegate && [self.delegate respondsToSelector:@selector(bindRouterBySelfCallback)]) {
                        [self.delegate performSelector:@selector(bindRouterBySelfCallback) withObject:nil];
                    }
                    [self doClose];
                } else {
                    NSString *msg = [paramDict objectForKey:@"msg"] ? [paramDict objectForKey:@"msg"] : nil;
                    [self showTipWithType:HWFTipTypeError code:code message:msg];
                }
            }
        }
    }
    return YES;
}

- (void)hwf_webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)hwf_webViewDidFinishLoad:(UIWebView *)webView {
    
}
- (void)hwf_webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (NSMutableDictionary *)splitParamWithURL:(NSString *)url
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSString *paramString = [url substringFromIndex:([url rangeOfString:@"?"].location+1)];
    NSArray *params = [paramString componentsSeparatedByString:@"&"];
    for (NSString *param in params) {
        NSArray *paramArray = [param componentsSeparatedByString:@"="];
        [paramDict setObject:[paramArray[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:[paramArray[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    return paramDict;
}

- (void)doClose {
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.navigationController.navigationBarHidden = NO;
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
