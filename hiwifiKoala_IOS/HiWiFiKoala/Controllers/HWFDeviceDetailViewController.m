//
//  HWFDeviceDetailViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-13.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDeviceDetailViewController.h"
#import "HWFGeneralTableViewCell.h"
#import "HWFDeviceDetailCell.h"
#import "HWFQosViewController.h"
#import "HWFBlackListViewController.h"
#import "HWFService+Device.h"
#import "HWFDeviceHistoryDetailViewController.h"
#import "HWFTool.h"
#import "HWFService+Device.h"
#import "HWFRenameView.h"
#import "UIViewExt.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#define kTagDeviceBlockAlertView 123


@interface HWFDeviceDetailViewController ()<UITableViewDataSource,UITableViewDelegate,HWFGeneralTableViewCellDelegate,HWFRenameViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deviceTableView;
@property (nonatomic,strong) NSMutableArray *zeroItem;
@property (nonatomic,strong) NSMutableArray *firstItem;
@property (nonatomic,strong) NSMutableArray *secondItem;
@property (nonatomic,strong) NSArray *thirdItem;

@property (nonatomic,strong) NSTimer *deviceTimer;


@property (weak, nonatomic) IBOutlet UIButton *maskButton;//遮罩
@property (strong,nonatomic) HWFRenameView *aliasNameView;


@end

@implementation HWFDeviceDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self startTimer];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
    
    [self loadDeviceDetailInfo];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopTimer];
}

- (void)startTimer {
    if (!self.deviceTimer) {
        self.deviceTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loadChangeData) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer {
    if (self.deviceTimer) {
        [self.deviceTimer invalidate];
        self.deviceTimer = nil;
    }
}

- (void)initData {
    
    self.zeroItem   = [[NSMutableArray alloc]init];
    self.firstItem  = [[NSMutableArray alloc]init];
    self.secondItem = [[NSMutableArray alloc]init];
}

- (void)initView {
    self.title = self.deviceModel.name;
    [self addLeftBarButtonItemWithImage:[UIImage imageNamed:@"arrow-left"] activeImage:[UIImage imageNamed:@"arrow-left-blue"] title:nil target:self action:@selector(doBack:)];
    [self.deviceTableView registerNib:[UINib nibWithNibName:@"HWFGeneralTableViewCell" bundle:nil] forCellReuseIdentifier:@"GeneralTableViewCell"];
    [self.deviceTableView registerNib:[UINib nibWithNibName:@"HWFDeviceDetailCell" bundle:nil] forCellReuseIdentifier:@"DeviceDetailCell"];
    
    //重命名
    if (!self.aliasNameView) {
        NSLog(@"test");
        self.aliasNameView = [HWFRenameView sharedInstance];
        self.aliasNameView.delegate = self;
        [self.view addSubview:self.aliasNameView];
        self.aliasNameView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem: self.aliasNameView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:174];
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem: self.aliasNameView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-174];
        topConstraint.identifier = @"renameTopCons";
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem: self.aliasNameView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem: self.aliasNameView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        
        [self.view addConstraints:@[heightConstraint,topConstraint,leadingConstraint,trailingConstraint]];
        [self.view layoutIfNeeded];
        [self.view setNeedsUpdateConstraints];
    }
}

