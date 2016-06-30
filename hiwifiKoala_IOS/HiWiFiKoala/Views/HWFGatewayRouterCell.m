//
//  HWFGatewayRouterCell.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFGatewayRouterCell.h"

@interface HWFGatewayRouterCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation HWFGatewayRouterCell

- (void)awakeFromNib {
    UIView *view = [[UIView alloc]initWithFrame:self.contentView.bounds];
    view.backgroundColor = COLOR_HEX(0xe0e8ed);
    self.selectedBackgroundView = view;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)loadDataWithInfo:(NSString *)infoStr {
#warning -----图片名字
    self.infoLabel.text = infoStr;
    if ([infoStr isEqualToString:@"重启路由器"]) {
        self.infoLabel.textColor = COLOR_HEX(0xff0000);
        self.imageView.image = [UIImage imageNamed:@"restart"];
        
    } else if ([infoStr isEqualToString:@"修改管理员密码"]) {
        self.imageView.image = [UIImage imageNamed:@"lock"];
        ;
    } else if ([infoStr isEqualToString:@"解除路由器绑定"]) {
        self.imageView.image = [UIImage imageNamed:@"unbind"];
        
    } else if ([infoStr isEqualToString:@"恢复出厂设置"]) {
        self.imageView.image = [UIImage imageNamed:@"reset"];
    }
}

@end
