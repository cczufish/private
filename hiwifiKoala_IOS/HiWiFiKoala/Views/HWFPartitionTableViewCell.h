//
//  HWFPartitionTableViewCell.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/31.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFTableViewCell.h"

#import "HWFDisk.h"

@interface HWFPartitionTableViewCell : HWFTableViewCell

@property (strong, nonatomic) HWFPartition *partition;

- (void)loadData:(HWFPartition *)partition;

@end
