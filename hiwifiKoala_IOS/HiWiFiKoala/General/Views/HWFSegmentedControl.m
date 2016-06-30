//
//  HWFSegmentedControl.m
//  HiWiFiKoala
//
//  Created by dp on 14/11/6.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFSegmentedControl.h"

@interface HWFSegmentedControl ()

@property (assign, nonatomic) CGVector scaleFactor; // 向内缩进比例 // 用于控制热区
@property (assign, nonatomic) CGFloat cornerRadius;

@end

@implementation HWFSegmentedControl

#pragma mark - Initialization
- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.scaleFactor = CGVectorMake(1.0, 1.0);
    self.cornerRadius = 1.0;
    
    self.selectedSegmentIndex = 0;
    self.segmentForegroundColor = self.tintColor;
    self.segmentBackgroundColor = [UIColor whiteColor];
    self.segmentTitles = @[ @"A", @"B" ];
}

#pragma mark - Properties
- (void)setSelectedSegmentIndex:(int)selectedSegmentIndex {
    if (_selectedSegmentIndex != selectedSegmentIndex) {
        _selectedSegmentIndex = selectedSegmentIndex;
        
        [self setNeedsDisplay];
    }
}

- (void)setSegmentForegroundColor:(UIColor *)segmentForegroundColor {
    if (_segmentForegroundColor != segmentForegroundColor) {
        _segmentForegroundColor = segmentForegroundColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setSegmentBackgroundColor:(UIColor *)segmentBackgroundColor {
    if (_segmentBackgroundColor != segmentBackgroundColor) {
        _segmentBackgroundColor = segmentBackgroundColor;
        
        [self setNeedsDisplay];
    }
}

- (void)setSegmentTitles:(NSArray *)segmentTitles {
    if (_segmentTitles != segmentTitles) {
        _segmentTitles = segmentTitles;
        
        [self setNeedsDisplay];
    }
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect validRect = CGRectInset(self.bounds, self.scaleFactor.dx, self.scaleFactor.dy);
    
    // Border
    [self drawBorderWithRect:validRect cornerRadius:self.cornerRadius lineWidth:1.0];
    
    // Segments
    [self drawSegmentsWithRect:validRect];
    
    // Titles
    [self drawSegmentsTitleWithRect:validRect];
}

- (void)drawBorderWithRect:(CGRect)aRect cornerRadius:(CGFloat)aCornerRadius lineWidth:(CGFloat)aLineWidth {
    [[self segmentForegroundColor] setStroke];
    UIBezierPath *border = [UIBezierPath bezierPathWithRoundedRect:aRect cornerRadius:aCornerRadius];
    border.lineWidth = aLineWidth;
    [border stroke];
}

- (void)drawSegmentsWithRect:(CGRect)aRect {
    for (int i=0; i<self.segmentTitles.count; i++) {
        if (i == self.selectedSegmentIndex) {
            [[self segmentForegroundColor] setFill];
        } else {
            [[self segmentBackgroundColor] setFill];
        }
        
        CGRect segmentRect = [self segmentRectWithValidRect:aRect index:i];
        UIBezierPath *segmentPath = [UIBezierPath bezierPathWithRect:segmentRect];
        [segmentPath fill];
    }
}

- (void)drawSegmentsTitleWithRect:(CGRect)aRect {
    for (int i=0; i<self.segmentTitles.count; i++) {
        if (i == self.selectedSegmentIndex) {
            [[self segmentBackgroundColor] setFill];
        } else {
            [[self segmentForegroundColor] setFill];
        }
        
        CGRect segmentRect = [self segmentRectWithValidRect:aRect index:i];

        NSLineBreakMode lineBreak = NSLineBreakByCharWrapping;
        NSString *aTitle = self.segmentTitles[i];
        UIFont *aFont = [UIFont systemFontOfSize:12.0];

        CGSize titleSize = [aTitle sizeWithFont:aFont constrainedToSize:segmentRect.size lineBreakMode:lineBreak];
        CGRect titleRect = CGRectInset(segmentRect, (segmentRect.size.width-titleSize.width)/2, (segmentRect.size.height-titleSize.height)/2);

        [aTitle drawInRect:titleRect withFont:aFont lineBreakMode:lineBreak alignment:NSTextAlignmentCenter];
    }
}

#pragma mark - Action
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    int segmentIndex = [self segmentIndexWithTouch:touch];
    if (segmentIndex >= 0 && self.clickHandler) {
        self.selectedSegmentIndex = segmentIndex;
        [self setNeedsDisplay];
        
        self.clickHandler(self, segmentIndex);
    }
}

#pragma mark - Functions
- (CGRect)segmentRectWithValidRect:(CGRect)aRect index:(int)index {
    CGFloat segmentWidth = aRect.size.width/(CGFloat)self.segmentTitles.count;
    return CGRectMake(index*segmentWidth+self.scaleFactor.dx, self.scaleFactor.dy, segmentWidth, aRect.size.height);
}

- (int)segmentIndexWithTouch:(UITouch *)aTouch {
    int index = -1;
    
    CGPoint location = [aTouch locationInView:self];
    
    if ([self isValidTouch:aTouch]) {
        CGRect validRect = CGRectInset(self.bounds, self.scaleFactor.dx, self.scaleFactor.dy);
        CGFloat segmentWidth = validRect.size.width/(CGFloat)self.segmentTitles.count;
        index =   location.x / segmentWidth;
    }
    
    return index;
}

/**
 *  @brief  验证Touch是否有效(在self.bounds范围内)
 *
 *  @param aTouch Touch对象
 *
 *  @return YES:有效 NO:无效
 */
- (BOOL)isValidTouch:(UITouch *)aTouch {
    CGPoint location = [aTouch locationInView:self];
    
    BOOL valid = NO;
    if (location.x >= 0 && location.x <= self.bounds.size.width && location.y >= 0 && location.y <= self.bounds.size.height) {
        valid = YES;
    }
    
    return valid;
}

@end