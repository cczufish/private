//
//  HWFLineView.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/31.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWFLineView : UIView

@property (assign, nonatomic) IBInspectable CGFloat lineWidth;
@property (strong, nonatomic) IBInspectable UIColor *lineColor;
@property (assign, nonatomic) IBInspectable CGPoint pointA;
@property (assign, nonatomic) IBInspectable CGPoint pointB;
@property (assign, nonatomic) IBInspectable BOOL    isVertical; // 是否纵向，默认 NO-横向

@end
