//
//  HWFChannelViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFChannelViewController.h"
#import "HWFService+RouterControl.h"
#import "HWFUser.h"
#import "HWFRouter.h"
#import "HWFChannelHeaderView.h"

@interface HWFChannelViewController ()

@property (weak, nonatomic) IBOutlet UITableView *channelTableView;
@property (strong, nonatomic) NSMutableArray *channelArray;
@property (assign, nonatomic) int currentChannel;
@property (assign, nonatomic) int tempChannel;
@property (assign, nonatomic) BOOL dragFlag;
@property (assign, nonatomic) BOOL isBridge;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation HWFChannelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initChannelData];
        [self initCurrentChannel];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)initView {
    _dragFlag = NO;
    self.title = @"WiFi信道";
    //[self.channelTableView registerClass:[HWFChannelTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.channelTableView registerNib:[UINib nibWithNibName:@"HWFChannelCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
//    [self.channelTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.channelTableView registerNib:[UINib nibWithNibName:@"HWFChannelHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"header"];
    
    self.channelTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.channelTableView.scrollEnabled = NO;
}

- (void)onTimer {
    [self initChannelData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}

- (void)initChannelData {
    _channelArray = [[NSMutableArray alloc] initWithCapacity:0];
    [[HWFService defaultService] loadWiFiChannelRankWithUser: [HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if(code == CODE_SUCCESS){
            if([data objectForKey:@"rank"]){
                _channelArray = [data objectForKey:@"rank"];
                if(_channelArray.count == 0) {
                    // 稍后重试
                }else{
                    [self.channelTableView reloadData];
                    [self updataChannelCell];
                }
            }else{
                // 稍后重试
            }
            
        }else{
            [self showTipWithType:HWFTipTypeSuccess code:CODE(data) message:msg];
        }

    }];
}

- (void)initCurrentChannel {
    [self loadingViewShow];
    [[HWFService defaultService] loadWiFiChannelWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        //
        [self loadingViewHide];
        if(code == CODE_SUCCESS) {
            if ([data objectForKey:@"channel"]) {
                self.currentChannel = [[data objectForKey:@"channel"] intValue] - 1;
                [self updataChannelCell];
            }
            if([data objectForKey:@"is_bridge"]) {
                if([[data objectForKey:@"is_bridge"] intValue] == 1) {
                    self.isBridge = YES ;
                }else {
                    self.isBridge = NO;
                }
            }
        }else{
            [self showTipWithType:HWFTipTypeSuccess code:CODE(data) message:msg];
            // 稍后重试
        }
    }];
}

- (void)updataChannelCell {
    NSIndexPath *path;
    for(int i=0;i<11;i++) {
         path = [NSIndexPath indexPathForRow:i inSection:0];
        [self.channelTableView deselectRowAtIndexPath:path animated:YES];
    }
    if(self.dragFlag) {
        path = [NSIndexPath indexPathForRow:self.tempChannel inSection:0];
    } else {
        path = [NSIndexPath indexPathForRow:self.currentChannel inSection:0];
    }
    
    [self.channelTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)changeChannel {
    [self loadingViewShow];
    [[HWFService defaultService] setWiFiChannelWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] channel:self.tempChannel+1 completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        self.dragFlag = NO;
        if(code == CODE_SUCCESS) {
            self.currentChannel = self.tempChannel;
        } else {
            
        }
        [self showTipWithType:HWFTipTypeSuccess code:CODE(data) message:msg];
    }];
}

#pragma mark - HWFChannelTableViewCellDelegate

- (void)didTouchDown:(HWFChannelCell *)cell {
    self.dragFlag = YES;
    NSIndexPath *path = [self.channelTableView indexPathForCell:cell];
    for(int i=0;i<11;i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        [self.channelTableView deselectRowAtIndexPath:path animated:YES];
    }
    self.tempChannel = (int) path.row;
    [self.channelTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
}
- (void)didSelectRow:(HWFChannelCell *)cell {
   self.dragFlag = YES;
    if(self.isBridge) {
        [self showTipWithType:HWFTipTypeFailure code:NSNotFound message:@"中继模式不能调整信道"];
        return;
    }
    NSIndexPath *path = [self.channelTableView indexPathForCell:cell];
    if(path.row == self.currentChannel) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"亲，您已经选择了该信道" message:Nil delegate:self cancelButtonTitle:Nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else {
        NSString *str = [NSString stringWithFormat:@"确定更换为信道%@？",cell.title.text];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:str message:Nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.delegate = self;
        [alertView show];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //[self.channelTableView reloadData];
}

- (void)didTouchDragExit:(HWFChannelCell *)cell {
    self.dragFlag = NO;
    [self updataChannelCell];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            self.dragFlag = NO;
            [self updataChannelCell];
            break;
        case 1:
            [self changeChannel];
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    float cellHeight = floorf((self.channelTableView.frame.size.height)/ 12);
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float cellHeight = floorf((self.channelTableView.frame.size.height)/ 12);
    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    return headerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HWFChannelCell *cell = (HWFChannelCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    float channelValue = 1;
    if([self.channelArray count] > indexPath.row){
        channelValue = [[self.channelArray objectAtIndex:indexPath.row] floatValue];
    }
    [cell setIndex:[NSString stringWithFormat:@"%ld",indexPath.row + 1] value:channelValue];
    cell.delegate = self;
   return cell;
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
