//
//  HWFBindWebViewController.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-11-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFWebViewController.h"

@protocol HWFBindWebViewControllerDelegate <NSObject>

// bindRouter
@optional
- (void)bindRouterSuccessCallbackWithMAC:(NSString *)aMAC;
- (void)bindRouterBySelfCallback; // 路由器被自己绑定

@end

@interface HWFBindWebViewController : HWFWebViewController

@property (weak, nonatomic) id<HWFBindWebViewControllerDelegate> delegate;


@end
