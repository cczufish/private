//
//  HWFLineView.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/31.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFLineView.h"

@implementation HWFLineView

- (void)setLineColor:(UIColor *)lineColor {
    if (_lineColor != lineColor) {
        _lineColor = lineColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    if (_lineWidth != lineWidth) {
        _lineWidth = lineWidth;
        
        [self setNeedsDisplay];
    }
}

- (void)setPointA:(CGPoint)pointA {
    if (_pointA.x != pointA.x || _pointA.y != pointA.y) {
        _pointA = pointA;
        
        [self setNeedsDisplay];
    }
}

- (void)setPointB:(CGPoint)pointB {
    if (_pointB.x != pointB.x || _pointB.y != pointB.y) {
        _pointB = pointB;
        
        [self setNeedsDisplay];
    }
}

- (void)setIsVertical:(BOOL)isVertical {
    if (_isVertical != isVertical) {
        _isVertical = isVertical;
        
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (self.pointA.x==0 && self.pointA.y==0 && self.pointB.x==0 && self.pointB.y==0) {
        if (self.isVertical) { // 纵向
            self.pointB = CGPointMake(0.0, self.bounds.size.height);
        } else { // 横向
            self.pointB = CGPointMake(self.bounds.size.width, 0.0);
        }
    }
    
    self.lineWidth = self.lineWidth ?: 0.25;
    self.lineColor = self.lineColor ?: [UIColor darkGrayColor];
    self.backgroundColor = [UIColor clearColor];
    
    // Drawing code
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    if (self.isVertical) { // 纵向
        [linePath moveToPoint:CGPointMake(self.pointA.x+self.lineWidth, self.pointA.y)];
        [linePath addLineToPoint:CGPointMake(self.pointB.x+self.lineWidth, self.pointB.y)];
    } else { // 横向
        [linePath moveToPoint:CGPointMake(self.pointA.x, self.pointA.y+self.lineWidth)];
        [linePath addLineToPoint:CGPointMake(self.pointB.x, self.pointB.y+self.lineWidth)];
    }
    
    linePath.lineWidth = self.lineWidth;
    [self.lineColor setStroke];
    [linePath stroke];
}

@end
