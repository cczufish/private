//
//  HWFUser.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-14.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFUser.h"

#import "NSString+Extension.h"
#import "HWFDataCenter.h"

NSInteger const UID_NIL = -1;
NSString *const CLIENT_ID_PREFIX = @"Hiapp2014";

@implementation HWFUser

- (id)init {
    self = [super init];
    if (self) {
        _UID = UID_NIL;
    }
    return self;
}

+ (instancetype)defaultUser {
    return [[HWFDataCenter defaultCenter] defaultUser];
}

- (NSMutableArray *)bindRouterRIDs {
    if (!_bindRouterRIDs) {
        _bindRouterRIDs = [[NSMutableArray alloc] init];
    }
    
    return _bindRouterRIDs;
}

- (NSArray *)bindRouters {
    return [[HWFDataCenter defaultCenter] bindRoutersWithUser:self];
}

// Override
// MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"UID" : @"uid",
             @"uToken" : @"token",
             @"identity" : @"identity",
             @"username" : @"username",
             @"email" : @"email",
             @"mobile" : @"mobile",
             @"avatar" : @"avatar",
             @"loginTime" : @"loginTime",
             @"expirationTime" : @"expirationTime",
             @"preference" : @"preference",
             @"bindRouterRIDs" : @"bindRouterRIDs",
             @"clientID" : @"clientID"
             };
}

- (NSString *)clientID {
    if (self.UID == UID_NIL) {
        return nil;
    } else {
        // MD5(Hiapp2014+UID)
        return [[CLIENT_ID_PREFIX stringByAppendingFormat:@"%ld", (long)self.UID] MD5Encode];
    }
}

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"%@ ~> UID:%ld uToken:%@ identity:%@ username:%@ email:%@ mobile:%@ loginTime:%@ expirationTime:%@ preference:%@ bindRouters:%@ clientID:%@ avatar:%@", [self class], (long)self.UID, self.uToken, self.identity, self.username, self.email, self.mobile, self.loginTime, self.expirationTime, self.preference, self.bindRouterRIDs, self.clientID, self.avatar];
    return desc;
}

@end


#pragma mark - HWFUserPreference
@implementation HWFUserPreference

// @Override MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"closePushMessageSwitchArray" : @"closePushMessageSwitchArray",
             };
}

@end
