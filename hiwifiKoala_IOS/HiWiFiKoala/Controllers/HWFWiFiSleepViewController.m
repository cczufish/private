//
//  HWFWiFiSleepViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFWiFiSleepViewController.h"
#import "HWFService+RouterControl.h"
#import "UIViewExt.h"
#import "HWFTool.h"

#define TAG_WIFIOFF_SWITCH 100
#define TAG_LED_SWITCH 200
#define TAG_WIFIOFFSTART_BUTTON 300
#define TAG_WIFIOFFEND_BUTTON 301

#define DEFAULT_WIFIOFFSTART_TIME @"2300"
#define DEFAULT_WIFIOFFEND_TIME @"700"

#define kWiFiOffStartTime @"wifiOffStartTime"
#define kWiFiOffEndTime @"wifiOffEndTime"

@interface HWFWiFiSleepViewController ()
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIView *wifiOffView;
@property (weak, nonatomic) IBOutlet UISwitch *wifiOffSwitch;
@property (weak, nonatomic) IBOutlet UIButton *wifiOffStartButton;
@property (weak, nonatomic) IBOutlet UIView *wifiTimeBgView;

@property (weak, nonatomic) IBOutlet UIButton *wifiOffEndButton;

@property (weak, nonatomic) IBOutlet UIDatePicker *wifiOffTimePicker;

@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (assign, nonatomic) BOOL isWiFiOffViewShow;


@end


@implementation HWFWiFiSleepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
    
}

- (void)initData {
#warning ------------假数据
    self.wifiOffSwitch.on = YES;
    [self.wifiOffStartButton setTitle:[self getFullDateStringWithString:@"2300"] forState:UIControlStateNormal];
    [self.wifiOffEndButton setTitle:[self getFullDateStringWithString:@"700"] forState:UIControlStateNormal];
}

- (void)initView {
    if ([self.identifier isEqualToString:@"2.4g"]) {
        self.title = @"2.4G定时开关";
    } else if ([self.identifier isEqualToString:@"5g"]) {
        self.title = @"5G定时开关";
    }
    
    [self addBackBarButtonItem];
    self.controlView.hidden = YES;
    
}


#pragma mark - wifi定时开关
- (IBAction)onSwitchChanged:(UISwitch *)sender {

#warning ------------假数据
    if (sender.on) { //显示
        if ([self.identifier isEqualToString:@"2.4g"]) {
            [HWFRouter defaultRouter].WiFi24GSleepConfig.status = YES;
            [HWFRouter defaultRouter].WiFi24GSleepConfig.WiFiOff = 1200;
            [HWFRouter defaultRouter].WiFi24GSleepConfig.WiFiOn = 2300;
            
        } else if ([self.identifier isEqualToString:@"5g"]) {
            [HWFRouter defaultRouter].WiFi5GSleepConfig.status = YES;
        }
        [self setWifiSleepTime];

    } else {
        if ([self.identifier isEqualToString:@"2.4g"]) {
            [HWFRouter defaultRouter].WiFi24GSleepConfig.status = NO;
            
        } else if ([self.identifier isEqualToString:@"5g"]) {
            [HWFRouter defaultRouter].WiFi5GSleepConfig.status = NO;
        }
        [self setWifiSleepTime];
    }
    
    /*
    return;
    
    NSLog(@"本身的状态%d",sender.on);
    
    NSLog(@"信息信息信息2：%d",[HWFRouter defaultRouter].WiFi24GSleepConfig.status);

    if ([self.identifier isEqualToString:@"2.4g"]) {
        
        [HWFRouter defaultRouter].WiFi24GSleepConfig.status =  sender.on;
        
        NSLog(@"本身的状态%d",[HWFRouter defaultRouter].WiFi24GSleepConfig.status);

        
        [self loadingViewShow];
        [[HWFService defaultService]setWiFiSleepConfig24GWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] sleepConfig:[HWFRouter defaultRouter].WiFi24GSleepConfig completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            [self loadingViewHide];
            NSLog(@"-----------%@",data);
            if (code == CODE_SUCCESS) {
                [self.wifiOffSwitch setOn:[HWFRouter defaultRouter].WiFi24GSleepConfig.status];
            } else {
                [HWFRouter defaultRouter].WiFi24GSleepConfig.status = !sender.on;
                [self.wifiOffSwitch setOn:[HWFRouter defaultRouter].WiFi24GSleepConfig.status];
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
        }];
        
    } else if ([self.identifier isEqualToString:@"5g"]) {
        
        
        [self loadingViewShow];
        [[HWFService defaultService]setWiFiSleepConfig5GWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] sleepConfig:[HWFRouter defaultRouter].WiFi24GSleepConfig completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            NSLog(@"++++++++++++%@",data);

            [self loadingViewHide];
            if (code == CODE_SUCCESS) {
                [self.wifiOffSwitch setOn:[HWFRouter defaultRouter].WiFi5GSleepConfig.status];
            } else {
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
        }];
    
    }
     */
}


