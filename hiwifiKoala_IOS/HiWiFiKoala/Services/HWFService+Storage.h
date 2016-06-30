//
//  HWFService+Storage.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/25.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService.h"

#import "HWFDisk.h"
#import "HWFFile.h"

@interface HWFService (Storage)

#pragma mark - Get Info
/**
 *  @brief  获取路由器存储状态(total/used/persent/available)
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadStorageInfoWithUser:(HWFUser *)aUser
                         router:(HWFRouter *)aRouter
                     completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - Get List
/**
 *  @brief  获取路由器存储分区列表
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadPartitionListWithUser:(HWFUser *)aUser
                           router:(HWFRouter *)aRouter
                       completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取路径下文件/目录列表
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param thePartition         分区对戏
 *  @param thePath              路径(不传时，取根目录列表)
 *  @param start                开始位置
 *  @param stop                 结束位置
 *  @param theCompletionHandler Handler
 */
- (void)loadFileListWithUser:(HWFUser *)aUser
                      router:(HWFRouter *)aRouter
                   partition:(HWFPartition *)thePartition
                        path:(NSString *)thePath
                       start:(NSInteger)start
                        stop:(NSInteger)stop
                  completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - Format
/**
 *  @brief  将分区格式化为EXT4
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param thePartition         分区对象
 *  @param theCompletionHandler Handler
 */
- (void)formatPartitionWithUser:(HWFUser *)aUser
                         router:(HWFRouter *)aRouter
                      partition:(HWFPartition *)thePartition
                     completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - Delete
/**
 *  @brief  批量删除文件
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param thePartition         分区对象
 *  @param thePath              路径
 *  @param files                文件数组
 *  @param theCompletionHandler Handler
 */
- (void)deleteFilesWithUser:(HWFUser *)aUser
                     router:(HWFRouter *)aRouter
                  partition:(HWFPartition *)thePartition
                       path:(NSString *)thePath
                      files:(NSArray *)files
                 completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - 安全弹出磁盘
/**
 *  @brief  安全弹出磁盘
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theDisk              磁盘对象
 *  @param theCompletionHandler Handler
 */
- (void)removeDiskSafeWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                          disk:(HWFDisk *)theDisk
                    completion:(ServiceCompletionHandler)theCompletionHandler;

@end
