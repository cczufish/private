//
//  HWFModifyAdminPwdViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-11-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFModifyAdminPwdViewController.h"
#import "HWFService+Router.h"

@interface HWFModifyAdminPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *myNewPwdTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;

@property (weak, nonatomic) IBOutlet UIButton *oldEyeButton;
@property (weak, nonatomic) IBOutlet UIButton *myNewEyeButton;

@property (assign, nonatomic) BOOL oldEyeFlag;
@property (assign, nonatomic) BOOL myNewEyeFlag;


@end

@implementation HWFModifyAdminPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    self.title = @"修改路由器后台密码";
    
    [self addBackBarButtonItem];
    
    self.oldPwdTextField.placeholder = @"旧密码";
    self.myNewPwdTextField.placeholder = @"新密码";
    self.tipLabel.text = @"至少5位，区分大小写";
    [self.commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIImage *commitImage = [[UIImage imageNamed:@"btn1"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    UIImage *highcommitImage = [[UIImage imageNamed:@"btn3"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self.commitButton setBackgroundImage:commitImage forState:UIControlStateNormal];
    [self.commitButton setBackgroundImage:highcommitImage forState:UIControlStateHighlighted];
    
    UIImage *cancleImage = [[UIImage imageNamed:@"btn2"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    UIImage *highcancleImage = [[UIImage imageNamed:@"btn4"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self.cancleButton setBackgroundImage:cancleImage forState:UIControlStateNormal];
    [self.cancleButton setBackgroundImage:highcancleImage forState:UIControlStateHighlighted];
}

#pragma mark - 提交,修改管理员密码
- (IBAction)commitAction:(UIButton *)sender {
    [self loadingViewShow];
    [[HWFService defaultService]modifyRouterPasswordWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] oldPWD:self.oldPwdTextField.text newPWD:self.myNewPwdTextField.text completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            //成功
            [self showTipWithType:HWFTipTypeSuccess code:CODE(data) message:@"密码修改成功"];
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - 取消事件
- (IBAction)cancleAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 旧密码眼睛
- (IBAction)oldEyeAction:(UIButton *)sender {
    NSLog(@"旧密码眼睛");
    self.oldEyeFlag = !self.oldEyeFlag;
    if (self.oldEyeFlag) {
        [self.oldEyeButton setBackgroundImage:[UIImage imageNamed:@"eye-o"] forState:UIControlStateNormal];
        [self.oldPwdTextField setSecureTextEntry:YES];
    } else {
        [self.oldEyeButton setBackgroundImage:[UIImage imageNamed:@"eye-c"] forState:UIControlStateNormal];
        [self.oldPwdTextField setSecureTextEntry:NO];
    }
}

#pragma mark - 新密码眼睛
- (IBAction)eyeNewAction:(UIButton *)sender {
    NSLog(@"新密码眼睛");
    self.myNewEyeFlag = !self.myNewEyeFlag;
    if (self.myNewEyeFlag) {
        [self.myNewEyeButton setBackgroundImage:[UIImage imageNamed:@"eye-o"] forState:UIControlStateNormal];
        [self.myNewPwdTextField setSecureTextEntry:YES];
    } else {
        [self.myNewEyeButton setBackgroundImage:[UIImage imageNamed:@"eye-c"] forState:UIControlStateNormal];
        [self.myNewPwdTextField setSecureTextEntry:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