- (void)loadData
{
    if ([self.identifier isEqualToString:@"2.4g"]) {
        //@"2.4G定时开关";
        [self loadingViewShow];
        [[HWFService defaultService] loadWiFiSleepConfig24GWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            NSLog(@"2.4g:%@",data);
            [self loadingViewHide];
            if (code == CODE_SUCCESS) {
                if ([HWFRouter defaultRouter].WiFi24GSleepConfig.status) {
                    self.wifiOffSwitch.on = YES;
//                    [UIView animateWithDuration:0.35 animations:^{
//                        self.wifiTimeBgView.alpha = 0.5;
//                    } completion:^(BOOL finished) {
//                        self.wifiTimeBgView.alpha = 1.0;
//                    }];
                    [self showSleepAnimationView];
                    
                    [self.wifiOffStartButton setTitle:@"取值1" forState:UIControlStateNormal];
                    [self.wifiOffEndButton setTitle:@"取值2" forState:UIControlStateNormal];
                } else {
                    self.wifiOffSwitch.on = NO;
//                    [UIView animateWithDuration:0.35 animations:^{
//                        self.wifiTimeBgView.alpha = 0.5;
//                    } completion:^(BOOL finished) {
//                        self.wifiTimeBgView.alpha = 0;
//                    }];
                    [self hidenSleepAnimationView];
                }
            } else {
#warning -----
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
        }];
    } else if ([self.identifier isEqualToString:@"5g"]) {
        //@"5G定时开关";
        [self loadingViewShow];
        [[HWFService defaultService] loadWiFiSleepConfig5GWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            NSLog(@"5g:%@",data);
            [self loadingViewHide];
            if (code == CODE_SUCCESS) {
                if ([HWFRouter defaultRouter].WiFi5GSleepConfig.status) {
                    self.wifiOffSwitch.on = YES;
                    [self showSleepAnimationView];
                    [self.wifiOffStartButton setTitle:@"取值1" forState:UIControlStateNormal];
                    [self.wifiOffEndButton setTitle:@"取值2" forState:UIControlStateNormal];
                } else {
                    self.wifiOffSwitch.on = NO;
                    [self hidenSleepAnimationView];
                }
            } else {
                #warning -----
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
        }];
    }
}

