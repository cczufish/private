//
//  HWFQosViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-11-3.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFQosViewController.h"
#import "HWFService+Device.h"
#import "UIViewExt.h"

#define TAG_QOSUPUNIT_ACTIONSHEET 200
#define TAG_QOSDOWNUNIT_ACTIONSHEET 201

#define TAG_QOSUP_FIELD 300
#define TAG_QOSDOWN_FIELD 301

#define DEFAULT_UP_SPEED  50
#define DEFAULT_DOWN_SPEED 100


@interface HWFQosViewController ()<UITextFieldDelegate,UIActionSheetDelegate>
//
@property (weak, nonatomic) IBOutlet UIView *qosSwitchView;
@property (weak, nonatomic) IBOutlet UILabel *speedLimitLabel;
@property (weak, nonatomic) IBOutlet UISwitch *qosSwitch;

//
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet UIView *remindBgView;

//
@property (strong, nonatomic) IBOutlet UIView *qosManagerView;
@property (weak, nonatomic) IBOutlet UILabel *upLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property (weak, nonatomic) IBOutlet UITextField *qosUpField;
@property (weak, nonatomic) IBOutlet UITextField *qosDownField;
@property (weak, nonatomic) IBOutlet UIButton *upUnitButton;
@property (weak, nonatomic) IBOutlet UIButton *downUnitButton;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation HWFQosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadQosStatus];
}

- (void)initView {
    self.title = @"智能限速";
    //    self.isQosManageViewShow = NO;
    [self addBackBarButtonItem];
    self.remindLabel.text = @"打开限速设置单台设备网速";
    self.upLabel.text = @"上行";
    self.downLabel.text = @"下行";
    self.speedLimitLabel.text = @"限速";
    [self.upUnitButton setTitle:@"KB/S" forState:UIControlStateNormal];
    [self.downUnitButton setTitle:@"KB/S" forState:UIControlStateNormal];
    [self.submitButton setTitle:@"确定" forState:UIControlStateNormal];
    
    self.qosUpField.tag = TAG_QOSUP_FIELD;
    self.qosDownField.tag = TAG_QOSDOWN_FIELD;
    
    [self.view addSubview:self.qosManagerView];
    if (self.view.subviews .count >= 3) {
        [self.view insertSubview:self.remindBgView atIndex:0];
        [self.view insertSubview:self.qosManagerView atIndex:1];
        [self.view insertSubview:self.qosSwitchView atIndex:2];
    }
    
    self.qosManagerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem: self.qosManagerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:133];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem: self.qosManagerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-133];
    topConstraint.identifier = @"qosTopCons";
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem: self.qosManagerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem: self.qosManagerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[heightConstraint,topConstraint,leadingConstraint,trailingConstraint]];
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];


    [self.qosSwitch setOn:self.acceptDeviceModel.QoSStatus];
    if (self.acceptDeviceModel.QoSStatus == YES) {
        [self showQosManagerViewAnimation];
    } else {
        [self hideQosManageViewAnimation];
    }
    
}

