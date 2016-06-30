//
//  HWFMessageListViewController.h
//  HiWiFiKoala
//
//  Created by dp on 14-10-16.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFViewController.h"
#import "XMPullingRefreshTableView.h"
#import "HWFMessageSettingViewController.h"
#import "HWFDoubtDeviceController.h"
@interface HWFMessageListViewController : HWFViewController <UITableViewDataSource,UITableViewDelegate,XMPullingRefreshTableViewDelegate,HWFMessageSettingViewControllerDelegate,HWFDoubtDeviceControllerDelegate>

@end
