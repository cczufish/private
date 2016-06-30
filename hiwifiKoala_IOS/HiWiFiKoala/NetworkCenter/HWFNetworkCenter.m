//
//  HWFNetworkCenter.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-14.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFNetworkCenter.h"

#import "HWFUser.h"
#import "HWFRouter.h"
#import "NSString+Extension.h"

@implementation HWFNetworkCenter

+ (HWFNetworkCenter *)defaultCenter {
    static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)POST:(NSString *)aURL
      paramDict:(NSDictionary *)aParamDict
        success:(NetworkCenterSuccessHandler)aSuccessHandler
        failure:(NetworkCenterFailureHandler)aFailureHandler {
    if (!aURL || [aURL isEqualToString:@""]) {
        // 参考Code.plist 21-URLIsNil
        NSError *error = [NSError errorWithDomain:REQUEST_ERROR_DOMAIN code:21 userInfo:nil];
        if (aFailureHandler) {
            aFailureHandler(nil, error);
        }
        return;
    }
    
    DDLogVerbose(@"\n POST ~>\n  URL : %@\nPARAM : %@\n", aURL, aParamDict);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = REQUEST_TIMEOUT_INTERVAL;
    
    // "User-Agent" = "HiWiFiKoala/140913 (iPhone Simulator; iOS 8.0; Scale/2.00)"
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Client-type"];
    [manager.requestSerializer setValue:APP_VERSION  forHTTPHeaderField:@"Client-ver"];
    [manager.requestSerializer setValue:APP_SRC forHTTPHeaderField:@"App-src"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:aURL parameters:aParamDict success:^(AFHTTPRequestOperation *operation, id responseObject) {        
        if (aSuccessHandler) {
            aSuccessHandler(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (aFailureHandler) {
            aFailureHandler(operation, error);
        }
        
        [operation cancel];
    }];
}

- (void)JSON:(NSString *)aURL
   paramDict:(NSDictionary *)aParamDict
     success:(NetworkCenterSuccessHandler)aSuccessHandler
     failure:(NetworkCenterFailureHandler)aFailureHandler {
    if (!aURL || [aURL isEqualToString:@""]) {
        // 参考Code.plist 21-URLIsNil
        NSError *error = [NSError errorWithDomain:REQUEST_ERROR_DOMAIN code:21 userInfo:nil];
        if (aFailureHandler) {
            aFailureHandler(nil, error);
        }
        return;
    }
    
    DDLogVerbose(@"\n JSON ~>\n  URL : %@\nPARAM : %@\n", aURL, aParamDict);
    
    NSString *JSONParam = aParamDict ? [self getJSONStringWithObject:aParamDict] : @"{}";
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:aURL]];
    
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    URLRequest.HTTPMethod = @"POST";
    URLRequest.timeoutInterval = REQUEST_TIMEOUT_INTERVAL;
    URLRequest.HTTPBody = [JSONParam dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:URLRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (aSuccessHandler) {
            aSuccessHandler(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (aFailureHandler) {
            aFailureHandler(operation, error);
        }
        
        [operation cancel];
    }];
    [manager.operationQueue addOperation:operation];
}


- (void)UPLOAD:(NSString *)aURL
      fileData:(NSData *)aFileData
fileDataParamName:(NSString *)aFileDataParamName
      fileName:(NSString *)aFileName
      mimeType:(NSString *)aMIMEType
     paramDict:(NSDictionary *)aParamDict
       success:(NetworkCenterSuccessHandler)aSuccessHandler
       failure:(NetworkCenterFailureHandler)aFailureHandler {
    if (!aURL || [aURL isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:REQUEST_ERROR_DOMAIN code:21 userInfo:nil];
        if (aFailureHandler) {
            aFailureHandler(nil, error);
        }
        return;
    }
    
    DDLogVerbose(@"\nUPLOAD ~>\n   URL : %@\n PARAM : %@\n  FILE : %@ [%.2f B]", aURL, aParamDict, aFileDataParamName, aFileData.length/1024.0);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = REQUEST_TIMEOUT_INTERVAL;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:aURL parameters:aParamDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:aFileData name:aFileDataParamName fileName:aFileName mimeType:aMIMEType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (aSuccessHandler) {
            aSuccessHandler(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (aFailureHandler) {
            aFailureHandler(operation, error);
        }
        
        [operation cancel];
    }];
}

- (void)OpenAPI:(NSString *)aURL
         method:(NSString *)aMethod
      paramDict:(NSDictionary *)aParamDict
           user:(HWFUser *)aUser
         router:(HWFRouter *)aRouter
        success:(NetworkCenterSuccessHandler)aSuccessHandler
        failure:(NetworkCenterFailureHandler)aFailureHandler {
    if (!aURL || [aURL isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:REQUEST_ERROR_DOMAIN code:21 userInfo:nil];
        if (aFailureHandler) {
            aFailureHandler(nil, error);
        }
        return;
    }
    
    if (!aMethod || [aMethod isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:REQUEST_ERROR_DOMAIN code:22 userInfo:nil];
        if (aFailureHandler) {
            aFailureHandler(nil, error);
        }
        return;
    }
    
    NSString *action = @"call";
    NSString *devID = aRouter.standardMAC;
    
    NSString *JSONParam = aParamDict ? [self getJSONStringWithObject:aParamDict] : @"{}";
    
    // TODO: 处理UID==UID_NIL的情况
    NSString *JSONBody = [NSString stringWithFormat:@"{\"app_id\":\"%d\", \"app_name\":\"%@\", \"client_id\":\"%@\", \"dev_id\":\"%@\", \"timeout\":%.f, \"method\":\"%@\", \"data\":%@ }", MOBILE_PLUGIN_APP_ID, MOBILE_PLUGIN_APP_NAME, aUser.clientID, devID, REQUEST_TIMEOUT_INTERVAL, aMethod, JSONParam];
    
    NSString *sign = [NSString stringWithFormat:@"%@%@%@", action, JSONBody, aRouter.clientSecret];
    
    NSString *URL = [NSString stringWithFormat:@"%@/%@?sign=%@&dev_id=%@&ios_client_ver=%@", aURL, action, [sign MD5Encode], devID, APP_VERSION];
    
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];

    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    URLRequest.HTTPMethod = @"POST";
    URLRequest.timeoutInterval = REQUEST_TIMEOUT_INTERVAL;
    URLRequest.HTTPBody = [JSONBody dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];

    DDLogVerbose(@"\n      OpenAPI ~>\n          URL : %@\n       METHOD : %@\n    CLIENT_ID : %@\n          RID : %ld\nCLIENT_SECRET : %@\n        PARAM : %@\n     JSONBody : %@\n", URL, aMethod, aUser.clientID, (long)aRouter.RID, aRouter.clientSecret, JSONParam, JSONBody);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer.timeoutInterval = REQUEST_TIMEOUT_INTERVAL;
    
    // TODO: POST Header
    // "User-Agent" = "HiWiFiKoala/140913 (iPhone Simulator; iOS 8.0; Scale/2.00)"
    // [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"Device-Type"];
    /*
     [URLRequest setValue:[self deviceModel] forHTTPHeaderField:@"Device-Model"];
     [URLRequest setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"Device-System-Version"];
     [URLRequest setValue:APP_VERSION forHTTPHeaderField:@"App-Version"];
     */
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:URLRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (aSuccessHandler) {
            aSuccessHandler(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (aFailureHandler) {
            aFailureHandler(operation, error);
        }
        
        [operation cancel];
    }];
    [manager.operationQueue addOperation:operation];
}

/**
 *  @brief  OBJECT转换为JSON
 *
 *  @param obj OBJECT
 *
 *  @return JSON
 */
- (NSString *)getJSONStringWithObject:(id)obj {
    __autoreleasing NSError* error = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) {
        DDLogError(@"Parse Object To JSONString Error! [%ld : %@]", (long)error.code, error.localizedDescription);
        
        return nil;
    }
    
    return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
}

@end
