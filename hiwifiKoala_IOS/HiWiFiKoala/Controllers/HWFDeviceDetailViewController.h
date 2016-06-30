//
//  HWFDeviceDetailViewController.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-13.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFViewController.h"
#import "HWFDeviceListModel.h"

@protocol HWFDeviceDetailViewControllerDelegate <NSObject>

- (void)refreshDeviceList;

@end

@interface HWFDeviceDetailViewController : HWFViewController

@property (assign, nonatomic) id<HWFDeviceDetailViewControllerDelegate> delegate;
@property (nonatomic,strong)HWFDeviceListModel *deviceModel;
@property (strong, nonatomic)NSString *acceptNPStr;
@property (strong, nonatomic)NSString *acceptRouterIpStr;

@end
