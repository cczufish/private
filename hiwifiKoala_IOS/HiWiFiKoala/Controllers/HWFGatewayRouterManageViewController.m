//
//  HWFGatewayRouterManageViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/22.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFGatewayRouterManageViewController.h"
#import "HWFGeneralTableViewCell.h"
#import "HWFGatewayRouterCell.h"
#import "HWFRomVersionCell.h"
#import "HWFLocationViewController.h"
#import "HWFBackUpViewController.h"
#import "HWFDiskManagerViewController.h"
#import "HWFService+Router.h"
#import "HWFWebViewController.h"
#import "HWFWANManageViewController.h"
#import "HWFService+RouterControl.h"
#import "HWFWiFiSleepViewController.h"
#import <MBProgressHUD.h>
#import "HWFDeviceDetailCell.h"
#import "HWFModifyAdminPwdViewController.h"
#import "UIViewExt.h"

#define TAG_RomUpgrade_ALERTVIEW 200

#define TAG_Reboot_ActionSheet 300
#define TAG_Unbind_ActionSheet 301
#define TAG_UnbindRouter_ActionSheet 303


@interface HWFGatewayRouterManageViewController ()<
                                                    UITableViewDataSource,
                                                    UITableViewDelegate,
                                                    UIAlertViewDelegate,
                                                    HWFGeneralTableViewCellDelegate,
                                                    UIActionSheetDelegate
                                                    >

@property (weak, nonatomic) IBOutlet UITableView *gatewayRoutTableView;
//不在线
@property (nonatomic,strong) NSMutableArray *notOnlieArr;

//在线
@property (nonatomic,strong) NSMutableArray *firstItems;
@property (nonatomic,strong) NSMutableArray *secondItems;
@property (nonatomic,strong) NSMutableArray *thirdItems;
@property (nonatomic,strong) NSMutableArray *fourItems;
@property (nonatomic,strong) NSMutableArray *fiveItems;
@property (nonatomic,strong) NSMutableArray *sixItems;
@property (nonatomic,strong) NSMutableArray *sevenItems;
@property (nonatomic,strong) NSMutableArray *eightItems;

@property (nonatomic,strong) NSMutableArray *allItemsArray;

//rom升级
@property (nonatomic,strong) NSString *romVersion;
@property (nonatomic,strong) NSString *romChangeLog;
//重启路由器
@property (nonatomic,strong) MBProgressHUD *rebootHUD;
@property (nonatomic,strong)NSTimer *rebootTimer;

//恢复出厂设置
@property (weak, nonatomic) IBOutlet UIButton *maskButton;
@property (strong, nonatomic) IBOutlet UIView *recoverFactorySettingBgView;
@property (weak, nonatomic) IBOutlet UITextField *recoverTextField;

@end

@implementation HWFGatewayRouterManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
    
    if ([[HWFRouter defaultRouter]isOnline]) {
        [self loadData];
    }
}

- (void)startRebootTimer {
    if (!self.rebootTimer) {
        self.rebootTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doSecondCount) userInfo:nil repeats:YES];
    }
}

- (void)doSecondCount {
    NSInteger timeRemaining = [self.rebootHUD.detailsLabelText intValue];
    timeRemaining--;
    if (timeRemaining < 0) {
        [self stopRebootTimer];
        [self.rebootHUD hide:YES];
        [self showTipWithType:HWFTipTypeSuccess code:CODE_SUCCESS message:@"重启成功"];
        
        //重新加载数据
        [self loadData];
    } else {
        self.rebootHUD.detailsLabelText = [NSString stringWithFormat:@"%ld",(long)timeRemaining];
    }
}

- (void)stopRebootTimer {
    if (self.rebootTimer) {
        [self.rebootTimer invalidate];
        self.rebootTimer = nil;
    }
}

- (void)initData {
    
    if ([[HWFRouter defaultRouter]isOnline]) {
        self.firstItems = [[NSMutableArray alloc]init];
        self.secondItems = [[NSMutableArray alloc]init];
        self.thirdItems = [[NSMutableArray alloc]init];
        self.fourItems = [[NSMutableArray alloc]init];
        self.fiveItems = [[NSMutableArray alloc]init];
        self.sixItems = [[NSMutableArray alloc]init];
        self.sevenItems = [[NSMutableArray alloc]init];
        self.eightItems = [[NSMutableArray alloc]init];
        self.allItemsArray = [[NSMutableArray alloc]init];
        
    } else {
        //不在线
        self.notOnlieArr = [[NSMutableArray alloc]init];
        [self.notOnlieArr addObject:@"解除路由器绑定"];
    }
}

