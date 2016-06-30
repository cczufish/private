//
//  HWFAppliedPluginTableViewCell.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFTableViewCell.h"

@class HWFPlugin;

@interface HWFAppliedPluginTableViewCell : HWFTableViewCell

@property (strong, nonatomic) HWFPlugin *plugin;

- (void)loadData:(HWFPlugin *)plugin;

@end
