//
//  HWFPartSpeedUpItem.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDevice.h"

@interface HWFPartSpeedUpItem : HWFDevice

//@property (strong, nonatomic) NSString *itemId; // itemId暂时就是mac
//@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *iconURL;
@property (assign, nonatomic) NSInteger status; // 当前状态：0，未加速；1，加速中
//@property (assign, nonatomic) NSInteger timeTotal; // 总时长 单位：秒
@property (assign, nonatomic) NSInteger timeOver; // 剩余时长 单位：秒
@property (assign, nonatomic) BOOL rpt; // 设备是否是极卫星 NO-不是 YES-是极卫星
@property (assign, nonatomic) NSTimeInterval finishTimeInterval; // 加速结束时间戳 <=0时表示未开始加速


@end
