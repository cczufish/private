//
//  HWFPlugin.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-29.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFPlugin.h"

#pragma mark - HWFPlugin
@implementation HWFPlugin

// Override
// MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"SID" : @"sid",
             @"name" : @"name",
             @"ICON" : @"icon",
             @"info" : @"info",
             @"statusMessage" : @"status_msg",
             @"hasInstalled" : @"has_installed",
             @"canUninstall" : @"can_uninstall",
             @"configURL" : @"detail_conf_url",
             };
}

@end


#pragma mark - HWFPluginCategory
@implementation HWFPluginCategory

// Override
// MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"CID" : @"cid",
             @"name" : @"name",
             };
}

@end
