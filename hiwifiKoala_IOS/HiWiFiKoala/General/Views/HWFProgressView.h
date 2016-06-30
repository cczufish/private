//
//  HWFProgressView.h
//  HiWiFiKoala
//
//  Created by dp on 14/11/11.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWFProgressView : UIControl

@property (assign, nonatomic) CGFloat progress;
@property (strong, nonatomic) IBInspectable UIColor *progressForegroundColor; // 前景色
@property (strong, nonatomic) IBInspectable UIColor *progressBackgroundColor; // 背景色

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
