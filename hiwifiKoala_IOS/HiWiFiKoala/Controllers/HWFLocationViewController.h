//
//  HWFLocationViewController.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFViewController.h"
#import "HWFNetworkNode.h"

@protocol HWFLocationViewControllerDelegate <NSObject>

- (void)refreshLocation:(NSString *)locationName;

@end

@interface HWFLocationViewController : HWFViewController

@property (strong, nonatomic) HWFNetworkNode *node;
@property (assign, nonatomic) id<HWFLocationViewControllerDelegate> delegate;

@end
