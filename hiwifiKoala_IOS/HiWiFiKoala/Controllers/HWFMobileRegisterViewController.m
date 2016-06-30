//
//  HWFMobileRegisterViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFMobileRegisterViewController.h"
#import "HWFVerifyViewController.h"
#import "HWFService+User.h"
#import "HWFTool.h"

@interface HWFMobileRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation HWFMobileRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    self.phoneNumberTextField.placeholder = @"手机号";
    self.tipLabel.text = @"请输入11位手机号";
    self.tipLabel.textColor = COLOR_HEX(0x999999);
    if ([self.mobileOrPwdIdentify isEqualToString:@"mobile"]) {
        self.title = @"注册";
    } else if ([self.mobileOrPwdIdentify isEqualToString:@"password"]) {
        self.title = @"找回密码";
    }
  
    [self addBackBarButtonItem];
    [self addRightBarButtonItemWithImage:nil activeImage:nil title:@"下一步" target:self action:@selector(nextAction:)];
}

//下一步
- (void)nextAction:(UIButton *)button {
    if ([self.mobileOrPwdIdentify isEqualToString:@"mobile"]) {
        HWFVerifyViewController *verifyVC = [[HWFVerifyViewController alloc]initWithNibName:@"HWFVerifyViewController" bundle:nil];
        verifyVC.myIdentifier = @"registerVerify";
        verifyVC.acceptPhoneNum = self.phoneNumberTextField.text;
        if ([HWFTool isMobile:self.phoneNumberTextField.text]) {
            [self loadingViewShow];
            [[HWFService defaultService] sendVerifyCodeWithMobile:self.phoneNumberTextField.text completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self loadingViewHide];
                if (code == CODE_SUCCESS) {
                    
                } else {
                    [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
                }
                [self.navigationController pushViewController:verifyVC animated:YES];
            }];
        } else {
            [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"请输入正确的手机号"];
        }
        
    } else if ([self.mobileOrPwdIdentify isEqualToString:@"password"]) {
        HWFVerifyViewController *verifyVC = [[HWFVerifyViewController alloc]initWithNibName:@"HWFVerifyViewController" bundle:nil];
        verifyVC.myIdentifier = @"foundPwdVerify";
        verifyVC.acceptPhoneNum = self.phoneNumberTextField.text;
        if ([HWFTool isMobile:self.phoneNumberTextField.text]) {
            [self loadingViewShow];
            [[HWFService defaultService] sendVerifyCodeWithMobile:self.phoneNumberTextField.text completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self loadingViewHide];
                if (code == CODE_SUCCESS) {

                } else {
                    [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
                }
                [self.navigationController pushViewController:verifyVC animated:YES];
            }];
        } else {
            [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"请输入正确的手机号"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
