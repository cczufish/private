//
//  HWFControlBarButton.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFControlBarButton.h"

#define kControlBarButtonSize CGSizeMake(55.0, 80.0)

#define kInfoFont [UIFont systemFontOfSize:10.0]
#define kInfoViewHeight 28.0
#define kInfoFrame CGRectMake(0, 0, kControlBarButtonSize.width, kInfoViewHeight)
#define kInfoGap 2.0

#define kImageSize CGSizeMake(30.0, 30.0)
#define kImageFrame CGRectMake((kControlBarButtonSize.width - kImageSize.width) / 2, kInfoViewHeight + kImageVerticalGap, kImageSize.width, kImageSize.height)
#define kImageVerticalGap (kControlBarButtonSize.height - kInfoViewHeight - kImageSize.height - kTitleViewHeight) / 2

#define kTitleFont [UIFont systemFontOfSize:12.0]
#define kTitleViewHeight 14.0
#define kTitleFrame CGRectMake(0, kInfoViewHeight + kImageSize.height + kImageVerticalGap * 2, kControlBarButtonSize.width, kTitleViewHeight)

#define kInfoColor [UIColor whiteColor]
#define kFontColorNormal COLOR_HEX(0x4F5F6F)
#define kFontColorActive COLOR_HEX(0x23AFFB)


@implementation HWFControlBarButton

#pragma mark - Initialization
- (void)awakeFromNib {
    self.contentMode = UIViewContentModeRedraw;
    
    self.bounds = CGRectMake(0, 0, kControlBarButtonSize.width, kControlBarButtonSize.height);
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

- (void)setActiveImage:(UIImage *)activeImage {
    if (_activeImage != activeImage) {
        _activeImage = activeImage;
        
        [self setNeedsDisplay];
    }
}

- (void)setInfo:(NSString *)info {
    if (_info != info) {
        _info = info;
        
        [self setNeedsDisplay];
    }
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    [self drawInfo:self.info font:kInfoFont rect:kInfoFrame];
    
    if (self.info && !IS_STRING_EMPTY(self.info)) {
        CGSize infoFontSize = [self.info sizeWithFont:kInfoFont constrainedToSize:kInfoFrame.size lineBreakMode:NSLineBreakByCharWrapping];
        CGRect infoBorderRect = CGRectInset(kInfoFrame, (kInfoFrame.size.width-infoFontSize.width)/3 - kInfoGap, (kInfoFrame.size.height-infoFontSize.height)/3);
        infoBorderRect.origin.y -= (kInfoFrame.size.height-infoFontSize.height)/3 - kInfoGap;
        
        [self drawBorderWithRect:infoBorderRect cornerRadius:infoBorderRect.size.height/2 lineWidth:1.0];
    }
    
    [self drawTitle:self.title font:kTitleFont rect:kTitleFrame];

    if (self.state == UIControlStateHighlighted && self.activeImage) {
        [self drawImage:self.activeImage rect:kImageFrame];
    } else {
        [self drawImage:self.image rect:kImageFrame];
    }
}

- (void)drawInfo:(NSString *)info font:(UIFont *)aFont rect:(CGRect)aRect {
    aRect.origin.y += kInfoGap * 2;
    NSLineBreakMode lineBreak = NSLineBreakByCharWrapping;
    [kInfoColor setFill];
    [info drawInRect:aRect withFont:aFont lineBreakMode:lineBreak alignment:NSTextAlignmentCenter];
}

- (void)drawBorderWithRect:(CGRect)aRect cornerRadius:(CGFloat)aCornerRadius lineWidth:(CGFloat)aLineWidth {
    [kInfoColor setStroke];
    UIBezierPath *border = [UIBezierPath bezierPathWithRoundedRect:aRect cornerRadius:aCornerRadius];
    border.lineWidth = aLineWidth;
    [border stroke];
}

- (void)drawImage:(UIImage *)anImage rect:(CGRect)aRect {
    if (anImage) {
        [anImage drawInRect:aRect];
    }
}

- (void)drawTitle:(NSString *)aTitle font:(UIFont *)aFont rect:(CGRect)aRect {
    NSLineBreakMode lineBreak = NSLineBreakByCharWrapping;
    
    UIColor *titleColor;
    if (self.state == UIControlStateHighlighted) {
        titleColor = kFontColorActive;
    } else {
        titleColor = kFontColorNormal;
    }
    [titleColor setFill];
    
    [aTitle drawInRect:aRect withFont:aFont lineBreakMode:lineBreak alignment:NSTextAlignmentCenter];
}

#pragma mark - Action
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setNeedsDisplay];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setNeedsDisplay];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setNeedsDisplay];

    if ([self isValidTouch:touch]) {
        if (self.clickHandler) {
            self.clickHandler(self);
        }
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self setNeedsDisplay];
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
