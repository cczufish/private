//
//  HWFDoubtDeviceController.m
//  HiWiFiKoala
//
//  Created by chang hong on 14-10-21.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDoubtDeviceController.h"
#import "HWFService+MessageCenter.h"
#import "HWFService+Device.h"
#import "HWFTool.h"
#import "UIViewExt.h"
#import "NSString+Extension.h"
#import "HWFDeviceHistoryListViewController.h"
@interface HWFDoubtDeviceController ()

@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@property (weak, nonatomic) IBOutlet UILabel *messageContent;
@property (weak, nonatomic) IBOutlet UILabel *deviceMac;
@property (weak, nonatomic) IBOutlet UITextField *aliasNameField;
@property (weak, nonatomic) IBOutlet UIButton *renameButton;
@property (strong,nonatomic) UIButton *maskButton;
@property (strong, nonatomic) IBOutlet UIView *changeNameView;
- (IBAction)blockDevice:(id)sender;
- (IBAction)trustDevice:(id)sender;
- (IBAction)detailView:(id)sender;
- (IBAction)doRename:(id)sender;

@end

@implementation HWFDoubtDeviceController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    self.title = @"消息处理";
    [self initMaskButton];
    [self initChangeDeviceNameView];
    if(self.message.transData) {
        [self initViewData];
    }else{
        [self loadingViewShow];
        [[HWFService defaultService] loadMessageDetailWithUser:[HWFUser defaultUser] message:self.message completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            [self loadingViewHide];
            if(code == CODE_SUCCESS) {
                self.message.transData = [[[[data objectForKey:@"message"] objectForKey:@"trans_data"] JSONObject] mutableCopy];
                [self initViewData];
                if([self.delegate respondsToSelector:@selector(messageDetailChanged:)]) {
                    [self.delegate messageDetailChanged:self.message];
                }
            }
        }];
    }
}

- (void)initViewData {
    NSString *name;
    if ((![self.message.transData objectForKey:@"device_name"]) || ([self.message.transData objectForKey:@"device_name"] && [[self.message.transData objectForKey:@"device_name"] isEqualToString:@""])) {
        name = @"未知";
    }else if ([self.message.transData objectForKey:@"device_name"] &&![[self.message.transData objectForKey:@"device_name"] isEqualToString:@""]) {
        name = [self.message.transData objectForKey:@"device_name"];
    }
    self.deviceName.text = name;
    self.deviceMac.text = [self.message.transData objectForKey:@"device_mac"];
    NSTimeInterval interval = [[self.message.transData objectForKey:@"connect_time"] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *connectTimeStr = [HWFTool dateAgoWithDate:date];
    self.messageContent.text = [NSString stringWithFormat:@"%@，此设备连接到您的WiFi，如果是不被信任的设备，有可能对您上网造成安全隐患。",connectTimeStr];
}

- (void)initMaskButton {
    _maskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _maskButton.frame = self.view.bounds;
    _maskButton.backgroundColor = [UIColor blackColor];
    _maskButton.alpha = 0.5;
    _maskButton.hidden = YES;
    _maskButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.maskButton addTarget:self action:@selector(hideChangeNameViewAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_maskButton];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_maskButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_maskButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:_maskButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:_maskButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.view addConstraints:@[topConstraint,bottomConstraint,leadingConstraint,trailingConstraint]];
}

- (void)initChangeDeviceNameView {
    [self.view addSubview:_changeNameView];
    _changeNameView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_changeNameView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:70];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_changeNameView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-70];
    topConstraint.identifier = @"topCons";
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:_changeNameView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:_changeNameView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[heightConstraint,topConstraint,leadingConstraint,trailingConstraint]];
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
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

- (IBAction)blockDevice:(id)sender {
    [self loadingViewShow];
    HWFDevice *device = [[HWFDevice alloc] init];
    device.MAC = [self.message.transData objectForKey:@"device_mac"];
    [[HWFService defaultService] addToBlackListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] device:device completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if(code == CODE_SUCCESS) {
            
        }else{
            
        }
        [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
    }];
}

- (IBAction)trustDevice:(id)sender {
    NSArray *ary = self.view.constraints;
    for(NSLayoutConstraint *tempCons in ary) {
        if([tempCons.identifier isEqualToString: @"topCons"]) {
            tempCons.constant = 0;
        }
    }
    self.aliasNameField.text = self.deviceName.text;
    [self.aliasNameField becomeFirstResponder];
    [self.maskButton setHidden:NO];
        [UIView animateWithDuration:0.3f animations:^{
            self.changeNameView.top = 0;
        } completion:^(BOOL finished) {
    }];
    
}

- (void)hideChangeNameViewAnimation {
    NSArray *ary = self.view.constraints;
    for(NSLayoutConstraint *tempCons in ary) {
        if([tempCons.identifier isEqualToString: @"topCons"]) {
            tempCons.constant = -70;
        }
    }
    [self.aliasNameField resignFirstResponder];
    [self.maskButton setHidden:YES];
    [UIView animateWithDuration:0.3f animations:^{
        self.changeNameView.top = -70;
    } completion:^(BOOL finished) {
    }];

}

- (IBAction)detailView:(id)sender {
    HWFDeviceHistoryListViewController *controller = [[HWFDeviceHistoryListViewController alloc] initWithNibName:@"HWFDeviceHistoryListViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    
    
}
- (IBAction)doRename:(id)sender {
    if ([[self.aliasNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"请输入设备名称"];
        return;
    } else if (self.aliasNameField.text.length > 30) {
        [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"您输入的设备名称超过30个字符"];
        return;
    }
    [self loadingViewShow];
    HWFDevice *device = [[HWFDevice alloc] init];
    device.MAC = [self.message.transData objectForKey:@"device_mac"];
    
    [[HWFService defaultService] setDeviceNameWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] device:device newName:self.aliasNameField.text completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if(code == CODE_SUCCESS) {
            self.deviceName.text = [data objectForKey:@"new_name"];
            [self.message.transData setObject:[data objectForKey:@"new_name"] forKey:@"device_name"];
            if([self.delegate respondsToSelector:@selector(messageDetailChanged:)]) {
                [self.delegate messageDetailChanged:self.message];
            }
        }else{
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
        [self hideChangeNameViewAnimation];
    }];
}
@end
