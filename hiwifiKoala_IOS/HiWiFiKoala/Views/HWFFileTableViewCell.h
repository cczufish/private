//
//  HWFFileTableViewCell.h
//  HiWiFiKoala
//
//  Created by dp on 14/11/1.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFTableViewCell.h"

#import "HWFFile.h"

@interface HWFFileTableViewCell : HWFTableViewCell

@property (strong, nonatomic) HWFFile *directory;
@property (strong, nonatomic) HWFFile *file;

- (void)loadDataWithDirectory:(HWFFile *)directory file:(HWFFile *)file;

@end
