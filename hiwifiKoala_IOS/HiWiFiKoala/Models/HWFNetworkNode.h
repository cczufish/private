//
//  HWFNetworkNode.h
//  HiWiFiKoala
//
//  Created by dp on 14-10-16.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFObject.h"

// 网络节点类型
typedef NS_ENUM(NSUInteger, NetworkNodeType) {
    NetworkNodeTypeWAN = 1, // 互联网
    NetworkNodeTypeGatewayRouter, // 网关路由器
    NetworkNodeTypeSmartDevice, // 智能设备
};

@interface HWFNetworkNode : HWFObject

@property (assign, nonatomic) NetworkNodeType type; // 节点类型
@property (strong, nonatomic) id nodeEntity; // 节点实体

@end
