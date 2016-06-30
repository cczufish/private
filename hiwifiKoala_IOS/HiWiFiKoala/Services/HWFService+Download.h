//
//  HWFService+Download.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService.h"

#import "HWFDownloadTask.h"
#import "HWFDisk.h"

@interface HWFService (Download)

#pragma mark - 查询

/**
 *  @brief  获取下载中任务列表
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theLastTask          上次取列表时取到的最后一个任务，如果是第一次取，传nil
 *  @param count                本次需要取出的任务数量
 *  @param theCompletionHandler Handler
 */
- (void)loadDownloadingTaskListWithUser:(HWFUser *)aUser
                                 router:(HWFRouter *)aRouter
                               lastTask:(HWFDownloadTask *)theLastTask
                                  count:(NSInteger)count
                             completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取已下载任务列表
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theLastTask          上次取列表时取到的最后一个任务，如果是第一次取，传nil
 *  @param count                本次需要取出的任务数量
 *  @param theCompletionHandler Handler
 */
- (void)loadDownloadedTaskListWithUser:(HWFUser *)aUser
                                router:(HWFRouter *)aRouter
                              lastTask:(HWFDownloadTask *)theLastTask
                                 count:(NSInteger)count
                            completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取下载任务的详细信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theTasks             下载任务对象数组
 *  @param theCompletionHandler Handler
 */
- (void)loadDownloadTaskDetailWithUser:(HWFUser *)aUser
                                router:(HWFRouter *)aRouter
                                 tasks:(NSArray *)theTasks
                            completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - 操作
/**
 *  @brief  根据URL添加下载任务
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aPartition           分区对象，nil:下载到`/tmp/data`所链接的分区
 *  @param theURLs              下载任务URL数组
 *  @param isForceReDownload    是否强制重新下载
 *  @param theCompletionHandler Handler
 */
- (void)addDownloadTaskWithUser:(HWFUser *)aUser
                         router:(HWFRouter *)aRouter
                      partition:(HWFPartition *)aPartition
                           URLs:(NSArray *)theURLs
                forceReDownload:(BOOL)isForceReDownload
                     completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  删除下载任务
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theTasks             下载任务对象数组
 *  @param isRemoveFile         是否同时删除文件
 *  @param theCompletionHandler Handler
 */
- (void)removeDownloadTaskWithUser:(HWFUser *)aUser
                            router:(HWFRouter *)aRouter
                             tasks:(NSArray *)theTasks
                        removeFile:(BOOL)isRemoveFile
                        completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  暂停下载任务
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theTasks             下载任务对象数组
 *  @param theCompletionHandler Handler
 */
- (void)pauseDownloadTaskWithUser:(HWFUser *)aUser
                           router:(HWFRouter *)aRouter
                            tasks:(NSArray *)theTasks
                       completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  暂停全部下载任务
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)pauseAllDownloadTaskWithUser:(HWFUser *)aUser
                              router:(HWFRouter *)aRouter
                          completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  恢复暂停的下载任务
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theTasks             下载任务对象数组
 *  @param theCompletionHandler Handler
 */
- (void)resumePausedDownloadTaskWithUser:(HWFUser *)aUser
                                  router:(HWFRouter *)aRouter
                                   tasks:(NSArray *)theTasks
                              completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  恢复所有暂停的下载任务
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)resumeAllPausedDownloadTaskWithUser:(HWFUser *)aUser
                                     router:(HWFRouter *)aRouter
                                 completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  清除未完成任务(删除所有相关临时文件)
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)clearDownloadingTasksWithUser:(HWFUser *)aUser
                               router:(HWFRouter *)aRouter
                           completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  清空已完成任务(不删除已下载文件)
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)clearDownloadedTasksWithUser:(HWFUser *)aUser
                              router:(HWFRouter *)aRouter
                          completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取某个时间点之后已完成的任务个数
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theDate              某个时间点
 *  @param theCompletionHandler Handler
 */
- (void)loadDownloadedTasksNumWithUser:(HWFUser *)aUser
                                router:(HWFRouter *)aRouter
                                  date:(NSDate *)theDate
                            completion:(ServiceCompletionHandler)theCompletionHandler;

@end
