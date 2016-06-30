//
//  HWFDownloadTask.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/29.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFObject.h"

// 下载任务状态
typedef NS_ENUM(NSUInteger, DownloadTaskStatus) {
    DownloadTaskStatusNone = 0,
    DownloadTaskStatusActive,
    DownloadTaskStatusPaused,
    DownloadTaskStatusWaiting,
    DownloadTaskStatusComplete,
    DownloadTaskStatusError,
};

@interface HWFDownloadTask : HWFObject

@property (strong, nonatomic) NSString           *GID; // 任务唯一编码
@property (strong, nonatomic) NSString           *dURL; // 下载地址
@property (strong, nonatomic) NSString           *iURL; // 映射地址，路由器内部使用
@property (assign, nonatomic) DownloadTaskStatus status; // 任务状态
@property (strong, nonatomic) NSString           *fileName; // 文件名
@property (strong, nonatomic) NSDate             *startTime; // 下载开始时间
@property (strong, nonatomic) NSDate             *stopTime; // 下载完成时间
@property (strong, nonatomic) NSDate             *downloadTime; // 已下载时间，active状态才有
@property (assign, nonatomic) double             completedSize; // 已下载完的大小，active状态才有
@property (assign, nonatomic) double             totalSize; // 文件大小
@property (assign, nonatomic) float              downloadSpeed; // 当前下载速度，active状态才有
@property (strong, nonatomic) NSString           *filePath; // 文件存储路径
@property (assign, nonatomic) NSInteger          errorCode;
@property (strong, nonatomic) NSString           *errorMessage;

@end
