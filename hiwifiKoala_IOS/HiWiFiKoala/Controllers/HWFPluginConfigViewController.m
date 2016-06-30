//
//  HWFPluginConfigViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/27.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFPluginConfigViewController.h"

#import "HWFPlugin.h"
#import "HWFService+Plugin.h"

@interface HWFPluginConfigViewController ()

@end

@implementation HWFPluginConfigViewController

- (void)viewDidLoad {
    if (self.plugin.canUninstall) { // 插件可卸载
        [self addRightBarButtonItemWithImage:[UIImage imageNamed:@"close"] activeImage:[UIImage imageNamed:@"colse-s"] title:nil target:self action:@selector(pluginUninstall:)];
    }
    
    if (!self.URL) {
        self.URL = self.plugin.configURL;
    }
    
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 插件卸载
- (void)pluginUninstall:(id)sender {
    [self loadingViewShow];
    [[HWFService defaultService] uninstallPluginWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] plugin:self.plugin completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        
        if (CODE_SUCCESS == code) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showTipWithType:HWFTipTypeFailure code:code message:msg];
        }
    }];
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
