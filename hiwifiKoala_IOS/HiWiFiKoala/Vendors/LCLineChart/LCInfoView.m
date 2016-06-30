//
//  LCInfoView.m
//  Classes
//
//  Created by Marcel Ruegenberg on 19.11.09.
//  Copyright 2009 Dustlab. All rights reserved.
//

#import "LCInfoView.h"
#import "UIKit+DrawingHelpers.h"
#import "UIViewExt.h"


@interface LCInfoView ()

- (void)recalculateFrame;

@end


@implementation LCInfoView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {		
        UIFont *fatFont = [UIFont systemFontOfSize:8];
        
        self.infoLabel = [[UILabel alloc] init];
        self.infoLabel.font = fatFont;
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.textColor = COLOR_HEX(0x2ECDA5);
        self.infoLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
//        self.infoLabel.shadowColor = [UIColor blackColor];
//        self.infoLabel.shadowOffset = CGSizeMake(0, -1);
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.infoLabel];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)init {
	if((self = [self initWithFrame:CGRectZero])) {
		;
	}
	return self;
}

#define TOP_BOTTOM_MARGIN 0
#define LEFT_RIGHT_MARGIN 0
#define SHADOWSIZE 3
#define SHADOWBLUR 0
#define HOOK_SIZE 2

void CGContextAddRoundedRectWithHookSimple(CGContextRef c, CGRect rect, CGFloat radius, LCInfoView *lcInfoView) {
	//eventRect must be relative to rect.
	CGFloat hookSize = HOOK_SIZE;

    CGFloat offsetX = (lcInfoView.tapPoint.x-144.0)/144.0 * (rect.size.width*1/3);
    CGFloat viewOffsetX = (lcInfoView.tapPoint.x-144.0)/144.0 * (rect.size.width*1/6);
    lcInfoView.left = lcInfoView.left - viewOffsetX;
    
    CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + radius, radius, M_PI, M_PI * 1.5, 0); //upper left corner
    CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, M_PI * 1.5, M_PI * 2, 0); //upper right corner
    CGContextAddArc(c, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI * 2, M_PI * 0.5, 0);
    
    CGContextAddLineToPoint(c, rect.origin.x + rect.size.width / 2 + hookSize + offsetX, rect.origin.y + rect.size.height);
    CGContextAddLineToPoint(c, rect.origin.x + rect.size.width / 2 + offsetX, rect.origin.y + rect.size.height + hookSize*2);
    CGContextAddLineToPoint(c, rect.origin.x + rect.size.width / 2 - hookSize + offsetX, rect.origin.y + rect.size.height);
    
    CGContextAddArc(c, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI * 0.5, M_PI, 0);
    CGContextAddLineToPoint(c, rect.origin.x, rect.origin.y + radius);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self sizeToFit];
    
    [self recalculateFrame];
    
    if (self.left < 0) {
        self.left = 0;
    }
    
    if (self.right > SCREEN_WIDTH) {
        self.right = SCREEN_WIDTH;
    }
    
    [self.infoLabel sizeToFit];
    self.infoLabel.frame = CGRectMake(self.bounds.origin.x + SHADOWSIZE +2, self.bounds.origin.y + 2 + SHADOWSIZE +1, self.infoLabel.frame.size.width, self.infoLabel.frame.size.height);
    
//    __DLogRect(self.infoLabel.frame);
}

- (CGSize)sizeThatFits:(CGSize)size {
    // TODO: replace with new text APIs in iOS 7 only version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize s = [self.infoLabel.text sizeWithFont:self.infoLabel.font];
#pragma clang diagnostic pop
    s.height += 15;
    s.height += SHADOWSIZE;
    
    s.width += 2 * SHADOWSIZE + 7;
    s.width = MAX(s.width, HOOK_SIZE * 2 + 2 * SHADOWSIZE + 10);
    
    return s;
}

- (void)drawRect:(CGRect)rect {
//	CGContextRef c = UIGraphicsGetCurrentContext();
//
//	CGRect theRect = self.bounds;
//	//passe x oder y Position sowie Hoehe oder Breite an, je nachdem, wo der Hook sitzt.
//	theRect.size.height -= SHADOWSIZE * 2;
//    theRect.size.width -= SHADOWSIZE * 2;
//	theRect.origin.x += SHADOWSIZE;
//    theRect.origin.y += SHADOWSIZE;
//	theRect.size.width -= SHADOWSIZE * 2;
//    theRect.size.height -= SHADOWSIZE * 2;
//	
//    theRect.size.width += 4;
//    theRect.origin.x += 2;
//    
//    [__COLOR_RGBA(213, 245, 237, 1) set];
//	CGContextSetAlpha(c, 1.0);
//	CGContextSaveGState(c);
//	
////    CGContextSetShadow(c, CGSizeMake(0.0, SHADOWSIZE), SHADOWBLUR);
//	
//	CGContextBeginPath(c);
//    CGContextAddRoundedRectWithHookSimple(c, theRect, 8, self);
//    CGContextSetLineWidth(c, 1.0);
//    CGContextStrokePath(c);
//    
//    [[UIColor whiteColor] set];
//    CGContextBeginPath(c);
//    CGContextAddRoundedRectWithHookSimple(c, theRect, 8, self);
//    CGContextSetAlpha(c, 1.0);
//	CGContextFillPath(c);
	
//    [[UIColor whiteColor] set];
//	CGContextSetAlpha(c, 1.0);
//    CGContextFillRoundedRect(c, theRect, 10);
}



#define MAX_WIDTH 100
// calculate own frame to fit within parent frame and be large enough to hold the event.
- (void)recalculateFrame {
    CGRect theFrame = self.frame;
    theFrame.size.width = MIN(MAX_WIDTH, theFrame.size.width);
    
    CGRect theRect = self.frame; theRect.origin = CGPointZero;

    {
        theFrame.origin.y = self.tapPoint.y - theFrame.size.height + 2 * SHADOWSIZE + 1;
        theFrame.origin.x = round(self.tapPoint.x - ((theFrame.size.width - 2 * SHADOWSIZE)) / 2.0);
    }
    
    self.frame = theFrame;
}

@end
