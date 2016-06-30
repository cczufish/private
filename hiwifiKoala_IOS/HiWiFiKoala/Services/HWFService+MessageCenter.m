//
//  HWFService+MessageCenter.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-16.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService+MessageCenter.h"

@implementation HWFService (MessageCenter)

#pragma mark - Message
- (void)loadNewMessageFlagWithUser:(HWFUser *)aUser
                        completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || aUser.UID == UID_NIL) {
        if (theCompletionHandler) {
            theCompletionHandler(23, NSLocalizedString(@"UnknownUser", @""), nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_NEWMESSAGE_FLAG];
    NSDictionary *paramDict = @{ @"token":aUser.uToken };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadMessageListWithUser:(HWFUser *)aUser
                          start:(NSInteger)start
                          count:(NSInteger)count
                     completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || aUser.UID == UID_NIL) {
        if (theCompletionHandler) {
            theCompletionHandler(23, NSLocalizedString(@"UnknownUser", @""), nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_MESSAGE_LIST];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"start":@(start), @"count":@(count) };

    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadMessageDetailWithUser:(HWFUser *)aUser
                          message:(HWFMessage *)aMessage
                       completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || aUser.UID == UID_NIL) {
        if (theCompletionHandler) {
            theCompletionHandler(23, NSLocalizedString(@"UnknownUser", @""), nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_MESSAGE_DETAIL];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"mid":@(aMessage.MID) };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setMessageStatusWithUser:(HWFUser *)aUser
                         message:(HWFMessage *)aMessage
                          status:(BOOL)theStatus
                      completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || aUser.UID == UID_NIL) {
        if (theCompletionHandler) {
            theCompletionHandler(23, NSLocalizedString(@"UnknownUser", @""), nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_MESSAGE_STATUS];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"mid":@(aMessage.MID), @"status":@(theStatus ? 1 : 0) };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setAllMessageReadWithUser:(HWFUser *)aUser
                       completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || aUser.UID == UID_NIL) {
        if (theCompletionHandler) {
            theCompletionHandler(23, NSLocalizedString(@"UnknownUser", @""), nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_ALL_MESSAGE_READ];
    NSDictionary *paramDict = @{ @"token":aUser.uToken };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)clearMessageListWithUser:(HWFUser *)aUser
                      completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || aUser.UID == UID_NIL) {
        if (theCompletionHandler) {
            theCompletionHandler(23, NSLocalizedString(@"UnknownUser", @""), nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_CLEAR_MESSAGE_LIST];
    NSDictionary *paramDict = @{ @"token":aUser.uToken };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - Message Switch
- (void)loadCloseMessageSwitchListWithUser:(HWFUser *)aUser
                                completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || aUser.UID == UID_NIL) {
        if (theCompletionHandler) {
            theCompletionHandler(23, NSLocalizedString(@"UnknownUser", @""), nil, nil);
        }
        return;
    }
    
    NSString *pToken = [[NSUserDefaults standardUserDefaults] objectForKey:kRemoteNotificationPushToken];
    
    if (!pToken || IS_STRING_EMPTY(pToken)) {
        if (theCompletionHandler) {
            theCompletionHandler(24, [self getMessageWithCode:24 defaultMessage:@"Param Error!"], nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_CLOSE_MESSAGESWITCH_LIST];
    NSDictionary *paramDict = @{ @"logintoken":aUser.uToken, @"pushtoken":pToken, @"getuitoken":pToken };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setMessageSwitchStatusWithUser:(HWFUser *)aUser
                     messageSwitchType:(NSInteger)theMessageSwitchType
                                status:(BOOL)theStatus
                            completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || aUser.UID == UID_NIL) {
        if (theCompletionHandler) {
            theCompletionHandler(23, NSLocalizedString(@"UnknownUser", @""), nil, nil);
        }
        return;
    }
    
    NSString *pToken = [[NSUserDefaults standardUserDefaults] objectForKey:kRemoteNotificationPushToken];
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_MESSAGESWITCH_STATUS];
    NSDictionary *paramDict = @{ @"logintoken":aUser.uToken, @"pushtoken":pToken, @"getuitoken":pToken, @"msgtype":@(theMessageSwitchType), @"status":@(theStatus ? 1 : 0) };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)setMessageSwitchStatusWithUser:(HWFUser *)aUser
              messageSwitchesTypeArray:(NSArray *)theMessageSwitchesTypeArray
                                status:(BOOL)theStatus
                            completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || aUser.UID == UID_NIL) {
        if (theCompletionHandler) {
            theCompletionHandler(23, NSLocalizedString(@"UnknownUser", @""), nil, nil);
        }
        return;
    }
    
    NSString *pToken = [[NSUserDefaults standardUserDefaults] objectForKey:kRemoteNotificationPushToken];
    
    NSString *messageSwitchTypes = @"";
    BOOL needSeparator = NO;
    for (id messageSwitchType in theMessageSwitchesTypeArray) {
        if (needSeparator) {
            [messageSwitchType appendString:@","];
        }
        needSeparator = YES;
        [messageSwitchType appendString:[NSString stringWithFormat:@"%ld", (long)[messageSwitchType integerValue]]];
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SET_MESSAGESWITCH_STATUS];
    NSDictionary *paramDict = @{ @"logintoken":aUser.uToken, @"pushtoken":pToken, @"getuitoken":pToken, @"msgtype":messageSwitchTypes, @"status":@(theStatus ? 1 : 0) };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

@end
