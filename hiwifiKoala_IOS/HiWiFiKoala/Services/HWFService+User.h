//
//  HWFService+User.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-14.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService.h"

@class HWFUser;

@interface HWFService (User)

/**
 *  @brief  登录接口(通过密码)
 *
 *  @param identity             身份标识(mobile/email/username)
 *  @param password             密码
 *  @param theCompletionHandler Handler
 */
- (void)loginWithIdentity:(NSString *)identity
                 password:(NSString *)password
               completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  退出接口
 *
 *  @param theCompletionHandler Handler
 */
- (void)logoutCompletion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  获取用户详细资料
 *
 *  @param aUser                用户对象
 *  @param theCompletionHandler Handler
 */
- (void)loadProfileWithUser:(HWFUser *)aUser
                 completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  发送验证码
 *
 *  @param aMobile              手机号码
 *  @param theCompletionHandler Handler
 */
- (void)sendVerifyCodeWithMobile:(NSString *)aMobile
                      completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  注册接口(通过手机号码和验证码)
 *
 *  @param aMobile              手机号码
 *  @param aVerifyCode          验证码
 *  @param theCompletionHandler Handler
 */
- (void)registerWithMobile:(NSString *)aMobile
                verifyCode:(NSString *)aVerifyCode
                completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  重置用户密码(通过手机号码和验证码)
 *
 *  @param aMobile              手机号码
 *  @param aVerifyCode          验证码
 *  @param theCompletionHandler Handler
 */
- (void)resetUserPasswordWithMobile:(NSString *)aMobile
                         verifyCode:(NSString *)aVerifyCode
                         completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  修改用户密码(通过旧密码)
 *
 *  @param aUser                用户对象
 *  @param oldPWD               旧密码
 *  @param newPWD               新密码
 *  @param theCompletionHandler Handler
 */
- (void)modifyUserPasswordWithUser:(HWFUser *)aUser
                            oldPWD:(NSString *)oldPWD
                            newPWD:(NSString *)newPWD
                        completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  完善用户资料
 *
 *  @param aUser                用户对象
 *  @param aUserInfo            用户资料字典(KEY: username / password / gender)
 *  @param theCompletionHandler Handler
 */
- (void)perfectInfoWithUser:(HWFUser *)aUser
                   userInfo:(NSDictionary *)aUserInfo
                 completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  修改用户资料
 *
 *  @param aUser                用户对象
 *  @param aUserInfo            用户资料字典(KEY: username / gender)
 *  @param theCompletionHandler Handler
 */
- (void)modifyInfoWithUser:(HWFUser *)aUser
                  userInfo:(NSDictionary *)aUserInfo
                completion:(ServiceCompletionHandler)theCompletionHandler;

/**
 *  @brief  修改用户头像
 *
 *  @param aUser                用户对象
 *  @param anAvatar             头像图片
 *  @param theCompletionHandler Handler
 */
- (void)modifyAvatarWithUser:(HWFUser *)aUser
                      avatar:(UIImage *)anAvatar
                  completion:(ServiceCompletionHandler)theCompletionHandler;

@end
