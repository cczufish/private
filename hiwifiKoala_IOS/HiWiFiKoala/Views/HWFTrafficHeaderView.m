//
//  HWFTrafficHeaderView.m
//  HiWiFi
//
//  Created by dp on 14-3-31.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import "HWFTrafficHeaderView.h"

#import "HWFStatisticsDescView.h"
#import "HWFTrafficChartView.h"
#import "HWFDeviceListHeaderView.h"
#import "HWFDeviceTimeListHeaderView.h"
#import "UIViewExt.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface HWFTrafficHeaderView () <HWFTrafficChartViewDelegate, HWFStatisticsDescViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *trafficDescBaseView;
@property (strong, nonatomic) HWFStatisticsDescView *trafficDescView;
@property (weak, nonatomic) IBOutlet HWFTrafficChartView *trafficChartView;
@property (weak, nonatomic) IBOutlet UIView *deviceListHeaderBaseView;
@property (strong, nonatomic) HWFDeviceListHeaderView *deviceListHeaderView;
@property (strong, nonatomic) HWFDeviceTimeListHeaderView *deviceTimeListHeaderView;

@property (assign, nonatomic) BOOL dateFlag;

@end

@implementation HWFTrafficHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)reloadWithChartDict:(NSDictionary *)aChartDict withOnlineDevice:(NSInteger)onlineCount deviceCount:(NSInteger)aDeviceCount dateFlag:(BOOL)aDateFlag headerViewType:(HWFHeaderViewType)aHeaderViewType totalTime:(NSInteger)aTotalTime totalTraffic:(double)aTotalTraffic
{
    
    self.dateFlag = aDateFlag;
        
    self.trafficChartView.delegate = self;
    [self.trafficChartView reloadWithChartDict:aChartDict dateFlag:aDateFlag];
    
    if (!self.trafficDescView) {
        self.trafficDescView = [HWFStatisticsDescView instanceView];
        self.trafficDescView.alpha = 1.0;
        self.trafficDescView.delegate = self;
        [self.trafficDescBaseView addSubview:self.trafficDescView];
    }
    [RACObserve(self.trafficDescBaseView, bounds) subscribeNext:^(id x) {
        self.trafficDescView.frame = self.trafficDescBaseView.bounds;
    }];
    
    //NP
    self.trafficDescView.npLabel.hidden = NO;
    self.trafficDescView.routerIconImgView.hidden = NO;
    if ([[HWFRouter defaultRouter].NP isEqualToString:@""]) {
        self.trafficDescView.feedBackButton.hidden = YES;
    } else {
        self.trafficDescView.feedBackButton.hidden = NO;
    }
    self.trafficDescView.npLabel.text = [HWFRouter defaultRouter].NP;    
    
    switch (aHeaderViewType) {
        case HWFHeaderViewTypeDeviceInfoList:
        {
           
            self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 215);
            self.deviceListHeaderBaseView.frame = CGRectMake(0, 176, SCREEN_WIDTH, 39);
            
            if (!self.deviceListHeaderView) {
                self.deviceListHeaderView = [HWFDeviceListHeaderView instanceView];
                [self.deviceListHeaderView reloadWithDeviceCount:aDeviceCount withOnlineDeviceCount:onlineCount];
                [self.deviceListHeaderBaseView addSubview:self.deviceListHeaderView];
            }
            
            [RACObserve(self.deviceListHeaderBaseView, bounds) subscribeNext:^(id x) {
                self.deviceListHeaderView.frame = self.deviceListHeaderBaseView.bounds;
            }];
            
            self.deviceListHeaderView.hidden = NO;
            self.deviceTimeListHeaderView.hidden = YES;
        }
            break;
        case HWFHeaderViewTypeDeviceTimeList:
        {
            self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 254);
            self.deviceListHeaderBaseView.frame = CGRectMake(0, 176, SCREEN_WIDTH, 78);
            
            if (!self.deviceTimeListHeaderView) {
                self.deviceTimeListHeaderView = [HWFDeviceTimeListHeaderView instanceView];
//              [self.deviceTimeListHeaderView loadWithTime:aTotalTime traffic:aTotalTraffic];
                [self.deviceListHeaderBaseView addSubview:self.deviceTimeListHeaderView];
            }
            [self.deviceTimeListHeaderView loadWithTime:aTotalTime traffic:aTotalTraffic];
            
            [RACObserve(self.deviceListHeaderBaseView, bounds) subscribeNext:^(id x) {
                self.deviceListHeaderView.frame = self.deviceListHeaderBaseView.bounds;
            }];
            
            
            self.deviceListHeaderView.hidden = YES;
            self.deviceTimeListHeaderView.hidden = NO;
        }
            break;
        default:
        {
            self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 176);
            self.deviceListHeaderView.hidden = YES;
            self.deviceTimeListHeaderView.hidden = YES;
        }
            break;
    }
    
}

- (void)reloadDeviceCount:(NSInteger)aDeviceCount withOnlineDeviceCount:(NSInteger)onlineCount
{
    [self.deviceListHeaderView reloadWithDeviceCount:aDeviceCount withOnlineDeviceCount:onlineCount];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.deviceListHeaderView.backgroundColor = [UIColor backgroundColorForDeviceHistoryChart];
}

+ (HWFTrafficHeaderView *)instanceView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HWFTrafficHeaderView" owner:self options:nil] firstObject];
}

#pragma mark - HWFStatisticsDescViewDelegate
- (void)toggleDateFromDateFlag:(BOOL)aDateFlag // NO-从昨天到今天 YES-从今天到昨天
{
    if ([self.delegate respondsToSelector:@selector(toggleToDate:)]) {
        [self.delegate toggleToDate:aDateFlag];
    }
}

#pragma mark - HWFTrafficChartViewDelegate
- (void)refreshCallbackWithTrafficChartView:(HWFTrafficChartView *)aView chartItem:(LCLineChartDataItem *)anItem
{
    [self.trafficDescView reloadWithItem:anItem dateFlag:self.dateFlag];
}

- (void)gestureRecognizerBegan
{
    if ([self.delegate respondsToSelector:@selector(scrollTop)]) {
        [self.delegate performSelector:@selector(scrollTop)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
