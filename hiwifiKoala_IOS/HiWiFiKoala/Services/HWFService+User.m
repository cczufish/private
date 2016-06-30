//
//  HWFService+User.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-14.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService+User.h"

#import "HWFUser.h"
#import "NSString+Extension.h"

@implementation HWFService (User)

- (void)loginWithIdentity:(NSString *)identity
                 password:(NSString *)password
               completion:(ServiceCompletionHandler)theCompletionHandler {
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_LOGIN];
    NSDictionary *paramDict = @{ @"email":identity, @"password":[password MD5Encode], @"app_src":APP_SRC };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {

        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {

            if (CODE_SUCCESS == code) {
                NSTimeInterval expire = (respDict[@"expire"] && ![respDict[@"expire"] isKindOfClass:[NSNull class]]) ? [respDict[@"expire"] doubleValue] : 0.0;
                [respDict setObject:[[NSDate date] dateByAddingTimeInterval:expire] forKey:@"expirationTime"];
                [respDict setObject:[NSDate date] forKey:@"loginTime"];
                [respDict setObject:identity forKey:@"identity"];
                HWFUser *user = [MTLJSONAdapter modelOfClass:[HWFUser class] fromJSONDictionary:respDict error:nil];
                [[HWFDataCenter defaultCenter] setDefaultUser:user];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserLogin object:nil];
            }
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];

    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)logoutCompletion:(ServiceCompletionHandler)theCompletionHandler {
    if (![HWFUser defaultUser]) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    HWFUser *theUser = [[HWFUser defaultUser] copy];
    
    [[HWFDataCenter defaultCenter] clearDefaultUser];

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserLogout object:nil];
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_LOGOUT];
    NSDictionary *paramDict = @{ @"uid":@(theUser.UID), @"token":theUser.uToken, @"push_token":@"", @"client_id":theUser.clientID, @"app_src":APP_SRC };
    //TODO: 处理退出队列
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                
            }
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
    

}

