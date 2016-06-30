//
//  HWFLoginFaiedlViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-11-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFLoginFaiedlViewController.h"
#import "HWFWebViewController.h"
#import "HWFAPIFactory.h"

@interface HWFLoginFaiedlViewController ()
@property (weak, nonatomic) IBOutlet UILabel *loginFailedLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *backgroundBtn;

@end

@implementation HWFLoginFaiedlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    self.title = @"HiWiFi未知";
    [self addBackBarButtonItem];
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"btn1"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    UIImage *highbackgroundImage = [[UIImage imageNamed:@"btn3"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self.backgroundBtn setTitle:@"进入路由器后台" forState:UIControlStateNormal];
    [self.backgroundBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [self.backgroundBtn setBackgroundImage:highbackgroundImage forState:UIControlStateHighlighted];
    
}

#pragma mark - 进入路由器后台
- (IBAction)pushBackgroundAction:(UIButton *)sender {
    //路由器后台管理WEB
    HWFWebViewController *webAdminWebViewController = [[HWFWebViewController alloc] initWithNibName:@"HWFWebViewController" bundle:nil];
    webAdminWebViewController.HTTPMethod = HTTPMethodGet;
    webAdminWebViewController.URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_WEB_WEBADMIN];
    [self.navigationController pushViewController:webAdminWebViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
