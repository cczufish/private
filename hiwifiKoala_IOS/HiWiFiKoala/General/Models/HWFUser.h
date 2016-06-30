//
//  HWFUser.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-14.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFObject.h"

@class HWFUserPreference;

NSInteger const UID_NIL;

typedef NS_ENUM(NSUInteger, UserGender) {
    UserGenderUnknown = 0,
    UserGenderMale, // 男
    UserGenderFemale, // 女
};

#pragma mark - HWFUser
@interface HWFUser : HWFObject

@property (assign, nonatomic) NSInteger         UID;
@property (strong, nonatomic) NSString          *uToken;
@property (strong, nonatomic) NSString          *identity; // username/email/mobile
@property (strong, nonatomic) NSString          *username; // 用户名
@property (strong, nonatomic) NSString          *email; // email
@property (strong, nonatomic) NSString          *mobile; // 手机号码
@property (strong, nonatomic) NSString          *avatar; // 头像地址
@property (strong, nonatomic) NSDate            *loginTime;
@property (strong, nonatomic) NSDate            *expirationTime;
@property (strong, nonatomic) HWFUserPreference *preference; // 用户偏好设置
@property (strong, nonatomic) NSMutableArray    *bindRouterRIDs; // 已绑定的路由器RID列表
@property (strong, nonatomic) NSString          *clientID;
@property (assign, nonatomic) UserGender        gender; // 性别

+ (instancetype)defaultUser;

- (NSArray *)bindRouters;

@end


#pragma mark - HWFUserPreference
@interface HWFUserPreference : HWFObject

@property (strong, nonatomic) NSMutableArray *closePushMessageSwitchArray; // 处于关闭状态的推送开关类型列表

@end