//
//  HWFBadgeView.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/31.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFBadgeView.h"

@implementation HWFBadgeView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setBadgeValue:(NSString *)badgeValue {
    if (![_badgeValue isEqualToString:badgeValue]) {
        _badgeValue = badgeValue;
        
        [self setNeedsDisplay];
    }
}

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    if (_badgeBackgroundColor != badgeBackgroundColor) {
        _badgeBackgroundColor = badgeBackgroundColor;
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGRect titleRect = self.bounds;
    
    if (self.badgeValue && !IS_STRING_EMPTY(self.badgeValue)) {
        titleRect = [self drawTitle:self.badgeValue font:[UIFont systemFontOfSize:12.0] rect:titleRect];
    }
    
    [self drawBackgroundWithRect:titleRect cornerRadius:titleRect.size.height*0.5];
}

- (CGRect)drawTitle:(NSString *)aTitle font:(UIFont *)aFont rect:(CGRect)aRect {
    NSLineBreakMode lineBreak = NSLineBreakByCharWrapping;
    CGSize titleSize = [aTitle sizeWithFont:aFont constrainedToSize:aRect.size lineBreakMode:lineBreak];
    CGRect titleRect = CGRectInset(aRect, (aRect.size.width-titleSize.width)/2, (aRect.size.height-titleSize.height)/2);
    if (self.badgeBackgroundColor) {
        [[self badgeForegroundColor] setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    [aTitle drawInRect:titleRect withFont:aFont lineBreakMode:lineBreak alignment:NSTextAlignmentCenter];
    
    return titleRect;
}

- (void)drawBackgroundWithRect:(CGRect)aRect cornerRadius:(CGFloat)aCornerRadius {
    if (self.badgeBackgroundColor) {
        [[self badgeBackgroundColor] setFill];
    } else {
        [[UIColor redColor] setFill];
    }
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:aRect cornerRadius:aCornerRadius];
    [rectPath fill];
}

@end