- (void)initView {
    self.title = [[HWFRouter defaultRouter] name];
    [self.gatewayRoutTableView registerNib:[UINib nibWithNibName:@"HWFGeneralTableViewCell" bundle:nil] forCellReuseIdentifier:@"GeneralTableViewCell"];
    [self.gatewayRoutTableView registerNib:[UINib nibWithNibName:@"HWFGatewayRouterCell" bundle:nil] forCellReuseIdentifier:@"GatewayRouterCell"];
    [self.gatewayRoutTableView registerNib:[UINib nibWithNibName:@"HWFRomVersionCell" bundle:nil] forCellReuseIdentifier:@"RomVersionCell"];
    [self.gatewayRoutTableView registerNib:[UINib nibWithNibName:@"HWFDeviceDetailCell" bundle:nil] forCellReuseIdentifier:@"DeviceDetailCell"];
    
    //恢复出厂设置ui
    self.maskButton.alpha = 0.5;
    [self.view addSubview:self.recoverFactorySettingBgView];
    self.recoverFactorySettingBgView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem: self.recoverFactorySettingBgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:280];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem: self.recoverFactorySettingBgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-280];
    topConstraint.identifier = @"recoverTopCons";
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem: self.recoverFactorySettingBgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem: self.recoverFactorySettingBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.view addConstraints:@[heightConstraint,topConstraint,leadingConstraint,trailingConstraint]];
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];

}

#pragma mark - 大接口
- (void)loadData {
    
    //rom信息
    [self performSelector:@selector(loadRomInfo) withObject:self afterDelay:0.0];
    
    //大接口
    //        "backup_date" = "2014-10-25 12:26:32";
    //        "device_model" = HC5761;
    //        "led_status" = 1;
    //        mac = D4EE070B1C38;
    //        place = "";
    //        "rom_version" = "0.9008.0.6969s";
    //        "wan_type" = dhcp;
    //        "wifi_24g" =     {
    //            ssid = "HiWiFi_0B1C38";
    //            status = 1;
    //        };
    //        "wifi_5g" =     {
    //            ssid = "HiWiFi_0B1C38_5G";
    //            status = 1;
    //        };
    //    }
    /*
     {
     "backup_date" = 0;
     "device_model" = HC5761;
     "led_status" = 1;
     mac = D4EE07056312;
     place = "";
     "rom_version" = "0.9008.0.7186s";
     "wan_type" = dhcp;
     "wifi_24g" =     {
     ssid = "HiWiFi_056312";
     status = 1;
     };
     "wifi_24g_sleep" =     {
     netid = "radio0.network1";
     status = 0;
     "wifi_id" = master;
     };
     "wifi_5g" =     {
     ssid = "HiWiFi_056312_5G";
     status = 1;
     };
     "wifi_5g_sleep" =     {
     netid = "radio1.network1";
     status = 0;
     "wifi_id" = masterac;
     };
     */
    [self loadingViewShow];
    [[HWFService defaultService]loadRouterDetailWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        NSLog(@"大接口============%@",data);
        if (code == CODE_SUCCESS) {
            
            if ([[data allKeys] count] <= 0) {
                [self showTipWithType:HWFTipTypeFailure code:CODE_NIL message:@"无数据"];
                return ;
            }
            
            [self.secondItems addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"21" style:GeneralTableViewCellStyleDescArrow title:@"位置" desc:@"门厅" switchOn:NO buttonTitle:nil]];
            [self.secondItems  addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"22" style:GeneralTableViewCellStyleDesc title:@"昵称" desc:[HWFRouter defaultRouter].name switchOn:NO buttonTitle:nil]];
            [self.allItemsArray addObject:self.secondItems];
            
            [self.thirdItems addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"31" style:GeneralTableViewCellStyleDescArrow title:@"硬件信息" desc:[[HWFRouter defaultRouter]model] switchOn:NO buttonTitle:nil]];
            
            if ([[HWFRouter defaultRouter]isOnline]) {
                [self.thirdItems  addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"32" style:GeneralTableViewCellStyleDescArrow title:@"上网设置" desc:@"已连接互联网" switchOn:NO buttonTitle:nil]];
            } else {
                [self.thirdItems  addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"32" style:GeneralTableViewCellStyleDescArrow title:@"上网设置" desc:@"已断开互联网" switchOn:NO buttonTitle:nil]];
            }
            [self.allItemsArray addObject:self.thirdItems];
            
