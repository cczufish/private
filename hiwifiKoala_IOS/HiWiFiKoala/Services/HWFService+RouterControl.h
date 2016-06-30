//
//  HWFService+RouterControl.h
//  HiWiFiKoala
//
//  Created by dp on 14-10-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService.h"

@class HWFUser;
@class HWFRouter;
@class HWFWiFiSleepConfig;

@interface HWFService (RouterControl)

#pragma mark - SYSTEM
/**
 *  @brief  重启路由器
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)rebootRouterWithUser:(HWFUser *)aUser
                      router:(HWFRouter *)aRouter
                  completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  重置路由器(通过后台管理密码)
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theAdminPWD          后台管理密码
 *  @param theCompletionHandler Handler
 */
- (void)resetRouterWithUser:(HWFUser *)aUser
                     router:(HWFRouter *)aRouter
                   adminPWD:(NSString *)theAdminPWD
                 completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - Part SpeedUp
/**
 *  @brief  获取单项加速列表
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadPartSpeedUpListWithUser:(HWFUser *)aUser
                             router:(HWFRouter *)aRouter
                         completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置某设备的单项加速
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param anItemId             设备ItemId
 *  @param theCompletionHandler Handler
 */
- (void)setPartSpeedUpWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                        itemId:(NSString *)anItemId
                    completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  取消某设备的单项加速
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param anItemId             设备ItemId
 *  @param theCompletionHandler Handler
 */
- (void)cancelPartSpeedUpWithUser:(HWFUser *)aUser
                           router:(HWFRouter *)aRouter
                           itemId:(NSString *)anItemId
                       completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - WiFi Channel
/**
 *  @brief  获取路由器当前的WiFi信道
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadWiFiChannelWithUser:(HWFUser *)aUser
                         router:(HWFRouter *)aRouter
                     completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置路由器的WiFi信道
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param aChannel             信道号
 *  @param theCompletionHandler Handler
 */
- (void)setWiFiChannelWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                       channel:(NSInteger)aChannel
                    completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  扫描路由器周围所有WiFi信道的质量
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadWiFiChannelRankWithUser:(HWFUser *)aUser
                             router:(HWFRouter *)aRouter
                         completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - LED
/**
 *  @brief  加载路由器LED状态
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadLEDStatusWithUser:(HWFUser *)aUser
                       router:(HWFRouter *)aRouter
                   completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置路由器LED状态
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theLEDStatus         LED状态(YES:开灯 NO:关灯)
 *  @param theCompletionHandler Handler
 */
- (void)setLEDStatusWithUser:(HWFUser *)aUser
                      router:(HWFRouter *)aRouter
                      status:(BOOL)theLEDStatus
                  completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - WiFi开关(2.4G/5G)
/**
 *  @brief  获取路由器2.4GWiFi开关状态
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadWiFiStatus24GWithUser:(HWFUser *)aUser
                           router:(HWFRouter *)aRouter
                       completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取路由器5GWiFi开关状态
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadWiFiStatus5GWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                      completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置路由器2.4GWiFi开关状态
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theWiFiStatus        2.4GWiFi开关状态(YES:开 NO:关)
 *  @param theCompletionHandler Handler
 */
- (void)setWiFiStatus24GWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                          status:(BOOL)theWiFiStatus
                      completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置路由器5GWiFi开关状态
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theWiFiStatus        5GWiFi开关状态(YES:开 NO:关)
 *  @param theCompletionHandler Handler
 */
- (void)setWiFiStatus5GWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                        status:(BOOL)theWiFiStatus
                    completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - WiFi Sleep
/**
 *  @brief  获取路由器2.4GWiFi休眠配置
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadWiFiSleepConfig24GWithUser:(HWFUser *)aUser
                                router:(HWFRouter *)aRouter
                            completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取路由器5GWiFi休眠配置
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadWiFiSleepConfig5GWithUser:(HWFUser *)aUser
                               router:(HWFRouter *)aRouter
                           completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  配置路由器2.4GWiFi休眠信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theSleepConfig       休眠配置对象
 *  @param theCompletionHandler Handler
 */
- (void)setWiFiSleepConfig24GWithUser:(HWFUser *)aUser
                               router:(HWFRouter *)aRouter
                          sleepConfig:(HWFWiFiSleepConfig *)theSleepConfig
                           completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  配置路由器5GWiFi休眠信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theSleepConfig       休眠配置对象
 *  @param theCompletionHandler Handler
 */
- (void)setWiFiSleepConfig5GWithUser:(HWFUser *)aUser
                              router:(HWFRouter *)aRouter
                         sleepConfig:(HWFWiFiSleepConfig *)theSleepConfig
                          completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - Wide Mode
/**
 *  @brief  获取路由器WiFi穿墙模式
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadWiFiWideModeWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                      completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置路由器WiFi穿墙模式
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theWideMode          穿墙模式状态
 *  @param theCompletionHandler Handler
 */
- (void)setWiFiWideModeWithUser:(HWFUser *)aUser
                         router:(HWFRouter *)aRouter
                           mode:(BOOL)theWideMode
                     completion:(ServiceCompletionHandler)theCompletionHandler;

@end
