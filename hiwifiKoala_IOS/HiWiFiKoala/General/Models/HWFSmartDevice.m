//
//  HWFSmartDevice.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-29.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFSmartDevice.h"

@implementation HWFSmartDevice

// Override
// MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name" : @"name",
             @"MAC" : @"mac",
             @"IP" : @"ip",
             @"signal" : @"signal",
             @"RPT" : @"rpt",
             @"QoSStatus" : @"qos_status",
             @"QoSUp" : @"qos_up",
             @"QoSDown" : @"qos_down",
             @"trafficUp" : @"traffic_up",
             @"trafficDown" : @"traffic_down",
             @"timeTotal" : @"time_total",
             @"trafficTotal" : @"traffic_total",
             @"isDiskLimit" : @"disk_limit",
             @"connectType" : @"connect_type",
             @"model" : @"model",
             @"place" : @"place",
             @"matchStatus" : @"match_status"
             };
}

@end
