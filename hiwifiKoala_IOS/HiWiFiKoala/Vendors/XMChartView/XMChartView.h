//
//  XMLineChartView.h
//  HiWiFi
//
//  Created by dp on 14-3-13.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMChartModel;

typedef NS_ENUM(NSInteger, XMChartViewType) {
    XMChartViewTypeLine = 0,    //  折线图
    XMChartViewTypeBar,         //  柱状图
    XMChartViewTypeBoth,        //  折线图+柱状图
};

@interface XMLineChartView : UIView

@property (assign, nonatomic) XMChartViewType type;

@property (strong, nonatomic) UIColor *lineColor;   // 线 颜色
@property (assign, nonatomic) float lineWidth;  // 线 宽度

@property (strong, nonatomic) UIColor *barColor;    // 柱状图 颜色
@property (assign, nonatomic) float barWidth;   // 柱状图 宽度

@property (assign, nonatomic) BOOL isPointDisplay;
@property (strong, nonatomic) UIColor *pointColor;  // 点 颜色
@property (assign, nonatomic) float pointRadius;    // 点 半径

@property (strong, nonatomic) UIColor *statusOnColor;
@property (strong, nonatomic) UIColor *statusOffColor;
@property (assign, nonatomic) float statusLineWidth;
@property (assign, nonatomic) float statusLineHeight;

@property (strong, nonatomic) UIColor *indicatorColor;

@property (assign, nonatomic) float minY;   // Y轴 最小值
@property (assign, nonatomic) float maxY;   // Y轴 最大值

@property (assign, nonatomic) NSInteger totalX; // X轴 能显示的总点数

@property (assign, nonatomic) UIEdgeInsets edge;    // 边距

@property (strong, nonatomic) NSMutableArray *dataSource;  // 数据源

- (void)refreshChartView;

- (void)refreshWithAppendChartModel:(XMChartModel *)aChartModel;

@end
