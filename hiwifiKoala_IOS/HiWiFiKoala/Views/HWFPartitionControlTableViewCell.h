//
//  HWFPartitionControlTableViewCell.h
//  HiWiFiKoala
//
//  Created by dp on 14/11/5.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFTableViewCell.h"

#import "HWFDisk.h"

@interface HWFPartitionControlTableViewCell : HWFTableViewCell

@property (strong, nonatomic) HWFDisk *disk;

- (void)loadData:(HWFDisk *)disk;

@end
