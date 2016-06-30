//
//  HWFDownloadTask.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/29.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDownloadTask.h"

@implementation HWFDownloadTask

// Override
// MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"GID" : @"gid",
             @"dURL" : @"d_url",
             @"iURL" : @"i_url",
             @"status" : @"status",
             @"fileName" : @"filename",
             @"startTime" : @"time_start",
             @"stopTime" : @"time_stop",
             @"downloadTime" : @"download_time",
             @"completedSize" : @"completed_length",
             @"totalSize" : @"total_length",
             @"downloadSpeed" : @"download_speed",
             @"filePath" : @"path",
             @"errorCode" : @"error_code",
             @"errorMessage" : @"error_msg",
             };
}

@end
