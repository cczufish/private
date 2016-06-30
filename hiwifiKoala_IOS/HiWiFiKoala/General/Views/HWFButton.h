//
//  HWFButton.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-18.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWFButton;

typedef void (^HWFButtonClickHandler)(HWFButton *sender);

@interface HWFButton : UIControl

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIFont *titleFont;
@property (assign, nonatomic) CGVector scaleFactor; // 向内缩进比例 // 用于控制热区
@property (strong, nonatomic) HWFButtonClickHandler clickHandler; // TouchUpInside时触发

@end
