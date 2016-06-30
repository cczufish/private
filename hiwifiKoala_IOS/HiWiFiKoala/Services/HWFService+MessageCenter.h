//
//  HWFService+MessageCenter.h
//  HiWiFiKoala
//
//  Created by dp on 14-10-16.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService.h"

#import "HWFMessage.h"

@interface HWFService (MessageCenter)

#pragma mark - Message
/**
 *  @brief  获取是否有未读消息
 *
 *  @param aUser                用户对象
 *  @param theCompletionHandler Handler
 */
- (void)loadNewMessageFlagWithUser:(HWFUser *)aUser
                        completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取消息列表
 *
 *  @param aUser                用户对象
 *  @param start                开始位置
 *  @param count                获取的总数量
 *  @param theCompletionHandler Handler
 */
- (void)loadMessageListWithUser:(HWFUser *)aUser
                          start:(NSInteger)start
                          count:(NSInteger)count
                     completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  加载消息详细信息
 *
 *  @param aUser                用户对象
 *  @param aMessage             消息对象
 *  @param theCompletionHandler Handler
 */
- (void)loadMessageDetailWithUser:(HWFUser *)aUser
                          message:(HWFMessage *)aMessage
                       completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置消息状态
 *
 *  @param aUser                用户对象
 *  @param aMessage             消息对象
 *  @param theStatus            状态
 *  @param theCompletionHandler Handler
 */
- (void)setMessageStatusWithUser:(HWFUser *)aUser
                         message:(HWFMessage *)aMessage
                          status:(BOOL)theStatus
                      completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置所有消息为已读状态
 *
 *  @param aUser                用户对象
 *  @param theCompletionHandler Handler
 */
- (void)setAllMessageReadWithUser:(HWFUser *)aUser
                       completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  清空消息列表
 *
 *  @param aUser                用户对象
 *  @param theCompletionHandler Handler
 */
- (void)clearMessageListWithUser:(HWFUser *)aUser
                      completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - Message Switch
/**
 *  @brief  获取所有处于关闭状态的消息开关列表
 *
 *  @param aUser                用户对象
 *  @param theCompletionHandler Handler
 */
- (void)loadCloseMessageSwitchListWithUser:(HWFUser *)aUser
                                completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置消息开关状态(单个)
 *
 *  @param aUser                用户对象
 *  @param theMessageSwitchType 消息开关类型
 *  @param theStatus            状态
 *  @param theCompletionHandler Handler
 */
- (void)setMessageSwitchStatusWithUser:(HWFUser *)aUser
                     messageSwitchType:(NSInteger)theMessageSwitchType
                                status:(BOOL)theStatus
                            completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  设置消息开关状态(多个)
 *
 *  @param aUser                        用户对象
 *  @param theMessageSwitchesTypeArray  消息开关类型数组
 *  @param theStatus                    状态
 *  @param theCompletionHandler         Handler
 */
- (void)setMessageSwitchStatusWithUser:(HWFUser *)aUser
              messageSwitchesTypeArray:(NSArray *)theMessageSwitchesTypeArray
                                status:(BOOL)theStatus
                            completion:(ServiceCompletionHandler)theCompletionHandler;

@end
