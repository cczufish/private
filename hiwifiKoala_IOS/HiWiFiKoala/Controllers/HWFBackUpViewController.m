//
//  HWFBackUpViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFBackUpViewController.h"
#import "HWFService+Router.h"
#import "HWFGatewayRouterCell.h"

@interface HWFBackUpViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *backupTableView;
@property (nonatomic,strong) NSMutableArray *backupArray;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *backUpTimeLabel;
@property (strong, nonatomic) IBOutlet UIView *infoBgView;

@end

@implementation HWFBackUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
    [self loadBackUpMessageWithLoading:YES];
}

- (void)initData {
    self.backupArray  = [[NSMutableArray alloc]init];
}

- (void)initView {
    self.backupTableView.hidden = YES;
    self.title = @"备份还原";
    [self addBackBarButtonItem];
    self.infoLabel.text = @"可备份或还原设备名称、限速设备、可疑设备及信任设备";
    [self.backupTableView registerNib:[UINib nibWithNibName:@"HWFGatewayRouterCell" bundle:nil] forCellReuseIdentifier:@"GatewayRouterCell"];
    
    self.backupTableView.tableHeaderView = self.infoBgView;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.backupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFGatewayRouterCell *cell = (HWFGatewayRouterCell *)[tableView dequeueReusableCellWithIdentifier:@"GatewayRouterCell"];
    [cell loadDataWithInfo:self.backupArray[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.backupArray.count == 1) {
        //备份
        NSLog(@"备份");
        [self backUpAction];
    } else if (self.backupArray.count == 2) {
        if (indexPath.section == 0) {
            //备份
             NSLog(@"备份");
            [self backUpAction];

        } else if (indexPath.section == 1){
            //还原
             NSLog(@"还原");
            [self restoreAction];
        }
    }
}

#pragma mark -  获取配置备份信息
- (void)loadBackUpMessageWithLoading:(BOOL)loadingFlag {
    if (self.backupArray.count > 0) {
        [self.backupArray removeAllObjects];
    }
    if (loadingFlag) {
        [self loadingViewShow];
    }
    [[HWFService defaultService]loadRouterBackupInfoWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        self.backupTableView.hidden = NO;
        if (loadingFlag) {
            [self loadingViewHide];
        }
        NSLog(@"%@",data);
        if (code == CODE_SUCCESS) {
            if ([[data objectForKey:@"has_backup"]intValue] == 1) {
                [self.backupArray addObject:@"备份"];
                [self.backupArray addObject:@"还原(会重新启动)"];
                self.backUpTimeLabel.text = [NSString stringWithFormat:@"上次备份: %@",[data objectForKey:@"backup_time"]];
                
            } else if ([[data objectForKey:@"has_backup"]intValue] == 0) {
                [self.backupArray addObject:@"备份"];
            }
            [self.backupTableView reloadData];
        } else {
            self.backupTableView.hidden = YES;
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - 备份
- (void)backUpAction {
    [self loadingViewShow];
    [[HWFService defaultService] backupUserConfigWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            [self loadBackUpMessageWithLoading:NO];
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - 还原
- (void)restoreAction {
    [self loadingViewShow];
    [[HWFService defaultService]restoreUserConfigWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            [self loadBackUpMessageWithLoading:NO];
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
