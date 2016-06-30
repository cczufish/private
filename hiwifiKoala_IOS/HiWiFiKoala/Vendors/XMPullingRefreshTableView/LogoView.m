//
//  LogoView.m
//  LogoDemo
//
//  Created by dp on 14-3-19.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import "LogoView.h"

@interface LogoView ()

@property (assign, nonatomic) CGFloat scale;
@property (strong, nonatomic) CAShapeLayer *logoLayer;
@property (assign, nonatomic) CGPathRef logoPath;

@end

@implementation LogoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.scale = 0.95;
    self.logoLayer = [CAShapeLayer layer];
    self.logoPath = [self loadPath];
}

- (void)layoutSubviews
{
    self.logoLayer.path = self.logoPath;
    self.logoLayer.strokeColor = self.tintColor.CGColor;
    //    self.logoLayer.strokeColor = [UIColor blackColor].CGColor;
    self.logoLayer.fillColor   = [UIColor clearColor].CGColor;
    self.logoLayer.lineCap   = kCALineCapRound;
    self.logoLayer.lineJoin  = kCALineJoinRound;
    self.logoLayer.position = CGPointMake(self.bounds.size.width*(1-self.scale)/2, self.bounds.size.width*(1-self.scale)/2);
    self.logoLayer.lineWidth = self.lineWidth;
    //    self.logoLayer.speed = 1.0;
    self.logoLayer.strokeEnd = 0.0;
    [self.layer addSublayer:self.logoLayer];    
}

- (void)refreshStrokeEnd:(CGFloat)strokeEnd
{
    self.logoLayer.strokeEnd = strokeEnd;
}

- (CGPathRef)loadPath
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat radius = width/2.0;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    // draw Circle
    //    CGPathAddEllipseInRect(path, NULL, self.bounds);
    CGPathAddArc(path, NULL, width/2, height/2, radius, M_PI*1.50, M_PI*1.499999, NO);
    
    // draw '-'
    CGPathMoveToPoint(path, NULL, 0.07*radius, 0.63*radius);
    CGPathAddLineToPoint(path, NULL, 0.70*radius, 0.63*radius);
    
    // draw '|'
    CGPathMoveToPoint(path, NULL, 0.38*radius, 0.22*radius);
    CGPathAddLineToPoint(path, NULL, 0.38*radius, 1.78*radius);
    
    // draw '/'
    CGPathMoveToPoint(path, NULL, 0.38*radius, 0.63*radius);
    CGPathAddCurveToPoint(path, NULL, 0.38*radius, 0.63*radius, 0.05*radius, 0.60*radius, 0.08*radius, 1.39*radius);
    
    // draw '\'
    CGPathMoveToPoint(path, NULL, 0.38*radius, 0.63*radius);
    CGPathAddCurveToPoint(path, NULL, 0.38*radius, 0.63*radius, 0.66*radius, 0.59*radius, 0.72*radius, 1.26*radius);
    
    // draw ')'
    CGPathMoveToPoint(path, NULL, 0.64*radius, 0.24*radius);
    CGPathAddArc(path, NULL, width/2, height/2, radius*0.84, M_PI_2*2.76, M_PI_2*3.73, NO);
    
    // draw '-'
    CGPathAddLineToPoint(path, NULL, 1.16*radius, 0.65*radius);
    
    // draw '\'
    CGPathAddLineToPoint(path, NULL, 1.83*radius, 0.86*radius);
    
    // draw ')'
    CGPathAddArc(path, NULL, width/2, height/2, radius*0.84, M_PI_2*3.90, M_PI_2*1.26, NO);
    
    // draw '/'
    CGPathMoveToPoint(path, NULL, 1.04*radius, 0.17*radius);
    CGPathAddLineToPoint(path, NULL, 0.59*radius, 1.72*radius);
    
    // draw '\'
    CGPathMoveToPoint(path, NULL, 0.79*radius, 1.04*radius);
    CGPathAddCurveToPoint(path, NULL, 0.79*radius, 1.04*radius, 1.20*radius, 1.20*radius, 1.73*radius, 1.67*radius);
    
    
    CGAffineTransform t = CGAffineTransformMakeScale(self.scale, self.scale);
    return CGPathCreateCopyByTransformingPath(path, &t);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
