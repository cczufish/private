//
//  HWFDevice.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-29.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDevice.h"

@implementation HWFDevice

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
             @"ComICON" : @"com_icon",
             };
}

- (NSString *)standardMAC {
    return [HWFTool standardMAC:self.MAC];
}

- (NSString *)displayMAC {
    return [HWFTool displayMAC:self.MAC];
}

- (NSString *)displayName {
    // MAC以@"D4:EE:07"开头，且name为空
    //  不是极卫星(rpt == NO)
    //      返回@"极路由_XXXXXX"
    //  是极卫星(rpt == YES)
    //      返回@"极卫星_XXXXXX"
    // 其他
    //  如果name为空，返回@"未知"，否则，返回原始name
    
    NSString *deviceName = nil;
    NSString *MACPrefix = [self.standardMAC substringToIndex:6];
    if ((!self.name || IS_STRING_EMPTY(self.name) || [self.name isEqualToString:NSLocalizedString(@"UnknownDevice", "未知")])
        && ([HIWIFI_MAC_PREFIX rangeOfString:MACPrefix].location != NSNotFound)) {
            NSString *suffix = [self.standardMAC substringFromIndex:6];
            if (self.RPT) {
                deviceName = [NSString stringWithFormat:@"%@_%@", NSLocalizedString(@"HiWiFiRPT", "极卫星"), suffix];
            } else {
                deviceName = [NSString stringWithFormat:@"%@_%@", NSLocalizedString(@"HiWiFiRouter", "极路由"), suffix];
            }
        } else if (!self.name || IS_STRING_EMPTY(self.name)) {
            deviceName = NSLocalizedString(@"UnknownDevice", "未知");
        } else {
            deviceName = self.name;
        }
    return deviceName;
}

@end