- (void)loadProfileWithUser:(HWFUser *)aUser
                 completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_PROFILE];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"app_src":APP_SRC };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                NSDictionary *userProfile = respDict[@"profile"];
                if (userProfile && userProfile[@"uid"] && aUser.UID == [userProfile[@"uid"] integerValue]) {
                    aUser.email = ([userProfile[@"has_mail"] boolValue] && userProfile[@"email"]) ? userProfile[@"email"] : nil;
                    aUser.mobile = ([userProfile[@"has_mobile"] boolValue] && userProfile[@"mobile"]) ? userProfile[@"mobile"] : nil;
                    aUser.username = userProfile[@"username"] ? : nil;
                    aUser.avatar = (userProfile[@"avatars"][@"b"] && !IS_STRING_EMPTY(userProfile[@"avatars"][@"b"])) ? userProfile[@"avatars"][@"b"] : nil;
                    aUser.gender = userProfile[@"sex"] ? [userProfile[@"sex"] unsignedIntegerValue] : UserGenderMale;
                    [[HWFDataCenter defaultCenter] cacheUser:aUser];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoadUserProfile object:nil];
            }
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)sendVerifyCodeWithMobile:(NSString *)aMobile
                      completion:(ServiceCompletionHandler)theCompletionHandler {
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_SEND_VERIFYCODE];
    NSDictionary *paramDict = @{ @"mobile":aMobile, @"app_src":APP_SRC };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)registerWithMobile:(NSString *)aMobile
                verifyCode:(NSString *)aVerifyCode
                completion:(ServiceCompletionHandler)theCompletionHandler {
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_REGISTER_MOBILE];
    NSDictionary *paramDict = @{ @"mobile":aMobile, @"regcode":aVerifyCode, @"app_src":APP_SRC };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                NSTimeInterval expire = (respDict[@"expire"] && ![respDict[@"expire"] isKindOfClass:[NSNull class]]) ? [respDict[@"expire"] doubleValue] : 0.0;
                [respDict setObject:[[NSDate date] dateByAddingTimeInterval:expire] forKey:@"expirationTime"];
                [respDict setObject:[NSDate date] forKey:@"loginTime"];
                [respDict setObject:aMobile forKey:@"identity"];
                HWFUser *user = [MTLJSONAdapter modelOfClass:[HWFUser class] fromJSONDictionary:respDict error:nil];
                [[HWFDataCenter defaultCenter] setDefaultUser:user];
            }
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)resetUserPasswordWithMobile:(NSString *)aMobile
                         verifyCode:(NSString *)aVerifyCode
                         completion:(ServiceCompletionHandler)theCompletionHandler {
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_USER_PASSWORD_RESET];
    NSDictionary *paramDict = @{ @"mobile":aMobile, @"secode":aVerifyCode, @"app_src":APP_SRC };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)modifyUserPasswordWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_USER_PASSWORD_MODIFY];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"oldpwd":oldPWD, @"newpwd":newPWD, @"app_src":APP_SRC };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                NSTimeInterval expire = (respDict[@"expire"] && ![respDict[@"expire"] isKindOfClass:[NSNull class]]) ? [respDict[@"expire"] doubleValue] : 0.0;
                aUser.expirationTime = [[NSDate date] dateByAddingTimeInterval:expire];
                aUser.loginTime = [NSDate date];
                aUser.uToken = respDict[@"token"];
                [[HWFDataCenter defaultCenter] cacheUser:aUser];
            }
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)perfectInfoWithUser:(HWFUser *)aUser
                   userInfo:(NSDictionary *)aUserInfo
                 completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_PERFECT_USERINFO];
    NSMutableDictionary *paramDict = [@{ @"token":aUser.uToken, @"app_src":APP_SRC } mutableCopy];
    if (aUserInfo[@"username"]) {
        paramDict[@"newusername"] = aUserInfo[@"username"];
    }
    if (aUserInfo[@"password"]) {
        paramDict[@"newpwd"] = aUserInfo[@"password"];
    }
    if (aUserInfo[@"gender"]) {
        paramDict[@"newsex"] = aUserInfo[@"gender"];
    }
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                if (aUserInfo[@"username"]) {
                    aUser.username = aUserInfo[@"username"];
                }
                if (aUserInfo[@"gender"]) {
                    aUser.gender = [aUserInfo[@"gender"] unsignedIntegerValue];
                }
                [[HWFDataCenter defaultCenter] cacheUser:aUser];
            }
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)modifyInfoWithUser:(HWFUser *)aUser
                  userInfo:(NSDictionary *)aUserInfo
                completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_MODIFY_USERINFO];
    NSMutableDictionary *profileDict = [@{} mutableCopy];
    if (aUserInfo[@"username"]) {
        profileDict[@"username"] = aUserInfo[@"username"];
    }
    if (aUserInfo[@"gender"]) {
        profileDict[@"sex"] = aUserInfo[@"gender"];
    }
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"profile":profileDict, @"app_src":APP_SRC };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                if (aUserInfo[@"username"]) {
                    aUser.username = aUserInfo[@"username"];
                }
                if (aUserInfo[@"gender"]) {
                    aUser.gender = [aUserInfo[@"gender"] unsignedIntegerValue];
                }
                [[HWFDataCenter defaultCenter] cacheUser:aUser];
            }
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)modifyAvatarWithUser:(HWFUser *)aUser
                      avatar:(UIImage *)anAvatarImage
                  completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    NSData *avatarData = UIImagePNGRepresentation(anAvatarImage);
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_MODIFY_AVATAR];
    NSMutableDictionary *paramDict = [@{ @"token":aUser.uToken, @"app_src":APP_SRC } mutableCopy];
    
    [[HWFNetworkCenter defaultCenter] UPLOAD:URL
                                    fileData:avatarData
                           fileDataParamName:@"pic"
                                    fileName:@"avatar.png"
                                    mimeType:@"image/png"
                                   paramDict:paramDict
                                     success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {

                aUser.avatar = (respDict[@"url"][@"b"] && !IS_STRING_EMPTY(respDict[@"url"][@"b"])) ? respDict[@"url"][@"b"] : nil;
                [[HWFDataCenter defaultCenter] cacheUser:aUser];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserAvatarModify object:nil];
            }
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

@end
