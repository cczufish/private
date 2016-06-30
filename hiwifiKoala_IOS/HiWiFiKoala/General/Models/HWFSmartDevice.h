//
//  HWFSmartDevice.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-29.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//
#import "HWFDevice.h"

@interface HWFSmartDevice : HWFDevice

@property (strong, nonatomic) NSString  *model;
@property (assign, nonatomic) NSInteger place;
@property (assign, nonatomic) NSInteger matchStatus;// 配对状态 0-未配对 1-配对成功 2-已与其他路由配对

@end
