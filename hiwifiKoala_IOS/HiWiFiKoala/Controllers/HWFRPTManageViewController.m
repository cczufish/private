//
//  HWFRPTManageViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/22.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFRPTManageViewController.h"
#import "HWFGeneralTableViewCell.h"
#import "HWFRPTManagerCell.h"
#import "HWFNetworkNode.h"
#import "HWFSmartDevice.h"
#import "HWFLocationViewController.h"
#import "HWFExtendWiFiCell.h"
#import "HWFService+SmartDevice.h"

#define TAG_BING_RPT 400
#define TAG_UNBIND_RPT 401

@interface HWFRPTManageViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,HWFLocationViewControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *rptTableView;
@property (nonatomic,strong)NSMutableArray *firstItem;
@property (nonatomic,strong)NSMutableArray *secondItem;

@property (nonatomic,assign)BOOL flag;//绑定了极卫星

@end

@implementation HWFRPTManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)initData {
    self.firstItem = [[NSMutableArray alloc]init];
    [self.firstItem addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleDescArrow title:@"位置" desc:@"门厅" switchOn:NO buttonTitle:nil]];
    [self.firstItem  addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"2" style:GeneralTableViewCellStyleDesc title:@"设备名" desc:@"极卫星" switchOn:NO buttonTitle:nil]];
    
#warning ------假的数据-----门厅，极卫星都是传进来的
    self.flag = NO;
    if (self.flag) {
        self.secondItem = [[NSMutableArray alloc]init];
        [self.secondItem addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleDesc title:@"硬件信息" desc:@"xx:xx:xx:xx" switchOn:NO buttonTitle:nil]];
        [self.secondItem  addObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"2" style:GeneralTableViewCellStyleDesc title:@"IP地址" desc:@"182.168.22.45" switchOn:NO buttonTitle:nil]];
    }
}

