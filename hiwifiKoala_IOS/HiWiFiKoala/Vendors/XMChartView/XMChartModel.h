//
//  XMChartModel.h
//  HiWiFi
//
//  Created by dp on 14-3-13.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XMChartModelDataYNil -1

@interface XMChartModel : NSObject

@property (assign, nonatomic) float dataX;  // X轴 数据
@property (assign, nonatomic) float dataY;  // Y轴 数据

@property (strong, nonatomic) NSString *displayX;   // X轴 显示文本
@property (strong, nonatomic) NSString *displayY;   // Y轴 显示文本

@end
