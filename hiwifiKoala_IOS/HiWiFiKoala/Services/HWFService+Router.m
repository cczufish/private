//
//  HWFService+Router.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService+Router.h"

#import "HWFUser.h"
#import "HWFRouter.h"

@implementation HWFService (Router)

- (void)loadBindRoutersWithUser:(HWFUser *)aUser
                     completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROUTER_LIST];
    NSDictionary *paramDict = @{ @"token":aUser.uToken };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                NSArray *routers = respDict[@"routers"];
                NSMutableArray *bindRouters = [NSMutableArray array];
                for (NSDictionary *routerDict in routers) {
                    NSInteger aRID = [routerDict[@"rid"] integerValue];
                    HWFRouter *router = [[HWFDataCenter defaultCenter] routerWithRID:aRID];
                    if (!router) {
                        router = [[HWFRouter alloc] init];
                    }
                    router.RID = [routerDict[@"rid"] integerValue];
                    router.name = routerDict[@"name"];
                    router.MAC = routerDict[@"mac"];
                    router.isOnline = [routerDict[@"is_online"] boolValue];
                    
                    [[HWFDataCenter defaultCenter] cacheRouter:router];
                    
                    [bindRouters addObject:router];
                }
                [[HWFDataCenter defaultCenter] setBindRouters:bindRouters withUser:aUser];
            }
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadClientSecretWithUser:(HWFUser *)aUser
                      completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_OPENAPI_BIND];
    NSDictionary *paramDict = @{ @"token":aUser.uToken };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        NSInteger code = 10;
        NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
        
        @try {
            if (data && [data isKindOfClass:[NSArray class]]) {
                code = 10101;
                msg = [self getMessageWithCode:code defaultMessage:@""];
                
                for (NSDictionary *respDict in (NSDictionary *)data) {
                    if (CODE_SUCCESS == CODE(respDict) || 100007 == CODE(respDict)) {
                        
                        if (respDict[@"client_secret"] && [respDict[@"client_secret"] isKindOfClass:[NSString class]]) {
                            NSInteger RID = [respDict[@"rid"] integerValue];
                            HWFRouter *router = [[HWFDataCenter defaultCenter] routerWithRID:RID];
                            router.clientSecret = respDict[@"client_secret"];
                            
                            [[HWFDataCenter defaultCenter] cacheRouter:router];
                            
                            if (![HWFRouter defaultRouter] || ([HWFRouter defaultRouter] && [[HWFRouter defaultRouter] RID] == RID)) {
                                code = 0;
                                msg = [self getMessageWithCode:code defaultMessage:@""];
                            }
                        }
                    } else {
                        NSInteger RID = respDict[@"rid"] ? [respDict[@"rid"] integerValue] : RID_NIL;
                        
                        if ([HWFRouter defaultRouter] && [[HWFRouter defaultRouter] RID] == RID) {
                            code = CODE(respDict);
                            msg = [self getMessageWithCode:code defaultMessage:MSG(respDict)];
                        }
                    }
                }
            } else {
                code = 11;
                msg = [self getMessageWithCode:code defaultMessage:@""];
            }
        }
        @catch (NSException *exception) {
            code = 10;
            msg = [self getMessageWithCode:code defaultMessage:@""];
        }
        @finally {
            if (CODE_SUCCESS == code || 100007 == code) {
                DDLogInfo(@"\n  URL : %@\nPARAM : %@\n CODE : %ld\n  MSG : %@\n DATA : %@\n JSON : %@", URL, paramDict, (long)code, msg, data, option.responseString);
            } else {
                DDLogWarn(@"\n  URL : %@\nPARAM : %@\n CODE : %ld\n  MSG : %@\n DATA : %@\n JSON : %@", URL, paramDict, (long)code, msg, data, option.responseString);
            }
            
            if (theCompletionHandler) {
                theCompletionHandler(code, msg, data, option);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadClientSecretWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                      completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_OPENAPI_BIND];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"macs":[aRouter standardMAC] };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        NSInteger code = 10;
        NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
        NSDictionary *respDict = nil;
        
        @try {
            if (data && [data isKindOfClass:[NSArray class]]) {
                respDict = (NSDictionary *)[data firstObject];
                
                code = CODE(respDict);
                msg = [self getMessageWithCode:code defaultMessage:MSG(respDict)];
                
                if (CODE_SUCCESS == CODE(respDict) || 100007 == CODE(respDict)) {
                    if (respDict[@"client_secret"] && [respDict[@"client_secret"] isKindOfClass:[NSString class]]) {
                        aRouter.clientSecret = respDict[@"client_secret"];
                        
                        [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
                    } else {
                        code = 10101;
                        msg = [self getMessageWithCode:code defaultMessage:@""];
                    }
                }
            } else {
                code = 11;
                msg = [self getMessageWithCode:code defaultMessage:@""];
            }
        }
        @catch (NSException *exception) {
            code = 10;
            msg = [self getMessageWithCode:code defaultMessage:@""];
        }
        @finally {
            if (CODE_SUCCESS == code || 100007 == code) {
                DDLogInfo(@"\n  URL : %@\nPARAM : %@\n CODE : %ld\n  MSG : %@\n DATA : %@\n JSON : %@", URL, paramDict, (long)code, msg, respDict?respDict:data, option.responseString);
            } else {
                DDLogWarn(@"\n  URL : %@\nPARAM : %@\n CODE : %ld\n  MSG : %@\n DATA : %@\n JSON : %@", URL, paramDict, (long)code, msg, respDict?respDict:data, option.responseString);
            }
            
            if (theCompletionHandler) {
                theCompletionHandler(code, msg, respDict?respDict:data, option);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadRouterDetailWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROUTER_DETAIL];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_ROUTER_DETAIL];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aRouter.LEDStatus = [respDict[@"led_status"] boolValue];
                aRouter.ROM = respDict[@"rom_version"];
                aRouter.backupDate = ([respDict[@"backup_date"] integerValue]) ? [NSDate dateWithTimeIntervalSince1970:[respDict[@"backup_date"] doubleValue]] : nil;
                aRouter.place = [respDict[@"place"] integerValue];
                aRouter.model = respDict[@"device_model"];
                NSDictionary *WiFi24GDict = respDict[@"wifi_24g"];
                if (WiFi24GDict && [WiFi24GDict[@"status"] integerValue]!=-1) {
                    aRouter.hasWiFi24G = YES;
                    aRouter.SSID24G = WiFi24GDict[@"ssid"];
                    aRouter.WiFi24GStatus = [WiFi24GDict[@"status"] boolValue];
                } else {
                    aRouter.hasWiFi24G = NO;
                }
                NSDictionary *WiFi5GDict = respDict[@"wifi_5g"];
                if (WiFi5GDict && [WiFi5GDict[@"status"] integerValue]!=-1) {
                    aRouter.hasWiFi5G = YES;
                    aRouter.SSID5G = WiFi5GDict[@"ssid"];
                    aRouter.WiFi5GStatus = [WiFi5GDict[@"status"] boolValue];
                } else {
                    aRouter.hasWiFi5G = NO;
                }
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
                
                [[HWFDataCenter defaultCenter] setBindRouter:aRouter withUser:aUser];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setRouterNameWithUser:(HWFUser *)aUser
                       router:(HWFRouter *)aRouter
                      newName:(NSString *)theNewName
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_ROUTER_NAME];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID), @"name":theNewName };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aRouter.name = theNewName;
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadRouterRealTimeTrafficWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROUTER_TRAFFIC];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_ROUTER_TRAFFIC];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadRouterHistoryTrafficWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROUTER_TRAFFIC_HISTORY];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_ROUTER_TRAFFIC_HISTORY];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)modifyRouterPasswordWithUser:(HWFUser *)aUser
                              router:(HWFRouter *)aRouter
                              oldPWD:(NSString *)oldPWD
                              newPWD:(NSString *)newPWD
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_ROUTER_PASSWORD_MODIFY];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_ROUTER_PASSWORD_MODIFY];
    NSDictionary *paramDict = @{ @"password":newPWD, @"old_password":oldPWD };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadRouterTopologyWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROUTER_TOPOLOGY];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_ROUTER_TOPOLOGY];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadWANInfoWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_WAN_INFO];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_WAN_INFO];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadRouterControlOverviewWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROUTER_CONTROL_OVERVIEW];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_ROUTER_CONTROL_OVERVIEW];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setPlaceWithUser:(HWFUser *)aUser
                  router:(HWFRouter *)aRouter
                     MAC:(NSString *)aMAC
                   place:(NSInteger)aPlace
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_PLACE];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_SET_PLACE];
    NSDictionary *paramDict = @{ @"mac":[HWFTool displayMAC:aMAC], @"place":@(aPlace) };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadModelWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_MODEL];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_MODEL];
    NSDictionary *paramDict = @{ @"mac":aRouter.displayMAC };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code && respDict[@"model"] && !IS_STRING_EMPTY(respDict[@"model"])) {
                aRouter.model = respDict[@"model"];
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadRouterOverviewNumbersWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROUTER_OVERVIEW_NUMBERS];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_ROUTER_OVERVIEW_NUMBERS];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - 获取直连路由器信息
- (void)loadConnectedRouterInfoWithRouter:(HWFRouter *)aRouter
                               completion:(ServiceCompletionHandler)theCompletionHandler {
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_CONNECTEDROUTER_INFO];
    URL = [URL stringByAppendingString:[NSString stringWithFormat:@"&dev_id=%@", aRouter.standardMAC]];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] JSON:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadIsConnectedRouterWithRouter:(HWFRouter *)aRouter
                             completion:(ServiceCompletionHandler)theCompletionHandler {
    [self loadConnectedRouterInfoWithRouter:aRouter completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        NSInteger returnCode = CODE_NIL;
        
        if (CODE_SUCCESS == code && data[@"app_data"] && data[@"app_data"][@"mac"]) {
            NSString *connectedRouterMAC = data[@"app_data"][@"mac"];
            if ([[HWFTool standardMAC:connectedRouterMAC] isEqualToString:[HWFTool standardMAC:aRouter.MAC]]) {
                returnCode = 0;
            }
        }
        
        if (theCompletionHandler) {
            theCompletionHandler(returnCode, MSG_NIL, data, option);
        }
    }];
}

