//
//  HWFPartSpeedUpViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFPartSpeedUpViewController.h"
#import "HWFPartSpeedUpTableViewCell.h"
#import "HWFService+RouterControl.h"
#import "HWFPartSpeedUpItem.h"
#define TAG_BASESINGLESPEEDUP_CELL 400

@interface HWFPartSpeedUpViewController ()<UITableViewDataSource,UITableViewDelegate,HWFPartSpeedUpCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *partSpeedUpTableView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *maskBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *maskButton;

@property (strong, nonatomic) NSMutableArray *partSpeedUpDataSource;

@property (strong,nonatomic) UILabel *tipLabel;


@end

@implementation HWFPartSpeedUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)initData {
    self.partSpeedUpDataSource = [[NSMutableArray alloc] init];
    [self loaPartSpeedUpList];
}

- (void)initView {
    
    self.title = @"一键加速";
    [self addLeftBarButtonItemWithImage:[UIImage imageNamed:@"arrow-left"] activeImage:[UIImage imageNamed:@"arrow-left-blue"] title:nil target:self action:@selector(backAction:)];
    [self addRightBarButtonItemWithImage:nil activeImage:nil title:@"刷新" target:self action:@selector(doRefresh:)];

    [self.partSpeedUpTableView registerNib:[UINib nibWithNibName:@"HWFPartSpeedUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"PartSpeedUpCell"];
}

#pragma mark - 获得单项加速列表
- (void)loaPartSpeedUpList {
    [self loadingViewShow];
    [[HWFService defaultService]loadPartSpeedUpListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            NSLog(@"-----------%@",data);
            [self.partSpeedUpDataSource removeAllObjects];
            NSArray *partSpeedUpList = [data objectForKey:@"list"];
            for (NSDictionary *partSpeedUpDic in partSpeedUpList) {
                HWFPartSpeedUpItem *partSpeedUpItem = [[HWFPartSpeedUpItem alloc]init];
                partSpeedUpItem.MAC = [partSpeedUpDic objectForKey:@"item_id"];
                partSpeedUpItem.name = [partSpeedUpDic objectForKey:@"name"];
                partSpeedUpItem.iconURL = [partSpeedUpDic objectForKey:@"icon"];
                partSpeedUpItem.status = [[partSpeedUpDic objectForKey:@"status"] integerValue];
                partSpeedUpItem.timeTotal = [[partSpeedUpDic objectForKey:@"time_total"] integerValue];
                partSpeedUpItem.timeOver = [[partSpeedUpDic objectForKey:@"time_over"] integerValue];
                partSpeedUpItem.rpt = [partSpeedUpDic objectForKey:@"rpt"] ? [[partSpeedUpDic objectForKey:@"rpt"] boolValue] : NO;
                partSpeedUpItem.finishTimeInterval = [[[NSDate date] dateByAddingTimeInterval:partSpeedUpItem.timeOver] timeIntervalSince1970];
                if (partSpeedUpItem.status == 1) {
                    [self.partSpeedUpDataSource insertObject:partSpeedUpItem atIndex:0];
                } else {
                    [self.partSpeedUpDataSource addObject:partSpeedUpItem];
                }
            }
            [self.partSpeedUpTableView reloadData];
            if ([self.partSpeedUpDataSource count] == 0) {
                [self.tipLabel setText:@"当前无连接设备"];
            } else {
                [self.tipLabel setText:@"为了您的网络资源，加速时间有限"];
            }
            
        } else {
            self.tipLabel.text = @"网络不给力，获取列表失败";
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 20)];
    [self.tipLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.tipLabel setTextColor:[UIColor grayColor]];
    [self.tipLabel setTextAlignment:NSTextAlignmentCenter];
    [self.tipLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel setText:@"为了您的网络资源，加速时间有限"];
    return self.tipLabel;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.partSpeedUpDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFPartSpeedUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PartSpeedUpCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.tag = TAG_BASESINGLESPEEDUP_CELL +indexPath.row;
    HWFPartSpeedUpItem *item = (HWFPartSpeedUpItem *)[self.partSpeedUpDataSource objectAtIndex:indexPath.row];
    [cell reloadCellWithSingleSpeedUpItem:item];
    return cell;
}

- (void)doRefresh:(UIButton *)btn {
    [self loaPartSpeedUpList];
}

- (void)backAction:(UIButton *)btn {
    int i = 0;
    for (HWFPartSpeedUpItem *partSpeedUpItem in self.partSpeedUpDataSource) {
        if (partSpeedUpItem.status == 1) {
            [(HWFPartSpeedUpTableViewCell *)[self.partSpeedUpTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]] pauseGradientPrgressViewAnimation];
            break;
        }
        i++;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMaskButtonClick:(UIButton *)sender {
    self.maskView.hidden = YES;
}

- (void)pauseWithPartSpeedUpCell:(HWFPartSpeedUpTableViewCell *)cell {
    NSLog(@"暂停");
    HWFPartSpeedUpItem *partSpeedUpItem = (HWFPartSpeedUpItem *)[self.partSpeedUpDataSource objectAtIndex:cell.tag - TAG_BASESINGLESPEEDUP_CELL];
    [self pauseAllSingleSpeedUp];
    [self.partSpeedUpTableView reloadData];
    
    [[HWFService defaultService]cancelPartSpeedUpWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] itemId:partSpeedUpItem.MAC completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if (code == CODE_SUCCESS) {
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];

}

- (void)doSpeedUpWithPartSpeedUpCell:(HWFPartSpeedUpTableViewCell *)cell {
    NSLog(@"加速");
    [self loadingViewShow];
    HWFPartSpeedUpItem *partSpeedUpItem = (HWFPartSpeedUpItem *)[self.partSpeedUpDataSource objectAtIndex:(cell.tag - TAG_BASESINGLESPEEDUP_CELL)];
    [[HWFService defaultService]setPartSpeedUpWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] itemId:partSpeedUpItem.MAC completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            [self pauseAllSingleSpeedUp];
            partSpeedUpItem.status = 1;
            partSpeedUpItem.timeOver = partSpeedUpItem.timeTotal;
            partSpeedUpItem.finishTimeInterval = [[[NSDate date] dateByAddingTimeInterval:partSpeedUpItem.timeOver] timeIntervalSince1970];
            [self.partSpeedUpDataSource removeObject:partSpeedUpItem];
            [self.partSpeedUpDataSource insertObject:partSpeedUpItem atIndex:0];
            [self.partSpeedUpTableView reloadData];
            [self.partSpeedUpTableView setContentOffset:CGPointMake(0, 0) animated:YES];
            [self.partSpeedUpTableView reloadData];
            
            [self showMaskView];

        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            [self pauseAllSingleSpeedUp];
        }
    }];
}

- (void)pauseAllSingleSpeedUp
{
    for (HWFPartSpeedUpItem *partSpeedUpItem in self.partSpeedUpDataSource) {
        partSpeedUpItem.status = 0;
        partSpeedUpItem.timeOver = partSpeedUpItem.timeTotal;
        partSpeedUpItem.finishTimeInterval = [[[NSDate date] dateByAddingTimeInterval:partSpeedUpItem.timeOver] timeIntervalSince1970];
    }
}

#pragma mark - GuideMask
- (void)showMaskView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"ShowSingleSpeedUpMaskView"] && [[defaults objectForKey:@"ShowSingleSpeedUpMaskView"] boolValue]) {
        return;
    } else {
        self.maskView.hidden = NO;
        [defaults setObject:@(YES) forKey:@"ShowSingleSpeedUpMaskView"];
        [defaults synchronize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
