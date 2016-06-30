//
//  HWFService+Device.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-13.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService+Device.h"

#import "HWFDevice.h"

@implementation HWFService (Device)

- (void)loadDeviceListWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_DEVICE_LIST];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_DEVICE_LIST];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setDeviceNameWithUser:(HWFUser *)aUser
                       router:(HWFRouter *)aRouter
                       device:(HWFDevice *)aDevice
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_DEVICE_NAME];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_SET_DEVICE_NAME];
    NSDictionary *paramDict = @{ @"mac":[aDevice displayMAC], @"name":theNewName };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aDevice.name = respDict[@"new_name"] ? : theNewName;
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadDeviceDetailWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                          device:(HWFDevice *)aDevice
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_DEVICE_DETAIL];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_DEVICE_DETAIL];
    NSDictionary *paramDict = @{ @"mac":[aDevice displayMAC] };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadDeviceRealTimeTrafficWithUser:(HWFUser *)aUser
                                   router:(HWFRouter *)aRouter
                                   device:(HWFDevice *)aDevice
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_DEVICE_TRAFFIC];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_DEVICE_TRAFFIC];
    NSDictionary *paramDict = @{ @"mac":[aDevice displayMAC] };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - 黑名单
- (void)loadBlackListWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_BLACKLIST];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_BLACKLIST];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)addToBlackListWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                        device:(HWFDevice *)aDevice
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_ADD_TO_BLACKLIST];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_ADD_TO_BLACKLIST];
    NSDictionary *paramDict = @{ @"mac":[aDevice displayMAC] };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)removeFromBlackListWithUser:(HWFUser *)aUser
                             router:(HWFRouter *)aRouter
                            devices:(NSArray *)aDeviceArray
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_REMOVE_FROM_BLACKLIST];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_REMOVE_FROM_BLACKLIST];
    
    NSMutableArray *MACs = [NSMutableArray array];
    for (HWFDevice *aDevice in aDeviceArray) {
        if ([aDevice isKindOfClass:[HWFDevice class]]) {
            [MACs addObject:[aDevice displayMAC]];
        }
    }
    NSDictionary *paramDict = @{ @"macs":MACs };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)clearBlackListWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_CLEAR_BLACKLIST];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_CLEAR_BLACKLIST];

    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadDeviceTrafficHistoryDetailWithUser:(HWFUser *)aUser
                                        router:(HWFRouter *)aRouter
                                        device:(HWFDevice *)aDevice
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_DEVICE_TRAFFIC_HISTORY_DETAIL];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_DEVICE_TRAFFIC_HISTORY_DETAIL];
    
    NSDictionary *paramDict = @{ @"days":@(2), @"mac":[aDevice displayMAC] };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadDeviceOnlineHistoryDetailWithUser:(HWFUser *)aUser
                                       router:(HWFRouter *)aRouter
                                       device:(HWFDevice *)aDevice
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_DEVICE_ONLINE_HISTORY_DETAIL];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_DEVICE_ONLINE_HISTORY_DETAIL];
    
    NSDictionary *paramDict = @{ @"days":@(2), @"mac":[aDevice displayMAC] };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - QoS
- (void)loadDeviceQoSWithUser:(HWFUser *)aUser
                       router:(HWFRouter *)aRouter
                       device:(HWFDevice *)aDevice
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_DEVICE_QOS];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_DEVICE_QOS];
    
    NSDictionary *paramDict = @{ @"mac":[aDevice displayMAC] };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aDevice.QoSStatus = YES;
                aDevice.QoSUp = respDict[@"up"] ? [respDict[@"up"] doubleValue]: -1;
                aDevice.QoSDown = respDict[@"down"] ? [respDict[@"down"] doubleValue]: -1;
            } else if (1 == code) { // "app_code":1  "app_msg":"not found device config"
                aDevice.QoSStatus = NO;
                aDevice.QoSUp = -1;
                aDevice.QoSDown = -1;
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setDeviceQoSWithUser:(HWFUser *)aUser
                      router:(HWFRouter *)aRouter
                      device:(HWFDevice *)aDevice
                       QoSUp:(double)theQoSUp
                     QoSDown:(double)theQoSDown
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_DEVICE_QOS];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_SET_DEVICE_QOS];
    
    NSDictionary *paramDict = @{ @"mac":[aDevice displayMAC], @"up":@(theQoSUp), @"down":@(theQoSDown), @"upg":@(-1), @"downg":@(-1), @"name":aDevice.name };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aDevice.QoSStatus = YES;
                aDevice.QoSUp = theQoSUp;
                aDevice.QoSDown = theQoSDown;
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)unsetDeviceQoSWithUser:(HWFUser *)aUser
                        router:(HWFRouter *)aRouter
                        device:(HWFDevice *)aDevice
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_UNSET_DEVICE_QOS];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_UNSET_DEVICE_QOS];
    
    NSDictionary *paramDict = @{ @"mac":[aDevice displayMAC] };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aDevice.QoSStatus = NO;
                aDevice.QoSUp = -1;
                aDevice.QoSDown = -1;
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - 磁盘存储访问权限
- (void)loadDeviceDiskLimitWithUser:(HWFUser *)aUser
                             router:(HWFRouter *)aRouter
                             device:(HWFDevice *)aDevice
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_DEVICE_DISK_LIMIT];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_DEVICE_DISK_LIMIT];
    
    NSDictionary *paramDict = @{ @"macs":@[ aDevice.displayMAC ] };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
//                aDevice.isDiskLimit =
                //TODO: 赋值isDiskLimit
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setDeviceDiskLimitWithUser:(HWFUser *)aUser
                            router:(HWFRouter *)aRouter
                            device:(HWFDevice *)aDevice
                         diskLimit:(BOOL)theDiskLimit
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_DEVICE_DISK_LIMIT];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_SET_DEVICE_DISK_LIMIT];
    
    NSDictionary *paramDict = @{ @"macs":@[ aDevice.displayMAC ], @"permit":@(theDiskLimit ? 1 : 0) };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                aDevice.isDiskLimit = theDiskLimit;
            }
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

@end
