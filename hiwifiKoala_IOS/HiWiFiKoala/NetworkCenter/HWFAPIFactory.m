//
//  HWFAPIFactory.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFAPIFactory.h"

// Production HTTP
#define P_USER_HTTP     @"http://user.hiwifi.com"
#define P_M_HTTP        @"http://m.hiwifi.com"
#define P_TW_HTTP       @"http://www.4006024680.com"
#define P_APP_HTTP      @"http://app.hiwifi.com"
#define P_CLIENT_HTTP   @"http://client.openapi.hiwifi.com"
#define P_OPENAPI_HTTP  @"http://openapi.hiwifi.com"
// Production HTTPS
#define P_USER_HTTPS    @"https://user.hiwifi.com"
#define P_M_HTTPS       @"https://m.hiwifi.com"
#define P_TW_HTTPS      @"https://www.4006024680.com"
#define P_APP_HTTPS     @"https://app.hiwifi.com"
#define P_CLIENT_HTTPS  @"https://client.openapi.hiwifi.com"
#define P_OPENAPI_HTTPS @"https://openapi.hiwifi.com"
// Testing HTTP
#define T_USER_HTTP     @"http://mt.user.hiwifi.com"
#define T_M_HTTP        @"http://mt.m.hiwifi.com"
#define T_TW_HTTP       @"http://mt.www.4006024680.com"
#define T_APP_HTTP      @"http://mt.app.hiwifi.com"
#define T_CLIENT_HTTP   @"http://mt.client.openapi.hiwifi.com"
#define T_OPENAPI_HTTP  @"http://mt.openapi.hiwifi.com"
// Testing HTTPS
#define T_USER_HTTPS    @"https://mt.user.hiwifi.com"
#define T_M_HTTPS       @"https://mt.m.hiwifi.com"
#define T_TW_HTTPS      @"https://mt.www.4006024680.com"
#define T_APP_HTTPS     @"https://mt.app.hiwifi.com"
#define T_CLIENT_HTTPS  @"https://mt.client.openapi.hiwifi.com"
#define T_OPENAPI_HTTPS @"https://mt.openapi.hiwifi.com"

// FILE READ URL
#define READ_FILE @"http://dl.hiwifi.com"

@interface HWFAPIFactory ()

@property (strong, nonatomic) NSString *URL_USER_HTTP;
@property (strong, nonatomic) NSString *URL_USER_HTTPS;
@property (strong, nonatomic) NSString *URL_M_HTTP;
@property (strong, nonatomic) NSString *URL_M_HTTPS;
@property (strong, nonatomic) NSString *URL_TW_HTTP;
@property (strong, nonatomic) NSString *URL_TW_HTTPS;
@property (strong, nonatomic) NSString *URL_APP_HTTP;
@property (strong, nonatomic) NSString *URL_APP_HTTPS;
@property (strong, nonatomic) NSString *URL_CLIENT_HTTP;
@property (strong, nonatomic) NSString *URL_CLIENT_HTTPS;
@property (strong, nonatomic) NSString *URL_OPENAPI_HTTP;
@property (strong, nonatomic) NSString *URL_OPENAPI_HTTPS;

@end

@implementation HWFAPIFactory

+ (HWFAPIFactory *)defaultFactory {
    static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
#ifdef GOD_MODE
        if (IS_TESTING_ENV) {
            _URL_USER_HTTP = T_USER_HTTP;
            _URL_USER_HTTPS = T_USER_HTTPS;
            _URL_M_HTTP = T_M_HTTP;
            _URL_M_HTTPS = T_M_HTTPS;
            _URL_TW_HTTP = T_TW_HTTP;
            _URL_TW_HTTPS = T_TW_HTTPS;
            _URL_APP_HTTP = T_APP_HTTP;
            _URL_APP_HTTPS = T_APP_HTTPS;
            _URL_CLIENT_HTTP = T_CLIENT_HTTP;
            _URL_CLIENT_HTTPS = T_CLIENT_HTTPS;
            _URL_OPENAPI_HTTP = T_OPENAPI_HTTP;
            _URL_OPENAPI_HTTPS = T_OPENAPI_HTTPS;
        } else {
            _URL_USER_HTTP = P_USER_HTTP;
            _URL_USER_HTTPS = P_USER_HTTPS;
            _URL_M_HTTP = P_M_HTTP;
            _URL_M_HTTPS = P_M_HTTPS;
            _URL_TW_HTTP = P_TW_HTTP;
            _URL_TW_HTTPS = P_TW_HTTPS;
            _URL_APP_HTTP = P_APP_HTTP;
            _URL_APP_HTTPS = P_APP_HTTPS;
            _URL_CLIENT_HTTP = P_CLIENT_HTTP;
            _URL_CLIENT_HTTPS = P_CLIENT_HTTPS;
            _URL_OPENAPI_HTTP = P_OPENAPI_HTTP;
            _URL_OPENAPI_HTTPS = P_OPENAPI_HTTPS;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleURLSetting:) name:UIApplicationWillEnterForegroundNotification object:nil];
