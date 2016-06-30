//
//  HWFRenameView.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-31.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFRenameView.h"

@interface HWFRenameView ()


@end

@implementation HWFRenameView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

+(id)sharedInstance {
    return [[[NSBundle mainBundle]loadNibNamed:@"HWFRenameView" owner:self options:nil]lastObject];
}

- (IBAction)cancleAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(renameViewCancleAction)]) {
        [self.delegate performSelector:@selector(renameViewCancleAction) withObject:self];
    }
}


- (IBAction)doRename:(id)sender {
    if ([self.delegate respondsToSelector:@selector(renameViewRenameAction)]) {
        [self.delegate performSelector:@selector(renameViewRenameAction) withObject:self];
    }
}

@end
