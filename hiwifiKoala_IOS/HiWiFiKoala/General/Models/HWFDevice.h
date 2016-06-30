//
//  HWFDevice.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-29.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFObject.h"

// 连接方式
typedef NS_ENUM(NSUInteger, ConnectType) {
    ConnectTypeLine = 1, // 有线
    ConnectTypeWiFi_2_4G, // 2.4G无线
    ConnectTypeWiFi_5G, // 5G无线
};

@interface HWFDevice : HWFObject

@property (strong, nonatomic) NSString    *name;
@property (strong, nonatomic) NSString    *MAC;
@property (strong, nonatomic) NSString    *IP;
@property (assign, nonatomic) NSInteger   signal;// 信号强度
@property (assign, nonatomic) BOOL        RPT; // 是否是极卫星
@property (assign, nonatomic) BOOL        QoSStatus;// 限速状态 0-不限 1-限速
@property (assign, nonatomic) double      QoSUp;// 上行限速值 KB
@property (assign, nonatomic) double      QoSDown;// 下行限速值 KB
@property (assign, nonatomic) double      trafficUp;// 上行流量 KB
@property (assign, nonatomic) double      trafficDown;// 下行流量 KB
@property (assign, nonatomic) long        timeTotal;// 连接总时长 秒
@property (assign, nonatomic) long        trafficTotal;// 总流量 KB
@property (assign, nonatomic) BOOL        isDiskLimit;// 是否限制路由盘访问
@property (assign, nonatomic) ConnectType connectType;// 连接方式
@property (strong, nonatomic) NSString    *ComICON; // 设备品牌ICON

/**
 *  返回标准化的MAC地址，大写/无分隔符
 *
 *  @return 标准MAC地址
 */
- (NSString *)standardMAC;

/**
 *  @brief  返回用于显示的MAC地址，大写/':'分割
 *
 *  @return 用于显示的MAC地址
 */
- (NSString *)displayMAC;

/**
 *  @brief  返回用于显示的设备名称
 *
 *  @return 用于显示的设备名称
 */
- (NSString *)displayName;

@end