#else
        _URL_USER_HTTP = P_USER_HTTP;
        _URL_USER_HTTPS = P_USER_HTTPS;
        _URL_M_HTTP = P_M_HTTP;
        _URL_M_HTTPS = P_M_HTTPS;
        _URL_TW_HTTP = P_TW_HTTP;
        _URL_TW_HTTPS = P_TW_HTTPS;
        _URL_APP_HTTP = P_APP_HTTP;
        _URL_APP_HTTPS = P_APP_HTTPS;
        _URL_CLIENT_HTTP = P_CLIENT_HTTP;
        _URL_CLIENT_HTTPS = P_CLIENT_HTTPS;
        _URL_OPENAPI_HTTP = P_OPENAPI_HTTP;
        _URL_OPENAPI_HTTPS = P_OPENAPI_HTTPS;
#endif
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)handleURLSetting:(NSNotification *)notification
{
    if (IS_TESTING_ENV) {
        _URL_USER_HTTP = T_USER_HTTP;
        _URL_USER_HTTPS = T_USER_HTTPS;
        _URL_M_HTTP = T_M_HTTP;
        _URL_M_HTTPS = T_M_HTTPS;
        _URL_TW_HTTP = T_TW_HTTP;
        _URL_TW_HTTPS = T_TW_HTTPS;
        _URL_APP_HTTP = T_APP_HTTP;
        _URL_APP_HTTPS = T_APP_HTTPS;
        _URL_CLIENT_HTTP = T_CLIENT_HTTP;
        _URL_CLIENT_HTTPS = T_CLIENT_HTTPS;
        _URL_OPENAPI_HTTP = T_OPENAPI_HTTP;
        _URL_OPENAPI_HTTPS = T_OPENAPI_HTTPS;
    } else {
        _URL_USER_HTTP = P_USER_HTTP;
        _URL_USER_HTTPS = P_USER_HTTPS;
        _URL_M_HTTP = P_M_HTTP;
        _URL_M_HTTPS = P_M_HTTPS;
        _URL_TW_HTTP = P_TW_HTTP;
        _URL_TW_HTTPS = P_TW_HTTPS;
        _URL_APP_HTTP = P_APP_HTTP;
        _URL_APP_HTTPS = P_APP_HTTPS;
        _URL_CLIENT_HTTP = P_CLIENT_HTTP;
        _URL_CLIENT_HTTPS = P_CLIENT_HTTPS;
        _URL_OPENAPI_HTTP = P_OPENAPI_HTTP;
        _URL_OPENAPI_HTTPS = P_OPENAPI_HTTPS;
    }
}

