//
//  HWFPwdFoundedViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-9-28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFPwdFoundedViewController.h"
#import "HWFService+User.h"

@interface HWFPwdFoundedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pwdFoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel1;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel2;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel3;
@property (weak, nonatomic) IBOutlet UIButton *founAgainBtn;

@end

@implementation HWFPwdFoundedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}

- (void)initView {
    //title
    self.title = @"密码找回";
    
    //文案
    self.pwdFoundLabel.text = @"找回成功 !";
    self.pwdFoundLabel.textColor =  COLOR_HEX(0x333333);
    self.infoLabel1.text = @"验证成功新密码已经以短信形式下发到手机";
    self.infoLabel1.textColor =  COLOR_HEX(0x333333);
    self.infoLabel2.text = self.acceptPhoneNum;
    self.infoLabel2.textColor =  COLOR_HEX(0x30b0f8);
    self.infoLabel3.text = @"短信大致需要等待2分钟";
    self.infoLabel3.textColor =  COLOR_HEX(0x333333);

    [self.founAgainBtn setTitle:@"没有收到？再次找回" forState:UIControlStateNormal];
    
    self.navigationItem.hidesBackButton = YES;
   
    [self addRightBarButtonItemWithImage:nil activeImage:nil title:@"关闭" target:self action:@selector(closeAction:)];
}

- (void)closeAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

//没有收到，再次找回
- (IBAction)foundPwdAgain:(UIButton *)sender {
    [self loadingViewShow];
    [[HWFService defaultService]resetUserPasswordWithMobile:self.acceptPhoneNum verifyCode:self.acceptCodeIndetifier completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {

        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
