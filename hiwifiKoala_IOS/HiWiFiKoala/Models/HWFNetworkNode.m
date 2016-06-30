//
//  HWFNetworkNode.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-16.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFNetworkNode.h"

@implementation HWFNetworkNode

// Override
// MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"type" : @"type",
             @"nodeEntity" : @"node_entity",
             };
}

@end