- (void)setWifiSleepTime {
    
    if ([self.identifier isEqualToString:@"2.4g"]) {
        NSLog(@"2.4g本身的状态%d",[HWFRouter defaultRouter].WiFi24GSleepConfig.status);
        [self loadingViewShow];
        [[HWFService defaultService]setWiFiSleepConfig24GWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] sleepConfig:[HWFRouter defaultRouter].WiFi24GSleepConfig completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            [self loadingViewHide];
            NSLog(@"2.4------11-----%@",data);
            if (code == CODE_SUCCESS) {
                 NSLog(@"test1");
//                if ([data objectForKey:@"data"] <= 0) {
//                     NSLog(@"test3");
//                    [self.wifiOffSwitch setOn:!(self.wifiOffSwitch.on)];
//                    [self showTipWithType:HWFTipTypeFailure code:CODE_NIL message:@"接口错误"];
//                    return ;
//                }
                if ([HWFRouter defaultRouter].WiFi24GSleepConfig.status) {
//                    self.wifiTimeBgView.hidden = NO;
                    [self showSleepAnimationView];
                    [self.wifiOffSwitch setOn:YES];
                    [self.wifiOffStartButton setTitle:@"24请求下来1" forState:UIControlStateNormal];
                    [self.wifiOffEndButton setTitle:@"24请求下来2" forState:UIControlStateNormal];
                } else {
                    [self hidenSleepAnimationView];
                    [self.wifiOffSwitch setOn:NO];
                }
                
            } else {
                NSLog(@"test2");
                //失败－还是关闭
                [self.wifiOffSwitch setOn:![HWFRouter defaultRouter].WiFi24GSleepConfig.status];
                if (self.wifiOffSwitch.on) {
                    [self showSleepAnimationView];
                    [self.wifiOffStartButton setTitle:@"24请求下来1" forState:UIControlStateNormal];
                    [self.wifiOffEndButton setTitle:@"24请求下来2" forState:UIControlStateNormal];
                } else {
                    [self hidenSleepAnimationView];
                }
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
        }];
        
    } else if ([self.identifier isEqualToString:@"5g"]) {
        
        [self loadingViewShow];
        [[HWFService defaultService]setWiFiSleepConfig5GWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] sleepConfig:[HWFRouter defaultRouter].WiFi24GSleepConfig completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            NSLog(@"++++++++++++%@",data);
            [self loadingViewHide];
            if (code == CODE_SUCCESS) {
//                if ([data objectForKey:@"data"] <= 0) {
//                    [self.wifiOffSwitch setOn:!(self.wifiOffSwitch.on)];
//                    [self showTipWithType:HWFTipTypeFailure code:CODE_NIL message:@"接口错误"];
//                    return ;
//                }
                if ([HWFRouter defaultRouter].WiFi5GSleepConfig.status) {
                    //                    self.wifiTimeBgView.hidden = NO;
                    [self showSleepAnimationView];
                    [self.wifiOffSwitch setOn:YES];
                    [self.wifiOffStartButton setTitle:@"24请求下来1" forState:UIControlStateNormal];
                    [self.wifiOffEndButton setTitle:@"24请求下来2" forState:UIControlStateNormal];
                } else {
                    [self hidenSleepAnimationView];
                    [self.wifiOffSwitch setOn:NO];
                }
            } else {
                //失败－还是关闭
                [self.wifiOffSwitch setOn:![HWFRouter defaultRouter].WiFi5GSleepConfig.status];
                if (self.wifiOffSwitch.on) {
                    [self showSleepAnimationView];
                    [self.wifiOffStartButton setTitle:@"24请求下来1" forState:UIControlStateNormal];
                    [self.wifiOffEndButton setTitle:@"24请求下来2" forState:UIControlStateNormal];
                } else {
                    [self hidenSleepAnimationView];
                }
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
        }];
    }
}

