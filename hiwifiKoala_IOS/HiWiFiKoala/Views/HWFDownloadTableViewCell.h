//
//  HWFDownloadTableViewCell.h
//  HiWiFiKoala
//
//  Created by dp on 14/11/10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFTableViewCell.h"

#import "HWFDownloadTask.h"

@class HWFDownloadTableViewCell;

@protocol HWFDownloadTableViewCellDelegate <NSObject>

- (void)downloadStatusButtonClick:(HWFDownloadTableViewCell *)aCell;

@end

@interface HWFDownloadTableViewCell : HWFTableViewCell

@property (assign, nonatomic) id <HWFDownloadTableViewCellDelegate> delegate;
@property (strong, nonatomic) HWFDownloadTask *task;

- (void)loadData:(HWFDownloadTask *)task;

@end
