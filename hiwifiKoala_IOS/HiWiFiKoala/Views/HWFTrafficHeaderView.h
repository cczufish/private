//
//  HWFTrafficHeaderView.h
//  HiWiFi
//
//  Created by dp on 14-3-31.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

//#import "HWFBaseView.h"
#import "HWFView.h"

typedef NS_ENUM(NSInteger, HWFHeaderViewType) {
    HWFHeaderViewTypeDeviceInfoList = 1,  // 设备列表
    HWFHeaderViewTypeDeviceTimeList = 2,  // 设备接入时间列表
};

@protocol HWFTrafficHeaderViewDelegate <NSObject>

- (void)toggleToDate:(BOOL)dateFlag;

- (void)scrollTop;

@end

@interface HWFTrafficHeaderView : HWFView

@property (assign, nonatomic) id<HWFTrafficHeaderViewDelegate> delegate;

+ (HWFTrafficHeaderView *)instanceView;

- (void)reloadWithChartDict:(NSDictionary *)aChartDict withOnlineDevice:(NSInteger)onlineCount deviceCount:(NSInteger)aDeviceCount dateFlag:(BOOL)aDateFlag headerViewType:(HWFHeaderViewType)aHeaderViewType totalTime:(NSInteger)aTotalTime totalTraffic:(double)aTotalTraffic;

// 只刷新设备数量
- (void)reloadDeviceCount:(NSInteger)aDeviceCount;

@end
