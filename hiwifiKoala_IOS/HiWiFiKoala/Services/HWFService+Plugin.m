//
//  HWFService+Plugin.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService+Plugin.h"

@implementation HWFService (Plugin)

/**
 *  @brief  获取已安装插件数量
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadPluginInstalledNUMWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_PLUGIN_INSTALLED_NUM];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID)};
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

/**
 *  @brief  获取已安装插件列表
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadPluginInstalledListWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_PLUGIN_INSTALLED_LIST];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID)};
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

/**
 *  @brief  获取插件分类列表
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCompletionHandler Handler
 */
- (void)loadPluginCategoryListWithUser:(HWFUser *)aUser
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_PLUGIN_CATEGORY_LIST];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID)};
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

/**
 *  @brief  获取插件分类下的插件列表
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theCategory          插件分类对象
 *  @param theCompletionHandler Handler
 */
- (void)loadPluginListInCategoryWithUser:(HWFUser *)aUser
                                  router:(HWFRouter *)aRouter
                                category:(HWFPluginCategory *)theCategory
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_PLUGIN_LIST_IN_CATEGORY];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID), @"cid":@(theCategory.CID)};
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

/**
 *  @brief  获取插件详细信息
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param thePlugin            插件对象
 *  @param theCompletionHandler Handler
 */
- (void)loadPluginDetailWithUser:(HWFUser *)aUser
                          router:(HWFRouter *)aRouter
                          plugin:(HWFPlugin *)thePlugin
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_PLUGIN_DETAIL];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID), @"sid":@(thePlugin.SID)};
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

/**
 *  @brief  插件安装
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param thePlugin            插件对象
 *  @param theCompletionHandler Handler
 */
- (void)installPluginWithUser:(HWFUser *)aUser
                       router:(HWFRouter *)aRouter
                       plugin:(HWFPlugin *)thePlugin
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_PLUGIN_INSTALL];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID), @"sid":@(thePlugin.SID), @"status":@(1)};
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

/**
 *  @brief  插件卸载
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param thePlugin            插件对象
 *  @param theCompletionHandler Handler
 */
- (void)uninstallPluginWithUser:(HWFUser *)aUser
                         router:(HWFRouter *)aRouter
                         plugin:(HWFPlugin *)thePlugin
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_PLUGIN_UNINSTALL];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID), @"sid":@(thePlugin.SID), @"status":@(0)};
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

/**
 *  @brief  插件操作(安装/卸载)状态查询
 *
 *  @param aUser                用户对象
 *  @param aRouter              路由器对象
 *  @param theTaskID            任务ID (安装/卸载接口返回)
 *  @param theCompletionHandler Handler
 */
- (void)loadPluginOperatingStatusWithUser:(HWFUser *)aUser
                                   router:(HWFRouter *)aRouter
                                   taskID:(NSString *)theTaskID
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
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_PLUGIN_OPERATING_STATUS];
    NSDictionary *paramDict = @{ @"token":aUser.uToken, @"rid":@(aRouter.RID), @"taskid":theTaskID};
    
    [[HWFNetworkCenter defaultCenter] POST:URL paramDict:paramDict success:^(AFHTTPRequestOperation *option, id data) {
        
        [self deal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL paramDict:paramDict requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self dealAfterFailureWithURL:URL paramDict:paramDict requestOption:option error:error completion:theCompletionHandler];
    }];
}

@end
