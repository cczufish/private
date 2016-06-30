//
//  HWFMessageSettingViewController.m
//  HiWiFiKoala
//
//  Created by chang hong on 14-10-22.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFMessageSettingViewController.h"
#import "HWFService+MessageCenter.h"
@interface HWFMessageSettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *messageSettingTableView;
@property (strong ,nonatomic) NSMutableArray *settingDataSource;
@property (assign ,nonatomic) BOOL preventConnectFlag;
@property (assign ,nonatomic) BOOL speedUpFlag;
@property (assign ,nonatomic) BOOL downloadCompleteFlag;
@property (assign ,nonatomic) BOOL pluginFlag;
- (IBAction)doAllRead:(id)sender;
- (IBAction)doDeleteAllMessage:(id)sender;
@end

@implementation HWFMessageSettingViewController

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
    _preventConnectFlag = YES;
    _speedUpFlag = YES;
    _downloadCompleteFlag = YES;
    _pluginFlag = YES;
    _settingDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    [[HWFService defaultService] loadCloseMessageSwitchListWithUser:[HWFUser defaultUser] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if(code == CODE_SUCCESS) {
            if([[data objectForKey:@"msg"] isKindOfClass:[NSArray class]]) {
                NSArray *array = [data objectForKey:@"msg"];
                for (int i=0;i<array.count;i++) {
                    int temp = [array[i] intValue];
                    if(temp == 21) {
                        _preventConnectFlag = NO;
                    }else if (temp == 22) {
                        _speedUpFlag = NO;
                    }else if(temp ==61) {
                        _downloadCompleteFlag = NO;
                    }else if(temp == 51) {
                        _pluginFlag = NO;
                    }
                }
            }
            [_settingDataSource addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"21" style:GeneralTableViewCellStyleSwitch title:@"防蹭网提醒" desc:nil switchOn:_preventConnectFlag buttonTitle:nil]];
            [_settingDataSource addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"22" style:GeneralTableViewCellStyleSwitch title:@"加速结束提醒" desc:nil switchOn:_speedUpFlag buttonTitle:nil]];
            [_settingDataSource addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"61" style:GeneralTableViewCellStyleSwitch title:@"下载完成提醒" desc:nil switchOn:_downloadCompleteFlag buttonTitle:nil]];
            [_settingDataSource addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"61" style:GeneralTableViewCellStyleSwitch title:@"插件提醒" desc:nil switchOn:_pluginFlag buttonTitle:nil]];
            
            [self.messageSettingTableView reloadData];
        }else{
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
    
    
    
}

- (void)initView {
    self.title = @"设置";
    [self.messageSettingTableView registerNib:[UINib nibWithNibName:@"HWFGeneralTableViewCell" bundle:nil] forCellReuseIdentifier:@"GeneralTableViewCell"];
    [self.messageSettingTableView reloadData];
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

#pragma mark - DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.settingDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HWFGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell" forIndexPath:indexPath];
    [cell loadData:self.settingDataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - HWFGeneralTableViewCellDelegate

- (void)descSwitchChanged:(HWFGeneralTableViewCell *)aCell {
    BOOL flag = aCell.item.isSwitchOn;
    [self loadingViewShow];
    [[HWFService defaultService] setMessageSwitchStatusWithUser:[HWFUser defaultUser] messageSwitchType:[aCell.item.identity intValue] status:flag completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if(code == CODE_SUCCESS) {
            
        }else{
            for(HWFGeneralTableViewItem *item in self.settingDataSource) {
                if(item.identity == aCell.item.identity) {
                    item.isSwitchOn = !flag;
                }
            }
            [self.messageSettingTableView reloadData];
        }
        [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
    }];
}

- (IBAction)doAllRead:(id)sender {
    UIAlertView *allReadAlert = [[UIAlertView alloc] initWithTitle:nil message:@"将消息中心的全部消息标记为已读？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    allReadAlert.tag = 0;
    [allReadAlert show];
}

- (IBAction)doDeleteAllMessage:(id)sender {
    UIAlertView *deleteAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"删除所有消息后，将不能再找回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    deleteAlertView.tag = 1;
    [deleteAlertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        return;
    }
    [self loadingViewShow];
    if(alertView.tag == 0) {
        [[HWFService defaultService] setAllMessageReadWithUser:[HWFUser defaultUser] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            if(code == CODE_SUCCESS) {
                if([self.delegate respondsToSelector:@selector(setAllReadHandle)]) {
                    [self.delegate setAllReadHandle];
                }
            }else{
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
            [self loadingViewHide];
        }];
    }else{
        [[HWFService defaultService] clearMessageListWithUser:[HWFUser defaultUser] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            if(code == CODE_SUCCESS) {
                if([self.delegate respondsToSelector:@selector(deleteAllMessageHandle)]) {
                    [self.delegate deleteAllMessageHandle];
                }
            }else{
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
            [self loadingViewHide];
        }];
    }
}
@end
