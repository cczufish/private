//
//  HWFControlBarButton.h
//  HiWiFiKoala
//
//  Created by dp on 14-10-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWFControlBarButton;

typedef void (^HWFControlBarButtonClickHandler)(HWFControlBarButton *sender);

@interface HWFControlBarButton : UIControl

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *activeImage;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *info;
@property (strong, nonatomic) HWFControlBarButtonClickHandler clickHandler; // TouchUpInside时触发

@end
