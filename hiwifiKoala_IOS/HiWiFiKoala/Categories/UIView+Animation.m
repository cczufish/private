//
//  UIView+Animation.m
//  HiWiFiKoala
//
//  Created by dp on 14/11/12.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "UIView+Animation.h"

#define kAnimationDurationFadeIn 0.2
#define kAnimationDurationFadeOut 0.2

@implementation UIView (Animation)

- (void)fadeIn {
    // Show
    self.hidden = NO;
    POPBasicAnimation *showAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    showAnimation.fromValue = @(0.0);
    showAnimation.toValue = @(1.0);
    showAnimation.beginTime = CACurrentMediaTime();
    showAnimation.duration = kAnimationDurationFadeIn;
    showAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    showAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    [self pop_addAnimation:showAnimation forKey:@"showAnimation"];
}

- (void)fadeOut {
    POPBasicAnimation *hideAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    hideAnimation.fromValue = @(1.0);
    hideAnimation.toValue = @(0.0);
    hideAnimation.beginTime = CACurrentMediaTime();
    hideAnimation.duration = kAnimationDurationFadeOut;
    hideAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    hideAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    };
    [self pop_addAnimation:hideAnimation forKey:@"hideAnimation"];
}

@end
