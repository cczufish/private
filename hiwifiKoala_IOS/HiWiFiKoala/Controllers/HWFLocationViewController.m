//
//  HWFLocationViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFLocationViewController.h"
#import "HWFLocationCell.h"
#import "HWFService.h"
#import "HWFService+Router.h"
#import "HWFSmartDevice.h"

@interface HWFLocationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
@property (nonatomic,strong) NSArray *locationArray;
@property(nonatomic,strong)NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) NSMutableDictionary *locationDic;


@end

@implementation HWFLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)initData {
    self.locationArray = [[NSArray alloc]init];
    self.locationDic = [[NSMutableDictionary alloc]init];
    
    [self loadingViewShow];
    [[HWFService defaultService] loadPlaceMapCompletion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        NSLog(@"======%@",data);
        if (code == CODE_SUCCESS) {
            self.locationDic = [data objectForKey:@"data"];
            self.locationArray = [self.locationDic allKeys];
            //第一次选择 门厅
//           NSInteger rptPlace = [(HWFSmartDevice *)self.node.nodeEntity place];
            NSInteger rptPlace = 1;
            NSInteger index = [self.locationArray indexOfObject:[NSString stringWithFormat:@"%ld",rptPlace]];
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.locationTableView selectRowAtIndexPath:firstIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            self.selectedIndexPath = firstIndexPath;

            [self.locationTableView reloadData];
            
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

- (void)initView {
    self.title = @"位置";
    [self addBackBarButtonItem];

    [self.locationTableView registerNib:[UINib nibWithNibName:@"HWFLocationCell" bundle:nil] forCellReuseIdentifier:@"LocationCell"];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFLocationCell *locationCell = (HWFLocationCell *)[tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    NSString *string = [self.locationDic objectForKey:self.locationArray[indexPath.row]];
    [locationCell loadUIWithData:string];
    if (self.selectedIndexPath.row == indexPath.row) {
        locationCell.imgView.hidden = NO;
    } else {
        locationCell.imgView.hidden = YES;
    }
    return locationCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *locationStr = [self.locationDic objectForKey:self.locationArray[indexPath.row]];
    NSLog(@"%@",self.locationArray[indexPath.row]);
    NSLog(@"------%@",locationStr);
    //请求接口
    NSInteger selectPlace = [self.locationArray[indexPath.row] integerValue];
    NSString *standMac = [(HWFSmartDevice *)self.node.nodeEntity MAC];
    NSLog(@"enenene:%d%@",selectPlace,standMac);
#warning ----------???-----------mac取不到时候会崩溃－－－－－
    [self loadingViewShow];
    [[HWFService defaultService]setPlaceWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] MAC:standMac place:selectPlace completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            ((HWFSmartDevice *)self.node.nodeEntity).place = selectPlace;
            self.selectedIndexPath = indexPath;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            
            //刷新前面那一页的位置
            if ([self.delegate respondsToSelector:@selector(refreshLocation:)]) {
                [self.delegate refreshLocation:locationStr];
            }
            
        } else {
            //失败
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
