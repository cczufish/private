//
//  LogoView.h
//  LogoDemo
//
//  Created by dp on 14-3-19.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogoView : UIView

@property (strong, nonatomic) UIColor *tintColor;
@property (assign, nonatomic) CGFloat lineWidth;

- (void)refreshStrokeEnd:(CGFloat)strokeEnd;

@end
