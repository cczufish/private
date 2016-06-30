//
//  HWFDisk.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/25.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDisk.h"

#pragma mark - HWFDisk
@implementation HWFDisk

// Override
// MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identity" : @"device",
             @"name" : @"device_name",
             @"type" : @"device_type",
             };
}

@end


#pragma mark - HWFPartition
@implementation HWFPartition
//TODO: 确认各大小
- (NSString *)displayTotalSize {
    return [HWFTool displaySizeWithUnitB:(self.totalSize)];
}

- (NSString *)displayAvailableSize {
    return [HWFTool displaySizeWithUnitB:self.availableSize];
}

- (NSString *)displaySystemUseSize {
    return [HWFTool displaySizeWithUnitB:self.systemUseSize];
}

- (NSString *)displayUserUsableSize {
    return [HWFTool displaySizeWithUnitB:self.userUsableSize];
}

// Override
// MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identity" : @"partition",
             @"name" : @"partition_name",
             @"displayName" : @"partition_name_show",
             @"label" : @"label",
             @"fileSystem" : @"fstype",
             @"status" : @"status",
             @"mountPoint" : @"mount_point",
             @"totalSize" : @"size",
             @"availableSize" : @"available",
             @"systemUseSize" : @"sys_use",
             @"userUsableSize" : @"mobile_use",
             @"disk" : @"disk",
             };
}

@end
