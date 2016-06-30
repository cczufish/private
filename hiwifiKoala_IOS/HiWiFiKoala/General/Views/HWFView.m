//
//  HWFBaseView.m
//  HiWiFi
//
//  Created by dp on 14-3-5.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import "HWFView.h"

@implementation HWFView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIViewController *)viewController {
    id next =[self nextResponder];
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return next;
        }
        next = [next nextResponder];
    }
    return nil;
}

@end
