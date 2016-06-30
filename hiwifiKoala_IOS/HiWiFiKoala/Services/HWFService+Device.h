//
//  HWFService+Device.h
//  HiWiFiKoala
//
//  Created by dp on 14-10-13.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService.h"

#import "HWFDevice.h"

@interface HWFService (Device)

/**
 *  @brief  加载当前连接在路由器上的设备列表
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadDeviceListWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                    completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置设备备注名
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aDevice              设备对象
 *  @param theNewName           新备注名
 *  @param theCompletionHandler Handler
 */
- (void)setDeviceNameWithUser:(HWFUser *)aUser
                       router:(HWFRouter *)aRouter
                       device:(HWFDevice *)aDevice
                      newName:(NSString *)theNewName
                   completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取设备详细信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aDevice              设备对象
 *  @param theCompletionHandler Handler
 */
- (void)loadDeviceDetailWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                          device:(HWFDevice *)aDevice
                      completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取设备实时流量
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aDevice              设备对象
 *  @param theCompletionHandler Handler
 */
- (void)loadDeviceRealTimeTrafficWithUser:(HWFUser *)aUser
                                   router:(HWFRouter *)aRouter
                                   device:(HWFDevice *)aDevice
                               completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - 黑名单
/**
 *  @brief  获取黑名单
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadBlackListWithUser:(HWFUser *)aUser
                       router:(HWFRouter *)aRouter
                   completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  向黑名单中添加设备
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aDevice              设备对象
 *  @param theCompletionHandler Handler
 */
- (void)addToBlackListWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                        device:(HWFDevice *)aDevice
                    completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  从黑名单中移除设备(批量)
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aDeviceArray         设备对象数组(数组元素类型: HWFDevice)
 *  @param theCompletionHandler Handler
 */
- (void)removeFromBlackListWithUser:(HWFUser *)aUser
                             router:(HWFRouter *)aRouter
                            devices:(NSArray *)aDeviceArray
                         completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  清空黑名单
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)clearBlackListWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                    completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - Traffic
/**
 *  @brief  获取设备流量历史详细记录
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aDevice              设备对象
 *  @param theCompletionHandler Handler
 */
- (void)loadDeviceTrafficHistoryDetailWithUser:(HWFUser *)aUser
                                        router:(HWFRouter *)aRouter
                                        device:(HWFDevice *)aDevice
                                    completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取设备连接历史详细记录
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aDevice              设备对象
 *  @param theCompletionHandler Handler
 */
- (void)loadDeviceOnlineHistoryDetailWithUser:(HWFUser *)aUser
                                       router:(HWFRouter *)aRouter
                                       device:(HWFDevice *)aDevice
                                   completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - QoS
/**
 *  @brief  获取设备限速信息
 *          code == 1 表示无设备限速信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aDevice              设备对象
 *  @param theCompletionHandler Handler
 */
- (void)loadDeviceQoSWithUser:(HWFUser *)aUser
                       router:(HWFRouter *)aRouter
                       device:(HWFDevice *)aDevice
                   completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置设备限速
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aDevice              设备对象
 *  @param theQoSUp             上行限速值
 *  @param theQoSDown           下行限速值
 *  @param theCompletionHandler Handler
 */
- (void)setDeviceQoSWithUser:(HWFUser *)aUser
                      router:(HWFRouter *)aRouter
                      device:(HWFDevice *)aDevice
                       QoSUp:(double)theQoSUp
                     QoSDown:(double)theQoSDown
                  completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  取消设备限速
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aDevice              设备对象
 *  @param theCompletionHandler Handler
 */
- (void)unsetDeviceQoSWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                        device:(HWFDevice *)aDevice
                    completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - 磁盘存储访问权限
/**
 *  @brief  获取设备对磁盘存储的访问权限
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aDevice              设备对象
 *  @param theCompletionHandler Handler
 */
- (void)loadDeviceDiskLimitWithUser:(HWFUser *)aUser
                             router:(HWFRouter *)aRouter
                             device:(HWFDevice *)aDevice
                         completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置设备对磁盘存储的访问权限
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aDevice              设备对象
 *  @param theDiskLimit         磁盘存储访问权限 NO:无权限 YES:有权限
 *  @param theCompletionHandler Handler
 */
- (void)setDeviceDiskLimitWithUser:(HWFUser *)aUser
                            router:(HWFRouter *)aRouter
                            device:(HWFDevice *)aDevice
                         diskLimit:(BOOL)theDiskLimit
                        completion:(ServiceCompletionHandler)theCompletionHandler;

@end
