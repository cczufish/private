//
//  HWFDownloadTaskAddViewController.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/29.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFViewController.h"

@class HWFDownloadTaskAddViewController;

@protocol HWFDownloadTaskAddViewControllerDelegate <NSObject>

- (void)addTaskWithDownloadTaskAddViewController:(HWFDownloadTaskAddViewController *)downloadTaskAddViewController;

@end

@interface HWFDownloadTaskAddViewController : HWFViewController

@property (assign, nonatomic) id <HWFDownloadTaskAddViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *partitions;

@end
