//
//  HWFPlugin.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-29.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFObject.h"

#pragma mark - HWFPlugin
@interface HWFPlugin : HWFObject

@property (assign, nonatomic) NSInteger SID;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSString  *ICON;
@property (strong, nonatomic) NSString  *info;
@property (assign, nonatomic) BOOL      hasInstalled; // 是否已安装
@property (strong, nonatomic) NSString  *statusMessage;
@property (assign, nonatomic) BOOL      canUninstall; // 是否可被卸载
@property (strong, nonatomic) NSString  *configURL; // 插件管理地址

@end


#pragma mark - HWFPluginCategory
@interface HWFPluginCategory : HWFObject

@property (assign, nonatomic) NSInteger CID;
@property (strong, nonatomic) NSString *name;

@end