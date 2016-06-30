//
//  HWFAPIListViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFAPIListViewController.h"

#import "HWFAPI.h"
#import "HWFAPIDetailViewController.h"
#import "HWFSceneViewController.h"
#import "HWFGeneralTableViewController.h"
#import "HWFWebViewController.h"
#import "HWFService.h"

#define HEIGHT_TABLEVIEW_CELL   28.0
#define HEIGHT_TABLEVIEW_HEADER 14.0

@interface HWFAPIListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *APIs;
@property (weak, nonatomic) IBOutlet UITableView *APITableView;

@end

@implementation HWFAPIListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"API";
    
    [self addBackBarButtonItem];
    
    self.APITableView.delegate = self;
    self.APITableView.dataSource = self;
    [self.APITableView registerNib:[UINib nibWithNibName:@"HWFAPITableViewCell" bundle:nil] forCellReuseIdentifier:@"APICell"];
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

- (NSArray *)APIs {
    if (!_APIs) {
        _APIs = @[
                      @[
                          [[HWFAPI alloc] initWithAPIName:@"清空缓存" identity:API_CLEAR_CACHE mark:nil],
                      ],
                      @[
                          [[HWFAPI alloc] initWithAPIName:@"检测App升级信息" identity:API_APP_UPGRADE_INFO mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"加载云端位置映射关系" identity:API_GET_CLOUD_PLACEMAP mark:nil],
                      ],
                      @[
                          [[HWFAPI alloc] initWithAPIName:@"登录 [kaol2046]" identity:API_LOGIN mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"退出" identity:API_LOGOUT mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取用户详细信息" identity:API_GET_PROFILE mark:nil],
                      ],
                      @[
                          [[HWFAPI alloc] initWithAPIName:@"获取路由器列表" identity:API_GET_ROUTER_LIST mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取用户下所有路由器的ClientSecret" identity:API_OPENAPI_BIND mark:@"ALL"],
                          [[HWFAPI alloc] initWithAPIName:@"获取当前路由器的ClientSecret" identity:API_OPENAPI_BIND mark:@"SINGLE"],
                          [[HWFAPI alloc] initWithAPIName:@"获取当前路由器的详细信息" identity:API_GET_ROUTER_DETAIL mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取当前路由器的实时流量" identity:API_GET_ROUTER_TRAFFIC mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取当前路由器的历史流量" identity:API_GET_ROUTER_TRAFFIC_HISTORY mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取当前路由器的IP和NP" identity:API_GET_ROUTER_IP_NP mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取当前路由器的拓扑结构" identity:API_GET_ROUTER_TOPOLOGY mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取流量历史详细信息" identity:API_GET_ROUTER_TRAFFIC_HISTORY_DETAIL mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取连接历史详细信息" identity:API_GET_ROUTER_ONLINE_HISTORY_DETAIL mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取WAN口信息" identity:API_GET_WAN_INFO mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取智能控制信息大接口" identity:API_GET_ROUTER_CONTROL_OVERVIEW mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取ROM升级信息" identity:API_GET_ROM_UPGRADE_INFO mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取当前路由器的型号" identity:API_GET_MODEL mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取当前路由器体检信息" identity:API_GET_ROUTER_EXAM_RESULT mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取直连路由器的相关信息" identity:API_GET_CONNECTEDROUTER_INFO mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取路由器绑定的用户信息" identity:API_GET_BINDUSER mark:nil],
                      ],
                      @[
                          [[HWFAPI alloc] initWithAPIName:@"重启路由器" identity:API_ROUTER_REBOOT mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取一键加速列表" identity:API_PARTSPEEDUP_LIST mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取当前WiFi信道" identity:API_GET_WIFI_CHANNEL mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"扫描周围所有WiFi信道质量" identity:API_GET_WIFI_CHANNEL_RANK mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取LED状态" identity:API_GET_LED_STATUS mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取2.4GWiFi状态" identity:API_GET_WIFI_STATUS_2_4G mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取5GWiFi状态" identity:API_GET_WIFI_STATUS_5G mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取2.4GWiFi休眠配置" identity:API_GET_WIFI_SLEEPCONFIG_2_4G mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取5GWiFi休眠配置" identity:API_GET_WIFI_SLEEPCONFIG_5G mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取路由器配置备份信息" identity:API_GET_ROUTER_BACKUP_INFO mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取穿墙模式" identity:API_GET_WIFI_WIDEMODE mark:nil],
                      ],
                      @[
                          [[HWFAPI alloc] initWithAPIName:@"获取当前连接的设备列表" identity:API_GET_DEVICE_LIST mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取黑名单" identity:API_GET_BLACKLIST mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"清空黑名单" identity:API_CLEAR_BLACKLIST mark:nil],
                      ],
                      @[
                          [[HWFAPI alloc] initWithAPIName:@"获取已安装插件数量" identity:API_GET_PLUGIN_INSTALLED_NUM mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取已安装插件列表" identity:API_GET_PLUGIN_INSTALLED_LIST mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取插件分类列表" identity:API_GET_PLUGIN_CATEGORY_LIST mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取分类下的插件列表 [1:云插件]" identity:API_GET_PLUGIN_LIST_IN_CATEGORY mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取插件的详细信息 [13:手机远程管理]" identity:API_GET_PLUGIN_DETAIL mark:nil],
                      ],
                      @[
                          [[HWFAPI alloc] initWithAPIName:@"获取存储分区列表" identity:API_GET_PARTITION_LIST mark:nil],
                      ],
                      @[
                          [[HWFAPI alloc] initWithAPIName:@"获取是否有未读消息" identity:API_GET_NEWMESSAGE_FLAG mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取消息列表" identity:API_GET_MESSAGE_LIST mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"设置所有消息为已读状态" identity:API_SET_ALL_MESSAGE_READ mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"清空消息列表" identity:API_CLEAR_MESSAGE_LIST mark:nil],
                          [[HWFAPI alloc] initWithAPIName:@"获取所有处于关闭状态的消息开关列表" identity:API_GET_CLOSE_MESSAGESWITCH_LIST mark:nil],
                      ],
                      @[
                          [[HWFAPI alloc] initWithAPIName:@"Web Admin" identity:0 mark:@"WebAdmin"],
                          [[HWFAPI alloc] initWithAPIName:@"UI Scene" identity:0 mark:@"UI"],
                          [[HWFAPI alloc] initWithAPIName:@"Show LoadingView" identity:0 mark:@"LoadingView"],
                          [[HWFAPI alloc] initWithAPIName:@"Show HUD" identity:0 mark:@"HUD"],
                          [[HWFAPI alloc] initWithAPIName:@"General TableView Cell" identity:0 mark:@"GeneralCells"],
                      ],
                  ];
    }
    return _APIs;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.APIs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.APIs[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEIGHT_TABLEVIEW_HEADER;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HEIGHT_TABLEVIEW_CELL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFAPITableViewCell *cell = (HWFAPITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"APICell"];
    
    HWFAPI *API = self.APIs[indexPath.section][indexPath.row];
    [cell loadData:API];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFAPI *API = self.APIs[indexPath.section][indexPath.row];
 
    if ([API.mark isEqualToString:@"UI"]) {
        HWFSceneViewController *POPViewController = [[HWFSceneViewController alloc] initWithNibName:@"HWFSceneViewController" bundle:nil];
        [self.navigationController pushViewController:POPViewController animated:YES];
    } else if ([API.mark isEqualToString:@"LoadingView"]) {
        [self performSelector:@selector(loadingViewShow) withObject:nil afterDelay:0.0];
        [self performSelector:@selector(loadingViewShow) withObject:nil afterDelay:1.0];
        [self performSelector:@selector(loadingViewHide) withObject:nil afterDelay:2.0];
        [self performSelector:@selector(loadingViewShow) withObject:nil afterDelay:3.0];
        [self performSelector:@selector(loadingViewHide) withObject:nil afterDelay:4.0];
        [self performSelector:@selector(loadingViewHide) withObject:nil afterDelay:5.0];
    } else if ([API.mark isEqualToString:@"HUD"]) {
        [self showTipWithType:HWFTipTypeSuccess code:CODE_NIL message:@"成功"];
    } else if ([API.mark isEqualToString:@"GeneralCells"]) {
        HWFGeneralTableViewController *generalTableViewController = [[HWFGeneralTableViewController alloc] initWithNibName:@"HWFGeneralTableViewController" bundle:nil];
        [self.navigationController pushViewController:generalTableViewController animated:YES];
    } else if ([API.mark isEqualToString:@"WebAdmin"]) {
        HWFWebViewController *webAdminWebViewController = [[HWFWebViewController alloc] initWithNibName:@"HWFWebViewController" bundle:nil];
        webAdminWebViewController.HTTPMethod = HTTPMethodGet;
        webAdminWebViewController.URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_WEB_WEBADMIN];
        [self.navigationController pushViewController:webAdminWebViewController animated:YES];
    } else {
        HWFAPIDetailViewController *APIDetailViewController = [[HWFAPIDetailViewController alloc] initWithNibName:@"HWFAPIDetailViewController" bundle:nil];
        [APIDetailViewController loadData:API completion:^(APIResult aResult) {
            API.result = aResult;
            [self.APITableView reloadData];
        }];
        
        [self.navigationController pushViewController:APIDetailViewController animated:YES];
    }
}

// 取消Section.HeaderView随动
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGFloat sectionHeaderHeight = HEIGHT_TABLEVIEW_HEADER; //sectionHeaderHeight
    if (aScrollView.contentOffset.y<=sectionHeaderHeight&&aScrollView.contentOffset.y>=0) {
        aScrollView.contentInset = UIEdgeInsetsMake(-aScrollView.contentOffset.y, 0, 0, 0);
    } else if (aScrollView.contentOffset.y>=sectionHeaderHeight) {
        aScrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

@end