#warning --------------------------------------假数据
#pragma mark - 关闭时间，开启时间
- (IBAction)onWifiOffButtonAction:(UIButton*)sender {
    NSLog(@"test");
    self.controlView.hidden = NO;

    return;
    
    self.controlView.hidden = NO;
    [self.wifiOffTimePicker setTag:sender.tag];
    switch (sender.tag) {
        case TAG_WIFIOFFSTART_BUTTON:
        {
            NSLog(@"关闭按钮");
            [self.wifiOffTimePicker setDate:[HWFTool getDateFromDateString:sender.titleLabel.text withFormatter:@"HH:mm"] animated:NO];
        }
            break;
        case TAG_WIFIOFFEND_BUTTON:
        {
             NSLog(@"确定按钮");
            [self.wifiOffTimePicker setDate:[HWFTool getDateFromDateString:sender.titleLabel.text withFormatter:@"HH:mm"] animated:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 取消
- (IBAction)doCancle:(id)sender {
    NSLog(@"取消datePicker");
    [self.controlView setHidden:YES];
}

#pragma mark - 确定
- (IBAction)doSubmit:(id)sender {

    NSLog(@"self.wifiOffTimePicker.date2:====%@",[HWFTool getDateStringFromDate:self.wifiOffTimePicker.date withFormatter:@"HH:mm"]);
    //取得时间
    if ([self.identifier isEqualToString:@"2.4g"]) {
        switch (self.wifiOffTimePicker.tag) {
                
            case TAG_WIFIOFFSTART_BUTTON:
            {
                //                [HWFRouter defaultRouter].WiFi24GSleepConfig.WiFiOff = [HWFTool getDateStringFromDate:timeOnDatePicker withFormatter:@"MM:hh"];
                [self.wifiOffStartButton setTitle:[HWFTool getDateStringFromDate:self.wifiOffTimePicker.date withFormatter:@"HH:mm"] forState:UIControlStateNormal];
            }
                break;
            case TAG_WIFIOFFEND_BUTTON:
            {
                //                [HWFRouter defaultRouter].WiFi24GSleepConfig.WiFiOn = [HWFTool getDateStringFromDate:timeOnDatePicker withFormatter:@"MM:hh"];
                [self.wifiOffEndButton setTitle:[HWFTool getDateStringFromDate:self.wifiOffTimePicker.date withFormatter:@"HH:mm"] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
    } else if ([self.identifier isEqualToString:@"5g"]) {
        switch (self.wifiOffTimePicker.tag) {
                
            case TAG_WIFIOFFSTART_BUTTON:
            {
//                [HWFRouter defaultRouter].WiFi5GSleepConfig.WiFiOff = [HWFTool getDateStringFromDate:timeOnDatePicker withFormatter:@"MM:hh"];
                [self.wifiOffStartButton setTitle:[HWFTool getDateStringFromDate:self.wifiOffTimePicker.date withFormatter:@"HH:mm"] forState:UIControlStateNormal];

            }
                break;
            case TAG_WIFIOFFEND_BUTTON:
            {
//                [HWFRouter defaultRouter].WiFi5GSleepConfig.WiFiOn = [HWFTool getDateStringFromDate:timeOnDatePicker withFormatter:@"MM:hh"];
                [self.wifiOffStartButton setTitle:[HWFTool getDateStringFromDate:self.wifiOffTimePicker.date withFormatter:@"HH:mm"] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
    }
    self.controlView.hidden = YES;
#warning ----------------------请求接口－－－－设置
    [self setWifiSleepTime];
}

#pragma mark - 设置关闭开启时间－ ui
- (void)showSleepAnimationView {
    for (NSLayoutConstraint *layoutConstraint in self.view.constraints) {
        if (layoutConstraint.firstAttribute == NSLayoutAttributeTop && layoutConstraint.relation == NSLayoutRelationEqual && layoutConstraint.secondAttribute == NSLayoutAttributeBottom ) {
            layoutConstraint.constant = 0;
            layoutConstraint.identifier = @"sleepTimeTopcons";
            NSLog(@"showshow");
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            self.wifiTimeBgView.top = 0;
        } completion:^(BOOL finished) {
        }];
        
    }
}

- (void)hidenSleepAnimationView {
    for (NSLayoutConstraint *layoutConstraint in self.view.constraints) {
        if (layoutConstraint.firstAttribute == NSLayoutAttributeTop && layoutConstraint.relation == NSLayoutRelationEqual && layoutConstraint.secondAttribute == NSLayoutAttributeBottom ) {
            layoutConstraint.constant = -96;
            layoutConstraint.identifier = @"sleepTimeTopcons";
             NSLog(@"hidenhiden");
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            self.wifiTimeBgView.top = -96;
        } completion:^(BOOL finished) {
        }];
    }
}

// 格式化返回的WiFi健康定时时间
- (NSString *)getFullDateStringWithString:(NSString *)dateString
{
    NSMutableString *retString = [NSMutableString stringWithString:dateString];
    for (int i=0; i<4-[dateString length]; i++) {
        [retString insertString:@"0" atIndex:0];
    }
    
    [retString insertString:@":" atIndex:2];
    
    return retString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
