//
//  HWFPartSpeedUpItem.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFPartSpeedUpItem.h"

@implementation HWFPartSpeedUpItem

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"iconURL" : @"icon",
             @"status" : @"status",
             @"timeTotal" : @"time_total",
             @"timeOver" : @"time_over",
             @"rpt" : @"rpt",
             @"finishTimeInterval" :@"finishTimeInterval"
             };
}

@end
