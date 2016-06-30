//
//  HWFService+SmartDevice.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService+SmartDevice.h"

@implementation HWFService (SmartDevice)

- (void)matchRPTWithUser:(HWFUser *)aUser
                  router:(HWFRouter *)aRouter
                     RPT:(HWFSmartDevice *)theRPT
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_RPT_MATCH];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_RPT_MATCH];
    
    NSDictionary *paramDict = @{ @"mac":[theRPT displayMAC] };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)unmatchRPTWithUser:(HWFUser *)aUser
                    router:(HWFRouter *)aRouter
                       RPT:(HWFSmartDevice *)theRPT
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_RPT_UNMATCH];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_RPT_UNMATCH];
    
    NSDictionary *paramDict = @{ @"mac":[theRPT displayMAC] };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

@end
