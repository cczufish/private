//
//  HWFAPI.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFAPI.h"

@implementation HWFAPI

- (instancetype)initWithAPIName:(NSString *)aName identity:(APIIdentity)anIdentity mark:(NSString *)aMark {
    self = [super init];
    if (self) {
        _name = aName;
        _identity = anIdentity;
        _mark = aMark;
        _result = API_RESULT_DEFAULT;
    }
    return self;
}

// @Override MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name" : @"name",
             @"identity" : @"identity",
             @"mark" : @"mark",
             @"result" : @"result"
             };
}

@end
