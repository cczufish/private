//
//  HWFNetworkCenter.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-14.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>

@class HWFUser;
@class HWFRouter;

typedef void (^NetworkCenterSuccessHandler)(AFHTTPRequestOperation *option, id data);
typedef void (^NetworkCenterFailureHandler)(AFHTTPRequestOperation *option, NSError *error);

@interface HWFNetworkCenter : NSObject

+ (HWFNetworkCenter *)defaultCenter;

/**
 *  @brief  发送Post请求(FORM表单)
 *
 *  @param aURL            请求URL
 *  @param aParamDict      请求参数
 *  @param aSuccessHandler SuccessHandler
 *  @param aFailureHandler FailureHandler
 */
- (void)POST:(NSString *)aURL
   paramDict:(NSDictionary *)aParamDict
     success:(NetworkCenterSuccessHandler)aSuccessHandler
     failure:(NetworkCenterFailureHandler)aFailureHandler;

/**
 *  @brief  发送Post请求(JSON)
 *
 *  @param aURL            请求URL
 *  @param aParamDict      请求参数
 *  @param aSuccessHandler SuccessHandler
 *  @param aFailureHandler FailureHandler
 */
- (void)JSON:(NSString *)aURL
   paramDict:(NSDictionary *)aParamDict
     success:(NetworkCenterSuccessHandler)aSuccessHandler
     failure:(NetworkCenterFailureHandler)aFailureHandler;

/**
 *  @brief  文件上传(二进制)
 *
 *  @param aURL               上传URL
 *  @param aFileData          二进制文件
 *  @param aFileDataParamName 文件参数对应的名称
 *  @param aFileName          文件名
 *  @param aMIMEType          MIME type [参考: http://www.iana.org/assignments/media-types/]
 *  @param aParamDict         请求参数
 *  @param aSuccessHandler    SuccessHandler
 *  @param aFailureHandler    FailureHandler
 */
- (void)UPLOAD:(NSString *)aURL
      fileData:(NSData *)aFileData
fileDataParamName:(NSString *)aFileDataParamName
      fileName:(NSString *)aFileName
      mimeType:(NSString *)aMIMEType
     paramDict:(NSDictionary *)aParamDict
       success:(NetworkCenterSuccessHandler)aSuccessHandler
       failure:(NetworkCenterFailureHandler)aFailureHandler;

/**
 *  @brief  请求OpenAPI接口
 *
 *  @param aURL            接口URL
 *  @param aMethod         接口Method
 *  @param aParamDict      接口参数
 *  @param aUser           User对象
 *  @param aRouter         Router对象
 *  @param aSuccessHandler SuccessHandler
 *  @param aFailureHandler FailureHandler
 */
- (void)OpenAPI:(NSString *)aURL
         method:(NSString *)aMethod
      paramDict:(NSDictionary *)aParamDict
           user:(HWFUser *)aUser
         router:(HWFRouter *)aRouter
        success:(NetworkCenterSuccessHandler)aSuccessHandler
        failure:(NetworkCenterFailureHandler)aFailureHandler;

@end
