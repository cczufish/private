//
//  HWFService+RouterControl.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService+RouterControl.h"

#import "HWFUser.h"
#import "HWFRouter.h"

@implementation HWFService (RouterControl)

#pragma mark - SYSTEM
- (void)rebootRouterWithUser:(HWFUser *)aUser
                      router:(HWFRouter *)aRouter
                  completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_ROUTER_REBOOT];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_ROUTER_REBOOT];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                // Nothing.
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)resetRouterWithUser:(HWFUser *)aUser
                     router:(HWFRouter *)aRouter
                   adminPWD:(NSString *)theAdminPWD
                 completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_ROUTER_RESET];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_ROUTER_RESET];
    NSDictionary *paramDict = @{ @"password":theAdminPWD };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                // Nothing.
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - Part SpeedUp
- (void)loadPartSpeedUpListWithUser:(HWFUser *)aUser
                             router:(HWFRouter *)aRouter
                         completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_PARTSPEEDUP_LIST];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_PARTSPEEDUP_LIST];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                // Nothing.
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setPartSpeedUpWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                        itemId:(NSString *)anItemId
                    completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_PARTSPEEDUP_SET];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_PARTSPEEDUP_SET];
    NSDictionary *paramDict = @{ @"item_id":anItemId };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                // Nothing.
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)cancelPartSpeedUpWithUser:(HWFUser *)aUser
                           router:(HWFRouter *)aRouter
                           itemId:(NSString *)anItemId
                       completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_PARTSPEEDUP_CANCEL];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_PARTSPEEDUP_CANCEL];
    NSDictionary *paramDict = @{ @"item_id":anItemId };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                // Nothing.
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - WiFi Channel
- (void)loadWiFiChannelWithUser:(HWFUser *)aUser
                         router:(HWFRouter *)aRouter
                     completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_WIFI_CHANNEL];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_WIFI_CHANNEL];
    NSDictionary *paramDict = @{ @"device":@"radio0.network1" };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                // Nothing.
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setWiFiChannelWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                       channel:(NSInteger)aChannel
                    completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_WIFI_CHANNEL];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_SET_WIFI_CHANNEL];
    NSDictionary *paramDict = @{ @"device":@"radio0.network1", @"channel":@(aChannel) };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                // Nothing.
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadWiFiChannelRankWithUser:(HWFUser *)aUser
                             router:(HWFRouter *)aRouter
                         completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_WIFI_CHANNEL_RANK];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_WIFI_CHANNEL_RANK];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                // Nothing.
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - LED
- (void)loadLEDStatusWithUser:(HWFUser *)aUser
                       router:(HWFRouter *)aRouter
                   completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_LED_STATUS];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_LED_STATUS];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aRouter.LEDStatus = [respDict[@"status"] boolValue];
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setLEDStatusWithUser:(HWFUser *)aUser
                      router:(HWFRouter *)aRouter
                      status:(BOOL)theLEDStatus
                  completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_LED_STATUS];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_SET_LED_STATUS];
    NSDictionary *paramDict = @{ @"status":@(theLEDStatus) };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aRouter.LEDStatus = theLEDStatus;
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - WiFi开关(2.4G/5G)
- (void)loadWiFiStatus24GWithUser:(HWFUser *)aUser
                           router:(HWFRouter *)aRouter
                       completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_WIFI_STATUS_2_4G];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_WIFI_STATUS_2_4G];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                // disabled == 1 代表被禁用
                aRouter.WiFi24GStatus = ![respDict[@"disabled"] boolValue];
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadWiFiStatus5GWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                      completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_WIFI_STATUS_5G];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_WIFI_STATUS_5G];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                // disabled == 1 代表被禁用
                aRouter.WiFi5GStatus = ![respDict[@"disabled"] boolValue];
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setWiFiStatus24GWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                          status:(BOOL)theWiFiStatus
                      completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_WIFI_STATUS_2_4G];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_SET_WIFI_STATUS_2_4G];
    NSDictionary *paramDict = @{ @"status":@(theWiFiStatus ? 1 : 0) };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aRouter.WiFi24GStatus = theWiFiStatus;
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setWiFiStatus5GWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                        status:(BOOL)theWiFiStatus
                    completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_WIFI_STATUS_5G];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_SET_WIFI_STATUS_5G];
    NSDictionary *paramDict = @{ @"status":@(theWiFiStatus ? 1 : 0) };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aRouter.WiFi5GStatus = theWiFiStatus;
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - WiFi Sleep
- (void)loadWiFiSleepConfig24GWithUser:(HWFUser *)aUser
                                router:(HWFRouter *)aRouter
                            completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_WIFI_SLEEPCONFIG_2_4G];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_WIFI_SLEEPCONFIG_2_4G];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                HWFWiFiSleepConfig *sleepConfig = [[HWFWiFiSleepConfig alloc] init];
                sleepConfig.type = WiFiType_2_4G;
                sleepConfig.status = respDict[@"status"] ? [respDict[@"status"] boolValue] : NO;
                if (sleepConfig.status) {
                    NSInteger WiFiOffHour = [respDict[@"down_hour"] integerValue];
                    NSInteger WiFiOffMin = [respDict[@"down_min"] integerValue];
                    sleepConfig.WiFiOff = WiFiOffHour*100 + WiFiOffMin;
                    
                    NSInteger WiFiOnHour = [respDict[@"up_hour"] integerValue];
                    NSInteger WiFiOnMin = [respDict[@"up_min"] integerValue];
                    sleepConfig.WiFiOn = WiFiOnHour*100 + WiFiOnMin;
                }
                aRouter.WiFi24GSleepConfig = sleepConfig;
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadWiFiSleepConfig5GWithUser:(HWFUser *)aUser
                               router:(HWFRouter *)aRouter
                           completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_WIFI_SLEEPCONFIG_5G];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_WIFI_SLEEPCONFIG_5G];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                HWFWiFiSleepConfig *sleepConfig = [[HWFWiFiSleepConfig alloc] init];
                sleepConfig.type = WiFiType_5G;
                sleepConfig.status = respDict[@"status"] ? [respDict[@"status"] boolValue] : NO;
                if (sleepConfig.status) {
                    NSInteger WiFiOffHour = [respDict[@"down_hour"] integerValue];
                    NSInteger WiFiOffMin = [respDict[@"down_min"] integerValue];
                    sleepConfig.WiFiOff = WiFiOffHour*100 + WiFiOffMin;
                    
                    NSInteger WiFiOnHour = [respDict[@"up_hour"] integerValue];
                    NSInteger WiFiOnMin = [respDict[@"up_min"] integerValue];
                    sleepConfig.WiFiOn = WiFiOnHour*100 + WiFiOnMin;
                }
                aRouter.WiFi5GSleepConfig = sleepConfig;
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setWiFiSleepConfig24GWithUser:(HWFUser *)aUser
                               router:(HWFRouter *)aRouter
                          sleepConfig:(HWFWiFiSleepConfig *)theSleepConfig
                           completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSInteger WiFiOffHour = theSleepConfig.WiFiOff / 100;
    NSInteger WiFiOffMin = theSleepConfig.WiFiOff % 100;
    
    NSInteger WiFiOnHour = theSleepConfig.WiFiOn / 100;
    NSInteger WiFiOnMin = theSleepConfig.WiFiOn % 100;
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_WIFI_SLEEPCONFIG_2_4G];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_SET_WIFI_SLEEPCONFIG_2_4G];
    NSDictionary *paramDict = @{ @"status":@(theSleepConfig.status ? 1 : 0), @"down_hour":@(WiFiOffHour), @"down_min":@(WiFiOffMin), @"up_hour":@(WiFiOnHour), @"up_min":@(WiFiOnMin) };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                theSleepConfig.type = WiFiType_2_4G;
                aRouter.WiFi5GSleepConfig = theSleepConfig;
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setWiFiSleepConfig5GWithUser:(HWFUser *)aUser
                              router:(HWFRouter *)aRouter
                         sleepConfig:(HWFWiFiSleepConfig *)theSleepConfig
                          completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSInteger WiFiOffHour = theSleepConfig.WiFiOff / 100;
    NSInteger WiFiOffMin = theSleepConfig.WiFiOff % 100;
    
    NSInteger WiFiOnHour = theSleepConfig.WiFiOn / 100;
    NSInteger WiFiOnMin = theSleepConfig.WiFiOn % 100;
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_WIFI_SLEEPCONFIG_5G];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_SET_WIFI_SLEEPCONFIG_5G];
    NSDictionary *paramDict = @{ @"status":@(theSleepConfig.status), @"down_hour":@(WiFiOffHour), @"down_min":@(WiFiOffMin), @"up_hour":@(WiFiOnHour), @"up_min":@(WiFiOnMin) };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                theSleepConfig.type = WiFiType_5G;
                aRouter.WiFi5GSleepConfig = theSleepConfig;
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - Wide Mode
- (void)loadWiFiWideModeWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                      completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_WIFI_WIDEMODE];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_WIFI_WIDEMODE];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aRouter.wideMode = [respDict[@"status"] boolValue];
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setWiFiWideModeWithUser:(HWFUser *)aUser
                         router:(HWFRouter *)aRouter
                           mode:(BOOL)theWideMode
                     completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_WIFI_WIDEMODE];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_SET_WIFI_WIDEMODE];
    NSDictionary *paramDict = @{ @"status":@(theWideMode ? 1 : 0) };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aRouter.wideMode = theWideMode;
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

@end