- (void)loadDeviceDetailInfo {
    [self loadingViewShow];
    [[HWFService defaultService]loadDeviceDetailWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] device:self.deviceModel completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        NSLog(@"deviceDetail :%@",data);
        if (code == CODE_SUCCESS) {
            NSString *connectTime = [self getRestTimeWithSeconds:[[data objectForKey:@"time_total"]intValue]];
            if ([connectTime isEqualToString:@"无"]) {
                connectTime = @"";
            } else {
                connectTime = [NSString stringWithFormat:@"今日%@",connectTime];
            }

            [self.zeroItem addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleDescArrow title:@"连接报告" desc:connectTime switchOn:NO buttonTitle:nil]];
            
            BOOL diskStatus = [[data objectForKey:@"disk_limit"]boolValue];
            [self.firstItem addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"2" style:GeneralTableViewCellStyleSwitch title:@"路由盘访问" desc:nil switchOn:diskStatus buttonTitle:nil]];
            
            NSString *netType = nil;
            if ([[data objectForKey:@"type"]isEqualToString:@"line"]) {
                netType = @"有线";
            }else if ([[data objectForKey:@"type"]isEqualToString:@"wifi"]) {
                if ([[data objectForKey:@"type_wifi"] isEqualToString:@"2.4G"]) {
                    netType = @"WiFi-2.4G";
                } else {
                    netType = @"WiFi-5G";
                }
            }
            

            NSString *downLoadAllTraffic = [self formateTrafficWith:[[data objectForKey:@"traffic_total"]floatValue]];
            NSString *deviceMac = [self.deviceModel displayMAC];
            NSString *deviceIp = [data objectForKey:@"ip"];
        
            [self.secondItem insertObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"3" style:GeneralTableViewCellStyleArrow title:@"智能限速" desc:nil switchOn:NO buttonTitle:nil] atIndex:0];
            [self.secondItem insertObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"4" style:GeneralTableViewCellStyleDesc title:@"连接类型" desc:netType switchOn:NO buttonTitle:nil] atIndex:1];
            [self.secondItem insertObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"5" style:GeneralTableViewCellStyleDesc title:@"当前速度" desc:@"下行：0KB/S | 上行: 0KB/s" switchOn:NO buttonTitle:nil] atIndex:2];
            [self.secondItem insertObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"6" style:GeneralTableViewCellStyleDesc title:@"下载总流量" desc:downLoadAllTraffic switchOn:NO buttonTitle:nil] atIndex:3];
            [self.secondItem insertObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"7" style:GeneralTableViewCellStyleDesc title:@"硬件地址" desc:deviceMac switchOn:NO buttonTitle:nil] atIndex:4];
            [self.secondItem insertObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"8" style:GeneralTableViewCellStyleDesc title:@"IP地址" desc:deviceIp switchOn:NO buttonTitle:nil] atIndex:5];

            self.thirdItem = @[@"修改设备名",@"加入黑名单"];
            
            [self.deviceTableView reloadData];
            [self loadChangeData];
            [self startTimer];

        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - 设备实时数据
