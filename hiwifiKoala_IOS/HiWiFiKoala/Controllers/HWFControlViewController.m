//
//  HWFControlViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-9.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFControlViewController.h"
#import "HWFGeneralTableViewCell.h"
#import "HWFPartSpeedUpViewController.h"
#import "HWFWiFiSleepViewController.h"
#import "HWFChannelViewController.h"
#import "HWFExamViewController.h"
#import "HWFSpeedTestViewController.h"
#import "HWFService+Router.h"
#import "HWFService+RouterControl.h"

@interface HWFControlViewController ()<UITableViewDataSource,UITableViewDelegate,HWFGeneralTableViewCellDelegate>
@property (nonatomic,strong)NSMutableArray *array;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HWFControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initView];
    
    [self loadData];
    
}

- (void)initData {
    
    self.array = [[NSMutableArray alloc]init];
}

- (void)initView {
    self.title = @"智能控制";
    [self addBackBarButtonItem];
    [self.tableView registerNib:[UINib nibWithNibName:@"HWFGeneralTableViewCell" bundle:nil] forCellReuseIdentifier:@"GeneralTableViewCell"];
}

//智能控制大接口:{
//    "online_device_count" = 9;
//    "speedup_device" = "";
//    "speedup_time_over" = 0;
//    "wifi_24g" =     {
//        channel = 11;
//        "sleep_info" =         {
//            status = 0;
//        };
//        "wide_mode" = 1;
//    };
//    "wifi_5g" =     {
//        "sleep_info" =         {
//            status = 0;
//        };
//    };
//}

- (void)loadData {
    [self loadingViewShow];
    [[HWFService defaultService]loadRouterControlOverviewWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        NSLog(@"智能控制大接口:%@",data);
        if (code == CODE_SUCCESS) {

            NSString *speedupDeviceMac = [data objectForKey:@"speedup_device"] ;
            if (speedupDeviceMac) {
                int  restTime = [[data objectForKey:@"speedup_time_over"]intValue];
                NSString *restTimeString = [self getRestTimeWithSeconds:restTime];
                if (![restTimeString isEqualToString:@"无"]) {
                    [self.array addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleDescArrow title:@"一键加速" desc:restTimeString switchOn:NO buttonTitle:nil]];
                } else {
                    [self.array addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleDescArrow title:@"一键加速" desc:nil switchOn:NO buttonTitle:nil]];
                }
            }else {
                [self.array addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleDescArrow title:@"一键加速" desc:nil switchOn:NO buttonTitle:nil]];
            }
            
            BOOL crossWallStatus = [[data objectForKey:@"wide_mode"]boolValue];
            [self.array addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"2" style:GeneralTableViewCellStyleSwitch title:@"一键穿墙" desc:nil switchOn:crossWallStatus buttonTitle:nil]];
            
            [self.array addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"3" style:GeneralTableViewCellStyleArrow title:@"一键体验" desc:nil switchOn:NO buttonTitle:nil]];
#warning ---------缺少 测速接口----假数据
            [self.array addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"4" style:GeneralTableViewCellStyleDescArrow title:@"一键测速" desc:@"网速 3MB/s" switchOn:NO buttonTitle:nil]];
            
            int channelNum = [[[data objectForKey:@"wifi_24g"]objectForKey:@"channel"]intValue];
            NSString *currentChannel = [NSString stringWithFormat:@"当前信道是%d",channelNum];
            [self.array addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"5" style:GeneralTableViewCellStyleDescArrow title:@"WiFi信道" desc:currentChannel switchOn:NO buttonTitle:nil]];
            
            [self.tableView reloadData];

        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

//求时间
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadData:self.array[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        HWFGeneralTableViewCell *cell= (HWFGeneralTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell.item.identity isEqualToString:@"1"]) {
            // 一键加速
            NSLog(@"一键加速");
            HWFPartSpeedUpViewController *partSpeedUp = [[HWFPartSpeedUpViewController alloc]initWithNibName:@"HWFPartSpeedUpViewController" bundle:nil];
            [self.navigationController pushViewController:partSpeedUp animated:YES];
            
        } else if ([cell.item.identity isEqualToString:@"2"]) {
            // 一键穿墙 －－－ 代理方法里面实现
            
        } else if ([cell.item.identity isEqualToString:@"3"]) {
            // 一键体验
            NSLog(@"一键体检");
            HWFExamViewController *examVC = [[HWFExamViewController alloc]initWithNibName:@"HWFExamViewController" bundle:nil];
            [self.navigationController pushViewController:examVC animated:YES];
        } else if ([cell.item.identity isEqualToString:@"4"]) {
            // 一键测速
            NSLog(@"一键测速");
            HWFSpeedTestViewController *speedTestVC = [[HWFSpeedTestViewController alloc]initWithNibName:@"HWFSpeedTestViewController" bundle:nil];
            [self.navigationController pushViewController:speedTestVC animated:YES];
        } else if ([cell.item.identity isEqualToString:@"5"]) {
            // WiFi信道
            NSLog(@"WiFi信道");
            HWFChannelViewController *channelVC = [[HWFChannelViewController alloc]initWithNibName:@"HWFChannelViewController" bundle:nil];
            [self.navigationController pushViewController:channelVC animated:YES];
        }
}

#pragma mark - HWFGeneralTableViewCellDelegate
- (void)descSwitchChanged:(HWFGeneralTableViewCell *)aCell {
    DDLogDebug(@"Switch Changed : %@ / %d", aCell.item.title, aCell.item.isSwitchOn);
    //穿墙
    [self loadingViewShow];
    [[HWFService defaultService] setWiFiWideModeWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] mode:aCell.item.isSwitchOn completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            if (aCell.item.isSwitchOn) {
                //改数据源
                [self.array replaceObjectAtIndex:1 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"2" style:GeneralTableViewCellStyleSwitch title:@"一键穿墙" desc:nil switchOn:YES buttonTitle:nil]];
            } else {
                [self.array replaceObjectAtIndex:1 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"2" style:GeneralTableViewCellStyleSwitch title:@"一键穿墙" desc:nil switchOn:NO buttonTitle:nil]];
            }
        } else {
            [self.array replaceObjectAtIndex:1 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"2" style:GeneralTableViewCellStyleSwitch title:@"一键穿墙" desc:nil switchOn:!(aCell.item.isSwitchOn) buttonTitle:nil]];
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
        
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
