//
//  HWFRouter.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFRouter.h"

#import "HWFDataCenter.h"

NSInteger const RID_NIL = -1;

@implementation HWFRouter

- (id)init {
    self = [super init];
    if (self) {
        _RID = RID_NIL;
    }
    return self;
}

+ (instancetype)defaultRouter {
    return [[HWFDataCenter defaultCenter] defaultRouter];
}

- (BOOL)isAuthWithUser:(HWFUser *)aUser {
    return [[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:self];
}

//- (NSMutableArray *)plugins {
//    if (!_plugins) {
//        _plugins = [[NSMutableArray alloc] init];
//    }
//    return _plugins;
//}

- (NSMutableArray *)smartDevices {
    if (!_smartDevices) {
        _smartDevices = [[NSMutableArray alloc] init];
    }
    return _smartDevices;
}

//- (NSMutableArray *)devices {
//    if (!_devices) {
//        _devices = [[NSMutableArray alloc] init];
//    }
//    return _devices;
//}

//- (NSString *)SSID {
//    if (_hasWiFi24G) {
//        return _SSID24G;
//    } else if (_hasWiFi5G) {
//        return _SSID5G;
//    } else {
//        return @"";
//    }
//    
//}
//
//- (BOOL)WiFiStatus {
//    if (_hasWiFi24G) {
//        return _WiFi24GStatus;
//    } else {
//        return _WiFi5GStatus;
//    }
//}

// Override
// MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"RID" : @"rid",
             @"name" : @"name",
             @"MAC" : @"mac",
             @"SSID24G" : @"ssid_24G",
             @"SSID5G" : @"ssid_5G",
             @"IP" : @"ip",
             @"NP" : @"np",
             @"model" : @"model",
             @"place" : @"place",
             @"ROM" : @"rom_version",
             @"isNeedUpgrade" : @"need_upgrade",
             @"isForceUpgrade" : @"force_upgrade",
             @"latestROMVersion" : @"version",
             @"latestROMChangeLog" : @"changelog",
             @"latestROMSize" : @"size",
             @"clientSecret" : @"client_secret",
             @"WANType" : @"wan_type",
             @"backupDate" : @"backup_date",
             @"isOnline" : @"is_online",
             @"LEDStatus" : @"led_status",
             @"hasWiFi24G" : @"hasWiFi24G",
             @"hasWiFi5G" : @"hasWiFi5G",
             @"WiFi24GStatus" : @"24G_wifi_status",
             @"WiFi5GStatus" : @"5G_wifi_status",
             @"wideMode" : @"wide_mode",
             @"WiFiChannel" : @"wifi_channel",
             @"WiFi24GSleepConfig" : @"WiFi24GSleepConfig",
             @"WiFi5GSleepConfig" : @"WiFi5GSleepConfig",
//             @"plugins" : @"plugins",
             @"smartDevices" : @"smart_devices",
//             @"devices" : @"devices"
             };
}

- (NSString *)standardMAC {
    return [HWFTool standardMAC:self.MAC];
}

- (NSString *)displayMAC {
    return [HWFTool displayMAC:self.MAC];
}

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"%@ ~> RID:%ld name:%@ MAC:%@ SSID_24G:%@ SSID_5G:%@ isOnline:%@ clientSecret:%@", [self class], (long)self.RID, self.name, self.MAC, self.SSID24G, self.SSID5G, self.isOnline?@"YES":@"NO", self.clientSecret];
    return desc;
}

@end


#pragma mark - HWFWiFiSleepConfig
@implementation HWFWiFiSleepConfig

// @Override MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"type" : @"type",
             @"status" : @"status",
             @"WiFiOff" : @"WiFiOff",
             @"WiFiOn" : @"WiFiOn",
             };
}

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"%@ ~> WiFiOff:%ld WiFiOn:%ld", [self class], (long)self.WiFiOff, (long)self.WiFiOn];
    return desc;
}

@end
