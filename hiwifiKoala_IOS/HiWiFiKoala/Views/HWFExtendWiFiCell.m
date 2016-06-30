//
//  HWFExtendWiFiCell.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-27.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFExtendWiFiCell.h"

@interface HWFExtendWiFiCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
@implementation HWFExtendWiFiCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)reloadWithStr:(NSString *)str {
    self.titleLabel.text = str;
    self.imgView.backgroundColor = [UIColor blueColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
