//
//  HWFTool.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-29.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWFTool : NSObject

/**
 *  验证是否为EMail
 *
 *  @param email 需要验证的验证串
 *
 *  @return 验证结果
 */
+ (BOOL)isEmail:(NSString *)email;

/**
 *  验证是否为手机号码
 *
 *  @param mobile 需要验证的验证串
 *
 *  @return 验证结果
 */
+ (BOOL)isMobile:(NSString *)mobile;

/**
 *  验证是否包含中文字符
 *
 *  @param str 需要验证的验证串
 *
 *  @return 验证结果
 */
+ (BOOL)isChinese:(NSString *)str;

/**
 *  @brief  当前连接着的WiFi的MAC地址
 *
 *  @return MAC地址(大写无分隔符)
 */
+ (NSString *)MAC4ConnectedWiFi;

/**
 *  @brief  通过颜色创建纯色图片
 *
 *  @param color 颜色
 *
 *  @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  @brief  格式化MAC (大写/无分隔符)
 *
 *  @param aMAC MAC
 *
 *  @return 格式化后的MAC
 */
+ (NSString *)standardMAC:(NSString *)aMAC;

/**
 *  @brief  格式化MAC (大写/':'分隔)
 *
 *  @param aMAC MAC
 *
 *  @return 格式化后的MAC
 */
+ (NSString *)displayMAC:(NSString *)aMAC;

/**
 *  @brief  网速格式化(原始数据单位: `B/s`)
 *
 *  @param trafficWithUnitB 原始网速值
 *
 *  @return 格式化后的网速
 */
+ (NSString *)displayTrafficWithUnitB:(CGFloat)trafficWithUnitB;

/**
 *  @brief  网速格式化(原始数据单位: `KB/s`)
 *
 *  @param trafficWithUnitKB 原始网速值
 *
 *  @return 格式化后的网速
 */
+ (NSString *)displayTrafficWithUnitKB:(CGFloat)trafficWithUnitKB;

/**
 *  @brief  存储大小格式化(原始数据单位: `B`)
 *
 *  @param sizeWithUnitB 原始大小值
 *
 *  @return 格式化后的存储大小
 */
+ (NSString *)displaySizeWithUnitB:(double)sizeWithUnitB;

/**
 *  @brief  存储大小格式化(原始数据单位: `KB`)
 *
 *  @param sizeWithUnitKB 原始大小值
 *
 *  @return 格式化后的存储大小
 */
+ (NSString *)displaySizeWithUnitKB:(double)sizeWithUnitKB;

/**
 *  @brief  存储大小格式化(原始数据单位: `MB`)
 *
 *  @param sizeWithUnitMB 原始大小值
 *
 *  @return 格式化后的存储大小
 */
+ (NSString *)displaySizeWithUnitMB:(double)sizeWithUnitMB;

//Date Format
+ (NSString *)getDateStringFromDate:(NSDate *)date withFormatter:(NSString *)formatter;
+ (NSDate *)getDateFromDateString:(NSString *)dateString withFormatter:(NSString *)formatter;

+ (NSString *)dateAgoWithDate:(NSDate*)date;

@end