#pragma mark - History
- (void)loadRouterTrafficHistoryDetailWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROUTER_TRAFFIC_HISTORY_DETAIL];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_ROUTER_TRAFFIC_HISTORY_DETAIL];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {

            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadRouterOnlineHistoryDetailWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROUTER_ONLINE_HISTORY_DETAIL];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_ROUTER_ONLINE_HISTORY_DETAIL];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - 备份
- (void)loadRouterBackupInfoWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROUTER_BACKUP_INFO];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_ROUTER_BACKUP_INFO];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)backupUserConfigWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_BACKUP_USER_CONFIG];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_BACKUP_USER_CONFIG];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)restoreUserConfigWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_RESTORE_USER_CONFIG];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_RESTORE_USER_CONFIG];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - ROM
- (void)loadROMUpgradeInfoWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROM_UPGRADE_INFO];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID) };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aRouter.isNeedUpgrade = respDict[@"need_upgrade"] ? [respDict[@"need_upgrade"] boolValue] : NO;
                aRouter.isForceUpgrade = respDict[@"force_upgrade"] ? [respDict[@"force_upgrade"] boolValue] : NO;
                aRouter.latestROMVersion = respDict[@"version"] ?: @"";
                aRouter.latestROMChangeLog = respDict[@"changelog"] ?: @"";
                aRouter.latestROMSize = respDict[@"size"] ? ([respDict[@"size"] integerValue]) : 0;
            }
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)upgradeROMWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_ROM_UPGRADE];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID) };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - BIND
- (void)loadBindUserWithUser:(HWFUser *)aUser
                         MAC:(NSString *)aMAC
                  completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_BINDUSER];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"mac":[HWFTool standardMAC:aMAC] };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)unbindWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_ROUTER_UNBIND];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID) };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - 体检
- (void)loadRouterExamResultWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROUTER_EXAM_RESULT];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_ROUTER_EXAM_RESULT];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - 测速
- (void)doRouterSpeedTestWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_DO_ROUTER_SPEEDTEST];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_DO_ROUTER_SPEEDTEST];
    NSDictionary *paramDict = @{ @"test_order":@(1) };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadRouterSpeedTestResultWithUser:(HWFUser *)aUser
                                   router:(HWFRouter *)aRouter
                                    actID:(NSString *)theActID
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROUTER_SPEEDTEST_RESULT];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"actid":theActID };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - 运营商
- (void)loadRouterIPNPWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_ROUTER_IP_NP];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID) };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aRouter.IP = respDict[@"ip"]?:nil;
                aRouter.NP = respDict[@"np"]?:nil;
                
                [[HWFDataCenter defaultCenter] cacheRouter:aRouter];
            }
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)reportRouterNPWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                       userTEL:(NSString *)aTEL
                        userNP:(NSString *)np
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_REPORT_NP];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID), @"ip":(aRouter.IP?:@""), @"ip_np":(aRouter.NP?:@""), @"user_tel":aTEL, @"user_np":np };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

@end
