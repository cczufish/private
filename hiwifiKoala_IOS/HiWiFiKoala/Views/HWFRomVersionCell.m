//
//  HWFRomVersionCell.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFRomVersionCell.h"

@interface HWFRomVersionCell ()
@property (weak, nonatomic) IBOutlet UILabel *romVersionInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *romImgView;

@end

@implementation HWFRomVersionCell

- (void)awakeFromNib {
    UIView *view = [[UIView alloc]initWithFrame:self.contentView.bounds];
    view.backgroundColor = COLOR_HEX(0xe0e8ed);
    self.selectedBackgroundView = view;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)reloadWithString:(NSString *)infoStr {
    
    self.romVersionInfoLabel.textColor = COLOR_HEX(0x30B0F8);
    self.romVersionInfoLabel.font = [UIFont systemFontOfSize:16.0];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:infoStr];
    [attString setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:16.0]} range:NSMakeRange(0, 10)];
    self.romVersionInfoLabel.attributedText = attString;
    self.romImgView.image = [UIImage imageNamed:@"alert"];
}

@end
