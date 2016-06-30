//
//  HWFInfoPerfectViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-9-28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFInfoPerfectViewController.h"
#import "HWFService+User.h"
#import "HWFUser.h"
#import "UIViewExt.h"

@interface HWFInfoPerfectViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *unameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *maskBtn;


@property (weak, nonatomic) IBOutlet UILabel *sexLabel;


//性别是否选择
@property (assign,nonatomic) BOOL isMale;
@property (assign,nonatomic) BOOL isFemale;
@property (weak, nonatomic) IBOutlet UIImageView *maleCheckedImgView;
@property (weak, nonatomic) IBOutlet UIImageView *femaleCheckedImgView;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;

@end

@implementation HWFInfoPerfectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    self.title = @"完善资料";
    self.view.backgroundColor = COLOR_HEX(0xecf5fb);
    self.phoneNumLabel.text = self.acceptPhoneNum;
    self.unameTextField.placeholder = @"用户名，可用于登录";
    self.pwdTextField.placeholder = @"密码";
    [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.sexLabel.text = @"性别";
    
    //没有返回按钮
    self.navigationItem.hidesBackButton = YES;
   
    [self addRightBarButtonItemWithImage:nil activeImage:nil title:@"跳过" target:self action:@selector(skipAction:)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHidenNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    //为了适配，改约束
    NSArray *contraints = self.view.constraints;
    for (NSLayoutConstraint *contraint in contraints) {
        if (contraint.constant == 25 && contraint.firstAttribute == NSLayoutAttributeTop && contraint.secondAttribute ==  NSLayoutAttributeTop ) {
            if (SCREEN_HEIGHT <= 480) {
                contraint.constant = 25;
            } else if (SCREEN_HEIGHT <= 568) {
                contraint.constant = 40;
            } else {
                contraint.constant = 60;
            }
        }
        
    }

}

- (IBAction)maskAction:(UIButton *)sender {
    [self.unameTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
}

- (void)skipAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

//提交
- (IBAction)commitAction:(UIButton *)sender {
    [self loadingViewShow];
    [[HWFService defaultService] perfectInfoWithUser:[HWFUser defaultUser] userInfo:@{@"username":self.unameTextField.text,@"password":self.pwdTextField.text} completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

- (IBAction)selectSexAction:(UIButton *)sender {
    self.isMale = !self.isMale;
    self.isFemale = !self.isFemale;
    switch (sender.tag) {
        case 500:
        {
            if (self.isMale) {
                self.maleCheckedImgView.hidden = NO;
                self.femaleButton.enabled = NO;
                
            } else {
                self.maleCheckedImgView.hidden = YES;
                self.femaleButton.enabled = YES;
            }
            
        }
            break;
        case 600:
        {
            if (self.isFemale) {
                self.femaleCheckedImgView.hidden = NO;
                self.maleButton.enabled = NO;
            } else {
                self.femaleCheckedImgView.hidden = YES;
                self.maleButton.enabled = YES;
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    switch (textField.tag) {
        case 200:
            [self.pwdTextField becomeFirstResponder];
            break;
        case 201:
            [self commitAction:nil];
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - UIKeyboardWillShowNotification ／ UIKeyboardWillHideNotification
- (void)keyboardShowNotification:(NSNotification *)notification {
    [UIView animateWithDuration:0.35 animations:^{
        self.view.top = -80;
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardHidenNotification:(NSNotification *)notification {
    [UIView animateWithDuration:0.35 animations:^{
        self.view.top = 0;
    } completion:^(BOOL finished) {
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
