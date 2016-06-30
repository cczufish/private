//
//  HWFSpeedUpAnimationView.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFSpeedUpAnimationView.h"

@interface HWFSpeedUpAnimationView ()

@property (strong, nonatomic) UIImageView *speedUpImageView;

@end

@implementation HWFSpeedUpAnimationView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    self.backgroundColor = [UIColor clearColor];
    self.speedUpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 37)];
    [self addSubview:self.speedUpImageView];
     NSMutableArray *speedUpImageViewArray = [[NSMutableArray alloc] init];
    for (int i=1; i<5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"speed_%d.png", i]];
        if (image) {
            [speedUpImageViewArray addObject:image];
        }
    }
    [self.speedUpImageView setAnimationImages:speedUpImageViewArray];
    [self.speedUpImageView setAnimationDuration:0.7f];
    [self.speedUpImageView setAnimationRepeatCount:0];
    [self.speedUpImageView startAnimating];
}

@end
