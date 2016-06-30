//
//  XMMacro.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-13.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#ifndef HiWiFiKoala_XMMacro_h
#define HiWiFiKoala_XMMacro_h

// String
#define NSStringFromInt(__X__) [NSString stringWithFormat:@"%d", (__X__)]
#define NSStringFromInteger(__X__) [NSString stringWithFormat:@"%d", (__X__)]
#define NSStringFromBool(__X__) ((__X__) ? @"YES" : @"NO")

#define IS_STRING_EMPTY(_s_) ([(_s_) isEqualToString:@""])

// Version
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define BUILD_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

// SettingsBundle
#define kSettingBundleSwitchTestingEnv    @"SwitchTestingEnv"
#define kSettingBundleSwitchDeviceConsole @"SwitchDeviceConsole"

#define IS_TESTING_ENV    ([[NSUserDefaults standardUserDefaults] boolForKey:kSettingBundleSwitchTestingEnv])
#define IS_DEVICE_CONSOLE ([[NSUserDefaults standardUserDefaults] boolForKey:kSettingBundleSwitchDeviceConsole])

// System Infomation
#define SYSTEM_VERSION    ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_LANGUAGE   ([[NSLocale preferredLanguages] objectAtIndex:0])

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// SCREEN
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define STATUS_HEIGHT 20.0
#define NAVIGATIONBAR_HEIGHT 44.0

//#define TOPBAR_EDGEINSET_TOP ((SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && SYSTEM_VERSION_LESS_THAN(@"7.1")) ? (STATUS_HEIGHT + NAVIGATIONBAR_HEIGHT) : 0.0)
#define TOPBAR_EDGEINSET_TOP 0.0

// Color
#define COLOR_RGB(r, g, b)        [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define COLOR_RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define COLOR_HEX(rgbVal)         [UIColor colorWithRed:((float)((rgbVal & 0xFF0000) >> 16))/255.0 green:((float)((rgbVal & 0xFF00) >> 8))/255.0 blue:((float)(rgbVal & 0xFF))/255.0 alpha:1.0]
#define COLOR_GRAY(g)             [UIColor colorWithRed:(g)/255.0f green:(g)/255.0f blue:(g)/255.0f alpha:1.0]

// RemoteNotification
#define kRemoteNotificationStatus @"RemoteNotificationStatus"
#define kRemoteNotificationPushToken @"RemoteNotificationPushToken"

#endif
