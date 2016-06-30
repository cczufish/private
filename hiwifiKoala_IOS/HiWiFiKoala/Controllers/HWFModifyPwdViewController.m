//
//  HWFModifyPwdViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-9.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFModifyPwdViewController.h"
#import "HWFService+User.h"
#import "UIViewExt.h"

@interface HWFModifyPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *pwdOldTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdNewTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIView *pwdBgNew;
@property (weak, nonatomic) IBOutlet UIView *pwdBgOld;
@property (assign, nonatomic) BOOL marginFlag;
- (IBAction)doChangePwd:(id)sender;
- (IBAction)maskAction:(id)sender;
@end

@implementation HWFModifyPwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initData];
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"did load");
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"did appear");
}

- (void)viewWillLayoutSubviews {
    NSLog(@"will layout");
}

- (void)viewDidLayoutSubviews {
    NSLog(@"did layout");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"did disappear");
}

- (void)initData {
    
}

- (void)initView {
    _marginFlag = NO;
    self.title = @"修改密码";
    self.pwdOldTextField.placeholder=@"旧密码";
    self.pwdNewTextField.placeholder=@"新密码";
    [self addBackBarButtonItem];
    [self.commitButton setTitle:@"提交" forState:UIControlStateNormal];
    
    self.pwdBgNew.layer.borderWidth = 1;
    self.pwdBgNew.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1] CGColor];
    
    self.pwdBgOld.layer.borderWidth = 1;
    self.pwdBgOld.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1] CGColor];
    
    UIImage *registerImage = [[UIImage imageNamed:@"btn1"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    UIImage *highRegisterImage = [[UIImage imageNamed:@"btn3"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self.commitButton setBackgroundImage:registerImage forState:UIControlStateNormal];
    [self.commitButton setBackgroundImage:highRegisterImage forState:UIControlStateHighlighted];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHidenNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
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

- (IBAction)doChangePwd:(id)sender {
    [self loadingViewShow];
    [[HWFService defaultService] modifyUserPasswordWithUser:[HWFUser defaultUser] oldPWD:self.pwdOldTextField.text newPWD:self.pwdNewTextField.text completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        [self showTipWithType:HWFTipTypeSuccess code:CODE(data) message:msg];
        if(code == CODE_SUCCESS){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
        }
    }];
}

- (IBAction)maskAction:(id)sender {
    [self.pwdNewTextField resignFirstResponder];
    [self.pwdOldTextField resignFirstResponder];
}

- (void)enterBackground:(UIApplication *)application {
    [self.pwdNewTextField resignFirstResponder];
    [self.pwdOldTextField resignFirstResponder];
}

#pragma mark - UIKeyboardWillShowNotification ／ UIKeyboardWillHideNotification
- (void)keyboardShowNotification:(NSNotification *)notification {
    [UIView animateWithDuration:0.35 animations:^{
        if(!self.marginFlag) {
            self.marginFlag = YES;
            self.view.top -= 80;
        }
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardHidenNotification:(NSNotification *)notification {
    [UIView animateWithDuration:0.35 animations:^{
        self.view.top += 80;
        self.marginFlag = NO;
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doChangePwd:nil];
    return YES;
}

@end
