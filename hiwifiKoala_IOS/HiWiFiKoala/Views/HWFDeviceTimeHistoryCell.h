//
//  HWFDeviceTimeHistoryCell.h
//  HiWiFi
//
//  Created by dp on 14-1-17.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

//#import "HWFBaseCell.h"

@interface HWFDeviceTimeHistoryCell : UITableViewCell

- (void)reloadCellWithStartTime:(NSString *)startTime endTime:(NSString *)endTime dateFlag:(BOOL)dateFlag ysOffPointIndex:(NSInteger)offPointIndex row:(NSInteger)aRow;

@end
