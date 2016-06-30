//
//  HWFBlackListModel.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-14.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDevice.h"

typedef NS_ENUM(NSInteger, HWFSelectType) {
    HWFSelectType_None,
    HWFSelectType_Select
};

@interface HWFBlackListModel : HWFDevice

@property (nonatomic,assign) HWFSelectType selectType;


@end
