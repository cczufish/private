//
//  HWFDeviceDetailCell.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-13.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDeviceDetailCell.h"

@interface HWFDeviceDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *myTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation HWFDeviceDetailCell

- (void)awakeFromNib {
    UIView *view = [[UIView alloc]initWithFrame:self.contentView.bounds];
    view.backgroundColor = COLOR_HEX(0xe0e8ed);
    self.selectedBackgroundView = view;
}

- (void)loadDateWithString:(NSString *)str {
    self.myTextLabel.text = str;
    if ([str isEqualToString:@"解除路由器绑定"]) {
        self.imgView.image = [UIImage imageNamed:@"unbind"];
    } else if ([str isEqualToString:@"修改设备名"]) {
        self.imgView.image = [UIImage imageNamed:@"edit"];
    }else if ([str isEqualToString:@"加入黑名单"]) {
        self.imgView.image = [UIImage imageNamed:@"black-list"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
