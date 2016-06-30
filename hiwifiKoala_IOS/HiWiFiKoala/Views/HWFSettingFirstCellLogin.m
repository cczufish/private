//
//  HWFSettingFirstCell.m
//  HiWiFiKoala
//
//  Created by chang hong on 14-10-9.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFSettingFirstCellLogin.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HWFSettingFirstCellLogin()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *manageButton;
- (IBAction)doManage:(id)sender;
@end

@implementation HWFSettingFirstCellLogin

- (void)loadData:(HWFUser *)user {
    
    //self.userImage.image;
    self.userNameLabel.text = user.username;
    [self.manageButton setTitle:@"账号管理>" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"user"];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:image];
}

- (void)awakeFromNib {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 2;
    self.userImage.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
    self.userImage.layer.cornerRadius = self.userImage.bounds.size.height / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)doManage:(id)sender {
    if([self.delegate respondsToSelector:@selector(manageButtonClick)]){
        [self.delegate manageButtonClick];
    }
}
@end
