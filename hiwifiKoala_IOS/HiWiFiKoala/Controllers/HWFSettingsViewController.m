//
//  HWFSettingsViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFSettingsViewController.h"
#import "HWFSettingFirstCellLogin.h"
#import "HWFSettingFirstCellNotLogin.h"
#import "HWFUser.h"
#import "HWFAPIListViewController.h"
#import "HWFModifyDataViewController.h"
#import "HWFService+User.h"
#import "HWFLoginViewController.h"
#import "HWFNavigationController.h"

@interface HWFSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
@property (strong,nonatomic) NSMutableArray *settingDataSource;
- (IBAction)logout:(id)sender;

@end

@implementation HWFSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.settingDataSource = [[NSMutableArray alloc] init];
    [self.settingDataSource addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleDesc title:[NSString stringWithFormat:@"APP版本"] subTitle:APP_VERSION desc:@"已是最新" switchOn:NO buttonTitle:nil]];
    BOOL remoteFlag = [[NSUserDefaults standardUserDefaults] boolForKey:kRemoteNotificationStatus];
    
    [self.settingDataSource addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"2" style:GeneralTableViewCellStyleSwitch title:@"推送通知" desc:nil switchOn:remoteFlag buttonTitle:nil]];
    [self.settingDataSource addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"3" style:GeneralTableViewCellStyleArrow title:@"意见反馈" desc:nil switchOn:NO buttonTitle:nil]];
    [self.settingDataSource addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"4" style:GeneralTableViewCellStyleArrow title:@"去评分" desc:nil switchOn:NO buttonTitle:nil]];
    [self.settingDataSource addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"5" style:GeneralTableViewCellStyleArrow title:@"关于" desc:nil switchOn:NO buttonTitle:nil]];
#ifdef GOD_MODE
    [self.settingDataSource addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"6" style:GeneralTableViewCellStyleArrow title:[NSString stringWithFormat:@"API"] subTitle:BUILD_VERSION desc:nil switchOn:NO buttonTitle:nil]];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initView {
    self.title = @"设置";
    [self addBackBarButtonItem];
    //self.settingTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.settingTableView registerNib:[UINib nibWithNibName:@"HWFGeneralTableViewCell" bundle:nil] forCellReuseIdentifier:@"GeneralTableViewCell"];
    [self.settingTableView registerNib:[UINib nibWithNibName:@"HWFSettingFirstCellLogin" bundle:nil] forCellReuseIdentifier:@"HWFSettingFirstCellLogin"];
    [self.settingTableView registerNib:[UINib nibWithNibName:@"HWFSettingFirstCellNotLogin" bundle:nil] forCellReuseIdentifier:@"HWFSettingFirstCellNotLogin"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessHandle) name:kNotificationUserLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avatarModifyHandle) name:kNotificationUserAvatarModify object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }else{
        return [self.settingDataSource count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if([HWFUser defaultUser] != nil){
            HWFSettingFirstCellLogin *cell = (HWFSettingFirstCellLogin *)[tableView dequeueReusableCellWithIdentifier:@"HWFSettingFirstCellLogin"];
            cell.delegate=self;
            [cell loadData:[HWFUser defaultUser]];
            return cell;
        }else{
            HWFSettingFirstCellNotLogin *cell = (HWFSettingFirstCellNotLogin *)[tableView dequeueReusableCellWithIdentifier:@"HWFSettingFirstCellNotLogin"];
            cell.delegate = self;
            return cell;
        }
    }else{
        HWFGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell"];
        [cell loadData:self.settingDataSource[indexPath.row]];
        cell.delegate = self;
        return cell;
    }
}

#pragma mark - HWFGeneraTableViewCellDelegate

- (void)descSwitchChanged:(HWFGeneralTableViewCell *)aCell{
    BOOL flag = aCell.item.isSwitchOn;
    if (flag) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    } else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    [[NSUserDefaults standardUserDefaults] setBool: flag forKey:kRemoteNotificationStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - HWFSettingFirstCellLoginDelegate

- (void)manageButtonClick {
    HWFModifyDataViewController *manageController = [[HWFModifyDataViewController alloc] initWithNibName:@"HWFModifyDataViewController" bundle:nil];
    manageController.delegate = self;
    [self.navigationController pushViewController:manageController animated:YES];
}

#pragma mark - HWFSettingFirstCellNotLoginDelegate

- (void)loginButtonClick {
    if ([self.delegate respondsToSelector:@selector(login)]) {
        [self.delegate performSelector:@selector(login)];
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - HWFModifyDataViewControllerDelegate

- (void)modifyDataSuccess {
    [self.settingTableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==0){
        return 16;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        if([HWFUser defaultUser] != nil){
            return 74;
        }else{
            return 45;
        }
    }else{
        return 45;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if([HWFUser defaultUser] != nil) {
            HWFModifyDataViewController *manageController = [[HWFModifyDataViewController alloc] initWithNibName:@"HWFModifyDataViewController" bundle:nil];
            manageController.delegate = self;
            [self.navigationController pushViewController:manageController animated:YES];
        }else{
            HWFLoginViewController *loginViewController = [[HWFLoginViewController alloc] initWithNibName:@"HWFLoginViewController" bundle:nil];
            HWFNavigationController *navigationController = [[HWFNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:^{
                // nothing.
            }];
        }
    } else if(indexPath.section == 1) {
        HWFGeneralTableViewCell *cell= (HWFGeneralTableViewCell *)[self.settingTableView cellForRowAtIndexPath:indexPath];
        if ([cell.item.identity isEqualToString:@"3"]) {
            // 意见反馈
        }else if([cell.item.identity isEqualToString:@"4"]){
            // 去评分
        }else if([cell.item.identity isEqualToString:@"5"]){
            // 关于
        }else if([cell.item.identity isEqualToString:@"6"]){
            // 测试
            HWFAPIListViewController *APIListViewController = [[HWFAPIListViewController alloc] initWithNibName:@"HWFAPIListViewController" bundle:nil];
            [self.navigationController pushViewController:APIListViewController animated:YES];
        }
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - 退出登录
- (IBAction)logout:(id)sender {
    [self loadingViewShow];
    [[HWFService defaultService] logoutCompletion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            [self.settingTableView reloadData];
            [self showTipWithType:HWFTipTypeSuccess code:CODE(data) message:msg];
        }else{
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            
        }
    }];
}



- (void)loginSuccessHandle {
    [self.settingTableView reloadData];
}

- (void)avatarModifyHandle {
    [self.settingTableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserLogin object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserAvatarModify object:nil];
}

@end
