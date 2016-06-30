//
//  HWFPartSpeedUpTableViewCell.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWFTableViewCell.h"
#import "HWFPartSpeedUpItem.h"

@class HWFPartSpeedUpTableViewCell;

@protocol HWFPartSpeedUpCellDelegate <NSObject>
@optional
- (void)pauseWithPartSpeedUpCell:(HWFPartSpeedUpTableViewCell *)cell;
- (void)doSpeedUpWithPartSpeedUpCell:(HWFPartSpeedUpTableViewCell *)cell;
@end

@interface HWFPartSpeedUpTableViewCell : HWFTableViewCell

@property (nonatomic,assign) id <HWFPartSpeedUpCellDelegate> delegate;

- (void)reloadCellWithSingleSpeedUpItem:(HWFPartSpeedUpItem *)partSpeedUpItem;

- (void)pauseGradientPrgressViewAnimation;
@end
