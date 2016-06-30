//
//  HWFAPITableViewCell.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFTableViewCell.h"

@class HWFAPI;

@interface HWFAPITableViewCell : HWFTableViewCell

- (void)loadData:(HWFAPI *)API;

@end
