//
//  HWFProgressView.m
//  HiWiFiKoala
//
//  Created by dp on 14/11/11.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFProgressView.h"

#import <pop/POP.h>

@interface HWFProgressView ()

@property (strong, nonatomic) CAShapeLayer *progressLayer;

@property (assign, nonatomic) CGPoint startPos;
@property (assign, nonatomic) CGPoint endPos;

@end

@implementation HWFProgressView

#pragma mark - Initialization
- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.path = [self progressPath];
        _progressLayer.strokeColor = self.progressForegroundColor.CGColor;
        _progressLayer.fillColor   = [UIColor clearColor].CGColor;
        _progressLayer.lineCap   = kCALineCapRound;
        _progressLayer.lineJoin  = kCALineJoinRound;
        _progressLayer.frame = self.layer.bounds;
        _progressLayer.lineWidth = self.bounds.size.height;
        _progressLayer.strokeEnd = 0.0;
        [self.layer addSublayer:_progressLayer];
    }
    return _progressLayer;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];

    self.progressForegroundColor = self.progressForegroundColor ?: self.tintColor;
    self.progressBackgroundColor = self.progressBackgroundColor ?: [UIColor lightGrayColor];
    
    self.startPos = CGPointMake(0.0, self.bounds.size.height*0.5);
    self.endPos = CGPointMake(self.bounds.size.width, self.bounds.size.height*0.5);
}

#pragma mark - Properties
- (void)setProgressForegroundColor:(UIColor *)progressForegroundColor {
    if (_progressForegroundColor != progressForegroundColor) {
        _progressForegroundColor = progressForegroundColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setProgressBackgroundColor:(UIColor *)progressBackgroundColor {
    if (_progressBackgroundColor != progressBackgroundColor) {
        _progressBackgroundColor = progressBackgroundColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO];
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self drawBackProgress];
}

- (void)drawBackProgress {
    [self.progressBackgroundColor setStroke];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.startPos];
    [path addLineToPoint:self.endPos];
    [path setLineWidth:self.bounds.size.height];
    [path stroke];
}

- (CGPathRef)progressPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.startPos];
    [path addLineToPoint:self.endPos];
    return path.CGPath;
}

#pragma mark - Functions
- (void)setProgress:(float)progress animated:(BOOL)animated {
    POPBasicAnimation *strokeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    strokeAnimation.toValue = @(progress);
    strokeAnimation.beginTime = CACurrentMediaTime();
    strokeAnimation.duration = animated ? 0.5 : 0.0;
    strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {

        }
    };
    [self.progressLayer pop_addAnimation:strokeAnimation forKey:@"strokeAnimation"];
}

@end
