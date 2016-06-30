//
//  HWFDeviceListHeaderView.h
//  HiWiFi
//
//  Created by dp on 14-4-1.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

//#import "HWFBaseView.h"
#import "HWFView.h"

@interface HWFDeviceListHeaderView : HWFView

+ (HWFDeviceListHeaderView *)instanceView;

- (void)reloadWithDeviceCount:(NSInteger)aDeviceCount withOnlineDeviceCount:(NSInteger)onlineCount;


@end
