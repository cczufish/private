//
//  HWFService.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-14.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService.h"

#import "HWFUser.h"
#import "HWFRouter.h"

NSInteger const CODE_SUCCESS = 0;
NSInteger const CODE_NIL     = NSIntegerMax;
NSString *const MSG_NIL      = @"N/A";

@interface HWFService ()

@property (strong, nonatomic) NSDictionary *codeDict;

@end

@implementation HWFService

+ (id)defaultService {
    static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (NSDictionary *)codeDict {
    if (!_codeDict) {
        _codeDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Code" ofType:@"plist"]];
    }
    
    return _codeDict;
}

#pragma mark - PUBLIC
- (NSString *)getMessageWithCode:(NSInteger)aCode defaultMessage:(NSString *)aDefaultMessage {
    NSString *returnMessage = [aDefaultMessage isKindOfClass:[NSString class]] ? [aDefaultMessage stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : @"";
    
    NSDictionary *dict = [self.codeDict objectForKey:[NSString stringWithFormat:@"%ld", (long)aCode]];
    if (dict) {
        returnMessage = NSLocalizedString(dict[@"msg"], @"");
    }
    
    if (!returnMessage || [returnMessage isEqualToString:@""] || [returnMessage isEqualToString:@"N/A"]) {
        returnMessage = NSLocalizedString(@"UndefinedError", @""); // 未知错误
    }
    
    return returnMessage;
}

- (void)deal:(HWFDictionaryDealHandler)aDealHandler
afterSuccessWithURL:(NSString *)aURL
   paramDict:(NSDictionary *)aParamDict
requestOption:(AFHTTPRequestOperation *)aRequestOption
        data:(id)data
  completion:(ServiceCompletionHandler)theCompletionHandler {
    NSInteger code = 10;
    NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
    NSMutableDictionary *respDict = nil;
    
    @try {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            respDict = [(NSDictionary *)data mutableCopy];
            
            code = CODE(respDict);
            msg = [self getMessageWithCode:code defaultMessage:MSG(respDict)];
            
            if (aDealHandler) {
                aDealHandler(code, msg, respDict);
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
        if (CODE_SUCCESS == code) {
            DDLogInfo(@"\n  URL : %@\nPARAM : %@\n CODE : %ld\n  MSG : %@\n DATA : %@\n JSON : %@", aURL, aParamDict, (long)code, msg, respDict, aRequestOption.responseString);
        } else {
            DDLogWarn(@"\n  URL : %@\nPARAM : %@\n CODE : %ld\n  MSG : %@\n DATA : %@\n JSON : %@", aURL, aParamDict, (long)code, msg, respDict, aRequestOption.responseString);
        }

        if (theCompletionHandler) {
            theCompletionHandler(code, msg, respDict?respDict:data, aRequestOption);
        }
    }
}

- (void)dealAfterFailureWithURL:(NSString *)aURL
                      paramDict:(NSDictionary *)aParamDict
                  requestOption:(AFHTTPRequestOperation *)aRequestOption
                          error:(NSError *)error
                     completion:(ServiceCompletionHandler)theCompletionHandler {
    DDLogError(@"\n  URL : %@\nPARAM : %@\n CODE : %ld\n  MSG : %@", aURL, aParamDict, (long)error.code, error.localizedDescription);
    
    if (theCompletionHandler) {
        theCompletionHandler(error.code, error.localizedDescription, nil, aRequestOption);
    }
}

- (void)OpenAPIDeal:(HWFDictionaryDealHandler)aDealHandler
afterSuccessWithURL:(NSString *)aURL
             method:(NSString *)aMethod
          paramDict:(NSDictionary *)aParamDict
               user:(HWFUser *)aUser
             router:(HWFRouter *)aRouter
      requestOption:(AFHTTPRequestOperation *)aRequestOption
               data:(id)data
         completion:(ServiceCompletionHandler)theCompletionHandler {
    NSInteger code = 10;
    NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
    NSMutableDictionary *respDict = nil;
    
    @try {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            respDict = [(NSDictionary *)data mutableCopy];
            
            code = CODE(respDict);
            msg = [self getMessageWithCode:code defaultMessage:MSG(respDict)];
            
            if (CODE_SUCCESS == code) { // CODE(__x__) == 0
                code = APP_CODE(respDict);
                msg = [self getMessageWithCode:code defaultMessage:APP_MSG(respDict)];
                
                if (CODE_SUCCESS == code && respDict[@"app_data"] && [respDict[@"app_data"] isKindOfClass:[NSDictionary class]]) { // APP_CODE(__x__) == 0
                    respDict = respDict[@"app_data"];
                }
            }
            
            if (aDealHandler) {
                aDealHandler(code, msg, respDict);
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
        if (CODE_SUCCESS == code) {
            DDLogInfo(@"\n          URL : %@\n       METHOD : %@\n    CLIENT_ID : %@\n          RID : %ld\nCLIENT_SECRET : %@\n        PARAM : %@\n         CODE : %ld\n          MSG : %@\n         DATA : %@\n         JSON : %@", aURL, aMethod, aUser.clientID, (long)aRouter.RID, aRouter.clientSecret, aParamDict, (long)code, msg, respDict, aRequestOption.responseString);
        } else {
            DDLogWarn(@"\n          URL : %@\n       METHOD : %@\n    CLIENT_ID : %@\n          RID : %ld\nCLIENT_SECRET : %@\n        PARAM : %@\n         CODE : %ld\n          MSG : %@\n         DATA : %@\n         JSON : %@", aURL, aMethod, aUser.clientID, (long)aRouter.RID, aRouter.clientSecret, aParamDict, (long)code, msg, respDict, aRequestOption.responseString);
        }
        
        if (theCompletionHandler) {
            theCompletionHandler(code, msg, respDict?respDict:data, aRequestOption);
        }
    }
}

- (void)OpenAPIDealAfterFailureWithURL:(NSString *)aURL
                                method:(NSString *)aMethod
                             paramDict:(NSDictionary *)aParamDict
                                  user:(HWFUser *)aUser
                                router:(HWFRouter *)aRouter
                         requestOption:(AFHTTPRequestOperation *)aRequestOption
                                 error:(NSError *)error
                            completion:(ServiceCompletionHandler)theCompletionHandler {
    DDLogError(@"\n          URL : %@\n       METHOD : %@\n    CLIENT_ID : %@\nCLIENT_SECRET : %@\n        PARAM : %@\n         CODE : %ld\n          MSG : %@", aURL, aMethod, aUser.clientID, aRouter.clientSecret, aParamDict, (long)error.code, error.localizedDescription);

    if (theCompletionHandler) {
        theCompletionHandler(error.code, error.localizedDescription, nil, aRequestOption);
    }
}

#pragma mark - Cloud Config
- (void)loadPlaceMapCompletion:(ServiceCompletionHandler)theCompletionHandler {
    // 从缓存加载
    NSDictionary *cache = [[HWFDataCenter defaultCenter] configWithKey:kConfigCachePlace];
    NSDate *cacheDate = cache[kCacheDate];
    //TODO:
    if ([[NSDate date] timeIntervalSince1970] - [cacheDate timeIntervalSince1970] < 1  /* 7*24*60*60 */) { // 小于7天
        NSDictionary *cacheData = cache[kCacheData];
        if (theCompletionHandler) {
            theCompletionHandler(0, @"OK", cacheData, nil);
            return;
        }
    }
    
    // 从服务器加载
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_CLOUD_PLACEMAP];
    NSDictionary *paramDict = @{ @"map_type":@"position" };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            if (CODE_SUCCESS == code) {
                [[HWFDataCenter defaultCenter] cacheConfig:data[@"data"] WithKey:kConfigCachePlace];
            }
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - OTHER
- (void)loadAppUpgradeInfoCompletion:(ServiceCompletionHandler)theCompletionHandler {
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_APP_UPGRADE_INFO];
    NSDictionary *paramDict = @{ @"ver":APP_VERSION, @"app_src":APP_SRC };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)uploadPushToken:(NSString *)aPushToken
             completion:(ServiceCompletionHandler)theCompletionHandler {
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_PUSHTOKEN_UPLOAD];
    NSDictionary *paramDict = @{ @"token":[[HWFUser defaultUser] uToken], @"push_token":aPushToken, @"apple_push_token":aPushToken, @"app_src":APP_SRC };
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

@end
