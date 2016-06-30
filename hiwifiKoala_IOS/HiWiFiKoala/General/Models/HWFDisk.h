//
//  HWFDisk.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/25.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFObject.h"

typedef NS_ENUM(NSUInteger, DiskType) {
    DiskTypeUnknown = 0, // 未知
    DiskTypeSATA, // SATA硬盘
    DiskTypeUSB, // USB磁盘
    DiskTypeSD, // SD卡
};

#pragma mark - HWFDisk
@interface HWFDisk : HWFObject

@property (strong, nonatomic) NSString *identity;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) DiskType type;

@end


//TODO: 待补充
// 磁盘状态
typedef NS_ENUM(NSUInteger, PartitionStatus) {
    PartitionStatusReadOnly = 0, // 只读 `ro`
    PartitionStatusReadWrite, // 可读写 `rw`
};

#pragma mark - HWFPartition
@interface HWFPartition : HWFObject

@property (strong, nonatomic) NSString *identity;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *displayName; // 对外显示名称
@property (strong, nonatomic) NSString *label; // 卷标
@property (strong, nonatomic) NSString *fileSystem; // 分区格式
@property (assign, nonatomic) PartitionStatus status; // 磁盘状态
@property (strong, nonatomic) NSString *mountPoint;
@property (assign, nonatomic) double   totalSize;   // 总大小， 单位：B
@property (assign, nonatomic) double   availableSize; // 总可用大小， 单位：B
@property (assign, nonatomic) double   systemUseSize; // 系统已使用大小， 单位：B
@property (assign, nonatomic) double   userUsableSize; // 用户可用大小， 单位：B
@property (strong, nonatomic) HWFDisk  *disk; // 所在磁盘

/**
 *  @brief  返回格式化后的分区总大小
 *
 *  @return 用于显示的分区总大小
 */
- (NSString *)displayTotalSize;

/**
 *  @brief  返回格式化后的分区可用大小
 *
 *  @return 用于显示的分区可用大小
 */
- (NSString *)displayAvailableSize;

/**
 *  @brief  返回格式化后的系统已使用大小
 *
 *  @return 用于显示的系统已使用大小
 */
- (NSString *)displaySystemUseSize;

/**
 *  @brief  返回格式化后的用户可用大小
 *
 *  @return 用于显示的用户可用大小
 */
- (NSString *)displayUserUsableSize;

@end