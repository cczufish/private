//
//  HWFDeviceInfoCell.h
//  HiWiFi
//
//  Created by dp on 14-5-14.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#define BASETAG_DEVICEHISTORYCELL 1024

@class HWFDeviceListModel;
@class HWFDeviceInfoCell;

@protocol HWFDeviceInfoCellDelegate <NSObject>

- (void)clickCell:(HWFDeviceInfoCell *)aCell withDeviceModel:(HWFDeviceListModel *)aDeviceModel dateFlag:(BOOL)aDateFlag;

- (void)clickQosWithCell:(HWFDeviceInfoCell *)aCell withDeviceModel:(HWFDeviceListModel *)aDeviceModel;

- (void)clickRenameWithCell:(HWFDeviceInfoCell *)aCell withDeviceModel:(HWFDeviceListModel *)aDeviceModel;

- (void)handleShowControlViewWithCell:(HWFDeviceInfoCell *)aCell;

- (void)handleHideControlViewWithCell:(HWFDeviceInfoCell *)aCell;

@end

@interface HWFDeviceInfoCell : UITableViewCell

@property (assign, nonatomic) id<HWFDeviceInfoCellDelegate> delegate;
@property (assign, nonatomic) BOOL showControlViewFlag;

- (void)reloadCellWithModel:(HWFDeviceListModel *)aDeviceModel dateFlag:(BOOL)dateFlag; // YES:今天 NO:昨天

/**
 *  隐藏控制试图(改名、限速)
 */
- (void)hideControlView;

@end
