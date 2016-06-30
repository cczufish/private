//
//  HWFDeviceListModel.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-16.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDeviceListModel.h"

@implementation HWFDeviceListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"isBlock":@"isBlock",
             @"isOnline":@"isOnline",
             @"totalTime":@"totalTime"
             };
}
@end
