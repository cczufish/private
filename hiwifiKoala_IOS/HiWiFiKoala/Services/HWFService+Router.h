//
//  HWFService+Router.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService.h"

@class HWFUser;
@class HWFRouter;

@interface HWFService (Router)

/**
 *  @brief  加载用户绑定的路由器列表
 *
 *  @param aUser                需要获取绑定路由器列表的用户对象
 *  @param theCompletionHandler Handler
 */
- (void)loadBindRoutersWithUser:(HWFUser *)aUser
                     completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取用户下所有绑定路由器的ClientSecret
 *
 *  @param aUser                用户对象
 *  @param theCompletionHandler Handler
 */
- (void)loadClientSecretWithUser:(HWFUser *)aUser
                      completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取路由器的ClientSecret
 *
 *  @param aUser                用户对象
 *  @param aRouter              需要获取ClientSecret的路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadClientSecretWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                      completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  加载路由器的详细信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadRouterDetailWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                      completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置路由器备注名
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theNewName           新备注名
 *  @param theCompletionHandler Handler
 */
- (void)setRouterNameWithUser:(HWFUser *)aUser
                       router:(HWFRouter *)aRouter
                      newName:(NSString *)theNewName
                   completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  加载路由器实时流量接口
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadRouterRealTimeTrafficWithUser:(HWFUser *)aUser
                                   router:(HWFRouter *)aRouter
                               completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  加载路由器历史流量接口
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadRouterHistoryTrafficWithUser:(HWFUser *)aUser
                                  router:(HWFRouter *)aRouter
                              completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  修改路由器密码(通过旧密码)
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param oldPWD               旧密码
 *  @param newPWD               新密码
 *  @param theCompletionHandler Handler
 */
- (void)modifyRouterPasswordWithUser:(HWFUser *)aUser
                              router:(HWFRouter *)aRouter
                              oldPWD:(NSString *)oldPWD
                              newPWD:(NSString *)newPWD
                          completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取路由器拓扑结构
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadRouterTopologyWithUser:(HWFUser *)aUser
                            router:(HWFRouter *)aRouter
                        completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取路由器WAN口信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadWANInfoWithUser:(HWFUser *)aUser
                     router:(HWFRouter *)aRouter
                 completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取路由器智能控制信息大接口
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadRouterControlOverviewWithUser:(HWFUser *)aUser
                                   router:(HWFRouter *)aRouter
                               completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置位置信息 (MAC:Place)
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aMAC                 MAC地址
 *  @param aPlace               位置
 *  @param theCompletionHandler Handler
 */
- (void)setPlaceWithUser:(HWFUser *)aUser
                  router:(HWFRouter *)aRouter
                     MAC:(NSString *)aMAC
                   place:(NSInteger)aPlace
              completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取路由器的型号
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadModelWithUser:(HWFUser *)aUser
                   router:(HWFRouter *)aRouter
               completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取路由器相关数字类概要信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadRouterOverviewNumbersWithUser:(HWFUser *)aUser
                                   router:(HWFRouter *)aRouter
                               completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - 获取直连路由器信息
/**
 *  @brief  获取直连路由器相关信息
 *
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadConnectedRouterInfoWithRouter:(HWFRouter *)aRouter
                               completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  判断是否是直连路由器
 *
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadIsConnectedRouterWithRouter:(HWFRouter *)aRouter
                             completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - History
/**
 *  @brief  获取路由器流量历史详细记录
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadRouterTrafficHistoryDetailWithUser:(HWFUser *)aUser
                                        router:(HWFRouter *)aRouter
                                    completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取路由器连接历史详细记录
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadRouterOnlineHistoryDetailWithUser:(HWFUser *)aUser
                                       router:(HWFRouter *)aRouter
                                   completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - 备份
/**
 *  @brief  获取配置备份信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadRouterBackupInfoWithUser:(HWFUser *)aUser
                              router:(HWFRouter *)aRouter
                          completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  备份路由器配置
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)backupUserConfigWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                      completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  还原路由器配置
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)restoreUserConfigWithUser:(HWFUser *)aUser
                           router:(HWFRouter *)aRouter
                       completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - ROM
/**
 *  @brief  获取ROM更新信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadROMUpgradeInfoWithUser:(HWFUser *)aUser
                            router:(HWFRouter *)aRouter
                        completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  执行ROM更新
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)upgradeROMWithUser:(HWFUser *)aUser
                    router:(HWFRouter *)aRouter
                completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - BIND
/**
 *  @brief  根据MAC获取绑定此路由器的用户信息
 *
 *  @param aUser                用户对象
 *  @param aMAC                 路由器MAC地址
 *  @param theCompletionHandler Handler
 */
- (void)loadBindUserWithUser:(HWFUser *)aUser
                         MAC:(NSString *)aMAC
                  completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  路由器与用户解绑
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)unbindWithUser:(HWFUser *)aUser
                router:(HWFRouter *)aRouter
            completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - 体检
/**
 *  @brief  执行体检，并获取体检结果
 *          wifi_5g_has_pwd == -1，表示不支持5GWiFi
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadRouterExamResultWithUser:(HWFUser *)aUser
                              router:(HWFRouter *)aRouter
                          completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - 测速
/**
 *  @brief  开始测速
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)doRouterSpeedTestWithUser:(HWFUser *)aUser
                           router:(HWFRouter *)aRouter
                       completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取测速结果
 *          下行跟上行分开测速
 *          轮询EndPoint: 状态为finish(显示对应的speed) 或 状态为error(报错) 或 timeout(超时) 或 time与当前时间比较，差异过大(算下已获得网速历史的平均值)
 *          平均值算法: 实时的取，累计下来，小的去掉20%，大的去掉10%，剩下的取均值。
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theActID             操作ID
 *  @param theCompletionHandler Handler
 */
- (void)loadRouterSpeedTestResultWithUser:(HWFUser *)aUser
                                   router:(HWFRouter *)aRouter
                                    actID:(NSString *)theActID
                               completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - 运营商

/**
 *  @brief  加载路由器的IP和NP信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadRouterIPNPWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                    completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  反馈用户运营商信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aTEL                 用户联系电话
 *  @param np                   用户反馈的运营商信息
 *  @param theCompletionHandler Handler
 */
- (void)reportRouterNPWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                       userTEL:(NSString *)aTEL
                        userNP:(NSString *)np
                    completion:(ServiceCompletionHandler)theCompletionHandler;

@end