//{
//    down = 0;
//    "time_total" = 4620;
//    "traffic_total" = 62682;
//    up = 0;
//}
- (void)loadChangeData {
    [[HWFService defaultService] loadDeviceRealTimeTrafficWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] device:self.deviceModel completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        NSLog(@"------%@",data);
        if (code == CODE_SUCCESS) {

            NSString *up = [HWFTool displayTrafficWithUnitB:[[data objectForKey:@"up"]floatValue]];
            NSString *down = [HWFTool displayTrafficWithUnitB:[[data objectForKey:@"down"]floatValue]];
            NSString *up_down_Traffic = [NSString stringWithFormat:@"下行:%@ ｜ 上行%@",up,down];
            NSString *totalTime = [self getRestTimeWithSeconds:[[data objectForKey:@"time_total"]intValue]];
            NSString *connectTime;
            if ([totalTime isEqualToString:@"无"]) {
                connectTime = @"";
            } else {
                connectTime = [NSString stringWithFormat:@"今日%@",totalTime];
            }
            NSString *totalTraffic = [self formateTrafficWith:[[data objectForKey:@"traffic_total"]floatValue]];
            NSLog(@"connectTime:%@",connectTime);
            NSLog(@"totalTraffic:%@",totalTraffic);

                [self.zeroItem replaceObjectAtIndex:0 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleDescArrow title:@"连接报告" desc:connectTime switchOn:NO buttonTitle:nil]];
            [self.secondItem replaceObjectAtIndex:2 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"5" style:GeneralTableViewCellStyleDesc title:@"当前速度" desc:up_down_Traffic switchOn:NO buttonTitle:nil]];
            [self.secondItem replaceObjectAtIndex:3 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"6" style:GeneralTableViewCellStyleDesc title:@"下载总流量" desc:totalTraffic switchOn:NO buttonTitle:nil]];
            
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
        
        [self.deviceTableView reloadData];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
        case 2:
        case 3:
            return 15;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.zeroItem.count;
            break;
        case 1:
            return self.firstItem.count;
            break;
        case 2:
            return self.secondItem.count;
            break;
        case 3:
            return self.thirdItem.count;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        case 1:
        case 2:
        {
            HWFGeneralTableViewCell *cell = [self.deviceTableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell"];
            if (indexPath.section == 0) {
                [cell loadData:self.zeroItem[indexPath.row]];
            } else if (indexPath.section == 1) {
                [cell loadData:self.firstItem[indexPath.row]];
            } else if (indexPath.section == 2) {
                [cell loadData:self.secondItem[indexPath.row]];
            }
            cell.delegate = self;
            return cell;
        }
            break;
        case 3:
        {
            HWFDeviceDetailCell *cell = [self.deviceTableView dequeueReusableCellWithIdentifier:@"DeviceDetailCell"];
            [cell loadDateWithString:self.thirdItem[indexPath.row]];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            //连接报告
            NSLog(@"连接报告");
            HWFDeviceHistoryDetailViewController *deviceHistoryDetailViewController = [[HWFDeviceHistoryDetailViewController alloc] initWithNibName:@"HWFDeviceHistoryDetailViewController" bundle:nil deviceModel:self.deviceModel dateFlag:YES];
            deviceHistoryDetailViewController.acceptDeviceModel = self.deviceModel;
            deviceHistoryDetailViewController.acceptRouterIpStr = self.acceptRouterIpStr;
            deviceHistoryDetailViewController.acceptNPStr = self.acceptNPStr;
            [self.navigationController pushViewController:deviceHistoryDetailViewController animated:YES];
        
        }
            break;
        case 1:
        {
           //代理方法实现
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                //qos限速
                NSLog(@"智能限速");
                HWFQosViewController *qosVC = [[HWFQosViewController alloc]initWithNibName:@"HWFQosViewController" bundle:nil];
                qosVC.acceptDeviceModel = self.deviceModel;
                [self.navigationController pushViewController:qosVC animated:YES];
            }
        }
            break;
        case 3:
        {
            
            if (indexPath.row == 0) {
                //修改设备名
#warning -----------
                NSLog(@"修改设备名");
                [self showAliasNameViewAnimation];
            
            } else if (indexPath.row == 1) {
                //加入黑名单
                 NSLog(@"加入黑名单");
                if (self.deviceModel.connectType == ConnectTypeLine) {
                    [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"有线设备不能断开"];
                } else {
                    UIAlertView *alv = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@ 将被路由器屏蔽。如需解除屏蔽，请进入'我查查-黑名单'移除。", [self.deviceModel displayName]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alv.tag = kTagDeviceBlockAlertView;
                    [alv show];
                }
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case kTagDeviceBlockAlertView:
        {
            switch (buttonIndex) {
                case 0: // 取消
                {
                }
                    break;
                case 1: // 确定
                {
                    [self loadingViewShow];
                    [[HWFService defaultService]addToBlackListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] device:self.deviceModel completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                        [self loadingViewHide];
                        if (code == CODE_SUCCESS) {
                            //刷新设备列表
                            if ([self.delegate respondsToSelector:@selector(refreshDeviceList)]) {
                                [self.delegate performSelector:@selector(refreshDeviceList) withObject:self];
                            }
                            [self doBack:nil];
                            
                        } else {
                            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
                        }
                    }];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 路由盘访问
- (void)descSwitchChanged:(HWFGeneralTableViewCell *)aCell {
    NSLog(@"路由盘访问");
#warning ------------路由盘访问接口
    [self loadingViewShow];
    [[HWFService defaultService]setDeviceDiskLimitWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] device:self.deviceModel diskLimit:aCell.item.isSwitchOn completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        NSLog(@"路由盘访问接口路由盘访问接口路由盘访问接口%@",data);
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
                //改数据源
                [self.firstItem replaceObjectAtIndex:0 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"2" style:GeneralTableViewCellStyleSwitch title:@"路由盘访问" desc:nil switchOn:aCell.item.isSwitchOn buttonTitle:nil]];
        } else {
            //改数据源
            [self.firstItem replaceObjectAtIndex:0 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"2" style:GeneralTableViewCellStyleSwitch title:@"路由盘访问" desc:nil switchOn:!(aCell.item.isSwitchOn) buttonTitle:nil]];
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
        [self.deviceTableView reloadData];
    }];
}

