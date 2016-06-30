//
//  HWFChannelCell.h
//  HiWiFiKoala
//
//  Created by chang hong on 14-11-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWFChannelCell;

@protocol HWFChannelCellDelegate <NSObject>

- (void)didTouchDown:(HWFChannelCell *)cell;
- (void)didSelectRow:(HWFChannelCell *)cell;
- (void)didTouchDragExit:(HWFChannelCell *)cell;

@end

@interface HWFChannelCell : UITableViewCell

@property(nonatomic,assign) id<HWFChannelCellDelegate> delegate;
@property(nonatomic,strong) UILabel *title;

- (void)setIndex:(NSString *)index value:(float)value;

@end
