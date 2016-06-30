//
//  HWFBlackListCell.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-14.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFBlackListCell.h"

@interface HWFBlackListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;

@end
@implementation HWFBlackListCell

- (void)awakeFromNib {
    
    self.nameLabel.textColor = COLOR_HEX(0x30b0f8);
    self.macLabel.textColor = COLOR_HEX(0x999999);
    
}

- (void)loadDataWith:(HWFBlackListModel *)model {
    if ([model.name isEqualToString:@""]) {
        self.nameLabel.text = @"未知";
    } else {
        self.nameLabel.text = model.name;
    }
    self.macLabel.text = model.MAC;
    if (model.selectType == HWFSelectType_None) {
        self.selectImgView.image = [UIImage imageNamed:@"btn-3"];
    } else {
        self.selectImgView.image = [UIImage imageNamed:@"btn-green"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
