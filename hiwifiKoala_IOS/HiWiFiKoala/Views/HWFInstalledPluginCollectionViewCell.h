//
//  HWFInstalledPluginCollectionViewCell.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFCollectionViewCell.h"

@class HWFPlugin;
@class HWFInstalledPluginCollectionViewCell;

#define kInstallPluginSID -1
#define kBlankPluginSID -2

@interface HWFInstalledPluginCollectionViewCell : HWFCollectionViewCell

@property (strong, nonatomic) HWFPlugin *plugin;
@property (strong, nonatomic) NSIndexPath *indexPath;

- (void)loadData:(HWFPlugin *)plugin indexPath:(NSIndexPath *)indexPath;

@end
