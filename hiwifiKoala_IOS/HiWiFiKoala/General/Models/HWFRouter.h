//
//  HWFRouter.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFObject.h"

@class HWFUser;
@class HWFWiFiSleepConfig;

NSInteger const RID_NIL;

#pragma mark - HWFRouter
@interface HWFRouter : HWFObject

@property (assign, nonatomic) NSInteger         RID;
@property (strong, nonatomic) NSString          *name;
@property (strong, nonatomic) NSString          *MAC;
@property (strong, nonatomic) NSString          *SSID24G;
@property (strong, nonatomic) NSString          *SSID5G;
@property (strong, nonatomic) NSString          *IP;
@property (strong, nonatomic) NSString          *NP; // 运营商
@property (strong, nonatomic) NSString          *model; // 型号 如：HC6361
@property (assign, nonatomic) NSInteger         place; // 位置
@property (strong, nonatomic) NSString          *ROM; // 当前路由器的ROM版本
@property (assign, nonatomic) BOOL              isNeedUpgrade; // 是否需要升级ROM
@property (assign, nonatomic) BOOL              isForceUpgrade; // 是否需要强制升级ROM
@property (strong, nonatomic) NSString          *latestROMVersion; // 最新的ROM版本号
@property (strong, nonatomic) NSString          *latestROMChangeLog; // 最新的ROMChangelog
@property (assign, nonatomic) NSInteger         latestROMSize; // 最新的ROM大小
@property (strong, nonatomic) NSString          *clientSecret;
@property (strong, nonatomic) NSString          *WANType; // WAN口连网方式 如：PPPoE
@property (strong, nonatomic) NSDate            *backupDate; // 上一次备份时间
@property (assign, nonatomic) BOOL              isOnline;
@property (assign, nonatomic) BOOL              LEDStatus;
@property (assign, nonatomic) BOOL              hasWiFi24G; // 是否有2.4GWiFi
@property (assign, nonatomic) BOOL              hasWiFi5G; // 是否有5GWiFi
@property (assign, nonatomic) BOOL              WiFi24GStatus; // 2.4G开关状态
@property (assign, nonatomic) BOOL              WiFi5GStatus; // 5G开关状态
@property (assign, nonatomic) BOOL              wideMode; // WiFi穿墙开关
@property (assign, nonatomic) NSInteger         WiFiChannel; // WiFi信道 0-自动
@property (strong, nonatomic) HWFWiFiSleepConfig *WiFi24GSleepConfig; // 2.4GWiFi休眠配置
@property (strong, nonatomic) HWFWiFiSleepConfig *WiFi5GSleepConfig; // 5GWiFi休眠配置
//@property (strong, nonatomic) NSMutableArray    *plugins; // 路由器已安装的插件列表
@property (strong, nonatomic) NSMutableArray    *smartDevices; // 已连接的智能设备列表
//@property (strong, nonatomic) NSMutableArray    *devices; // 已连接的设备列表

+ (instancetype)defaultRouter;

- (BOOL)isAuthWithUser:(HWFUser *)aUser;

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

///**
// *  @brief  返回SSID
// *
// *  @return 优先级: 2.4G SSID > 5G SSID
// */
//- (NSString *)SSID;
//
///**
// *  @brief  返回WiFi开关状态
// *
// *  @return 优先级: 2.4GWiFi开关状态 > 5GWiFi开关状态
// */
//- (BOOL)WiFiStatus;

@end


#pragma mark - HWFWiFiSleepConfig
// WiFi类型
typedef NS_ENUM(NSUInteger, WiFiType) {
    WiFiType_2_4G, // 2.4G无线
    WiFiType_5G, // 5G无线
};

@interface HWFWiFiSleepConfig : HWFObject

@property (assign, nonatomic) WiFiType  type;
@property (assign, nonatomic) BOOL      status; // YES:开 NO:关
@property (assign, nonatomic) NSInteger WiFiOff; // WiFi关闭时间
@property (assign, nonatomic) NSInteger WiFiOn;  // WiFi开启时间

@end