//
//  HWFLocationCell.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFLocationCell.h"

@interface HWFLocationCell ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
@implementation HWFLocationCell

- (void)awakeFromNib {
    UIView *view = [[UIView alloc]initWithFrame:self.contentView.bounds];
    view.backgroundColor = COLOR_HEX(0xe0e8ed);
    self.selectedBackgroundView = view;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadUIWithData:(NSString *)string {
    self.locationLabel.text = string;
    self.imgView.image = [UIImage imageNamed:@"check"];
}

@end
