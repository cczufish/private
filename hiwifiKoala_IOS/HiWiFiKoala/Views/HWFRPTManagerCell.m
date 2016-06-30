//
//  HWFRPTManagerCell.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-22.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFRPTManagerCell.h"

@interface HWFRPTManagerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *rptImgView;
@property (weak, nonatomic) IBOutlet UILabel *bindRPTLabel;

@end

@implementation HWFRPTManagerCell



- (void)reloadWithString:(NSString *)str {
    self.bindRPTLabel.text = str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
