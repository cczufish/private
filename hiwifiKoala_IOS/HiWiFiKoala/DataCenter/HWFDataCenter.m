//
//  HWFDataCenter.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-14.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDataCenter.h"

#import "HWFUser.h"
#import "HWFRouter.h"

#import <TMCache/TMCache.h>

#define CACHE_ROOT_PATH ([[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/Caches"])

NSString *const kDefaultUserUIDCache = @"DefaultUserUIDCache";
NSString *const kUserCache = @"UserCache_";

NSString *const kDefaultRouterRIDCache = @"DefaultRouterRIDCache";
NSString *const kRouterCache = @"RouterCache_";

@interface HWFDataCenter ()

@property (strong, nonatomic) TMCache *cache;

@end

@implementation HWFDataCenter

+ (HWFDataCenter *)defaultCenter {
    static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark - Cache
- (TMCache *)cache {
    if (!_cache) {
        _cache = [[TMCache alloc] initWithName:APP_VERSION rootPath:CACHE_ROOT_PATH];
        DDLogDebug(@"CACHE PATH: %@", _cache.diskCache.cacheURL);
    }
    return _cache;
}

#pragma mark - USER
- (HWFUser *)userWithUID:(NSInteger)aUID {
    return [self.cache objectForKey:[kUserCache stringByAppendingFormat:@"%ld", (long)aUID]];
}

- (void)cacheUser:(HWFUser *)aUser {
    [self.cache setObject:aUser forKey:[kUserCache stringByAppendingFormat:@"%ld", (long)aUser.UID]];
}

- (HWFUser *)defaultUser {
    NSNumber *aUID = [self.cache objectForKey:kDefaultUserUIDCache];
    HWFUser *defaultUser = aUID ? [self userWithUID:[aUID integerValue]] : nil;

    return defaultUser;
}

- (void)setDefaultUser:(HWFUser *)defaultUser {
    [self cacheUser:defaultUser];
    
    [self.cache setObject:@(defaultUser.UID) forKey:kDefaultUserUIDCache];
}

- (void)clearDefaultUser {
    [self.cache removeObjectForKey:kDefaultUserUIDCache];
    
    [self clearDefaultRouter];
}

#pragma mark - ROUTER
- (HWFRouter *)routerWithRID:(NSInteger)aRID {
    return [self.cache objectForKey:[kRouterCache stringByAppendingFormat:@"%ld", (long)aRID]];
}

- (void)cacheRouter:(HWFRouter *)aRouter {
    [self.cache setObject:aRouter forKey:[kRouterCache stringByAppendingFormat:@"%ld", (long)aRouter.RID]];
}

- (NSArray *)bindRoutersWithUser:(HWFUser *)aUser {
    NSMutableArray *bindRouters = [NSMutableArray array];
    for (NSNumber *RID in aUser.bindRouterRIDs) {
        HWFRouter *router = [self routerWithRID:[RID integerValue]];
        [bindRouters addObject:router];
    }
    return bindRouters;
}

- (void)setBindRouter:(HWFRouter *)theRouter withUser:(HWFUser *)theUser {
    if (![theUser.bindRouterRIDs containsObject:@(theRouter.RID)]) {
        [theUser.bindRouterRIDs addObject:@(theRouter.RID)];
    }
    [self.cache setObject:theUser forKey:[kUserCache stringByAppendingFormat:@"%ld", (long)theUser.UID]];
}

- (void)setBindRouters:(NSArray *)theBindRouters withUser:(HWFUser *)theUser {
    [theUser.bindRouterRIDs removeAllObjects];
    for (HWFRouter *router in theBindRouters) {
        [self setBindRouter:router withUser:theUser];
    }
}

- (BOOL)isAuthWithUser:(HWFUser *)aUser router:(HWFRouter *)aRouter {
    return [aUser.bindRouterRIDs containsObject:@(aRouter.RID)];
}

- (HWFRouter *)defaultRouter {
    NSNumber *aRID = [self.cache objectForKey:kDefaultRouterRIDCache];
    HWFRouter *defaultRouter = aRID ? [self routerWithRID:[aRID integerValue]] : [[self bindRoutersWithUser:[self defaultUser]] firstObject];
    
    return defaultRouter;
}

- (void)setDefaultRouter:(HWFRouter *)defaultRouter {
    [self cacheRouter:defaultRouter];
    
    [self.cache setObject:@(defaultRouter.RID) forKey:kDefaultRouterRIDCache];
}

- (void)clearDefaultRouter {
    [self.cache removeObjectForKey:kDefaultRouterRIDCache];
}

- (void)clearCache {
    [self.cache removeAllObjects];
}

#pragma mark - Config Cache
- (void)cacheConfig:(id)config WithKey:(NSString *)key {
    NSDictionary *configDict = @{ kCacheDate:[NSDate date],kCacheData:config };
    [self.cache setObject:configDict forKey:key];
}

- (NSDictionary *)configWithKey:(NSString *)key {
    return [self.cache objectForKey:key];
}

@end
