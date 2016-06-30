//
//  HWFAPI.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFObject.h"

#import "HWFAPIFactory.h"
#import "HWFAPITableViewCell.h"

typedef NS_ENUM(NSUInteger, APIResult) {
    API_RESULT_DEFAULT = 0,
    API_RESULT_SUCCESS,
    API_RESULT_FAILURE,
};

@interface HWFAPI : HWFObject

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) APIIdentity identity;
@property (strong, nonatomic) NSString *mark;
@property (assign, nonatomic) APIResult result;

- (instancetype)initWithAPIName:(NSString *)aName identity:(APIIdentity)anIdentity mark:(NSString *)aMark;

@end
