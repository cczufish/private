//
//  HWFService+SmartDevice.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService.h"

#import "HWFSmartDevice.h"

@interface HWFService (SmartDevice)

/**
 *  @brief  极卫星配对
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theRPT               极卫星
 *  @param theCompletionHandler Handler
 */
- (void)matchRPTWithUser:(HWFUser *)aUser
                  router:(HWFRouter *)aRouter
                     RPT:(HWFSmartDevice *)theRPT
              completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  极卫星取消配对
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theRPT               极卫星
 *  @param theCompletionHandler Handler
 */
- (void)unmatchRPTWithUser:(HWFUser *)aUser
                    router:(HWFRouter *)aRouter
                       RPT:(HWFSmartDevice *)theRPT
                completion:(ServiceCompletionHandler)theCompletionHandler;

@end
