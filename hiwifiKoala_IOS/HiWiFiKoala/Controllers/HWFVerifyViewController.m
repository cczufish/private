//
//  HWFVerifyViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-9-28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFVerifyViewController.h"
#import "HWFInfoPerfectViewController.h"
#import "HWFPwdFoundedViewController.h"
#import "HWFService+User.h"

@interface HWFVerifyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *gainVerifyButton;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation HWFVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}

- (void)initView {
    //title
    if ([self.myIdentifier isEqualToString:@"registerVerify"]) {
        self.title = @"注册";
        [self.gainVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        
    } else if ([self.myIdentifier isEqualToString:@"foundPwdVerify"]) {
        self.title = @"找回密码";
        [self.gainVerifyButton setTitle:@"重新获取" forState:UIControlStateNormal];
    }
    
    //文案
    self.verifyTextField.placeholder = @"请输入验证码";
    NSString *string = [NSString stringWithFormat:@"已经发送 验证码短信 到 %@ 还需要 10 秒 才能重新获取验证码",self.acceptPhoneNum];
    NSMutableAttributedString *mulAttString = [[NSMutableAttributedString alloc]initWithString:string];
    [mulAttString setAttributes:@{NSForegroundColorAttributeName: COLOR_HEX(0x30b0f8)} range:NSMakeRange(12, 13)];
    self.infoLabel.attributedText = mulAttString;
    [self.gainVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [self addBackBarButtonItem];
    [self addRightBarButtonItemWithImage:nil activeImage:nil title:@"下一步" target:self action:@selector(nextAction:)];
}

//下一步
- (void)nextAction:(UIButton *)button {
    if ([self.myIdentifier isEqualToString:@"registerVerify"]) {
        HWFInfoPerfectViewController *infoPerfectVC = [[HWFInfoPerfectViewController alloc]initWithNibName:@"HWFInfoPerfectViewController" bundle:nil];
        infoPerfectVC.acceptPhoneNum = self.acceptPhoneNum;
        [self loadingViewShow];
        [[HWFService defaultService]registerWithMobile:self.acceptPhoneNum verifyCode:self.verifyTextField.text completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            [self loadingViewHide];
            if (code == CODE_SUCCESS) {
                [self.navigationController pushViewController:infoPerfectVC animated:YES];
            } else {
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
        }];
    } else if ([self.myIdentifier isEqualToString:@"foundPwdVerify"]) {
        HWFPwdFoundedViewController *pwdFoundedVC = [[HWFPwdFoundedViewController alloc]initWithNibName:@"HWFPwdFoundedViewController" bundle:nil];
        pwdFoundedVC.acceptPhoneNum = self.acceptPhoneNum;
        pwdFoundedVC.acceptCodeIndetifier = self.verifyTextField.text;
        [self loadingViewShow];
        [[HWFService defaultService]resetUserPasswordWithMobile:self.acceptPhoneNum verifyCode:self.verifyTextField.text completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            [self loadingViewHide];
            if (code == CODE_SUCCESS) {
                [self.navigationController pushViewController:pwdFoundedVC animated:YES];
            } else {
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
        }];
    }
}

//获取验证码
- (IBAction)gainVerifyAction:(UIButton *)sender {
    [self loadingViewShow];
    [[HWFService defaultService] sendVerifyCodeWithMobile:self.acceptPhoneNum completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {

        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
