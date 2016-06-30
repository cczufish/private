//
//  XMGradientProgressView.m
//  XMGradientProgressViewDemo
//
//  Created by dp on 13-12-4.
//  Copyright (c) 2013年 Chief. All rights reserved.
//

#import "XMGradientProgressView.h"

#define DEFAULT_BACKCOLOR UIColor.grayColor
#define DEFAULT_TINTCOLORS @[@[@(70), @(152), @(236)], @[@(61), @(205), @(74)], @[@(254), @(150), @(14)], @[@(234), @(40), @(26)]]
#define DEFAULT_ANIMATION_DURATION 1.0f
#define DEFAULT_BORDER_WIDTH 0.0f
#define DEFAULT_LINE_WIDTH 1.0f

@interface XMGradientProgressView ()
{
    NSInteger _idx;
    BOOL _isAnimated;
    CGFloat _colorProgress;
}

@property (nonatomic, assign, readwrite) float fromProgress;
@property (nonatomic, assign, readwrite) float toProgress;
@property (nonatomic, assign, readwrite) CFTimeInterval startTime;
@property (nonatomic, strong, readwrite) CADisplayLink *displayLink;

@end

@implementation XMGradientProgressView

+ (Class)layerClass {
    return CAShapeLayer.class;
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame backColor:DEFAULT_BACKCOLOR tintColors:DEFAULT_TINTCOLORS borderWidth:DEFAULT_BORDER_WIDTH lineWidth:DEFAULT_LINE_WIDTH animationDuration:DEFAULT_ANIMATION_DURATION];
}

- (id)initWithFrame:(CGRect)frame backColor:(UIColor *)backColor tintColors:(NSArray *)tintColors borderWidth:(CGFloat)borderWidth lineWidth:(CGFloat)lineWidth animationDuration:(CGFloat)duration
{
    if (self = [super initWithFrame:frame]) {
        _idx = 0;
        _colorProgress = 0.0f;
        self.tintColors = tintColors;
        self.backColor = backColor;
        self.borderWidth = borderWidth;
        self.lineWidth = lineWidth;
        self.backgroundColor = [UIColor colorWithRed:[tintColors[_idx][0] floatValue]/255.0 green:[tintColors[_idx][1] floatValue]/255.0 blue:[tintColors[_idx][2] floatValue]/255.0 alpha:1.0];
        self.animationDuration = duration;
    }
    return self;
}

- (void)layoutSubviews
{
    self.shapeLayer.borderColor = self.backColor.CGColor;
    self.shapeLayer.borderWidth = self.borderWidth;
    
    self.shapeLayer.strokeColor = self.backColor.CGColor;
    self.shapeLayer.fillColor = UIColor.clearColor.CGColor;
    self.shapeLayer.lineWidth = self.lineWidth;
}

- (void)changeTintColor
{
    NSInteger newIdx = [self.tintColors count]*self.progress;

    if (_colorProgress >= 1) {
        _colorProgress = 0.0f;
    }
    
    if (_idx == newIdx) {
        _colorProgress = _colorProgress>=1.0f?0.0f:self.progress*[self.tintColors count];
    } else {
        _colorProgress = 0.0f;
        _idx = newIdx<self.tintColors.count-1 ? newIdx : self.tintColors.count-2;
    }
    
    CGFloat r = [self.tintColors[_idx][0] floatValue] + ([self.tintColors[_idx+1][0] floatValue]-[self.tintColors[_idx][0] floatValue])*self.progress;
    CGFloat g = [self.tintColors[_idx][1] floatValue] + ([self.tintColors[_idx+1][1] floatValue]-[self.tintColors[_idx][1] floatValue])*self.progress;
    CGFloat b = [self.tintColors[_idx][2] floatValue] + ([self.tintColors[_idx+1][2] floatValue]-[self.tintColors[_idx][2] floatValue])*self.progress;
    
//    NSLog(@"%.2f||%.2f   %d||%d    %.2f||%.2f||%.2f", self.progress, _colorProgress, _idx, newIdx, r, g, b);
    
    self.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
//    return;
//
//    if (_isAnimated) {
//        [UIView animateWithDuration:1.0f animations:^{
//            self.backgroundColor = self.tintColors[_idx];
//        } completion:^(BOOL finished) {
//            
//        }];
//    } else {
//        self.backgroundColor = self.tintColors[_idx];
//    }
}

- (CGFloat)assertProgress:(CGFloat)progress
{
    progress = (progress < 0) ? 0 : progress;
    progress = (progress > 1) ? 1 : progress;
    
    return progress;
}

- (void)setProgress:(CGFloat)progress
{
    // Stop running animation
    if (self.displayLink) {
        [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        self.displayLink = nil;
    }
    
    _progress = [self assertProgress:progress];
    
    [self updateProgress];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    _isAnimated = animated;
    if (animated) {
        if (self.progress == progress) {
            return;
        }
        
        self.startTime = CACurrentMediaTime();
        self.fromProgress = self.progress;
        self.toProgress = progress;
        
        if (self.displayLink) {
            [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
            self.displayLink = nil;
        }
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateFrame:)];
        [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        
    } else {
        self.progress = progress;
    }
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated progressBlock:(XMGradientProgressBlock)aBlock
{
    if (self.progressBlock != aBlock) {
        self.progressBlock = aBlock;
    }
    
    [self setProgress:progress animated:animated];
}

- (void)animateFrame:(CADisplayLink *)displayLink {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        CGFloat d = (displayLink.timestamp - self.startTime) / self.animationDuration;
        
        if (d >= 1.0) {
            // Order is important! Otherwise concurrency will cause errors, because setProgress: will detect an
            // animation in progress and try to stop it by itself.
            if (self.displayLink) {
                [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
                self.displayLink = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progress = self.toProgress;
            });
            
            return;
        }
        
        _progress = self.fromProgress + d * (self.toProgress - self.fromProgress);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateProgress];
        });
    });
}

- (void)updateProgress
{
    [self updatePath];
    
    if (self.progressBlock) {
        self.progressBlock(self.progress);
    }
    
    if ([self.delegate respondsToSelector:@selector(xmProgressView:progress:)]) {
        [self.delegate xmProgressView:self progress:self.progress];
    }
}

- (void)updatePath
{
    self.shapeLayer.path = [self layoutPath].CGPath;
    
    [self changeTintColor];
}

- (UIBezierPath *)layoutPath {
    CGRect frame = self.frame;

    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(frame.size.width, frame.size.height/2)];
    [bezierPath addLineToPoint: CGPointMake(frame.size.width*(1-self.progress), frame.size.height/2)];
    return bezierPath;

}

- (void)pauseProgress
{
    if (self.displayLink) {
        [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        self.displayLink = nil;
    }
}

- (void)resetProgress
{
    [self setProgress:0.0f animated:NO];
}

@end
