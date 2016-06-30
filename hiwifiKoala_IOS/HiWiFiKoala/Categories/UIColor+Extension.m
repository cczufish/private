//
//  UIColor+Extension.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-9.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)baseTintColor {
    return [UIColor whiteColor];
}

+ (UIColor *)navigationBarColor {
    return COLOR_HEX(0x30B0F8);
}

+ (UIColor *)HWFBlueColor {
    return COLOR_HEX(0x30B0F8);
}

+ (UIColor *)HWFGrayFontColor {
    return COLOR_HEX(0x333333);
}

+ (UIColor *)backgroundColorForDeviceHistoryChart
{
    return COLOR_RGB(218, 237, 232);
}

+ (UIColor *)backgroundColorForGeneralTableViewCellSelected {
    return COLOR_HEX(0xE0E8ED);
}

@end