#warning --------------定时开关---------------假接口
            //2.4g
            if ([[HWFRouter defaultRouter]hasWiFi24G]) {
                [self.fourItems insertObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"41" style:GeneralTableViewCellStyleSwitch title:@"WiFi开关（2.4G）" desc:nil switchOn:[[HWFRouter defaultRouter]WiFi24GStatus] buttonTitle:nil] atIndex:0];
                [self.fourItems insertObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"42" style:GeneralTableViewCellStyleDesc title:@"定时开关" desc:@"23:00关闭 | 06:00开启" switchOn:YES buttonTitle:nil] atIndex:1];
                [self.allItemsArray addObject:self.fourItems];
            }
            //5g
            if ([[HWFRouter defaultRouter]hasWiFi5G]) {
                [self.fiveItems insertObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"51" style:GeneralTableViewCellStyleSwitch title:@"WiFi开关（5G）" desc:nil switchOn:[[HWFRouter defaultRouter]WiFi5GStatus] buttonTitle:nil] atIndex:0];
                [self.fiveItems insertObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"52" style:GeneralTableViewCellStyleDesc title:@"定时开关" desc:@"未开启" switchOn:NO buttonTitle:nil] atIndex:1];
                [self.allItemsArray addObject:self.fiveItems];
            }
            
            [self.sixItems  addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"61" style:GeneralTableViewCellStyleArrow title:@"无线WiFi设置" desc:nil switchOn:NO buttonTitle:nil]];
            [self.sixItems insertObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"62" style:GeneralTableViewCellStyleSwitch title:@"路由器面板灯" desc:nil switchOn:[[HWFRouter defaultRouter]LEDStatus]  buttonTitle:nil] atIndex:1];
            [self.sixItems  addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"63" style:GeneralTableViewCellStyleArrow title:@"磁盘管理" desc:nil switchOn:NO buttonTitle:nil]];
            [self.sixItems  addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"64" style:GeneralTableViewCellStyleArrow title:@"备份还原" desc:nil switchOn:NO buttonTitle:nil]];
            [self.allItemsArray addObject:self.sixItems];
            
            [self.sevenItems addObject:@"重启路由器"];
            [self.sevenItems addObject:@"修改管理员密码"];
            [self.allItemsArray addObject:self.sevenItems];
            
            [self.eightItems addObject:@"解除路由器绑定"];
            [self.eightItems addObject:@"恢复出厂设置"];
            [self.allItemsArray addObject:self.eightItems];
            
            [self.gatewayRoutTableView reloadData];
            
        } else {
            
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - rom信息
- (void)loadRomInfo {
    [self loadingViewShow];
    [[HWFService defaultService] loadROMUpgradeInfoWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        NSLog(@"%@",data);
        if (code == CODE_SUCCESS) {
            if ([[data objectForKey:@"need_upgrade"]intValue] == 1) {
                //需要升级
                self.romVersion = [data objectForKey:@"version"];
                self.romChangeLog = [data objectForKey:@"changelog"];
                [self.firstItems addObject:[NSString stringWithFormat:@"有可用更新 版本号 “%@",self.romVersion]];
                [self.allItemsArray insertObject:self.firstItems atIndex:0];
                
            } else {
                //不需要升级
            }
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
// 取消Section.HeaderView随动
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGFloat sectionHeaderHeight = 15; //sectionHeaderHeight
    if (aScrollView.contentOffset.y<=sectionHeaderHeight&&aScrollView.contentOffset.y>=0) {
        aScrollView.contentInset = UIEdgeInsetsMake(-aScrollView.contentOffset.y, 0, 0, 0);
    } else if (aScrollView.contentOffset.y>=sectionHeaderHeight) {
        aScrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[HWFRouter defaultRouter]isOnline]) {
        return self.allItemsArray.count;
    } else {
        return self.notOnlieArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[HWFRouter defaultRouter]isOnline]) {
        if (section == 0) {
            return 0;
        } else {
            return 15;
        }
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if ([[HWFRouter defaultRouter]isOnline]) {
         return [self.allItemsArray[section]count];
     }else {
         return self.notOnlieArr.count;
     }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[HWFRouter defaultRouter]isOnline]) {
        if ([self.allItemsArray[indexPath.section][indexPath.row] isKindOfClass:[HWFGeneralTableViewItem class]]) {
            HWFGeneralTableViewCell *genneralCell = [tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell"];
            genneralCell.delegate = self;
            [genneralCell loadData:self.allItemsArray[indexPath.section][indexPath.row]];
            return genneralCell;
        } else if ([self.allItemsArray[indexPath.section][indexPath.row] isKindOfClass:[NSString class]] && [self.allItemsArray[indexPath.section][indexPath.row] hasPrefix:@"有可用更新"]) {
            HWFRomVersionCell *romVersionCell = [tableView dequeueReusableCellWithIdentifier:@"RomVersionCell"];
            [romVersionCell reloadWithString:self.firstItems[indexPath.row]];
            romVersionCell.identifier = @"rom升级";
            return romVersionCell;
        } else if ([self.allItemsArray[indexPath.section][indexPath.row] isKindOfClass:[NSString class]] && [self.allItemsArray[indexPath.section][indexPath.row] hasPrefix:@"重启路由器"]){
            HWFGatewayRouterCell *gatewayRouterCell = [tableView dequeueReusableCellWithIdentifier:@"GatewayRouterCell"];
            [gatewayRouterCell loadDataWithInfo:self.allItemsArray[indexPath.section][indexPath.row]];
                gatewayRouterCell.identifier = @"重启路由器";
            return gatewayRouterCell;
        }else if ([self.allItemsArray[indexPath.section][indexPath.row] isKindOfClass:[NSString class]] && [self.allItemsArray[indexPath.section][indexPath.row] hasPrefix:@"修改管理员密码"]){
            HWFGatewayRouterCell *gatewayRouterCell = [tableView dequeueReusableCellWithIdentifier:@"GatewayRouterCell"];
            [gatewayRouterCell loadDataWithInfo:self.allItemsArray[indexPath.section][indexPath.row]];
            gatewayRouterCell.identifier = @"修改管理员密码";
            return gatewayRouterCell;
        }else if ([self.allItemsArray[indexPath.section][indexPath.row] isKindOfClass:[NSString class]] && [self.allItemsArray[indexPath.section][indexPath.row] hasPrefix:@"解除路由器绑定"]){
            HWFGatewayRouterCell *gatewayRouterCell = [tableView dequeueReusableCellWithIdentifier:@"GatewayRouterCell"];
            [gatewayRouterCell loadDataWithInfo:self.allItemsArray[indexPath.section][indexPath.row]];
            gatewayRouterCell.identifier = @"解除路由器绑定";
            return gatewayRouterCell;
        }else if ([self.allItemsArray[indexPath.section][indexPath.row] isKindOfClass:[NSString class]] && [self.allItemsArray[indexPath.section][indexPath.row] hasPrefix:@"恢复出厂设置"]){
            HWFGatewayRouterCell *gatewayRouterCell = [tableView dequeueReusableCellWithIdentifier:@"GatewayRouterCell"];
            [gatewayRouterCell loadDataWithInfo:self.allItemsArray[indexPath.section][indexPath.row]];
            gatewayRouterCell.identifier = @"恢复出厂设置";
            return gatewayRouterCell;
        }
        
    } else {
        HWFDeviceDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailCell"];
        NSLog(@"%@",self.notOnlieArr[indexPath.row]);
        [detailCell loadDateWithString:self.notOnlieArr[indexPath.row]];
        return detailCell;
    }
    return nil;
    
    /*
    if ([[HWFRouter defaultRouter]isOnline]) {
        if (self.firstItems.count > 0 && self.fiveItems.count > 0) {
            NSLog(@"都有的时候");
            switch (indexPath.section) {
                case 0:
                {
                    HWFRomVersionCell *romVersionCell = [tableView dequeueReusableCellWithIdentifier:@"RomVersionCell"];
                    [romVersionCell reloadWithString:self.firstItems[indexPath.row]];
                    romVersionCell.identifier = @"rom升级";
                    return romVersionCell;
                }
                    break;
                    
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                {
                    HWFGeneralTableViewCell *genneralCell = [tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell"];
                    genneralCell.delegate = self;
//                    [genneralCell loadData:self.allItemsArray[indexPath.section][indexPath.row]];
                    if ([self.allItemsArray[indexPath.section][indexPath.row] isKindOfClass:[HWFGeneralTableViewItem class]]) {
                        [genneralCell loadData:self.allItemsArray[indexPath.section][indexPath.row]];
                    }
                    return genneralCell;
                }
                    break;
                    
                case 6:
                case 7:
                {
                    HWFGatewayRouterCell *gatewayRouterCell = [tableView dequeueReusableCellWithIdentifier:@"GatewayRouterCell"];
                    [gatewayRouterCell loadDataWithInfo:self.allItemsArray[indexPath.section][indexPath.row]];
                    if (indexPath.section == 6) {
                        gatewayRouterCell.identifier = @"重启路由器";
                    } else if (indexPath.section == 7) {
                        gatewayRouterCell.identifier = @"解除路由器绑定";
                    }
                    return gatewayRouterCell;
                }
                    break;
                    
                default:
                    break;
            }
        } else if (self.firstItems.count <= 0 && self.fiveItems.count <= 0) {
            
            NSLog(@"都没有的时候");
            switch (indexPath.section) {
                case 0:
                case 1:
                case 2:
                case 3:
                {
                    HWFGeneralTableViewCell *genneralCell = [tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell"];
                    genneralCell.delegate = self;
//                    [genneralCell loadData:self.allItemsArray[indexPath.section][indexPath.row]];
                    if ([self.allItemsArray[indexPath.section][indexPath.row] isKindOfClass:[HWFGeneralTableViewItem class]]) {
                        [genneralCell loadData:self.allItemsArray[indexPath.section][indexPath.row]];
                    }
                    return genneralCell;
                }
                    break;
                    
                case 4:
                case 5:
                {
                    HWFGatewayRouterCell *gatewayRouterCell = [tableView dequeueReusableCellWithIdentifier:@"GatewayRouterCell"];
                    [gatewayRouterCell loadDataWithInfo:self.allItemsArray[indexPath.section][indexPath.row]];
                    if (indexPath.section == 4) {
                        gatewayRouterCell.identifier = @"重启路由器";
                    } else if (indexPath.section == 5) {
                        gatewayRouterCell.identifier = @"解除路由器绑定";
                    }
                    return gatewayRouterCell;
                }
                    break;
                    
                default:
                    break;
            }
        } else if (self.firstItems.count > 0  && self.fiveItems.count <= 0 ) {
            NSLog(@"firstItems有，fiveItems无");
            switch (indexPath.section) {
                case 0:
                {
                    HWFRomVersionCell *romVersionCell = [tableView dequeueReusableCellWithIdentifier:@"RomVersionCell"];
                    [romVersionCell reloadWithString:self.firstItems[indexPath.row]];
                    romVersionCell.identifier = @"rom升级";
                    return romVersionCell;
                }
                    break;
                    
                case 1:
                case 2:
                case 3:
                case 4:
                {
                    HWFGeneralTableViewCell *genneralCell = [tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell"];
                    genneralCell.delegate = self;
                    if ([self.allItemsArray[indexPath.section][indexPath.row] isKindOfClass:[HWFGeneralTableViewItem class]]) {
                        [genneralCell loadData:self.allItemsArray[indexPath.section][indexPath.row]];
                    }
                    return genneralCell;
                }
                    break;
                    
                case 5:
                case 6:
                {
                    HWFGatewayRouterCell *gatewayRouterCell = [tableView dequeueReusableCellWithIdentifier:@"GatewayRouterCell"];
                    [gatewayRouterCell loadDataWithInfo:self.allItemsArray[indexPath.section][indexPath.row]];
                    if (indexPath.section == 5) {
                        gatewayRouterCell.identifier = @"重启路由器";
                    } else if (indexPath.section == 6) {
                        gatewayRouterCell.identifier = @"解除路由器绑定";
                    }
                    return gatewayRouterCell;
                }
                    break;
                    
                default:
                    break;
            }
        } else if (self.firstItems.count <= 0  && self.fiveItems.count > 0 ) {
            NSLog(@"firstItems无，fiveItems有");
            switch (indexPath.section) {
                case 0:
                case 1:
                case 2:
                case 3:
                case 4:
                {
                    HWFGeneralTableViewCell *genneralCell = [tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell"];
                    genneralCell.delegate = self;
//                    [genneralCell loadData:self.allItemsArray[indexPath.section][indexPath.row]];
                    if ([self.allItemsArray[indexPath.section][indexPath.row] isKindOfClass:[HWFGeneralTableViewItem class]]) {
                        [genneralCell loadData:self.allItemsArray[indexPath.section][indexPath.row]];
                    }
                    return genneralCell;
                }
                    break;
                    
                case 5:
                case 6:
                {
                    HWFGatewayRouterCell *gatewayRouterCell = [tableView dequeueReusableCellWithIdentifier:@"GatewayRouterCell"];
                    [gatewayRouterCell loadDataWithInfo:self.allItemsArray[indexPath.section][indexPath.row]];
                    if (indexPath.section == 5) {
                        gatewayRouterCell.identifier = @"重启路由器";
                    } else if (indexPath.section == 6) {
                        gatewayRouterCell.identifier = @"解除路由器绑定";
                    }
                    return gatewayRouterCell;
                }
                    break;
                    
                default:
                    break;
            }
        }
    } else  {
        //不在线
#warning ----------------why??
        HWFDeviceDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"DeviceDetailCell"];
        NSLog(@"%@",self.notOnlieArr[indexPath.row]);
        [detailCell loadDateWithString:self.notOnlieArr[indexPath.row]];
        return detailCell;
        
    }
    return nil;
     */
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[HWFRouter defaultRouter]isOnline]) {
        //在线
        if (self.firstItems.count > 0) {
            HWFRomVersionCell *romCell = (HWFRomVersionCell *)[tableView cellForRowAtIndexPath:indexPath];
            if ([romCell isKindOfClass:[HWFRomVersionCell class]] && [romCell.identifier isEqualToString:@"rom升级"]) {
                NSLog(@"rom升级");
                [self doRomUpgrade];
            }
        }
        
        if (self.secondItems.count > 0) {
            HWFGeneralTableViewCell *genCell = (HWFGeneralTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            if ([genCell isKindOfClass:[HWFGeneralTableViewCell class]] && [genCell.item.identity isEqualToString:@"21"]) {
                NSLog(@"位置");
                HWFLocationViewController *locationVC = [[HWFLocationViewController alloc]initWithNibName:@"HWFLocationViewController" bundle:nil];
                [self.navigationController pushViewController:locationVC animated:YES];
                
            }else if([genCell isKindOfClass:[HWFGeneralTableViewCell class]] && [genCell.item.identity isEqualToString:@"22"]) {
#warning -----------该名字
                NSLog(@"昵称");
                // [self setRouterName];
            }
        }
        
        if (self.thirdItems.count > 0) {
            HWFGeneralTableViewCell *genCell = (HWFGeneralTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            
            
            if ([genCell isKindOfClass:[HWFGeneralTableViewCell class]] && [genCell.item.identity isEqualToString:@"31"]) {
#warning -----------硬件信息
                NSLog(@"硬件信息");
                HWFWebViewController *webAdminWebViewController = [[HWFWebViewController alloc] initWithNibName:@"HWFWebViewController" bundle:nil];
                webAdminWebViewController.HTTPMethod = HTTPMethodGet;
                webAdminWebViewController.URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_WEB_HARDWARE_INFO];
                [self.navigationController pushViewController:webAdminWebViewController animated:YES];
                
            }else if([genCell isKindOfClass:[HWFGeneralTableViewCell class]] && [genCell.item.identity isEqualToString:@"32"]) {
#warning -----------硬件信息
                NSLog(@"上网设置");
                HWFWebViewController *webAdminWebViewController = [[HWFWebViewController alloc] initWithNibName:@"HWFWebViewController" bundle:nil];
                webAdminWebViewController.HTTPMethod = HTTPMethodGet;
                webAdminWebViewController.URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_WEB_NETWORK_CONFIG];
                [self.navigationController pushViewController:webAdminWebViewController animated:YES];
            }
            
        }
        
        if (self.fourItems.count > 0) {
            HWFGeneralTableViewCell *genCell = (HWFGeneralTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            if ([genCell isKindOfClass:[HWFGeneralTableViewCell class]] && [genCell.item.identity isEqualToString:@"41"]) {
#warning -----------wifi开关 2.4G------代理方法里面实现
                NSLog(@"WiFi开关（2.4G）");
                
            }else if([genCell isKindOfClass:[HWFGeneralTableViewCell class]] && [genCell.item.identity isEqualToString:@"42"]) {
#warning -----------定时开关
                NSLog(@"2.4g定时开关");
                HWFWiFiSleepViewController *wifiSleepVC = [[HWFWiFiSleepViewController alloc]initWithNibName:@"HWFWiFiSleepViewController" bundle:nil];
                wifiSleepVC.identifier = @"2.4g";
                [self.navigationController pushViewController:wifiSleepVC animated:YES];
            }
        }
        
        if (self.fiveItems.count > 0) {
            HWFGeneralTableViewCell *genCell = (HWFGeneralTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            if ([genCell isKindOfClass:[HWFGeneralTableViewCell class]] && [genCell.item.identity isEqualToString:@"51"]) {
#warning -----------wifi开关 5G-------代理方法里面实现
                NSLog(@"wifi开关 5G");
                
            }else if([genCell isKindOfClass:[HWFGeneralTableViewCell class]] && [genCell.item.identity isEqualToString:@"52"]) {
#warning -----------定时开关
                NSLog(@"5g定时开关");
                HWFWiFiSleepViewController *wifiSleepVC = [[HWFWiFiSleepViewController alloc]initWithNibName:@"HWFWiFiSleepViewController" bundle:nil];
                wifiSleepVC.identifier = @"5g";
                [self.navigationController pushViewController:wifiSleepVC animated:YES];
            }
        }
        
        if (self.sixItems.count > 0) {
            HWFGeneralTableViewCell *genCell = (HWFGeneralTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            if ([genCell isKindOfClass:[HWFGeneralTableViewCell class]] && [genCell.item.identity isEqualToString:@"61"]) {
#warning -----------无线wifi设置
                NSLog(@"无线wifi设置");
                HWFWebViewController *webAdminWebViewController = [[HWFWebViewController alloc] initWithNibName:@"HWFWebViewController" bundle:nil];
                webAdminWebViewController.HTTPMethod = HTTPMethodGet;
                webAdminWebViewController.URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_WEB_WIFI_CONFIG];
                [self.navigationController pushViewController:webAdminWebViewController animated:YES];
                
            }else if([genCell isKindOfClass:[HWFGeneralTableViewCell class]] && [genCell.item.identity isEqualToString:@"62"]) {
#warning -----------路由器面板灯
                NSLog(@"路由器面板灯");
                
            }else if([genCell isKindOfClass:[HWFGeneralTableViewCell class]] && [genCell.item.identity isEqualToString:@"63"]) {
#warning -----------磁盘管理－－－－－－－－暂无接口－－－－－－－－－－－
                NSLog(@"磁盘管理");
                HWFDiskManagerViewController *diskManagerVC = [[HWFDiskManagerViewController alloc]initWithNibName:@"HWFDiskManagerViewController" bundle:nil];
                [self.navigationController pushViewController:diskManagerVC animated:YES];
                
            }else if([genCell isKindOfClass:[HWFGeneralTableViewCell class]] && [genCell.item.identity isEqualToString:@"64"]) {
#warning -----------备份还原
                NSLog(@"备份还原");
                HWFBackUpViewController *backUpVC = [[HWFBackUpViewController alloc]initWithNibName:@"HWFBackUpViewController" bundle:nil];
                [self.navigationController pushViewController:backUpVC animated:YES];
            }
        }
        
        if (self.sevenItems.count > 0) {
            HWFGatewayRouterCell *routeCell = (HWFGatewayRouterCell *)[tableView cellForRowAtIndexPath:indexPath];
            if ([routeCell isKindOfClass:[HWFGatewayRouterCell class]] && [routeCell.identifier isEqualToString:@"重启路由器"]) {
#warning -----------重启路由器
                NSLog(@"重启路由器");
                [self reboot];
                
            } else if ([routeCell isKindOfClass:[HWFGatewayRouterCell class]] && [routeCell.identifier isEqualToString:@"修改管理员密码"]) {
#warning -----------修改管理员密码
                NSLog(@"修改管理员密码");
                HWFModifyAdminPwdViewController *modifyAdminPwd = [[HWFModifyAdminPwdViewController alloc]initWithNibName:@"HWFModifyAdminPwdViewController" bundle:nil];
                [self.navigationController pushViewController:modifyAdminPwd animated:YES];
            }
        }
        
        if (self.eightItems.count > 0) {
            HWFGatewayRouterCell *routeCell = (HWFGatewayRouterCell *)[tableView cellForRowAtIndexPath:indexPath];
            if ([routeCell isKindOfClass:[HWFGatewayRouterCell class]] && [routeCell.identifier isEqualToString:@"解除路由器绑定"]) {
#warning -----------解除路由器绑定
                NSLog(@"解除路由器绑定");
                [self unbind];
        
            } else if ([routeCell isKindOfClass:[HWFGatewayRouterCell class]] && [routeCell.identifier isEqualToString:@"恢复出厂设置"]) {
#warning -----------恢复出厂设置
                NSLog(@"恢复出厂设置");
                [self showRecoverFactorySettingViewAnimation];
            }
        }
        
    } else {
        //不在线
        //绑定极卫星
        UIActionSheet *rebootSheet = [[UIActionSheet alloc]initWithTitle:@"确定要解除路由器绑定吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解除绑定", nil];
        rebootSheet.tag = TAG_UnbindRouter_ActionSheet;
        rebootSheet.destructiveButtonIndex = 0;
        [rebootSheet showInView:self.view];
    }
    
}

#pragma mark - romUpgrade
- (void)doRomUpgrade {
    NSString *msg = [NSString stringWithFormat:@"请将您的路由器更新到最新版固件%@\n%@", self.romVersion, self.romChangeLog];
    UIAlertView *romUpgradeAlert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"现在更新", nil];
    [romUpgradeAlert setTag:TAG_RomUpgrade_ALERTVIEW];
    [romUpgradeAlert show];
}

