//
//  HWFAPIDetailViewController.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFViewController.h"

#import "HWFAPI.h"

@class HWFAPI;

typedef void (^APIResultHandler)(APIResult aResult);

@interface HWFAPIDetailViewController : HWFViewController

- (void)loadData:(HWFAPI *)data completion:(APIResultHandler)theHandler;

@end
