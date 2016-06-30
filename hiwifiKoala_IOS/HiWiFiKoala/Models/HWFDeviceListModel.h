//
//  HWFDeviceListModel.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-16.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDevice.h"


@interface HWFDeviceListModel : HWFDevice
//@property (strong, nonatomic) NSString    *name;
//@property (strong, nonatomic) NSString    *MAC;
//@property (strong, nonatomic) NSString    *IP;
//@property (assign, nonatomic) NSInteger   signal;// 信号强度
//@property (assign, nonatomic) BOOL        RPT; // 是否是极卫星
//@property (assign, nonatomic) BOOL        QoSStatus;// 限速状态 0-不限 1-限速
//@property (assign, nonatomic) double      QoSUp;// 上行限速值 KB
//@property (assign, nonatomic) double      QoSDown;// 下行限速值 KB
//@property (assign, nonatomic) double      trafficUp;// 上行流量 KB
//@property (assign, nonatomic) double      trafficDown;// 下行流量 KB
//@property (assign, nonatomic) long        timeTotal;// 连接总时长 秒
//@property (assign, nonatomic) long        trafficTotal;// 总流量 KB
//@property (assign, nonatomic) BOOL        isDiskLimit;// 是否限制路由盘访问
//@property (assign, nonatomic) ConnectType connectType;// 连接方式
//{
//    comid = 0;
//    "is_block" = 0;
//    mac = "4c:aa:16:23:d2:38";
//    name = "android-5e8b100f30cb1a40";
//    online = 0;
//    "qos_down" = 0;
//    "qos_status" = 0;
//    "qos_up" = 0;
//    rpt = 0;
//    time = 187;
//    traffic = 125945425;
//    type = wifi;
//},

@property (nonatomic,assign) BOOL isBlock; // 该设备是否在黑名单中
@property (assign, nonatomic) BOOL isOnline; // 是否在线
@property (assign, nonatomic) NSInteger totalTime; // 连接时长


@end
