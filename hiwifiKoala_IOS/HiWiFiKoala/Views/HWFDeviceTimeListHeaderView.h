//
//  HWFDeviceTimeListHeaderView.h
//  HiWiFi
//
//  Created by dp on 14-4-1.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

//#import "HWFBaseView.h"
#import "HWFView.h"

@interface HWFDeviceTimeListHeaderView : HWFView

+ (HWFDeviceTimeListHeaderView *)instanceView;

- (void)loadWithTime:(NSInteger)aTime traffic:(double)aTraffic;

@end
