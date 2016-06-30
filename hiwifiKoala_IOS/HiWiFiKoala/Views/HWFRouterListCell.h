//
//  HWFRouterListCell.h
//  HiWiFiKoala
//
//  Created by dp on 14-10-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFTableViewCell.h"

@class HWFRouterListCell;

@protocol HWFRouterListCellDelegate <NSObject>

- (void)clickRouterListCell:(HWFRouterListCell *)aCell;

@end

@interface HWFRouterListCell : HWFTableViewCell

@property (assign, nonatomic) id <HWFRouterListCellDelegate> delegate;
@property (strong, nonatomic) HWFRouter *router;

- (void)loadData:(HWFRouter *)aRouter;

@end
