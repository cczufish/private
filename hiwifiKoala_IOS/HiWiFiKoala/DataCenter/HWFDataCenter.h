//
//  HWFDataCenter.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-14.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HWFUser;
@class HWFRouter;

#define kCacheDate @"CacheDate"
#define kCacheData @"CacheData"

#define kConfigCachePlace @"ConfigCachePlace"

extern NSString *const kDefaultUserUIDCache;

@interface HWFDataCenter : NSObject

+ (HWFDataCenter *)defaultCenter;

#pragma mark - USER
/**
 *  @brief  根据UID取用户对象
 *
 *  @param aUID UID
 *
 *  @return 用户对象
 */
- (HWFUser *)userWithUID:(NSInteger)aUID;

/**
 *  @brief  获取默认用户
 *
 *  @return 默认用户对象
 */
- (HWFUser *)defaultUser;

/**
 *  @brief  设置默认用户
 *
 *  @param defaultUser 默认用户对象
 */
- (void)setDefaultUser:(HWFUser *)defaultUser;

/**
 *  @brief  缓存用户对象
 *
 *  @param aUser 用户对象
 */
- (void)cacheUser:(HWFUser *)aUser;

/**
 *  @brief  清除默认用户
 */
- (void)clearDefaultUser;

#pragma mark - ROUTER
/**
 *  @brief  根据RID取路由对象
 *
 *  @param aRID RID
 *
 *  @return 路有对象
 */
- (HWFRouter *)routerWithRID:(NSInteger)aRID;

/**
 *  @brief  设置用户和路由的绑定关系(一对一)
 *
 *  @param theRouter 路由对象
 *  @param theUser   用户对象
 */
- (void)setBindRouter:(HWFRouter *)theRouter withUser:(HWFUser *)theUser;

/**
 *  @brief  获取用户绑定的路由列表
 *
 *  @param aUser 用户对象
 *
 *  @return 路由列表
 */
- (NSArray *)bindRoutersWithUser:(HWFUser *)aUser;

/**
 *  @brief  设置用户和路由的绑定关系(一对多)
 *
 *  @param theBindRouters 路由列表
 *  @param theUser        用户对象
 */
- (void)setBindRouters:(NSArray *)theBindRouters withUser:(HWFUser *)theUser;

/**
 *  @brief  校验用户是否有该路由的操作权限
 *
 *  @param aUser   用户对象
 *  @param aRouter 路由对象
 *
 *  @return 是否有权限
 */
- (BOOL)isAuthWithUser:(HWFUser *)aUser router:(HWFRouter *)aRouter;

/**
 *  @brief  获取默认路由
 *
 *  @return 默认路由对象
 */
- (HWFRouter *)defaultRouter;

/**
 *  @brief  设置默认路由
 *
 *  @param defaultRouter 默认路由对象
 */
- (void)setDefaultRouter:(HWFRouter *)defaultRouter;

/**
 *  @brief  缓存路由器对象
 *
 *  @param aRouter 路由器对象
 */
- (void)cacheRouter:(HWFRouter *)aRouter;

#pragma mark - Cache
/**
 *  @brief  清除所有缓存数据
 */
- (void)clearCache;

#pragma mark - Config Cache
/**
 *  @brief  缓存配置信息
 *
 *  @param config 配置信息
 *  @param key    KEY
 */
- (void)cacheConfig:(id)config WithKey:(NSString *)key;

/**
 *  @brief  获取缓存的配置信息
 *
 *  @param key KEY
 *
 *  @return 配置信息
 */
- (NSDictionary *)configWithKey:(NSString *)key;

@end
