//
//  HWFBlackListViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-13.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFBlackListViewController.h"
#import "HWFBlackListCell.h"
#import "HWFService+Device.h"
#import "HWFBlackListModel.h"

@interface HWFBlackListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *blackListTableView;
@property (weak, nonatomic) IBOutlet UIButton *recoverButton;

@property (strong,nonatomic) NSMutableArray *modelArray;
@property (strong,nonatomic) NSMutableArray *selectModelArray;

@property (assign,nonatomic) BOOL noSelectAllFlag;//YES:全不选,NO:全选

@property (strong,nonatomic) UILabel *tipLabel;

@end

@implementation HWFBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    [self initView];
}

#warning ------------点击出现线条？？

- (void)initData {
    self.modelArray = [[NSMutableArray alloc]init];
    self.selectModelArray = [[NSMutableArray alloc]init];
    
    [self loadDataWithLoging:YES];
}

- (void)initView {
    self.title = @"黑名单";
    [self addBackBarButtonItem];
    [self addRightBarButtonItemWithImage:nil activeImage:nil title:@"全选" target:self action:@selector(selectAll:)];
    [self.recoverButton setTitle:@"恢复选中设备" forState:UIControlStateNormal];
    [self.recoverButton setTitleColor:COLOR_HEX(0x999999) forState:UIControlStateNormal];
    
    [self.blackListTableView registerNib:[UINib nibWithNibName:@"HWFBlackListCell" bundle:nil] forCellReuseIdentifier:@"BlackListCell"];
    
    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.tipLabel.text = @"当前未发现被断开设备";
    self.tipLabel.textColor = [UIColor colorWithWhite:0.667 alpha:1.000];
    self.tipLabel.font = [UIFont systemFontOfSize:17.0];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.blackListTableView addSubview:self.tipLabel];
    self.tipLabel.hidden = YES;
}

- (void)loadDataWithLoging:(BOOL)loadingFlag{
    if (self.modelArray.count > 0) {
        [self.modelArray removeAllObjects];
    }
    if (loadingFlag) {
        [self loadingViewShow];
    }
    [[HWFService defaultService]loadBlackListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if (loadingFlag) {
            [self loadingViewHide];
        }
        if (code == CODE_SUCCESS) {
            DDLogDebug(@"-----%@",data);
            NSArray *blackListArr = [data objectForKey:@"black_list"];
            if (blackListArr.count <= 0) {
                [self refreshUIWithTabelViewrefresh:NO];
            } else {
                //model
                for (NSDictionary *device in blackListArr) {
                    HWFBlackListModel *blackModel = [[HWFBlackListModel alloc]init];
                    blackModel.selectType = HWFSelectType_None;
//                    blackModel.RPT = 
                    blackModel.MAC = [device objectForKey:@"mac"];
                    blackModel.name = [device objectForKey:@"name"];
                    [self.modelArray addObject:blackModel];
                }
                [self refreshUIWithTabelViewrefresh:YES];
            }
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFBlackListCell *cell = [self.blackListTableView dequeueReusableCellWithIdentifier:@"BlackListCell"];
    [cell loadDataWith:self.modelArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFBlackListModel *selectModel = self.modelArray[indexPath.row];
    if (selectModel.selectType == HWFSelectType_None) {
        selectModel.selectType = HWFSelectType_Select;
        [self.selectModelArray addObject:selectModel];
    } else {
        selectModel.selectType = HWFSelectType_None;
        [self.selectModelArray removeObject:selectModel];
    }
    
    [self refreshUIWithTabelViewrefresh:YES];
}

//全选
- (void)selectAll:(UIButton*)sender {
    //把之前选的全删掉
    if (self.selectModelArray.count > 0) {
        [self.selectModelArray removeAllObjects];
    }
    if (self.noSelectAllFlag) {
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        for (HWFBlackListModel *model in self.modelArray) {
            model.selectType = HWFSelectType_None;
            self.noSelectAllFlag = NO;
        }
    }else {
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        for (HWFBlackListModel *model in self.modelArray) {
            model.selectType = HWFSelectType_Select;
            self.noSelectAllFlag = YES;
            [self.selectModelArray addObject:model];
        }
    }
    [self refreshUIWithTabelViewrefresh:YES];
}

#warning ----------恢复选中设备
//恢复选中设备
- (IBAction)recoverAction:(UIButton *)sender {
    if (self.selectModelArray.count <= 0) {
        [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"请选择需要恢复的设备"];
    } else {
        [self loadingViewShow];
        [[HWFService defaultService]removeFromBlackListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] devices:self.selectModelArray completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            [self loadingViewHide];
            if (code == CODE_SUCCESS) {
                
                [self showTipWithType:HWFTipTypeSuccess code:CODE_SUCCESS message:@"恢复成功"];

                if ([self.delegate respondsToSelector:@selector(refreshDeviceList)]) {
                    [self.delegate performSelector:@selector(refreshDeviceList)];
                }
                //恢复设备列表(UI)
                for (HWFBlackListModel *model in self.selectModelArray) {
                    [self.modelArray removeObject:model];
                }
                [self.selectModelArray removeAllObjects];
                
                [self refreshUIWithTabelViewrefresh:YES];
                
            } else {
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
        }];
    }
}

- (void)refreshUIWithTabelViewrefresh:(BOOL)refreshTableView {
    if (self.modelArray.count <= 0) {
        self.tipLabel.hidden = NO;
    } else {
        self.tipLabel.hidden = YES;
    }
    
    if (self.selectModelArray.count <= 0) {
        [self.recoverButton setTitle:@"恢复选中设备" forState:UIControlStateNormal];
        [self.recoverButton setTitleColor:COLOR_HEX(0x999999) forState:UIControlStateNormal];
    } else {
        [self.recoverButton setTitle:[NSString stringWithFormat:@"恢复选中设备 %lu台",(unsigned long)[self.selectModelArray count]] forState:UIControlStateNormal];
        [self.recoverButton setTitleColor:COLOR_HEX(0x30b0f8) forState:UIControlStateNormal];
    }
    
    if (refreshTableView) {
        [self.blackListTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
