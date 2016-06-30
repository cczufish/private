//
//  UIColor+Extension.h
//  HiWiFiKoala
//
//  Created by dp on 14-10-9.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)baseTintColor;

+ (UIColor *)navigationBarColor;

+ (UIColor *)HWFBlueColor;

+ (UIColor *)HWFGrayFontColor;

/**
 *  我查查折线图的背景色
 *
 *  @return 色值
 */
+ (UIColor *)backgroundColorForDeviceHistoryChart;

/**
 *  @brief  公共TableViewCell被选中状态的背景颜色
 *
 *  @return 色值
 */
+ (UIColor *)backgroundColorForGeneralTableViewCellSelected;

@end