#pragma mark -加载qos状态
- (void)loadQosStatus {
    
    [self loadingViewShow];
    [[HWFService defaultService]loadDeviceQoSWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] device:self.acceptDeviceModel completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        NSLog(@"qos------%d",[[data objectForKey:@"state"]boolValue]);
        if (code == CODE_SUCCESS) {
            [self.qosSwitch setOn:[[data objectForKey:@"state"]boolValue]];
            if (self.qosSwitch.on == YES) {
                [self showQosManagerViewAnimation];
            } else {
                [self hideQosManageViewAnimation];
            }
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
     
}
//{
//    down = 100;
//    downg = "-1";
//    mac = "B8:E8:56:3C:26:80";
//    name = "dp-rMBP";
//    up = 100;
//    upg = "-1";
//}
#pragma mark - 设置限速
- (void)setDeviceQoSWithUp:(float)upQos withDown:(float)downQos {
    NSLog(@"mymy,=======%f:%f",upQos,downQos);
    [self loadingViewShow];
    [[HWFService defaultService]setDeviceQoSWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] device:self.acceptDeviceModel QoSUp:upQos QoSDown:downQos completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        NSLog(@"qos=======%@",data);
        if (code == CODE_SUCCESS) {
            [self showTipWithType:HWFTipTypeSuccess code:CODE(data) message:@"限速成功"];
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:@(upQos) forKey:@"LastQosUp"];
            [userDefault setObject:@(downQos) forKey:@"LastQosDown"];
            [userDefault synchronize];
            
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - 取消限速
- (void)unsetDeviceQoS {
    [[HWFService defaultService]unsetDeviceQoSWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] device:self.acceptDeviceModel completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        NSLog(@"qos++++++%@",data);
        if (code == CODE_SUCCESS) {
            [self hideQosManageViewAnimation];
            
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

- (NSString *)formatWithoutUnitFromKBTraffic:(CGFloat)trafficValue {
    NSString *trafficString = nil;
    if (trafficValue >= 1024) {
        trafficString = [NSString stringWithFormat:@"%d",[@(trafficValue / 1024.0f) intValue]];
    } else {
        trafficString = [NSString stringWithFormat:@"%d",[@(trafficValue) intValue]];
    }
    return trafficString;
}



#pragma mark - 限速开关
- (IBAction)qosSwitchValueChanged:(UISwitch *)sender {
    if (sender.on) {
        [self showQosManagerViewAnimation];
        
    } else {
        //限速关闭
        [self unsetDeviceQoS];
    }
}

#pragma mark - 提交
- (IBAction)submitAction:(UIButton *)sender {
    
    NSLog(@"--------提交-------");
    if (self.qosUpField.text && [self.qosUpField.text isEqualToString:@""]) {
        [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"请输入上行限速值"];
        return;
    }
    
    if (self.qosDownField.text && [self.qosDownField.text isEqualToString:@""]) {
        [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"请输入下行限速值"];
        return;
    }
    
    if (![self.qosUpField.text respondsToSelector:@selector(floatValue)] || ![self.qosDownField.text respondsToSelector:@selector(floatValue)]) {
        [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"请重新输入限速值，只允许数字"];
        return;
    }
    
    CGFloat qosUp = [self.qosUpField.text floatValue];
    CGFloat qosDown = [self.qosDownField.text floatValue];
    
    NSLog(@"ffffff%f:%f",qosUp,qosDown);
    
    
    if (qosDown < 0 && qosUp < 0) {
        [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"请输入大于0的限速值"];
        return;
    }
    if (self.upUnitButton.tag == 1) {
        qosUp *= 1024;
        NSLog(@"mb=====%f",qosUp);
    }
    if (self.downUnitButton.tag == 1) {
        qosDown *= 1024;
        NSLog(@"mb=====%f",qosDown);
        
    }
    
    if (qosUp > 1024*1024) {
        [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"上行限速超过最大值1024MB/s"];
        return;
    }
    
    if (qosDown > 1024*1024) {
        [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"下行限速超过最大值1024MB/s"];
        return;
    }
    
    [self setDeviceQoSWithUp:qosUp withDown:qosDown];
    
}

#pragma mark - 上行流量单位
- (IBAction)setQosUpUnit:(UIButton *)sender {
    
    [self.qosUpField resignFirstResponder];
    [self.qosDownField resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"KB/s",@"MB/s",nil];
    actionSheet.tag = TAG_QOSUPUNIT_ACTIONSHEET;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

#pragma mark - 下行流量单位
- (IBAction)setQosDownUnit:(UIButton *)sender {
    
    [self.qosUpField resignFirstResponder];
    [self.qosDownField resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"KB/s", @"MB/s",nil];
    actionSheet.tag = TAG_QOSDOWNUNIT_ACTIONSHEET;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}


#pragma mark - 显示Qos管理
- (void)showQosManagerViewAnimation {
    NSArray *ary = self.view.constraints;
    for(NSLayoutConstraint *tempCons in ary) {
        if([tempCons.identifier isEqualToString: @"qosTopCons"]) {
            tempCons.constant = 44;
        }
    }
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    float up = [userdefault objectForKey:@"LastQosUp"] ? [[userdefault objectForKey:@"LastQosUp"]floatValue] : DEFAULT_UP_SPEED;
    float down = [userdefault objectForKey:@"LastQosDown"] ? [[userdefault objectForKey:@"LastQosDown"]floatValue] : DEFAULT_DOWN_SPEED;
    self.qosUpField.text = [self formatWithoutUnitFromKBTraffic:up];
    self.qosDownField.text = [self formatWithoutUnitFromKBTraffic:down];
    if (up >= 1024) {
        [self.upUnitButton setTitle:@"MB/s" forState:UIControlStateNormal];
        self.upUnitButton.tag = 1;
    } else {
        [self.upUnitButton setTitle:@"KB/s" forState:UIControlStateNormal];
        self.upUnitButton.tag = 0;
    }
    
    if (down >= 1024) {
        [self.downUnitButton setTitle:@"MB/s" forState:UIControlStateNormal];
        self.downUnitButton.tag = 1;
    } else {
        [self.downUnitButton setTitle:@"KB/s" forState:UIControlStateNormal];
        self.downUnitButton.tag = 0;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.qosManagerView.top = 44;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 隐藏Qos管理
- (void)hideQosManageViewAnimation {
    NSArray *ary = self.view.constraints;
    for(NSLayoutConstraint *tempCons in ary) {
        if([tempCons.identifier isEqualToString: @"qosTopCons"]) {
            tempCons.constant = -133+44;
        }
    }
    [self.qosUpField resignFirstResponder];
    [self.qosDownField resignFirstResponder];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.qosManagerView.top = -133+44;
    } completion:^(BOOL finished) {
    }];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (actionSheet.tag == TAG_QOSUPUNIT_ACTIONSHEET) {
            [self.upUnitButton setTitle:@"KB/s" forState:UIControlStateNormal];
            self.upUnitButton.tag = 0;
        } else {
            [self.downUnitButton setTitle:@"KB/s" forState:UIControlStateNormal];
            self.downUnitButton.tag = 0;
        }
    } else if (buttonIndex == 1) {
        if (actionSheet.tag == TAG_QOSUPUNIT_ACTIONSHEET) {
            [self.upUnitButton setTitle:@"MB/s" forState:UIControlStateNormal];
            self.upUnitButton.tag = 1;
        } else {
            [self.downUnitButton setTitle:@"MB/s" forState:UIControlStateNormal];
            self.downUnitButton.tag = 1;
        }
    } else if (buttonIndex == 2) {//取消
        
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    switch (textField.tag) {
        case TAG_QOSUP_FIELD:
        {
            [self.qosDownField becomeFirstResponder];
        }
            break;
        case TAG_QOSDOWN_FIELD:
        {
            [self submitAction:nil];
        }
            break;
            
        default:
            break;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789n"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    return basicTest;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
