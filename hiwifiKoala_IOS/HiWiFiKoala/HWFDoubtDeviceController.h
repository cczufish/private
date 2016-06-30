//
//  HWFDoubtDeviceController.h
//  HiWiFiKoala
//
//  Created by chang hong on 14-10-21.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWFMessage.h"
#import "HWFViewController.h"
#import "HWFMessage.h"

@protocol HWFDoubtDeviceControllerDelegate <NSObject>

- (void)messageDetailChanged:(HWFMessage *)msg;

@end

@interface HWFDoubtDeviceController : HWFViewController

@property (strong,nonatomic) HWFMessage *message;
@property (assign, nonatomic) id <HWFDoubtDeviceControllerDelegate> delegate;
@end
