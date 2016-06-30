//
//  HWFMessage.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-16.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFMessage.h"

@implementation HWFMessage

// Override
// MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"MID" : @"mid",
             @"UID" : @"uid",
             @"RID" : @"rid",
             @"type" : @"type",
             @"title" : @"title",
             @"content" : @"content",
             @"createTime" : @"createTime",
             @"updateTime" : @"updateTime",
             @"status" : @"status",
             @"rank" : @"rank",
             @"transData" : @"transData",
             @"ICON" : @"icon",
             };
}

@end
