//
//  HWFSettingFirstCell.h
//  HiWiFiKoala
//
//  Created by chang hong on 14-10-9.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWFTableViewCell.h"

@protocol HWFSettingFirstCellLoginDelegate <NSObject>

@optional
- (void)manageButtonClick;

@end

@interface HWFSettingFirstCellLogin : HWFTableViewCell

@property (assign, nonatomic) id <HWFSettingFirstCellLoginDelegate> delegate;
- (void)loadData:(HWFUser *)user;
@end
