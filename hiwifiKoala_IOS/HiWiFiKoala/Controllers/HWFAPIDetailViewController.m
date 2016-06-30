//
//  HWFAPIDetailViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFAPIDetailViewController.h"

#import "HWFUser.h"
#import "HWFRouter.h"

#import "HWFService.h"
#import "HWFService+User.h"
#import "HWFService+Router.h"
#import "HWFService+RouterControl.h"
#import "HWFService+Device.h"
#import "HWFService+Plugin.h"
#import "HWFService+Storage.h"
#import "HWFService+MessageCenter.h"

@interface HWFAPIDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *JSONTextView;

@end

@implementation HWFAPIDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addBackBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showResultInfo:(NSDictionary *)aResultInfo {
    self.JSONTextView.text = aResultInfo[@"info"] ? : @"N/A";
    
    switch ([aResultInfo[@"result"] unsignedIntegerValue]) {
        case API_RESULT_DEFAULT:
            self.JSONTextView.textColor = [UIColor colorWithRed:(60/255.0) green:(180/255.0) blue:(255/255.0) alpha:1.0];
            break;
        case API_RESULT_SUCCESS:
            self.JSONTextView.textColor = [UIColor colorWithRed:(60/255.0) green:(180/255.0) blue:(60/255.0) alpha:1.0];
            break;
        case API_RESULT_FAILURE:
            self.JSONTextView.textColor = [UIColor colorWithRed:(255/255.0) green:(60/255.0) blue:(160/255.0) alpha:1.0];
            break;
        default:
            self.JSONTextView.textColor = [UIColor colorWithRed:(60/255.0) green:(180/255.0) blue:(255/255.0) alpha:1.0];
            break;
    }
}

- (void)dealAfterServiceWithAPI:(HWFAPI *)API
                           code:(NSInteger)code
                            msg:(NSString *)msg
                           data:(id)data
                         option:(AFHTTPRequestOperation *)option
                     completion:(APIResultHandler)theHandler {
    NSString *aURL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API.identity] ? : @"N/A";
    NSString *aParam = [[NSString alloc] initWithData:option.request.HTTPBody encoding:NSUTF8StringEncoding];
    NSString *resultInfo = [NSString stringWithFormat:@"\n  URL : %@\nPARAM : %@\n CODE : %ld\n  MSG : %@\n DATA : %@\n JSON : %@", aURL, aParam, (long)code, msg, data, option.responseString];
    
    APIResult aResult = API_RESULT_DEFAULT;
    if (CODE_SUCCESS == code) {
        aResult = API_RESULT_SUCCESS;
    } else if (API.identity == API_OPENAPI_BIND && 100007 == code) {
        aResult = API_RESULT_SUCCESS;
    } else if (CODE_SUCCESS != code) {
        aResult = API_RESULT_FAILURE;
    }
    
    [self showResultInfo:@{ @"result":@(aResult), @"info":resultInfo }];
    
    if (theHandler) {
        theHandler(aResult);
    }
}

