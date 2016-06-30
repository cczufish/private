//
//  HWFButton.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-18.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFButton.h"

#import <pop/POP.h>

@interface HWFButton ()

@end

@implementation HWFButton

#pragma mark - Initialization
- (void)awakeFromNib {
//    self.backgroundColor = nil;
//    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    
    self.scaleFactor = CGVectorMake(0.0, 0.0);
    
    [self showAppearAnimation];
}

#pragma mark - Animation
- (void)showAppearAnimation {
    CGSize size = self.bounds.size;
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    animation.fromValue = [NSValue valueWithCGSize:CGSizeMake(size.width/2, size.height/2)];
    animation.toValue = [NSValue valueWithCGSize:size];
    animation.springBounciness = 14.0;
    animation.springSpeed = 10.0;
    [self.layer pop_addAnimation:animation forKey:@"appear_animation"];
}

#pragma mark - Properties
- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        
        [self setNeedsDisplay];
    }
}

- (void)setImage:(UIImage *)image {
    if (_image != image) {
        _image = image;
        
        [self setNeedsDisplay];
    }
}

- (void)setScaleFactor:(CGVector)scaleFactor {
    if (_scaleFactor.dx != scaleFactor.dx && _scaleFactor.dy != scaleFactor.dy) {
        _scaleFactor = scaleFactor;
        
        [self setNeedsDisplay];
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    if (_titleFont != titleFont) {
        _titleFont = titleFont;
        
        [self setNeedsDisplay];
    }
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    CGRect validRect = CGRectInset(self.bounds, self.scaleFactor.dx, self.scaleFactor.dy);
    
    [self drawTitle:self.title font:self.titleFont rect:validRect];
    
    //TODO: cornerRadius
    [self drawBorderWithRect:validRect cornerRadius:3.0 lineWidth:1.0];
    
    [self drawImage:self.image rect:validRect];
}

- (void)drawBorderWithRect:(CGRect)aRect cornerRadius:(CGFloat)aCornerRadius lineWidth:(CGFloat)aLineWidth {
    [[self tintColor] setStroke];
    UIBezierPath *border = [UIBezierPath bezierPathWithRoundedRect:aRect cornerRadius:aCornerRadius];
    border.lineWidth = aLineWidth;
    [border stroke];
}

- (void)drawTitle:(NSString *)aTitle font:(UIFont *)aFont rect:(CGRect)aRect {
    NSLineBreakMode lineBreak = NSLineBreakByCharWrapping;
    CGSize titleSize = [aTitle sizeWithFont:aFont constrainedToSize:aRect.size lineBreakMode:lineBreak];
    CGRect titleRect = CGRectInset(aRect, (aRect.size.width-titleSize.width)/2, (aRect.size.height-titleSize.height)/2);
    [[self tintColor] setFill];
    [aTitle drawInRect:titleRect withFont:aFont lineBreakMode:lineBreak alignment:NSTextAlignmentCenter];
}

- (void)drawImage:(UIImage *)anImage rect:(CGRect)aRect {
    if (anImage) {
        [anImage drawInRect:aRect];
    }
}

#pragma mark - Action
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if ([self isValidTouch:touch]) {
        if (self.clickHandler) {
            self.clickHandler(self);
        }
    }
}

/**
 *  @brief  验证Touch是否有效(在Button范围内)
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
