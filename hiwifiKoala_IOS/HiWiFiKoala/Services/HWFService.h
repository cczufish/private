//
//  HWFService.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-14.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HWFNetworkCenter.h"
#import "HWFDataCenter.h"
#import "HWFAPIFactory.h"

#define CODE(__x__) (([(__x__) objectForKey:@"code"] && ([[(__x__) objectForKey:@"code"] isKindOfClass:[NSNumber class]] || [[(__x__) objectForKey:@"code"] isKindOfClass:[NSString class]])) ? [[(__x__) objectForKey:@"code"] integerValue] : CODE_NIL)
#define MSG(__x__) ([__x__ objectForKey:@"msg"] ? [__x__ objectForKey:@"msg"] : MSG_NIL)

#define APP_CODE(__x__) (([(__x__) objectForKey:@"app_code"] && ([[(__x__) objectForKey:@"app_code"] isKindOfClass:[NSNumber class]] || [[(__x__) objectForKey:@"app_code"] isKindOfClass:[NSString class]])) ? [[(__x__) objectForKey:@"app_code"] integerValue] : CODE_NIL)
#define APP_MSG(__x__) ([__x__ objectForKey:@"app_msg"] ? [__x__ objectForKey:@"app_msg"] : MSG_NIL)

/**
 *  @brief  接口调用服务成功处理句柄
 *
 *  @param code   接口返回的code
 *  @param msg    接口返回的msg
 *  @param data   接口返回的数据
 *  @param option AFNetworking HTTP请求选项
 */
typedef void (^ServiceCompletionHandler)(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option);

/**
 *  @brief  `接口调用服务成功处理句柄`处理完成后的Callback句柄(Service内部使用)
 *
 *  @param code     处理后的code
 *  @param msg      处理后的msg
 *  @param respDict 处理后的数据(NSDictionary类型)
 */
typedef void (^HWFDictionaryDealHandler)(NSInteger code, NSString *msg, NSMutableDictionary *respDict);

extern NSInteger const CODE_SUCCESS;
extern NSInteger const CODE_NIL;
extern NSString *const MSG_NIL;

/**
 *  @brief  接口调用服务，处理所有接口调用
 */
@interface HWFService : NSObject

+ (id)defaultService;

#pragma mark - PUBLIC
/**
 *  @brief  根据Code获取Message
 *
 *  @param aCode           Code
 *  @param aDefaultMessage 配置文件取不到时，显示的Message
 *
 *  @return Message
 */
- (NSString *)getMessageWithCode:(NSInteger)aCode defaultMessage:(NSString *)aDefaultMessage;

/**
 *  @brief  普通接口的公共处理函数
 *
 *  @param aDealHandler         DealHandler
 *  @param aURL                 URL
 *  @param aParamDict           参数字典
 *  @param aRequestOption       AFHTTPRequestOperation
 *  @param data                 接口返回的数据
 *  @param theCompletionHandler Handler
 */
- (void)deal:(HWFDictionaryDealHandler)aDealHandler
afterSuccessWithURL:(NSString *)aURL
   paramDict:(NSDictionary *)aParamDict
requestOption:(AFHTTPRequestOperation *)aRequestOption
        data:(id)data
  completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  普通接口调用失败时的公共处理函数
 *
 *  @param aURL                 URL
 *  @param aParamDict           参数字典
 *  @param aRequestOption       AFHTTPRequestOperation
 *  @param error                ERROR
 *  @param theCompletionHandler Handler
 */
- (void)dealAfterFailureWithURL:(NSString *)aURL
                      paramDict:(NSDictionary *)aParamDict
                  requestOption:(AFHTTPRequestOperation *)aRequestOption
                          error:(NSError *)error
                     completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  OpenAPI接口的公共处理函数
 *
 *  @param aDealHandler         DealHandler
 *  @param aURL                 URL
 *  @param aMethod              Method
 *  @param aParamDict           参数字典
 *  @param aUser                用户对象
 *  @param aRouter              路由对象
 *  @param aRequestOption       AFHTTPRequestOperation
 *  @param data                 接口返回的数据
 *  @param theCompletionHandler Handler
 */
- (void)OpenAPIDeal:(HWFDictionaryDealHandler)aDealHandler
afterSuccessWithURL:(NSString *)aURL
             method:(NSString *)aMethod
          paramDict:(NSDictionary *)aParamDict
               user:(HWFUser *)aUser
             router:(HWFRouter *)aRouter
      requestOption:(AFHTTPRequestOperation *)aRequestOption
               data:(id)data
         completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  OpenAPI接口调用失败时的公共处理函数
 *
 *  @param aURL                 URL
 *  @param aMethod              Method
 *  @param aParamDict           参数字典
 *  @param aUser                用户对象
 *  @param aRouter              路有对象
 *  @param aRequestOption       AFHTTPRequestOperation
 *  @param error                ERROR
 *  @param theCompletionHandler Handler
 */
- (void)OpenAPIDealAfterFailureWithURL:(NSString *)aURL
                                method:(NSString *)aMethod
                             paramDict:(NSDictionary *)aParamDict
                                  user:(HWFUser *)aUser
                                router:(HWFRouter *)aRouter
                         requestOption:(AFHTTPRequestOperation *)aRequestOption
                                 error:(NSError *)error
                            completion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - Cloud Config
/**
 *  @brief  获取位置映射关系
 *
 *  @param theCompletionHandler Handler
 */
- (void)loadPlaceMapCompletion:(ServiceCompletionHandler)theCompletionHandler;

#pragma mark - OTHER
/**
 *  @brief  检测App升级信息
 *
 *  @param theCompletionHandler Handler
 */
- (void)loadAppUpgradeInfoCompletion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  上报推送的PushToken
 *
 *  @param aPushToken           PushToken
 *  @param theCompletionHandler Handler
 */
- (void)uploadPushToken:(NSString *)aPushToken
             completion:(ServiceCompletionHandler)theCompletionHandler;

@end
