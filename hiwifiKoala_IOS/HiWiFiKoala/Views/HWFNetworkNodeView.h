//
//  HWFNetworkNodeView.h
//  HiWiFiKoala
//
//  Created by dp on 14-10-16.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HWFNetworkNode.h"

@class HWFNetworkNodeView;

typedef void (^HWFNetworkNodeViewClickHandler)(HWFNetworkNodeView *sender);

@interface HWFNetworkNodeView : UIControl

@property (strong, nonatomic) HWFNetworkNode *node;

@property (strong, nonatomic) HWFNetworkNodeViewClickHandler clickHandler; // TouchUpInside时触发

@end
