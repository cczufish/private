//
//  HWFService+Plugin.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService.h"

#import "HWFPlugin.h"

@interface HWFService (Plugin)

/**
 *  @brief  获取已安装插件数量
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadPluginInstalledNUMWithUser:(HWFUser *)aUser
                                router:(HWFRouter *)aRouter
                            completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取已安装插件列表
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadPluginInstalledListWithUser:(HWFUser *)aUser
                                 router:(HWFRouter *)aRouter
                             completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取插件分类列表
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadPluginCategoryListWithUser:(HWFUser *)aUser
                                router:(HWFRouter *)aRouter
                            completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取插件分类下的插件列表
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCategory          插件分类对象
 *  @param theCompletionHandler Handler
 */
- (void)loadPluginListInCategoryWithUser:(HWFUser *)aUser
                                  router:(HWFRouter *)aRouter
                                category:(HWFPluginCategory *)theCategory
                              completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取插件详细信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param thePlugin            插件对象
 *  @param theCompletionHandler Handler
 */
- (void)loadPluginDetailWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                          plugin:(HWFPlugin *)thePlugin
                      completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  插件安装
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param thePlugin            插件对象
 *  @param theCompletionHandler Handler
 */
- (void)installPluginWithUser:(HWFUser *)aUser
                       router:(HWFRouter *)aRouter
                       plugin:(HWFPlugin *)thePlugin
                   completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  插件卸载
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param thePlugin            插件对象
 *  @param theCompletionHandler Handler
 */
- (void)uninstallPluginWithUser:(HWFUser *)aUser
                         router:(HWFRouter *)aRouter
                         plugin:(HWFPlugin *)thePlugin
                     completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  插件操作(安装/卸载)状态查询
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theTaskID            任务ID (安装/卸载接口返回)
 *  @param theCompletionHandler Handler (code=> 0:安装/卸载成功 2004605:正在安装/卸载 其他:安装/卸载失败)
 */
- (void)loadPluginOperatingStatusWithUser:(HWFUser *)aUser
                                   router:(HWFRouter *)aRouter
                                   taskID:(NSString *)theTaskID
                               completion:(ServiceCompletionHandler)theCompletionHandler;

@end
