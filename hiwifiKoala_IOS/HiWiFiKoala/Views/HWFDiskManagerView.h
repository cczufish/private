//
//  HWFDiskManagerView.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWFDisk.h"

@interface HWFDiskManagerView : UIView


+ (HWFDiskManagerView *)sharedInstance;

- (void)reloadWithPartition:(HWFPartition *)partition;

@end
