//
//  HWFMessage.h
//  HiWiFiKoala
//
//  Created by dp on 14-10-16.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFObject.h"

// 消息优先级
typedef NS_ENUM(NSUInteger, MessageRank) {
    MessageRankHight = 1, // 高优先级
    MessageRankMedium = 2, // 中等优先级
    MessageRankLow = 3, // 低优先级
};

// 消息类型
typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeWeb = 10, // 打开网页
    MessageTypeNotice = 11, // 公告
    MessageTypeNews = 12, // 新闻
    MessageTypeDownloadURL = 13, // 下载链接
    
    MessageTypeNewDevice = 21, // 陌生设备连接
    MessageTypePartSpeedUpEnd = 22, // 单设备加速结束前
    MessageTypeWiFiChannel = 23, // WiFi信道拥挤
    MessageTypeWiFiSleep = 24, // WiFi定时关闭前
    MessageTypeWiFiPWDCrack = 25, // 破解WiFi密码
    
    MessageTypeROMUpgrade = 31, // ROM升级提醒
    MessageTypeAppUpgrade = 32, // App升级提醒
    
    MessageTypeRouterReport = 41, // 路由器简报
    
    MessageTypePluginInstall = 51, // 新增插件
    MessageTypePluginUpgrade = 52, // 更新插件
    MessageTypePluginConfig = 53, // 修改插件配置
    
    MessageTypeDownloadCompletion = 61, // 下载完成
    
};

@interface HWFMessage : HWFObject

@property (assign, nonatomic) NSInteger MID; // Message ID
@property (assign, nonatomic) NSInteger UID; // 归属用户UID
@property (assign, nonatomic) NSInteger RID; // 归属路由RID
@property (assign, nonatomic) MessageType type; // 消息类型
@property (strong, nonatomic) NSString *title; // 消息标题
@property (strong, nonatomic) NSString *content; // 消息内容
@property (strong, nonatomic) NSDate *createTime;
@property (strong, nonatomic) NSDate *updateTime;
@property (assign, nonatomic) BOOL status; // 消息状态 0-未读 1-已读
@property (assign, nonatomic) MessageRank rank; // 消息优先级
@property (strong, nonatomic) NSMutableDictionary *transData; // 透传消息
@property (strong, nonatomic) NSString  *ICON; // ICON图标的URL

@end
