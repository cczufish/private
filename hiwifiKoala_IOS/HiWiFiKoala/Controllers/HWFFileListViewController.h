//
//  HWFFileListViewController.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFViewController.h"

@class HWFPartition;
@class HWFFile;

@interface HWFFileListViewController : HWFViewController

@property (strong, nonatomic) HWFPartition *partition;
@property (strong, nonatomic) HWFFile *directory; // 当前目录

@end