#warning -----------------------没调用（缺样式设计）
#pragma mark - 设置路由器名字
- (void)setRouterName {
    [self loadingViewShow];
    [[HWFService defaultService] setRouterNameWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] newName:@"HiWiFi_C38" completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - 重启路由器
- (void)reboot
{
    
    if (![[HWFRouter defaultRouter]isOnline]) {
        [self showTipWithType:HWFTipTypeFailure code:CODE_NIL message:@"此路由器不在线"];
    } else {
        UIActionSheet *rebootSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重启路由器", nil];
        rebootSheet.tag = TAG_Reboot_ActionSheet;
        rebootSheet.destructiveButtonIndex = 0;
        [rebootSheet showInView:self.view];
    }
}

#pragma mark - 解除绑定
- (void)unbind{
    
    UIActionSheet *unbindSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解除路由器绑定", nil];
    unbindSheet.tag = TAG_Unbind_ActionSheet;
    unbindSheet.destructiveButtonIndex = 0;
    [unbindSheet showInView:self.view];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case TAG_RomUpgrade_ALERTVIEW://rom升级
        {
            if (buttonIndex == 0) {
                //取消
            } else {
#warning ----------调主页的一个代理方法
    
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case TAG_Reboot_ActionSheet:
        {
            if (buttonIndex == 0) {
                NSLog(@"重启路由器");
                //测试
                self.rebootHUD = [[MBProgressHUD alloc]initWithView:self.view];
                [self.view addSubview:self.rebootHUD];
                self.rebootHUD.dimBackground = YES;
                self.rebootHUD.labelText = @"重启中...";
                self.rebootHUD.detailsLabelText = @"90";
                [self.rebootHUD show:YES];
                
                [self startRebootTimer];
                
#warning --------真实数据－－－－－－－－－－－－－
                /*
                 [[HWFService defaultService]rebootRouterWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                 if (code == CODE_SUCCESS) {
                 self.rebootHUD = [[MBProgressHUD alloc]initWithView:self.view];
                 [self.view addSubview:self.rebootHUD];
                 self.rebootHUD.dimBackground = YES;
                 self.rebootHUD.labelText = @"重启中...";
                 self.rebootHUD.detailsLabelText = @"90";
                 [self.rebootHUD show:YES];
                 
                 [self startRebootTimer];
                 [HWFRouter defaultRouter].isOnline == NO;
                 
                 #warning --------------主页把名字修改
                 //                        if ([self.delegate respondsToSelector:@selector(refreshTitleView)]) {
                 //                            [self.delegate performSelector:@selector(refreshTitleView)];
                 //                        }
                 }
                 }];
                 */
            } else {
                
            }
        }
            break;
        case TAG_Unbind_ActionSheet:
        {
            if (buttonIndex == 0) {
                NSLog(@"解除路由器绑定");
                
                [[HWFService defaultService]unbindWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                 
                }];
                 
            } else {
                
            }
        }
            break;
        case TAG_UnbindRouter_ActionSheet:
        {
            if (buttonIndex == 0) {
                NSLog(@"离线时解除路由器绑定");
                
            } {
                
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - HWFGeneralTableViewCellDelegate
- (void)descSwitchChanged:(HWFGeneralTableViewCell *)aCell {
    DDLogDebug(@"Switch Changed : %@ / %d", aCell.item.title, aCell.item.isSwitchOn);
    if ([aCell.item.title isEqualToString:@"WiFi开关（2.4G）"]) {
        NSLog(@"WiFi开关（2.4G）");
        [[HWFService defaultService]setWiFiStatus24GWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] status:aCell.item.isSwitchOn completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            if (code == CODE_SUCCESS) {
                NSLog(@"成功了 阿 ");
#warning ===========修改数据源。刷新
                [self.fourItems replaceObjectAtIndex:0 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleSwitch title:@"WiFi开关（2.4G）" desc:nil switchOn:aCell.item.isSwitchOn buttonTitle:nil]];

            } else {
                [self.fourItems replaceObjectAtIndex:0 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleSwitch title:@"WiFi开关（2.4G）" desc:nil switchOn:!(aCell.item.isSwitchOn) buttonTitle:nil]];
              [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
            [self.gatewayRoutTableView reloadData];
        }];
    } else if ([aCell.item.title isEqualToString:@"WiFi开关（5G）"]) {
        NSLog(@"WiFi开关（5G）");
        [[HWFService defaultService]setWiFiStatus5GWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] status:aCell.item.isSwitchOn completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            if (code == CODE_SUCCESS) {
#warning ===========修改数据源。刷新
                [self.fiveItems replaceObjectAtIndex:0 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleSwitch title:@"WiFi开关（5G）" desc:nil switchOn:aCell.item.isSwitchOn buttonTitle:nil]];

            } else {
                [self.fiveItems replaceObjectAtIndex:0 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleSwitch title:@"WiFi开关（5G）" desc:nil switchOn:!(aCell.item.isSwitchOn) buttonTitle:nil]];
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
            [self.gatewayRoutTableView reloadData];
        }];
    } else if ([aCell.item.title isEqualToString:@"路由器面板灯"]) {
        NSLog(@"路由器面板灯");
        [[HWFService defaultService]setLEDStatusWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] status:aCell.item.isSwitchOn completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            if (code == CODE_SUCCESS) {
#warning ===========修改数据源。刷新
                [self.sixItems replaceObjectAtIndex:1 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"3" style:GeneralTableViewCellStyleSwitch title:@"路由器面板灯" desc:nil switchOn:aCell.item.isSwitchOn buttonTitle:nil]];
            } else {
                [self.sixItems replaceObjectAtIndex:1 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"3" style:GeneralTableViewCellStyleSwitch title:@"路由器面板灯" desc:nil switchOn:!(aCell.item.isSwitchOn) buttonTitle:nil]];
            }
            [self.gatewayRoutTableView reloadData];
        }];
    }
}