- (void)loadData:(HWFAPI *)API completion:(APIResultHandler)theHandler {
    self.title = API.name;
    
    switch (API.identity) {
        case API_CLEAR_CACHE:
        {
            [[HWFDataCenter defaultCenter] clearCache];
            
            APIResult aResult = API_RESULT_SUCCESS;
            [self showResultInfo:@{ @"result":@(aResult), @"info":@"OK" }];
            if (theHandler) {
                theHandler(aResult);
            }
        }
            break;
        case API_GET_CLOUD_PLACEMAP:
        {
            [[HWFService defaultService] loadPlaceMapCompletion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_LOGIN:
        {
            [[HWFService defaultService] loginWithIdentity:@"kaol2046" password:@"123456" completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
                DDLogDebug(@"Login : %@", [HWFUser defaultUser]);
            }];
        }
            break;
        case API_LOGOUT:
        {
            [[HWFService defaultService] logoutCompletion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
                DDLogDebug(@"Logout : %@", [HWFUser defaultUser]);
            }];
        }
            break;
        case API_GET_PROFILE:
        {
            [[HWFService defaultService] loadProfileWithUser:[HWFUser defaultUser] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_ROUTER_LIST:
        {
            HWFUser *defaultUser = [HWFUser defaultUser];
            [[HWFService defaultService] loadBindRoutersWithUser:defaultUser completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_OPENAPI_BIND:
        {            
            if ([API.mark isEqualToString:@"ALL"]) {
                [[HWFService defaultService] loadClientSecretWithUser:[HWFUser defaultUser] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                    [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
                }];
            } else if ([API.mark isEqualToString:@"SINGLE"]) {
                [[HWFService defaultService] loadClientSecretWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                    [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
                }];
            }
        }
            break;
        case API_GET_ROUTER_DETAIL:
        {
            [[HWFService defaultService] loadRouterDetailWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_ROUTER_TRAFFIC:
        {
            [[HWFService defaultService] loadRouterRealTimeTrafficWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_ROUTER_TRAFFIC_HISTORY_DETAIL:
        {
            [[HWFService defaultService] loadRouterTrafficHistoryDetailWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_ROUTER_ONLINE_HISTORY_DETAIL:
        {
            [[HWFService defaultService] loadRouterOnlineHistoryDetailWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_ROUTER_IP_NP:
        {
            [[HWFService defaultService] loadRouterIPNPWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_ROUTER_TOPOLOGY:
        {
            [[HWFService defaultService] loadRouterTopologyWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_WAN_INFO:
        {
            [[HWFService defaultService] loadWANInfoWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_MODEL:
        {
            [[HWFService defaultService] loadModelWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_ROUTER_CONTROL_OVERVIEW:
        {
            [[HWFService defaultService] loadRouterControlOverviewWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_ROM_UPGRADE_INFO:
        {
            [[HWFService defaultService] loadROMUpgradeInfoWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_ROUTER_EXAM_RESULT:
        {
            [[HWFService defaultService] loadRouterExamResultWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_BINDUSER:
        {
            [[HWFService defaultService] loadBindUserWithUser:[HWFUser defaultUser] MAC:@"D4EE0707D83C" completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_ROUTER_REBOOT:
        {
            [[HWFService defaultService] rebootRouterWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_PARTSPEEDUP_LIST:
        {
            [[HWFService defaultService] loadPartSpeedUpListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_WIFI_CHANNEL:
        {
            [[HWFService defaultService] loadWiFiChannelWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_WIFI_CHANNEL_RANK:
        {
            [[HWFService defaultService] loadWiFiChannelRankWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_LED_STATUS:
        {
            [[HWFService defaultService] loadLEDStatusWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_WIFI_STATUS_2_4G:
        {
            [[HWFService defaultService] loadWiFiStatus24GWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_WIFI_STATUS_5G:
        {
            [[HWFService defaultService] loadWiFiStatus5GWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_WIFI_SLEEPCONFIG_2_4G:
        {
            [[HWFService defaultService] loadWiFiSleepConfig24GWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_ROUTER_BACKUP_INFO:
        {
            [[HWFService defaultService] loadRouterBackupInfoWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_CONNECTEDROUTER_INFO:
        {
            [[HWFService defaultService] loadConnectedRouterInfoWithRouter:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_WIFI_WIDEMODE:
        {
            [[HWFService defaultService] loadWiFiWideModeWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_DEVICE_LIST:
        {
            [[HWFService defaultService] loadDeviceListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_BLACKLIST:
        {
            [[HWFService defaultService] loadBlackListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_CLEAR_BLACKLIST:
        {
            [[HWFService defaultService] clearBlackListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_APP_UPGRADE_INFO:
        {
            [[HWFService defaultService] loadAppUpgradeInfoCompletion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_PLUGIN_INSTALLED_NUM:
        {
            [[HWFService defaultService] loadPluginInstalledNUMWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_PLUGIN_INSTALLED_LIST:
        {
            [[HWFService defaultService] loadPluginInstalledListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_PLUGIN_CATEGORY_LIST:
        {
            [[HWFService defaultService] loadPluginCategoryListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_PLUGIN_LIST_IN_CATEGORY:
        {
            HWFPluginCategory *pluginCategory = [[HWFPluginCategory alloc] init];
            pluginCategory.CID = 1; // 云插件
            [[HWFService defaultService] loadPluginListInCategoryWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] category:pluginCategory completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_PLUGIN_DETAIL:
        {
            HWFPlugin *plugin = [[HWFPlugin alloc] init];
            plugin.SID = 13; // 手机远程管理
            [[HWFService defaultService] loadPluginDetailWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] plugin:plugin completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
            
        case API_GET_NEWMESSAGE_FLAG:
        {
            [[HWFService defaultService] loadNewMessageFlagWithUser:[HWFUser defaultUser] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_MESSAGE_LIST:
        {
            [[HWFService defaultService] loadMessageListWithUser:[HWFUser defaultUser] start:0 count:20 completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_SET_ALL_MESSAGE_READ:
        {
            [[HWFService defaultService] setAllMessageReadWithUser:[HWFUser defaultUser] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_CLEAR_MESSAGE_LIST:
        {
            [[HWFService defaultService] clearMessageListWithUser:[HWFUser defaultUser] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_CLOSE_MESSAGESWITCH_LIST:
        {
            [[HWFService defaultService] loadCloseMessageSwitchListWithUser:[HWFUser defaultUser] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        case API_GET_PARTITION_LIST:
        {
            [[HWFService defaultService] loadPartitionListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self dealAfterServiceWithAPI:API code:code msg:msg data:data option:option completion:theHandler];
            }];
        }
            break;
        default:
            break;
    }
}

@end
