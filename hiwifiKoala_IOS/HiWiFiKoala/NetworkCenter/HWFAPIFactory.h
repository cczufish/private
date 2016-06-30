//
//  HWFAPIFactory.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, APIIdentity) {
    /// OTHER
    API_OPENAPI_BIND = 1000, // OpenAPI插件绑定
    API_APP_UPGRADE_INFO, // 检测App升级信息
    API_PUSHTOKEN_UPLOAD, // 上报设备PushToken
    API_CLEAR_CACHE, // 清空缓存
    API_GET_CLOUD_PLACEMAP, // 加载云端位置映射关系
    
    /// USER
    API_LOGIN = 2000, // 登录
    API_LOGOUT, // 登出
    API_GET_PROFILE, // 获取用户详细资料
    API_PERFECT_USERINFO, // 完善用户资料
    API_MODIFY_USERINFO, // 修改用户资料
    API_MODIFY_AVATAR, // 修改用户头像
    API_SEND_VERIFYCODE, // 发送验证码
    API_REGISTER_MOBILE, // 手机注册
    API_REGISTER_EMAIL, // 邮箱注册
    API_USER_PASSWORD_RESET, // 用户密码重置(通过手机验证码)
    API_USER_PASSWORD_MODIFY, // 修改用户密码(通过旧密码)
    
    /// ROUTER
    API_GET_ROUTER_LIST = 3100, // 获取用户绑定的路由器列表
    API_GET_ROUTER_DETAIL, // 获取路由器的详细信息
    API_GET_ROUTER_TRAFFIC, // 获取路由器的实时流量
    API_GET_ROUTER_TRAFFIC_HISTORY, // 获取路由器的历史流量
    API_GET_ROUTER_TRAFFIC_HISTORY_DETAIL, // 获取路由器流量历史详细记录
    API_GET_ROUTER_ONLINE_HISTORY_DETAIL, // 获取路由器连接历史详细记录
    API_SET_ROUTER_NAME, // 设置路由器备注名
    API_GET_ROUTER_IP_NP, // 获取路由器的IP和NP信息
    API_ROUTER_PASSWORD_MODIFY, // 修改路由器密码(通过旧密码)
    API_GET_ROUTER_TOPOLOGY, // 获取路由器拓扑结构
    API_GET_ROUTER_BACKUP_INFO, // 获取配置备份信息
    API_BACKUP_USER_CONFIG, // 备份路由器配置
    API_RESTORE_USER_CONFIG, // 还原路由器配置
    API_GET_WAN_INFO, // 获取WAN口信息大接口
    API_GET_ROUTER_CONTROL_OVERVIEW, // 获取路由器智能控制信息大接口
    API_SET_PLACE, // 设置位置信息 (MAC:Place)
    API_GET_ROM_UPGRADE_INFO, // 获取路由器ROM升级信息
    API_ROM_UPGRADE, // 执行路由器ROM升级
    API_ROUTER_UNBIND, // 解绑路由器
    API_GET_MODEL, // 根据MAC获取设备型号
    API_GET_ROUTER_EXAM_RESULT, // 执行体检，并获取体检结果
    API_DO_ROUTER_SPEEDTEST, // 开始测速
    API_GET_ROUTER_SPEEDTEST_RESULT, // 获取测速结果
    API_GET_ROUTER_OVERVIEW_NUMBERS, // 获取路由器相关数字类概要信息
    API_GET_CONNECTEDROUTER_INFO, // 获取直连路由器的相关信息
    API_REPORT_NP, // 用户反馈运营商信息
    API_GET_BINDUSER, // 根据MAC获取绑定此路由器的用户信息
    
    /// ROUTER CONTROL
    API_ROUTER_REBOOT = 3200, // 重启路由器
    API_ROUTER_RESET, // 重置路由器
    API_PARTSPEEDUP_LIST, // 获取单项加速列表
    API_PARTSPEEDUP_SET, // 设置单项加速
    API_PARTSPEEDUP_CANCEL, // 取消单项加速
    API_GET_LED_STATUS, // 获取路由器LED灯状态
    API_SET_LED_STATUS, // 设置路由器LED灯状态
    API_GET_WIFI_CHANNEL, // 获取路由器WiFi信道
    API_SET_WIFI_CHANNEL, // 设置路由器WiFi信道
    API_GET_WIFI_CHANNEL_RANK, // 扫描所有WiFi信道质量
    API_GET_WIFI_STATUS_2_4G, // 获取路由器2.4GWiFi开关状态
    API_GET_WIFI_STATUS_5G, // 获取路由器5GWiFi开关状态
    API_SET_WIFI_STATUS_2_4G, // 设置路由器2.4GWiFi开关状态
    API_SET_WIFI_STATUS_5G, // 设置路由器5GWiFi开关状态
    API_GET_WIFI_SLEEPCONFIG_2_4G, // 获取2.4GWiFi休眠配置
    API_GET_WIFI_SLEEPCONFIG_5G, // 获取5GWiFi休眠配置
    API_SET_WIFI_SLEEPCONFIG_2_4G, // 配置2.4GWiFi休眠信息
    API_SET_WIFI_SLEEPCONFIG_5G, // 配置5GWiFi休眠信息
    API_GET_WIFI_WIDEMODE, // 获取穿墙模式状态
    API_SET_WIFI_WIDEMODE, // 设置穿墙模式状态
    API_WIFI_PASSWORD_MODIFY_2_4G, // 修改2.4GWiFi密码
    API_WIFI_PASSWORD_MODIFY_5G, // 修改5GWiFi密码
    
    /// DEVICE
    API_GET_DEVICE_LIST = 4100, // 获取路由器当前连接设备列表
    API_GET_DEVICE_DETAIL, // 获取设备详细信息
    API_SET_DEVICE_NAME, // 设置设备备注名
    API_GET_BLACKLIST, // 获取黑名单
    API_ADD_TO_BLACKLIST, // 添加设备到黑名单
    API_REMOVE_FROM_BLACKLIST, // 从黑名单列表中移除设备(批量)
    API_CLEAR_BLACKLIST, // 清空黑名单
    API_GET_DEVICE_TRAFFIC_HISTORY_DETAIL, // 获取设备流量历史详细记录
    API_GET_DEVICE_ONLINE_HISTORY_DETAIL, // 获取设备连接历史详细记录
    API_GET_DEVICE_TRAFFIC, // 获取设备实时流量
    API_GET_DEVICE_QOS, // 获取设备限速信息
    API_SET_DEVICE_QOS, // 设置设备限速
    API_UNSET_DEVICE_QOS, // 取消设备限速
    API_GET_DEVICE_DISK_LIMIT, // 获取设备对存储的访问权限
    API_SET_DEVICE_DISK_LIMIT, // 设置设备对存储的访问权限
    
    /// SMART DEVICE
    API_RPT_MATCH = 4200, // 极卫星配对
    API_RPT_UNMATCH, // 极卫星取消配对
    
    /// PLUGIN
    API_GET_PLUGIN_INSTALLED_NUM = 5000, // 获取已安装插件数量
    API_GET_PLUGIN_INSTALLED_LIST, // 获取已安装插件列表
    API_GET_PLUGIN_CATEGORY_LIST, // 获取插件分类列表
    API_GET_PLUGIN_LIST_IN_CATEGORY, // 获取分类下的插件列表
    API_GET_PLUGIN_DETAIL, // 获取插件的详细信息
    API_PLUGIN_INSTALL, // 插件安装
    API_PLUGIN_UNINSTALL, // 插件卸载
    API_GET_PLUGIN_OPERATING_STATUS, // 插件操作(安装/卸载)状态查询
    
    /// STORAGE
    API_GET_PARTITION_LIST = 6100, // 获取存储分区列表
    API_FORMAT_PARTITION, // 分区格式化
    API_GET_FILE_LIST, // 获取文件/目录列表
    API_GET_STORAGE_INFO, // 获取存储状态
    API_READ_FILE, // 直连读取文件内容
    API_DELETE_FILE, // 删除文件
    API_REMOVE_DISK_SAFE, // 安全弹出磁盘设备
    
    /// DOWNLOAD
    API_GET_ALL_DOWNLOAD_TASKS = 6200, // 获取所有下载任务
    API_GET_DOWNLOADING_TASKS, // 获取下载中任务列表
    API_GET_DOWNLOADED_TASKS, // 获取已下载任务列表
    API_ADD_DOWNLOAD_TASK, // 新增下载任务
    API_REMOVE_DOWNLOAD_TASK, // 删除下载任务
    API_PAUSE_DOWNLOAD_TASK, // 暂停下载任务
    API_PAUSE_ALL_DOWNLOAD_TASKS, // 暂停所有下载任务
    API_RESUME_PAUSED_DOWNLOAD_TASK, // 恢复已暂停的下载任务
    API_RESUME_ALL_PAUSED_DOWNLOAD_TASKS, // 恢复所有暂停的下载任务
    API_GET_DOWNLOAD_TASK_DETAIL, // 获取下载任务的详细信息
    API_CLEAR_DOWNLOADING_TASKS, // 清除未完成任务(删除所有相关临时文件)
    API_CLEAR_DOWNLOADED_TASKS, // 清空已完成任务(不删除已下载文件)
    API_GET_DOWNLOADED_TASKS_NUM_AFTER_TIME, // 获取某个时间点之后已完成的任务个数
    
    /// MESSAGE CENTER
    API_GET_MESSAGE_LIST = 7000, // 获取消息列表
    API_GET_MESSAGE_DETAIL, // 获取消息详情
    API_SET_MESSAGE_STATUS, // 修改消息状态
    API_SET_ALL_MESSAGE_READ, // 设置所有消息为已读状态
    API_CLEAR_MESSAGE_LIST, // 清空消息列表
    API_GET_NEWMESSAGE_FLAG, // 获取是否有未读消息
    API_GET_CLOSE_MESSAGESWITCH_LIST, // 获取处于关闭状态的消息开关列表
    API_SET_MESSAGESWITCH_STATUS, // 修改消息开关状态
    
    /// WEB VIEW
    API_WEB_WEBADMIN = 8000, // 路由器后台管理WEB
    API_WEB_HARDWARE_INFO, // 硬件信息WEB
    API_WEB_NETWORK_CONFIG, // 上网设置WEB
    API_WEB_WIFI_CONFIG, // 无线WiFi设置WEB
    API_WEB_ROUTER_BIND, // 绑定路由器 // 需要拼接 &token=%@
    API_WEB_ROUTER_TURBO, // 电信加速
};

@interface HWFAPIFactory : NSObject

+ (HWFAPIFactory *)defaultFactory;

/**
 *  @brief  根据Identity取接口URL
 *
 *  @param identity Identity
 *
 *  @return URL
 */
- (NSString *)URLWithAPIIdentity:(APIIdentity)identity;

/**
 *  @brief  根据Identity取OpenAPI接口Method
 *
 *  @param identity Identity
 *
 *  @return Method
 */
- (NSString *)methodWithAPIIdentity:(APIIdentity)identity;

@end
