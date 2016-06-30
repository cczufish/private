//
//  HWFDiskManagerCell.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDiskManagerCell.h"

@interface HWFDiskManagerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HWFDiskManagerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataWithInfo:(NSString *)string {
    self.titleLabel.text = string;
    //因为只有格式化，无清缓存
    self.imgView.image = [UIImage imageNamed:@"format"];
}

@end
