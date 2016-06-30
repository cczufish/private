//
//  HWFObject.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-13.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFObject.h"

@implementation HWFObject

// abstract
// MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    DDLogVerbose(@"To Be Override...");
    return nil;
}

@end
