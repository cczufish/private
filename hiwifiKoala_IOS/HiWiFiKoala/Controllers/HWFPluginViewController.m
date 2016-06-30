//
//  HWFPluginViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFPluginViewController.h"

#import "HWFPlugin.h"

#import "HWFService+Plugin.h"

#import "HWFPluginConfigViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface HWFPluginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *operatingButton;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (assign, nonatomic) NSInteger pluginInstalledStatus; // 插件安装状态 -1:安装中 0:未安装 1:已安装
@property (assign, nonatomic) NSUInteger installStatusCheckCount; // 安装状态查询轮询次数

@end

@implementation HWFPluginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Title
    self.title = self.plugin.name;
    
    // Back Button
    [self addBackBarButtonItem];
    
    // setup
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    [self loadingViewShow];
    [[HWFService defaultService] loadPluginDetailWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] plugin:self.plugin completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        
        if (CODE_SUCCESS == code) {
            NSDictionary *pluginInfoDict = data[@"data"];
            
            // Brief
            NSString *developer = pluginInfoDict[@"developer"] ?: @"";
            NSString *version = pluginInfoDict[@"version"] ?: @"";
            NSString *releaseDate = pluginInfoDict[@"datetime"] ?: @"";
            NSMutableAttributedString *briefAttributedString = [[NSMutableAttributedString alloc] initWithString:@"开发者/版本/时间：" attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName : [UIColor blackColor] }];
            [briefAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@/%@", developer, version, releaseDate] attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName : COLOR_HEX(0x999999) }]];
            self.briefLabel.attributedText = briefAttributedString;
            
            // Info
            self.infoLabel.text = pluginInfoDict[@"description"] ?: @"";
            
            // Button
            self.pluginInstalledStatus = [pluginInfoDict[@"installed"] integerValue];
            [self refreshOperationButtonStatus];
            
            // Status Message
            [self.statusButton setBackgroundImage:[[UIImage imageNamed:@"app-tip"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:8.0] forState:UIControlStateNormal];
            [self.statusButton setBackgroundImage:[[UIImage imageNamed:@"app-tip"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:8.0] forState:UIControlStateHighlighted];
            self.statusButton.hidden = ![pluginInfoDict[@"is_third_party"] boolValue];
        }
    }];
}

// 根据pluginInstalledStatus刷新按钮状态
- (void)refreshOperationButtonStatus {
    if (self.pluginInstalledStatus == 0) { // 未安装
        [self.operatingButton setTitle:@"安装" forState:UIControlStateNormal];
        [self.operatingButton setBackgroundImage:[[UIImage imageNamed:@"btn-4"] stretchableImageWithLeftCapWidth:23.0 topCapHeight:23.0] forState:UIControlStateNormal];
        [self.operatingButton setBackgroundImage:[[UIImage imageNamed:@"btn-1"] stretchableImageWithLeftCapWidth:23.0 topCapHeight:23.0] forState:UIControlStateHighlighted];
    } else if (self.pluginInstalledStatus == 1) { // 已安装
        [self.operatingButton setTitle:@"打开" forState:UIControlStateNormal];
        [self.operatingButton setBackgroundImage:[[UIImage imageNamed:@"btn-4"] stretchableImageWithLeftCapWidth:23.0 topCapHeight:23.0] forState:UIControlStateNormal];
        [self.operatingButton setBackgroundImage:[[UIImage imageNamed:@"btn-1"] stretchableImageWithLeftCapWidth:23.0 topCapHeight:23.0] forState:UIControlStateHighlighted];
    } else if (self.pluginInstalledStatus == -1) { // 安装中
        [self.operatingButton setTitle:@"安装中..." forState:UIControlStateNormal];
        [self.operatingButton setBackgroundImage:[[UIImage imageNamed:@"btn-1"] stretchableImageWithLeftCapWidth:23.0 topCapHeight:23.0] forState:UIControlStateNormal];
        [self.operatingButton setBackgroundImage:[[UIImage imageNamed:@"btn-1"] stretchableImageWithLeftCapWidth:23.0 topCapHeight:23.0] forState:UIControlStateHighlighted];
    }
}

// 轮询取安装结果
- (void)loadInstallResultWithTaskID:(NSString *)taskID {
    [[HWFService defaultService] loadPluginOperatingStatusWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] taskID:taskID completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        
        if (CODE_SUCCESS == code) {
            self.pluginInstalledStatus = 1; // 已安装
            [self refreshOperationButtonStatus];
            [self showTipWithType:HWFTipTypeSuccess code:code message:@"安装成功"];
        } else if (2004605 == code) { // 安装中...，3S后重新查询状态
            self.installStatusCheckCount++;
            if (self.installStatusCheckCount < 10) {
                [self performSelector:@selector(loadInstallResultWithTaskID:) withObject:taskID afterDelay:3.0];
            } else {
                [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"感谢您的等待，极路由将在后台继续努力为您安装，请稍后查看"];
            }
        } else {
            self.pluginInstalledStatus = 0; // 未安装
            [self refreshOperationButtonStatus];
            
            [self showTipWithType:HWFTipTypeFailure code:code message:msg];
        }
        
    }];
}

- (IBAction)operate:(UIButton *)sender {
    if (self.pluginInstalledStatus == 0) { // 未安装->安装
        
        [self loadingViewShow];
        [[HWFService defaultService] installPluginWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] plugin:self.plugin completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            [self loadingViewHide];
            
            if (CODE_SUCCESS == code) {
                self.pluginInstalledStatus = -1; // 安装中
                [self refreshOperationButtonStatus];
                
                // 轮询
                NSString *taskID = data[@"data"][@"taskid"];
                self.installStatusCheckCount = 0; // 重置计数
                [self performSelector:@selector(loadInstallResultWithTaskID:) withObject:taskID afterDelay:3.0];
            } else {
                [self showTipWithType:HWFTipTypeMessage code:code message:msg];
            }
        }];
    } else if (self.pluginInstalledStatus == 1) { // 已安装->打开
        HWFPluginConfigViewController *pluginConfigViewController = [[HWFPluginConfigViewController alloc] initWithNibName:@"HWFWebViewController" bundle:nil];
        pluginConfigViewController.plugin = self.plugin;
        [self.navigationController pushViewController:pluginConfigViewController animated:YES];
    }
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
