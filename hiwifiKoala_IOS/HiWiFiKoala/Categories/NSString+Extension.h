//
//  NSString+Extension.h
//  HiWiFi
//
//  Created by dp on 14-8-1.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSString *)MD5Encode;

- (id)JSONObject;

- (NSString *)URLEncodedString;

/**
 *  @brief  计算字符串在服务器上所占的长度(中文占两个字符)
 *
 *  @return 长度
 */
- (int)sLength;

@end
