//
//  HWFTool.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-29.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFTool.h"

#import <SystemConfiguration/CaptiveNetwork.h>

@implementation HWFTool

+ (BOOL)isEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isMobile:(NSString *)mobile {
//    NSString *phoneRegex = @"^(1(([358][0-9])|([4][57])|([7][07])))\\d{8}$";
    NSString *phoneRegex = @"^(1(([34578][0-9])))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isChinese:(NSString *)str {
    for(int i = 0; i < [str length]; i++) {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
            return YES;
    }
    return NO;
}

+ (NSString *)MAC4ConnectedWiFi {
    NSString *MAC = @"";
    CFArrayRef interfacesArr = CNCopySupportedInterfaces();
    if (interfacesArr != nil) {
        CFDictionaryRef networkInfoDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(interfacesArr, 0));
        if (networkInfoDict != nil) {
            NSString *BSSID = [(NSDictionary*)CFBridgingRelease(networkInfoDict) valueForKey:@"BSSID"];
            
            // Format: d4:ee:7:7:5f:42~>D4EE07075F42
            NSArray *bssidArr = [BSSID componentsSeparatedByString:@":"];
            
            int i = 0;
            for (NSString *bssidItem in bssidArr) {
                if (bssidItem.length == 0) {
                    MAC = [MAC stringByAppendingString:@"00"];
                } else if (bssidItem.length == 1) {
                    MAC = [MAC stringByAppendingString:[@"0" stringByAppendingString:bssidItem]];
                } else {
                    MAC = [MAC stringByAppendingString:bssidItem];
                }
                
                i++;
            }
        }
    }
    
    return [MAC uppercaseString];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (NSString *)standardMAC:(NSString *)aMAC {
    NSString *separator = @":";
    
    if (aMAC.length == 12 && [aMAC rangeOfString:separator].location == NSNotFound) {
        return [aMAC uppercaseString];
    } else {
        return [[aMAC stringByReplacingOccurrencesOfString:separator withString:@""] uppercaseString];
    }
}

+ (NSString *)displayMAC:(NSString *)aMAC {
    NSString *separator = @":";
    
    if (aMAC.length == 17 && [aMAC rangeOfString:separator].location != NSNotFound) {
        return [aMAC uppercaseString];
    } else if (aMAC.length == 12) {
        NSMutableArray *MACModuleArray = [NSMutableArray array];
        for (int i=0; i<aMAC.length; i+=2) {
            [MACModuleArray addObject:[aMAC substringWithRange:NSMakeRange(i, 2)]];
        }
        return [[MACModuleArray componentsJoinedByString:separator] uppercaseString];
    } else {
        return aMAC;
    }
}

+ (NSString *)displayTrafficWithUnitB:(CGFloat)trafficWithUnitB {
    NSString *displayTraffic = nil;
    if (trafficWithUnitB >= 1024.0 * 1024.0) {
        displayTraffic = [NSString stringWithFormat:@"%0.1f MB/s", (trafficWithUnitB / 1024.0 / 1024.0)];
    } else {
        displayTraffic = [NSString stringWithFormat:@"%0.1f KB/s",  fabs(trafficWithUnitB) / 1024.0];
    }
    
    return displayTraffic;
}

+ (NSString *)displayTrafficWithUnitKB:(CGFloat)trafficWithUnitKB {
    NSString *displayTraffic = nil;
    if (trafficWithUnitKB >= 1024.0) {
        displayTraffic = [NSString stringWithFormat:@"%0.1f MB/s", (trafficWithUnitKB / 1024.0)];
    } else {
        displayTraffic = [NSString stringWithFormat:@"%0.1f KB/s", trafficWithUnitKB];
    }
    return displayTraffic;
}

+ (NSString *)displaySizeWithUnitB:(double)sizeWithUnitB {
    NSString *displaySize = nil;
    if (sizeWithUnitB >= 1024.0 * 1024.0 * 1024.0) {
        displaySize = [NSString stringWithFormat:@"%0.1f GB", (sizeWithUnitB / 1024.0 / 1024.0 / 1024.0)];
    } else if (sizeWithUnitB >= 1024.0 * 1024.0) {
        displaySize = [NSString stringWithFormat:@"%0.1f MB", (sizeWithUnitB / 1024.0 / 1024.0)];
    } else if (sizeWithUnitB >= 1024.0) {
        displaySize = [NSString stringWithFormat:@"%0.1f KB", (sizeWithUnitB / 1024.0)];
    } else {
        displaySize = [NSString stringWithFormat:@"%ld B", (long)sizeWithUnitB];
    }
    return displaySize;
}

+ (NSString *)displaySizeWithUnitKB:(double)sizeWithUnitKB {
    NSString *displaySize = nil;
    if (sizeWithUnitKB >= 1024.0 * 1024.0) {
        displaySize = [NSString stringWithFormat:@"%0.1f GB", (sizeWithUnitKB / 1024.0 / 1024.0)];
    } else if (sizeWithUnitKB >= 1024.0) {
        displaySize = [NSString stringWithFormat:@"%0.1f MB", (sizeWithUnitKB / 1024.0)];
    } else {
        displaySize = [NSString stringWithFormat:@"%ld KB", (long)sizeWithUnitKB];
    }
    return displaySize;
}

