//
//  AppMacro.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-13.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#ifndef HiWiFiKoala_AppMacro_h
#define HiWiFiKoala_AppMacro_h

// 请求超时时间，单位：秒
#define REQUEST_TIMEOUT_INTERVAL 30.0

// DDLog
#ifdef LOG_ENABLE
static const int ddLogLevel = LOG_LEVEL_ALL;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif

// 手机远程管理插件AppID
#define MOBILE_PLUGIN_APP_ID 13
// 手机远程管理插件AppName
#define MOBILE_PLUGIN_APP_NAME @"mobile"
// 自定义ERROR的DOMAIN
#define REQUEST_ERROR_DOMAIN @"com.hiwifi.error"
// 调用接口时的请求来源
#define APP_SRC @"hiwifi"
// 极路由MAC地址前缀
#define HIWIFI_MAC_PREFIX @"D4EE07|D6EE07|"

#endif
