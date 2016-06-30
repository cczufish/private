//
//  HWFMessageSettingViewController.h
//  HiWiFiKoala
//
//  Created by chang hong on 14-10-22.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWFViewController.h"
#import "HWFGeneralTableViewCell.h"

@protocol HWFMessageSettingViewControllerDelegate <NSObject>

- (void)setAllReadHandle;
- (void)deleteAllMessageHandle;

@end

@interface HWFMessageSettingViewController : HWFViewController <UITableViewDataSource,UITableViewDelegate,HWFGeneralTableViewCellDelegate>

@property (assign, nonatomic) id <HWFMessageSettingViewControllerDelegate> delegate;
@end
