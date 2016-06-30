//
//  HWFBroadbandMsgFeedBackViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-13.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFBroadbandMsgFeedBackViewController.h"
#import "HWFService+Router.h"

@interface HWFBroadbandMsgFeedBackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *routerLabel;
@property (weak, nonatomic) IBOutlet UILabel *routIPlabel;

@property (weak, nonatomic) IBOutlet UILabel *broadBandProviderLabel;
@property (weak, nonatomic) IBOutlet UILabel *npLabel;

@property (weak, nonatomic) IBOutlet UILabel *feedBackLabel;
@property (weak, nonatomic) IBOutlet UITextView *feedBackContent;
@property (weak, nonatomic) IBOutlet UILabel *connectLabel;
@property (weak, nonatomic) IBOutlet UITextView *connectMessage;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation HWFBroadbandMsgFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    self.title = @"宽带商信息反馈";
    [self addBackBarButtonItem];
    
    self.routerLabel.text = @"路由器IP地址";
    self.routIPlabel.text = [[HWFRouter defaultRouter]IP];
    
    self.broadBandProviderLabel.text = @"宽带商信息反馈";
    self.npLabel.text = [[HWFRouter defaultRouter]NP];
    
    self.tipLabel.hidden = NO;
    self.tipLabel.text = @"这是我的反馈";
    self.feedBackLabel.text = @"我的反馈";
    self.feedBackContent.layer.borderWidth = 0.5;
    self.feedBackContent.layer.borderColor = COLOR_HEX(0xebeef0).CGColor;
    self.feedBackContent.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 5);
    
    self.connectLabel.text = @"我的联系方式";
    self.connectMessage.layer.borderWidth = 0.5;
    self.connectMessage.layer.borderColor =  COLOR_HEX(0xebeef0).CGColor;
    self.connectMessage.textContainerInset = UIEdgeInsetsMake(10, 10, 5, 5);
    
    [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(begainEdit) name:UITextViewTextDidBeginEditingNotification object:nil];
    
}

- (void)begainEdit {
    self.tipLabel.hidden = YES;
}

#pragma mark - 提交反馈
- (IBAction)commitAction:(id)sender {
    [self loadingViewShow];
    [[HWFService defaultService]reportRouterNPWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] userTEL:self.connectMessage.text userNP:self.feedBackContent.text completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            [self showTipWithType:HWFTipTypeSuccess code:CODE(data) message:@"提交成功"];
            
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
