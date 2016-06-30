//
//  HWFTrafficChartView.h
//  HiWiFi
//
//  Created by dp on 14-3-31.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import "HWFView.h"

@class HWFTrafficChartView;
@class LCLineChartDataItem;

@protocol HWFTrafficChartViewDelegate <NSObject>

- (void)refreshCallbackWithTrafficChartView:(HWFTrafficChartView *)aView chartItem:(LCLineChartDataItem *)anItem;

- (void)gestureRecognizerBegan;

@end

@interface HWFTrafficChartView : HWFView

@property (weak, nonatomic) id<HWFTrafficChartViewDelegate> delegate;

@property (assign, nonatomic) NSUInteger pointCount;
@property (strong, nonatomic) NSMutableArray *trafficData;
@property (assign, nonatomic) NSInteger maxPointIndex;
@property (assign, nonatomic) float maxTraffic;
@property (assign, nonatomic) float maxPointY;
@property (assign, nonatomic) BOOL dateFlag;

- (void)reloadWithChartDict:(NSDictionary *)aChartDict dateFlag:(BOOL)aDateFlag;

@end
