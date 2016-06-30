//
//  HWFSettingsViewController.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFViewController.h"
#import "HWFGeneralTableViewCell.h"
#import "HWFSettingFirstCellLogin.h"
#import "HWFSettingFirstCellNotLogin.h"
#import "HWFModifyDataViewController.h"

@protocol HWFSettingsViewControllerDelegate <NSObject>

- (void)login;

@end

@interface HWFSettingsViewController : HWFViewController <UITableViewDataSource,UITableViewDelegate,HWFGeneralTableViewCellDelegate,HWFSettingFirstCellLoginDelegate,HWFSettingFirstCellNotLoginDelegate,HWFModifyDataViewControllerDelegate>

@property (assign, nonatomic) id <HWFSettingsViewControllerDelegate> delegate;

@end