- (NSString *)URLWithAPIIdentity:(APIIdentity)identity {
    NSString *URL = @"";
    
    switch (identity) {
        case API_OPENAPI_BIND:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_M_HTTPS, @"/api/Open/bind"];
        }
            break;
        case API_APP_UPGRADE_INFO:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_APP_HTTPS, @"/router.php?m=json&a=check_ios_upgrade"];
        }
            break;
        case API_PUSHTOKEN_UPLOAD:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_APP_HTTPS, @"/router.php?m=json&a=add_ios_push_token"];
        }
            break;
        case API_GET_CLOUD_PLACEMAP:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_OPENAPI_HTTPS, @"/app.getmaps"];
        }
            break;
        case API_LOGIN:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_USER_HTTPS, @"/index.php?m=ssov2&a=auth"];
        }
            break;
        case API_LOGOUT:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_M_HTTPS, @"/api/Open/logout"];
        }
            break;
        case API_GET_PROFILE:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_USER_HTTPS, @"/mapi.php?m=user&a=getprofile"];
        }
            break;
        case API_PERFECT_USERINFO:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_USER_HTTPS, @"/mapi.php?m=user&a=change_init_username_pwd"];
        }
            break;
        case API_MODIFY_USERINFO:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_USER_HTTPS, @"/mapi.php?m=user&a=editprofile"];
        }
            break;
        case API_MODIFY_AVATAR:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_USER_HTTPS, @"/mapi.php?m=user&a=update_avatars"];
        }
            break;
        case API_SEND_VERIFYCODE:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_USER_HTTPS, @"/mapi.php?m=sms&a=send_mobile_code"];
        }
            break;
        case API_REGISTER_MOBILE:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_USER_HTTPS, @"/mapi.php?m=user&a=login"];
        }
            break;
        case API_REGISTER_EMAIL:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_USER_HTTPS, @"/mobile.php?m=register&a=register&source=mobile"];
        }
            break;
        case API_USER_PASSWORD_RESET:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_USER_HTTPS, @"/mapi.php?m=user&a=reset_pwd"];
        }
            break;
        case API_USER_PASSWORD_MODIFY:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_USER_HTTPS, @"/mapi.php?m=user&a=change_pwd"];
        }
            break;
        case API_ROUTER_UNBIND:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_USER_HTTPS, @"/mapi.php?m=user&a=unbind"];
        }
            break;
        case API_GET_ROM_UPGRADE_INFO:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_APP_HTTPS, @"/router.php?m=json&a=check_router_upgrade"];
        }
            break;
        case API_ROM_UPGRADE:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_APP_HTTPS, @"/router.php?m=json&a=do_router_upgrade"];
        }
            break;
        case API_GET_ROUTER_LIST:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_APP_HTTPS, @"/router.php?m=json&a=bind_list_30"];
        }
            break;
        case API_SET_ROUTER_NAME:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_APP_HTTPS, @"/router.php?m=json&a=set_router_name"];
        }
            break;
        case API_GET_ROUTER_IP_NP:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_APP_HTTPS, @"/router.php?m=json&a=get_np"];
        }
            break;
        case API_REPORT_NP:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_M_HTTPS, @"/api/UserFeedback/ReportNp"];
        }
            break;
        case API_GET_BINDUSER:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_OPENAPI_HTTPS, @"/user.getuserbymac"];
        }
            break;
        case API_GET_CONNECTEDROUTER_INFO:
        {
            URL = [NSString stringWithFormat:@"%@/%@", self.URL_CLIENT_HTTP, @"router_info"];
        }
            break;
        case API_GET_ROUTER_SPEEDTEST_RESULT:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_M_HTTPS, @"/api/Exam/getStResult"];
        }
            break;
        case API_GET_MESSAGE_LIST:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_M_HTTPS, @"/api/Message/get_message_list"];
        }
            break;
        case API_GET_MESSAGE_DETAIL:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_M_HTTPS, @"/api/Message/get_message_view"];
        }
            break;
        case API_SET_MESSAGE_STATUS:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_M_HTTPS, @"/api/Message/update_message_status"];
        }
            break;
        case API_SET_ALL_MESSAGE_READ:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_M_HTTPS, @"/api/Message/set_all_read"];
        }
            break;
        case API_CLEAR_MESSAGE_LIST:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_M_HTTPS, @"/api/Message/del_all_message"];
        }
            break;
        case API_GET_NEWMESSAGE_FLAG:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_M_HTTPS, @"/api/Message/get_has_new_message"];
        }
            break;
        case API_GET_CLOSE_MESSAGESWITCH_LIST:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_M_HTTPS, @"/api/Message/get_close_switch"];
        }
            break;
        case API_SET_MESSAGESWITCH_STATUS:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_M_HTTPS, @"/api/Message/change_switch_status"];
        }
            break;
        case API_GET_PLUGIN_INSTALLED_NUM:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_OPENAPI_HTTPS, @"/app.getnum"];
        }
            break;
        case API_GET_PLUGIN_INSTALLED_LIST:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_OPENAPI_HTTPS, @"/app.installedlist"];
        }
            break;
        case API_GET_PLUGIN_CATEGORY_LIST:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_OPENAPI_HTTPS, @"/app.getcatlist"];
        }
            break;
        case API_GET_PLUGIN_LIST_IN_CATEGORY:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_OPENAPI_HTTPS, @"/app.getcatapps"];
        }
            break;
        case API_GET_PLUGIN_DETAIL:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_OPENAPI_HTTPS, @"/app.appinfo"];
        }
            break;
        case API_PLUGIN_INSTALL:
        case API_PLUGIN_UNINSTALL:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_OPENAPI_HTTPS, @"/app.sendconf"];
        }
            break;
        case API_GET_PLUGIN_OPERATING_STATUS:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_OPENAPI_HTTPS, @"/app.checkstatus"];
        }
            break;
        case API_WEB_WEBADMIN:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_TW_HTTP, @"/cgi-bin/turbo/admin_mobile?hideheadfoot=1"];
        }
            break;
        case API_WEB_HARDWARE_INFO:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_TW_HTTP, @"/cgi-bin/turbo/admin_mobile/info?hideheadfoot=1"];
        }
            break;
        case API_WEB_NETWORK_CONFIG:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_TW_HTTP, @"/cgi-bin/turbo/admin_mobile/network?hideheadfoot=1"];
        }
            break;
        case API_WEB_WIFI_CONFIG:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_TW_HTTP, @"/cgi-bin/turbo/admin_mobile/wifi?hideheadfoot=1"];
        }
            break;
        case API_WEB_ROUTER_BIND:
        {
            URL = [NSString stringWithFormat:@"%@%@", self.URL_TW_HTTP, @"/cgi-bin/turbo/admin_web?clinet_bind=1"];
        }
            break;
        case API_WEB_ROUTER_TURBO:
        {
            URL = @"http://operators.hiwifi.com/telecom.php?m=telecom&a=index";
        }
            break;
        case API_READ_FILE:
        {
            URL = READ_FILE;
        }
            break;
        case API_GET_ROUTER_DETAIL:
        case API_ROUTER_PASSWORD_MODIFY:
        case API_GET_ROUTER_TRAFFIC:
        case API_GET_ROUTER_TRAFFIC_HISTORY:
        case API_GET_ROUTER_TRAFFIC_HISTORY_DETAIL:
        case API_GET_ROUTER_ONLINE_HISTORY_DETAIL:
        case API_GET_ROUTER_TOPOLOGY:
        case API_GET_ROUTER_OVERVIEW_NUMBERS:
        case API_GET_ROUTER_BACKUP_INFO:
        case API_BACKUP_USER_CONFIG:
        case API_RESTORE_USER_CONFIG:
        case API_GET_LED_STATUS:
        case API_SET_LED_STATUS:
        case API_GET_WIFI_CHANNEL:
        case API_SET_WIFI_CHANNEL:
        case API_GET_WIFI_CHANNEL_RANK:
        case API_GET_WAN_INFO:
        case API_GET_ROUTER_CONTROL_OVERVIEW:
        case API_SET_PLACE:
        case API_GET_MODEL:
        case API_GET_ROUTER_EXAM_RESULT:
        case API_DO_ROUTER_SPEEDTEST:
        case API_ROUTER_REBOOT:
        case API_ROUTER_RESET:
        case API_GET_WIFI_WIDEMODE:
        case API_SET_WIFI_WIDEMODE:
        case API_PARTSPEEDUP_LIST:
        case API_PARTSPEEDUP_SET:
        case API_PARTSPEEDUP_CANCEL:
        case API_GET_WIFI_STATUS_2_4G:
        case API_GET_WIFI_STATUS_5G:
        case API_SET_WIFI_STATUS_2_4G:
        case API_SET_WIFI_STATUS_5G:
        case API_GET_WIFI_SLEEPCONFIG_2_4G:
        case API_GET_WIFI_SLEEPCONFIG_5G:
        case API_SET_WIFI_SLEEPCONFIG_2_4G:
        case API_SET_WIFI_SLEEPCONFIG_5G:
        case API_WIFI_PASSWORD_MODIFY_2_4G:
        case API_WIFI_PASSWORD_MODIFY_5G:
        case API_GET_DEVICE_LIST:
        case API_GET_DEVICE_DETAIL:
        case API_SET_DEVICE_NAME:
        case API_GET_BLACKLIST:
        case API_ADD_TO_BLACKLIST:
        case API_REMOVE_FROM_BLACKLIST:
        case API_CLEAR_BLACKLIST:
        case API_GET_DEVICE_TRAFFIC_HISTORY_DETAIL:
        case API_GET_DEVICE_ONLINE_HISTORY_DETAIL:
        case API_GET_DEVICE_TRAFFIC:
        case API_GET_DEVICE_QOS:
        case API_SET_DEVICE_QOS:
        case API_UNSET_DEVICE_QOS:
        case API_GET_DEVICE_DISK_LIMIT:
        case API_SET_DEVICE_DISK_LIMIT:
        case API_RPT_MATCH:
        case API_RPT_UNMATCH:
        case API_GET_PARTITION_LIST:
        case API_FORMAT_PARTITION:
        case API_GET_FILE_LIST:
        case API_GET_STORAGE_INFO:
        case API_REMOVE_DISK_SAFE:
        case API_DELETE_FILE:
        case API_GET_ALL_DOWNLOAD_TASKS:
        case API_GET_DOWNLOADING_TASKS:
        case API_GET_DOWNLOADED_TASKS:
        case API_ADD_DOWNLOAD_TASK:
        case API_REMOVE_DOWNLOAD_TASK:
        case API_PAUSE_DOWNLOAD_TASK:
        case API_PAUSE_ALL_DOWNLOAD_TASKS:
        case API_RESUME_PAUSED_DOWNLOAD_TASK:
        case API_RESUME_ALL_PAUSED_DOWNLOAD_TASKS:
        case API_GET_DOWNLOAD_TASK_DETAIL:
        case API_CLEAR_DOWNLOADING_TASKS:
        case API_CLEAR_DOWNLOADED_TASKS:
        case API_GET_DOWNLOADED_TASKS_NUM_AFTER_TIME:
        {
            URL = self.URL_CLIENT_HTTP;
        }
            break;
        default:
            break;
    }
    
    if (![URL isEqualToString:self.URL_CLIENT_HTTP]
        && ![URL isEqualToString:self.URL_CLIENT_HTTPS]
        && identity != API_READ_FILE
    ) {
        if ([URL rangeOfString:@"?"].length > 0) {
            URL = [URL stringByAppendingFormat:@"&ios_client_ver=%@", APP_VERSION];
        } else {
            URL = [URL stringByAppendingFormat:@"?ios_client_ver=%@", APP_VERSION];
        }
    }
    
    return URL;
}

