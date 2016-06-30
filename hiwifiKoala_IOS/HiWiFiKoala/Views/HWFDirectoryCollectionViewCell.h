//
//  HWFDirectoryCollectionViewCell.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/31.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFCollectionViewCell.h"

#import "HWFFile.h"

@interface HWFDirectoryCollectionViewCell : HWFCollectionViewCell

@property (strong, nonatomic) HWFFile *directory;

- (void)loadData:(HWFFile *)directory;

@end