#pragma mark - 遮罩事件
- (IBAction)maskAction:(UIButton *)sender {
    [self hideRecoverFactorySettingViewAnimation];
}

#pragma mark - 取消
- (IBAction)cancleRecoverAction:(UIButton *)sender {
    [self hideRecoverFactorySettingViewAnimation];
}

#pragma mark - 确定,恢复出厂设置
- (IBAction)commitRecoverAction:(UIButton *)sender {
    //测试
    [self hideRecoverFactorySettingViewAnimation];

    //真实情况
    /*
    [self loadingViewShow];
    [[HWFService defaultService]resetRouterWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] adminPWD:nil completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            [self showTipWithType:HWFTipTypeSuccess code:CODE(data) message:@"恢复出厂设置成功"];
            [self hideRecoverFactorySettingViewAnimation];
            
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
     */
}

#pragma mark - 改名 - ui
- (void)showRecoverFactorySettingViewAnimation {
    NSArray *ary = self.view.constraints;
    for(NSLayoutConstraint *tempCons in ary) {
        if([tempCons.identifier isEqualToString: @"recoverTopCons"]) {
            tempCons.constant = 0;
        }
    }
    [ self.recoverTextField becomeFirstResponder];
    [self.maskButton setHidden:NO];
    [UIView animateWithDuration:0.3f animations:^{
        self.recoverFactorySettingBgView.top = 0;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)hideRecoverFactorySettingViewAnimation {
    NSArray *ary = self.view.constraints;
    for(NSLayoutConstraint *tempCons in ary) {
        if([tempCons.identifier isEqualToString: @"recoverTopCons"]) {
            tempCons.constant = -280;
        }
    }
    [self.recoverTextField resignFirstResponder];
    [self.maskButton setHidden:YES];
    [UIView animateWithDuration:0.3f animations:^{
        self.recoverFactorySettingBgView.top = -280;
    } completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