#pragma mark - 求时间
- (NSString *)getRestTimeWithSeconds:(int) restTime {
    NSString *timeStr ;
    int hour = restTime / 3600;
    int minutes = restTime % 3600 /60;
    if (hour > 0 && minutes >0 ) {
        timeStr = [NSString stringWithFormat:@"%d小时%d分钟",hour,minutes];
    } else if (hour <= 0 && minutes >0 ) {
        timeStr = [NSString stringWithFormat:@"%d分钟",minutes];
    } else if (hour > 0 && minutes <= 0){
        timeStr = [NSString stringWithFormat:@"%d小时",hour];
    } else {
        timeStr = @"无";
    }
    return timeStr;
}

#pragma mark - 求总流量
- (NSString *)formateTrafficWith:(float)aTraffic {
    NSString *trafficText;
    if (aTraffic < 102.4) {
        trafficText = @"0 KB";
    } else if (aTraffic < 1024.0*1024.0) {
        trafficText = [NSString stringWithFormat:@"%.1f KB", aTraffic/1024.0];
    } else if (aTraffic < 1024.0*1024.0*1024.0) {
        trafficText = [NSString stringWithFormat:@"%.1f MB", aTraffic/1024.0/1024.0];
    } else if (aTraffic < 1024.0*1024.0*1024.0*1024.0) {
        trafficText = [NSString stringWithFormat:@"%.1f GB", aTraffic/1024.0/1024.0/1024.0];
    }
    return trafficText;
}
#pragma mark - 改名 - ui
- (void)showAliasNameViewAnimation {
    NSArray *ary = self.view.constraints;
    for(NSLayoutConstraint *tempCons in ary) {
        if([tempCons.identifier isEqualToString: @"renameTopCons"]) {
            tempCons.constant = 0;
        }
    }
    self.aliasNameView.nameTextField.text = self.deviceModel.name;
    [ self.aliasNameView.nameTextField becomeFirstResponder];
    [self.maskButton setHidden:NO];
    [UIView animateWithDuration:0.3f animations:^{
        self.aliasNameView.top = 0;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)hideAliasNameViewAnimation {
    NSArray *ary = self.view.constraints;
    for(NSLayoutConstraint *tempCons in ary) {
        if([tempCons.identifier isEqualToString: @"renameTopCons"]) {
            tempCons.constant = -174;
        }
    }
    [self.aliasNameView.nameTextField resignFirstResponder];
    [self.maskButton setHidden:YES];
    [UIView animateWithDuration:0.3f animations:^{
        self.aliasNameView.top = -174;
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)maskAction:(id)sender {
    //遮罩
    [self hideAliasNameViewAnimation];
}

- (void)renameViewRenameAction {
    //确定
    NSLog(@"确定");
    [self doRename];
}

- (void)renameViewCancleAction {
    //取消
     NSLog(@"取消");
    [self hideAliasNameViewAnimation];
}

#pragma mark - 命名 - 接口
- (void)doRename {
    
    NSLog(@"-----------%@",self.aliasNameView.nameTextField.text);
    if ([[self.aliasNameView.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"请输入设备名称"];
        return;
    } else if (self.aliasNameView.nameTextField.text.length > 30) {
        [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"您输入的设备名称超过30个字符"];
        return;
    }

    [self loadingViewShow];
    [[HWFService defaultService]setDeviceNameWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] device:self.deviceModel newName:self.aliasNameView.nameTextField.text completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            [self hideAliasNameViewAnimation];
            self.title = self.aliasNameView.nameTextField.text;
            if ([self.delegate respondsToSelector:@selector(refreshDeviceList)]) {
                [self.delegate performSelector:@selector(refreshDeviceList) withObject:self];
            }
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

- (void)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
