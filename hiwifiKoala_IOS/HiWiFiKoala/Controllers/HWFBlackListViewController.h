//
//  HWFBlackListViewController.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-13.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFViewController.h"

@protocol HWFRecoverDeviceViewControllerDelegate <NSObject>

- (void)refreshDeviceList;

@end

@interface HWFBlackListViewController : HWFViewController

@property (assign, nonatomic) id<HWFRecoverDeviceViewControllerDelegate> delegate;


@end
