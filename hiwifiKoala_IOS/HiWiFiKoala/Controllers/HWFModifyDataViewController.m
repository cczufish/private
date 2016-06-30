//
//  HWFModifyDataViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-9.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFModifyDataViewController.h"
#import "HWFModifyPwdViewController.h"
#import "HWFUser.h"
#import "HWFService+User.h"
#import "UIViewExt.h"
#import "NSString+Extension.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HWFModifyDataViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *modifyPwdBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIView *userNameBg;
@property (assign, nonatomic) BOOL marginFlag;
@property (weak, nonatomic) IBOutlet UIImageView *maleSelect;
@property (weak, nonatomic) IBOutlet UIImageView *femaleSelect;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIcon;

- (IBAction)changeUserImage:(id)sender;
- (void)pickFromPhotosAlbum;
- (void)pickFromCamera;
- (IBAction)maskAction:(id)sender;
@end

@implementation HWFModifyDataViewController

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
    [super viewDidLoad];
    [self initView];
}

- (void)initData {

}
- (void)initView {
    self.title = @"修改资料";
    _marginFlag = NO;
    [self addBackBarButtonItem];
    if([[HWFUser defaultUser].mobile isEqualToString:@""] || [HWFUser defaultUser].mobile == nil) {
        self.phoneIcon.hidden = YES;
        self.phoneNumLabel.text = @"";
    }else{
        NSLog(@"%@",[HWFUser defaultUser].mobile);
        self.phoneIcon.hidden = NO;
        self.phoneNumLabel.text = [HWFUser defaultUser].mobile;
    }
    
    self.userNameTextField.placeholder = [HWFUser defaultUser].username;
    [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    UIImage *registerImage = [[UIImage imageNamed:@"btn1"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    UIImage *highRegisterImage = [[UIImage imageNamed:@"btn3"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self.commitBtn setBackgroundImage:registerImage forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:highRegisterImage forState:UIControlStateHighlighted];
    
    
    
    [self.modifyPwdBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"photo"];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[HWFUser defaultUser].avatar] placeholderImage:image];
    
    if([HWFUser defaultUser].gender == UserGenderMale) {
        self.maleSelect.hidden = NO;
        self.femaleSelect.hidden = YES;
    }else if([HWFUser defaultUser].gender == UserGenderFemale){
        self.maleSelect.hidden = YES;
        self.femaleSelect.hidden = NO;
    }else{
        self.maleSelect.hidden = YES;
        self.femaleSelect.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHidenNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.layer.borderWidth = 2;
    self.avatarImgView.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
    self.avatarImgView.layer.cornerRadius = self.avatarImgView.bounds.size.height / 2;
    
    self.userNameBg.layer.borderWidth = 1;
    self.userNameBg.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1] CGColor];
}

/**
 *  @brief  修改用户资料
 *
 *  @param aUser                用户对象
 *  @param aUserInfo            用户资料字典(KEY: username)
 *  @param theCompletionHandler Handler
 */
//- (void)modifyInfoWithUser:(HWFUser *)aUser
//                  userInfo:(NSDictionary *)aUserInfo
//                completion:(ServiceCompletionHandler)theCompletionHandler;
//提交
- (IBAction)commitAction:(UIButton *)sender {
    [self.userNameTextField resignFirstResponder];
    int userLength = self.userNameTextField.text.sLength;
    if(userLength < 4 || userLength > 20) {
        [self showTipWithType:HWFTipTypeFailure code:CODE_NIL message:@"用户名需4-20位字符(中文占2字符)"];
        return;
    }
    [self loadingViewShow];
    UserGender temp = self.maleSelect.hidden ? UserGenderFemale : UserGenderMale;
    [[HWFService defaultService] modifyInfoWithUser:[HWFUser defaultUser] userInfo:@{@"username":self.userNameTextField.text, @"gender":@(temp)} completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            [self showTipWithType:HWFTipTypeSuccess code:CODE(data) message:msg];
            if([self.delegate respondsToSelector:@selector(modifyDataSuccess)]){
                [self.delegate modifyDataSuccess];
            }
            //跳到设置页面
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        } 
    }];
}
- (IBAction)maleTouchAction:(id)sender {
    self.maleSelect.hidden = NO;
    self.femaleSelect.hidden = YES;
}
- (IBAction)femaleTouchAction:(id)sender {
    self.maleSelect.hidden = YES;
    self.femaleSelect.hidden = NO;
}

//修改密码
- (IBAction)modifyPwdAction:(id)sender {
    HWFModifyPwdViewController *modifyPwdController = [[HWFModifyPwdViewController alloc] initWithNibName:@"HWFModifyPwdViewController" bundle:nil];
    //manageController.delegate = self;
    [self.navigationController pushViewController:modifyPwdController animated:YES];
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


- (IBAction)changeUserImage:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择文件来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"本地相簿",nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self pickFromCamera];
            break;
        case 1:
            [self pickFromPhotosAlbum];
            break;
        default:
            break;
    }
}

- (void)pickFromCamera {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)maskAction:(id)sender {
    [self.userNameTextField resignFirstResponder];
}

- (void)pickFromPhotosAlbum {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    if(image != nil) {
        [self loadingViewShow];
        [[HWFService defaultService] modifyAvatarWithUser:[HWFUser defaultUser] avatar:image completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            [self loadingViewHide];
            if(code == CODE_SUCCESS){
                self.userImage.image = image;
            }else{
                [self showTipWithType:HWFTipTypeSuccess code:CODE(data) message:msg];
            }
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    [self commitAction:nil];
    return YES;
}

@end