- (NSString *)methodWithAPIIdentity:(APIIdentity)identity {
    NSString *method = @"";
    
    switch (identity) {
        case API_GET_ROUTER_DETAIL:
        {
            method = @"apps.mobile.router_status";
        }
            break;
        case API_ROUTER_PASSWORD_MODIFY:
        {
            method = @"system.os.set_password";
        }
            break;
        case API_GET_ROUTER_TRAFFIC:
        {
            method = @"network.traffic.status";
        }
            break;
        case API_GET_ROUTER_TRAFFIC_HISTORY:
        {
            method = @"network.traffic.status_with_history";
        }
            break;
        case API_GET_ROUTER_TRAFFIC_HISTORY_DETAIL:
        {
            method = @"network.traffic.history";
        }
            break;
        case API_GET_ROUTER_ONLINE_HISTORY_DETAIL:
        {
            method = @"network.online.history";
        }
            break;
        case API_GET_ROUTER_TOPOLOGY:
        {
            method = @"apps.mobile.smarthome_map";
        }
            break;
        case API_GET_ROUTER_CONTROL_OVERVIEW:
        {
            method = @"apps.mobile.get_smart_control_overview";
        }
            break;
        case API_SET_PLACE:
        {
            method = @"apps.mobile.set_smart_device_place";
        }
            break;
        case API_GET_MODEL:
        {
            method = @"network.device_model.get_device_model";
        }
            break;
        case API_GET_LED_STATUS:
        {
            method = @"system.led.get_status";
        }
            break;
        case API_SET_LED_STATUS:
        {
            method = @"system.led.set_status";
        }
            break;
        case API_GET_WIFI_CHANNEL:
        {
            method = @"network.wireless.get_channel";
        }
            break;
        case API_SET_WIFI_CHANNEL:
        {
            method = @"network.wireless.set_channel";
        }
            break;
        case API_GET_WIFI_CHANNEL_RANK:
        {
            method = @"network.wireless.get_channel_rank";
        }
            break;
        case API_GET_ROUTER_BACKUP_INFO:
        {
            method = @"system.userdata.get_backup_info";
        }
            break;
        case API_BACKUP_USER_CONFIG:
        {
            method = @"system.userdata.backup_user_config";
        }
            break;
        case API_RESTORE_USER_CONFIG:
        {
            method = @"system.userdata.restore_user_config";
        }
            break;
        case API_GET_WAN_INFO:
        {
            method = @"network.wan.get_simple_info";
        }
            break;
        case API_GET_ROUTER_OVERVIEW_NUMBERS:
        {
            method = @"apps.mobile.device_overview";
        }
            break;
        case API_GET_ROUTER_EXAM_RESULT:
        {
            method = @"apps.mobile.do_exam_app5_0";
        }
            break;
        case API_DO_ROUTER_SPEEDTEST:
        {
            method = @"apps.mobile.exam_do_st";
        }
            break;
        case API_ROUTER_REBOOT:
        {
            method = @"system.os.reboot";
        }
            break;
        case API_ROUTER_RESET:
        {
            method = @"system.os.safe_reset_all";
        }
            break;
        case API_GET_WIFI_WIDEMODE:
        {
            method = @"network.wireless.get_wide_mode";
        }
            break;
        case API_SET_WIFI_WIDEMODE:
        {
            method = @"network.wireless.set_wide_mode";
        }
            break;
        case API_WIFI_PASSWORD_MODIFY_2_4G:
        {
            method = @"network.wireless.set_24g_info";
        }
            break;
        case API_WIFI_PASSWORD_MODIFY_5G:
        {
            method = @"network.wireless.set_5g_info";
        }
            break;
        case API_GET_DEVICE_LIST:
        {
            method = @"network.device.device_list";
        }
            break;
        case API_GET_DEVICE_DETAIL:
        {
            method = @"network.device.get_device_detail";
        }
            break;
        case API_PARTSPEEDUP_LIST:
        {
            method = @"network.qos.get_part_speedup_list";
        }
            break;
        case API_PARTSPEEDUP_SET:
        {
            method = @"network.qos.set_part_speedup";
        }
            break;
        case API_PARTSPEEDUP_CANCEL:
        {
            method = @"network.qos.cancel_part_speedup";
        }
            break;
        case API_GET_WIFI_STATUS_2_4G:
        {
            method = @"network.wireless.get_24g_info";
        }
            break;
        case API_GET_WIFI_STATUS_5G:
        {
            method = @"network.wireless.get_5g_info";
        }
            break;
        case API_SET_WIFI_STATUS_2_4G:
        {
            method = @"network.wireless.set_24g_status";
        }
            break;
        case API_SET_WIFI_STATUS_5G:
        {
            method = @"network.wireless.set_5g_status";
        }
            break;
        case API_GET_WIFI_SLEEPCONFIG_2_4G:
        {
            method = @"network.wireless.get_24g_sleep";
        }
            break;
        case API_GET_WIFI_SLEEPCONFIG_5G:
        {
            method = @"network.wireless.get_5g_sleep";
        }
            break;
        case API_SET_WIFI_SLEEPCONFIG_2_4G:
        {
            method = @"network.wireless.set_24g_sleep";
        }
            break;
        case API_SET_WIFI_SLEEPCONFIG_5G:
        {
            method = @"network.wireless.set_5g_sleep";
        }
            break;
        case API_SET_DEVICE_NAME:
        {
            method = @"network.device.set_device_name";
        }
            break;
        case API_GET_BLACKLIST:
        {
            method = @"network.device.get_black_list";
        }
            break;
        case API_ADD_TO_BLACKLIST:
        {
            method = @"network.device.add_to_black_list";
        }
            break;
        case API_REMOVE_FROM_BLACKLIST:
        {
            method = @"network.device.remove_black_list";
        }
            break;
        case API_CLEAR_BLACKLIST:
        {
            method = @"network.device.clear_all_black_list";
        }
            break;
        case API_GET_DEVICE_TRAFFIC_HISTORY_DETAIL:
        {
            method = @"network.traffic.device_history";
        }
            break;
        case API_GET_DEVICE_ONLINE_HISTORY_DETAIL:
        {
            method = @"network.online.device_history";
        }
            break;
        case API_GET_DEVICE_TRAFFIC:
        {
            method = @"network.device.get_device_traffic";
        }
            break;
        case API_GET_DEVICE_QOS:
        {
            method = @"network.sqosutils.get_device_config";
        }
            break;
        case API_SET_DEVICE_QOS:
        {
            method = @"network.sqosutils.set_device_config";
        }
            break;
        case API_UNSET_DEVICE_QOS:
        {
            method = @"network.sqosutils.unset_device_config";
        }
            break;
        case API_GET_DEVICE_DISK_LIMIT:
        {
            method = @"system.storage.get_device_access_permission";
        }
            break;
        case API_SET_DEVICE_DISK_LIMIT:
        {
            method = @"system.storage.set_device_access_permission";
        }
            break;
        case API_DELETE_FILE:
        {
            method = @"system.storage.rm_file";
        }
            break;
        case API_RPT_MATCH:
        {
            method = @"network.device_rpt.bind_rpt";
        }
            break;
        case API_RPT_UNMATCH:
        {
            method = @"network.device_rpt.unbind_rpt";
        }
            break;
        case API_GET_PARTITION_LIST:
        {
            method = @"apps.mobile.storage_device_list";
        }
            break;
        case API_FORMAT_PARTITION:
        {
            method = @"system.storage.format_partition";
        }
            break;
        case API_GET_FILE_LIST:
        {
            method = @"system.storage.list_file";
        }
            break;
        case API_GET_STORAGE_INFO:
        {
            method = @"utils.cache.prefetch_storage_info";
        }
            break;
        case API_REMOVE_DISK_SAFE:
        {
            method = @"system.storage.safe_remove_device";
        }
            break;
        case API_GET_ALL_DOWNLOAD_TASKS:
        {
            method = @"utils.cache.prefetch_list";
        }
            break;
        case API_GET_DOWNLOADING_TASKS:
        {
            method = @"utils.cache.prefetch_list_unfinished";
        }
            break;
        case API_GET_DOWNLOADED_TASKS:
        {
            method = @"utils.cache.prefetch_list_finished";
        }
            break;
        case API_ADD_DOWNLOAD_TASK:
        {
            method = @"utils.cache.prefetch_add";
        }
            break;
        case API_REMOVE_DOWNLOAD_TASK:
        {
            method = @"utils.cache.prefetch_remove";
        }
            break;
        case API_PAUSE_DOWNLOAD_TASK:
        {
            method = @"utils.cache.prefetch_pause";
        }
            break;
        case API_PAUSE_ALL_DOWNLOAD_TASKS:
        {
            method = @"utils.cache.prefetch_pauseall";
        }
            break;
        case API_RESUME_PAUSED_DOWNLOAD_TASK:
        {
            method = @"utils.cache.prefetch_unpause";
        }
            break;
        case API_RESUME_ALL_PAUSED_DOWNLOAD_TASKS:
        {
            method = @"utils.cache.prefetch_unpauseall";
        }
            break;
        case API_GET_DOWNLOAD_TASK_DETAIL:
        {
            method = @"utils.cache.prefetch_progress";
        }
            break;
        case API_CLEAR_DOWNLOADING_TASKS:
        {
            method = @"utils.cache.prefetch_clean_unfinished";
        }
            break;
        case API_CLEAR_DOWNLOADED_TASKS:
        {
            method = @"utils.cache.prefetch_clean_finished";
        }
            break;
        case API_GET_DOWNLOADED_TASKS_NUM_AFTER_TIME:
        {
            method = @"utils.cache.prefetch_uncheck";
        }
            break;
        default:
            break;
    }
    
    return method;
}

@end