+ (NSString *)displaySizeWithUnitMB:(double)sizeWithUnitMB {
    NSString *displaySize = nil;
    if (sizeWithUnitMB >= 1024.0 * 1024.0) {
        displaySize = [NSString stringWithFormat:@"%0.1f TB", (sizeWithUnitMB / 1024.0 / 1024.0)];
    } else if (sizeWithUnitMB >= 1024.0) {
        displaySize = [NSString stringWithFormat:@"%0.1f GB", (sizeWithUnitMB / 1024.0)];
    } else {
        displaySize = [NSString stringWithFormat:@"%ld MB", (long)sizeWithUnitMB];
    }
    return displaySize;
}

#pragma mark - Date Format
+ (NSString *)getDateStringFromDate:(NSDate *)date withFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)getDateFromDateString:(NSString *)dateString withFormatter:(NSString *)formatter
{
    if (!dateString || IS_STRING_EMPTY(dateString)) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
}


+ (NSString *)dateAgoWithDate:(NSDate*)date
{
    //日期处理
    NSDate * today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate *afterSevenDay1 = [NSDate dateWithTimeIntervalSinceNow:-86400*2];
    NSDate *afterSevenDay2 = [NSDate dateWithTimeIntervalSinceNow:-86400*3];
    NSDate *afterSevenDay3 = [NSDate dateWithTimeIntervalSinceNow:-86400*4];
    NSDate *afterSevenDay4 = [NSDate dateWithTimeIntervalSinceNow:-86400*5];
    NSDate *afterSevenDay5 = [NSDate dateWithTimeIntervalSinceNow:-86400*6];
    
    NSDateFormatter *currentdateFormatter = [[NSDateFormatter alloc] init];
    [currentdateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *refDateString  = [currentdateFormatter stringFromDate:date];
    NSString * todayString = [currentdateFormatter stringFromDate:today];
    NSString * yesterdayString = [currentdateFormatter stringFromDate:yesterday];
    NSString * afterSevenDayString1 = [currentdateFormatter stringFromDate:afterSevenDay1];
    NSString * afterSevenDayString2 = [currentdateFormatter stringFromDate:afterSevenDay2];
    NSString * afterSevenDayString3 = [currentdateFormatter stringFromDate:afterSevenDay3];
    NSString * afterSevenDayString4 = [currentdateFormatter stringFromDate:afterSevenDay4];
    NSString * afterSevenDayString5 = [currentdateFormatter stringFromDate:afterSevenDay5];
    
    NSString *dateString =  [[NSString alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateSMS = [dateFormatter stringFromDate:date];
    
    if ([refDateString isEqualToString:todayString])
    {
        dateString = dateSMS;
        
    } else if ([refDateString isEqualToString:yesterdayString])
    {
        dateString = [NSString stringWithFormat:@"昨天 %@",dateSMS];
    }else if([refDateString isEqualToString:afterSevenDayString1])
    {
        dateString = [NSString stringWithFormat:@"%@ %@",[self dayOfWeekTypeString:date],dateSMS];
    }else if([refDateString isEqualToString:afterSevenDayString2])
    {
        dateString = [NSString stringWithFormat:@"%@ %@",[self dayOfWeekTypeString:date],dateSMS];
    }else if([refDateString isEqualToString:afterSevenDayString3])
    {
        dateString = [NSString stringWithFormat:@"%@ %@",[self dayOfWeekTypeString:date],dateSMS];
    }else if([refDateString isEqualToString:afterSevenDayString4])
    {
        dateString = [NSString stringWithFormat:@"%@ %@",[self dayOfWeekTypeString:date],dateSMS];
    }else if([refDateString isEqualToString:afterSevenDayString5])
    {
        dateString = [NSString stringWithFormat:@"%@ %@",[self dayOfWeekTypeString:date],dateSMS];
    }else{
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        comps = [calendar components:unitFlags fromDate:date];
        int month = [comps month];
        int day = [comps day];
        //日期显示
        dateString = [NSString stringWithFormat:@"%d月%d日 %@",month,day,dateSMS];
    }
    return dateString;
}

+ (NSString *)dayOfWeekTypeString:(NSDate *)date
{
    NSDateFormatter *fmtter = [[NSDateFormatter alloc]init];
    [fmtter setDateFormat:@"EEE"];
    NSString *dayString = [fmtter stringFromDate:date];
    
    if ([dayString hasPrefix:@"Mon"]) {
        return @"星期一";
    }
    if([dayString
        hasPrefix:@"Tue"])
    {
        return @"星期二";
    }
    if([dayString
        hasPrefix:@"Wed"])
    {
        return @"星期三";
    }
    if([dayString
        hasPrefix:@"Thu"])
    {
        return @"星期四";
    }
    if([dayString
        hasPrefix:@"Fri"])
    {
        return @"星期五";
    }
    if([dayString
        hasPrefix:@"Sat"])
    {
        return @"星期六";
    }
    if([dayString
        hasPrefix:@"Sun"])
    {
        return @"星期日";
    }
    if (dayString.length < 3) {
        dayString = [dayString stringByReplacingOccurrencesOfString:@"周" withString:@"星期"];
    }
    return dayString;
}

@end