- (void)initView {
    self.title = [(HWFSmartDevice *)self.node.nodeEntity name];
    self.title = @"极卫星";
    [self addBackBarButtonItem];
    [self.rptTableView registerNib:[UINib nibWithNibName:@"HWFGeneralTableViewCell" bundle:nil] forCellReuseIdentifier:@"GeneralTableViewCell"];
    [self.rptTableView registerNib:[UINib nibWithNibName:@"HWFRPTManagerCell" bundle:nil] forCellReuseIdentifier:@"RPTManagerCell"];
    [self.rptTableView registerNib:[UINib nibWithNibName:@"HWFExtendWiFiCell" bundle:nil] forCellReuseIdentifier:@"ExtendWiFiCell"];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
// 取消Section.HeaderView随动
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGFloat sectionHeaderHeight = 40; //sectionHeaderHeight
    if (aScrollView.contentOffset.y<=sectionHeaderHeight&&aScrollView.contentOffset.y>=0) {
        aScrollView.contentInset = UIEdgeInsetsMake(-aScrollView.contentOffset.y, 0, 0, 0);
    } else if (aScrollView.contentOffset.y>=sectionHeaderHeight) {
        aScrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.flag) {//极卫星绑定
        return 4;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.flag) {
        switch (section) {
            case 0:
            {
                return self.firstItem.count;
            }
                break;
            case 1:
            {
                return self.secondItem.count;
            }
                break;
            case 2:
            {
                return 1;
            }
                break;
            case 3:
            {
                return 1;
            }
                break;
                
            default:
                break;
        }
    } else {
        if (section == 0) {
            return self.firstItem.count;
        } else if (section == 1) {
            return 1;
        }
    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.flag) {
        switch (section) {
            case 0:
            {
                return 10;
            }
                break;
            case 1:
            {
                return 20;
            }
                break;
            case 2:
            {
                return 20;
            }
                break;
            case 3:
            {
                return 40;
            }
                break;
            default:
                break;
        }
        
    } else {
        if (section == 0) {
            return 10;
        } else if (section == 1) {
            return 40;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.flag) {
        switch (indexPath.section) {
            case 0:
            {
                HWFGeneralTableViewCell *generalCell = [tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell"];
                [generalCell loadData:self.firstItem[indexPath.row]];
                return generalCell;
            }
                break;
            case 1:
            {
                HWFGeneralTableViewCell *generalCell = [tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell"];
                [generalCell loadData:self.secondItem[indexPath.row]];
                return generalCell;
            }
                break;
            case 2:
            {
                HWFExtendWiFiCell *extendCell = [tableView dequeueReusableCellWithIdentifier:@"ExtendWiFiCell"];
                [extendCell reloadWithStr:@"扩展无线WiFi网络"];
                return extendCell;
            }
                break;
            case 3:
            {
                HWFRPTManagerCell *rptCell = [tableView dequeueReusableCellWithIdentifier:@"RPTManagerCell"];
                [rptCell reloadWithString:@"解除极卫星绑定"];
                return rptCell;
            }
                break;
            default:
                break;
        }
        
    } else {
        if (indexPath.section == 0) {
            HWFGeneralTableViewCell *generalCell = [tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell"];
            [generalCell loadData:self.firstItem[indexPath.row]];
            return generalCell;
        } else if (indexPath.section == 1) {
            HWFRPTManagerCell *rptCell = [tableView dequeueReusableCellWithIdentifier:@"RPTManagerCell"];
            [rptCell reloadWithString:@"绑定极卫星"];
            return rptCell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.flag) {
        switch (indexPath.section) {
            case 0:
            {
                HWFGeneralTableViewCell *cell= (HWFGeneralTableViewCell *)[self.rptTableView cellForRowAtIndexPath:indexPath];
                if ([cell.item.identity isEqualToString:@"1"]) {
                    // 位置
                    NSLog(@"绑定位置");
                    HWFLocationViewController *locationVC = [[HWFLocationViewController alloc]initWithNibName:@"HWFLocationViewController" bundle:nil];
                    locationVC.delegate = self;
                    locationVC.node = self.node;
                    [self.navigationController pushViewController:locationVC animated:YES];
                    
                } else if ([cell.item.identity isEqualToString:@"2"]) {
                    //设备名
                    NSLog(@"绑定设备名");
                }
            }
                break;
            case 1:
            {
                HWFGeneralTableViewCell *cell= (HWFGeneralTableViewCell *)[self.rptTableView cellForRowAtIndexPath:indexPath];
                if ([cell.item.title isEqualToString:@"硬件信息"]) {
                    NSLog(@"硬件信息");
                    
                } else if ([cell.item.title isEqualToString:@"IP地址"]) {
                    NSLog(@"IP地址");
                }
            }
                break;
            case 2:
            {
                NSLog(@"扩展无线wifi网络");
            }
                break;
            case 3:
            {
                NSLog(@"解除极卫星绑定");
#warning --- 解除极卫星绑定
                UIActionSheet *rebootSheet = [[UIActionSheet alloc]initWithTitle:@"解绑后，极卫星不再扩展当前无线WiFi，是否继续?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解除极卫星绑定", nil];
                rebootSheet.tag = TAG_UNBIND_RPT;
                rebootSheet.destructiveButtonIndex = 0;
                [rebootSheet showInView:self.view];
            }
                break;
            default:
                break;
        }
        
    } else {
        if (indexPath.section == 0) {
            HWFGeneralTableViewCell *cell= (HWFGeneralTableViewCell *)[self.rptTableView cellForRowAtIndexPath:indexPath];
            if ([cell.item.identity isEqualToString:@"1"]) {
                // 位置
                NSLog(@"未绑定位置");
                HWFLocationViewController *locationVC = [[HWFLocationViewController alloc]initWithNibName:@"HWFLocationViewController" bundle:nil];
                locationVC.delegate = self;
                locationVC.node = self.node;
                [self.navigationController pushViewController:locationVC animated:YES];
                
            } else if ([cell.item.identity isEqualToString:@"2"]) {
                //设备名
                NSLog(@"未绑定设备名");
            }
        } else if (indexPath.section == 1) {
            //绑定极卫星
            UIActionSheet *rebootSheet = [[UIActionSheet alloc]initWithTitle:@"绑定后会自动扩展当前无线WiFi的覆盖范围，是否继续?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"绑定极卫星", nil];
            rebootSheet.tag = TAG_BING_RPT;
            rebootSheet.destructiveButtonIndex = 0;
            [rebootSheet showInView:self.view];
           
        }
    }
}

#warning -------------绑定极卫星
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (actionSheet.tag) {
        case TAG_BING_RPT:
        {
            if (buttonIndex == 0) {
                HWFSmartDevice *smartDevice = (HWFSmartDevice *)self.node.nodeEntity;
                smartDevice.MAC = [HWFTool displayMAC:@"d4ee0718c215"];
                [self loadingViewShow];
                [[HWFService defaultService]matchRPTWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] RPT:(HWFSmartDevice *)self.node.nodeEntity completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                    [self loadingViewHide];
                    NSLog(@"-----bindbind:%@",data);
                    if (code == CODE_SUCCESS) {
                        
                    } else {
                        [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
                    }
                }];
            } else {
                //取消
            }
        }
            break;
        case TAG_UNBIND_RPT:
        {
            if (buttonIndex == 0) {
                HWFSmartDevice *smartDevice = (HWFSmartDevice *)self.node.nodeEntity;
                smartDevice.MAC = [HWFTool displayMAC:@"d4ee0718c215"];
                [self loadingViewShow];
                [[HWFService defaultService]unmatchRPTWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] RPT:(HWFSmartDevice *)self.node.nodeEntity completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                    [self loadingViewHide];
                    NSLog(@"======unbindunbind:%@",data);
                    
                    if (code == CODE_SUCCESS) {
                        
                    } else {
                        [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
                    }
                }];
                
            } else {
                //取消
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark - HWFLocationViewControllerDelegate
- (void)refreshLocation:(NSString *)locationName {
    [self.firstItem replaceObjectAtIndex:0 withObject:[[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleDescArrow title:@"位置" desc:locationName switchOn:NO buttonTitle:nil]];
    [self.rptTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
