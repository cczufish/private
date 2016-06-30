//
//  HWFSettingFirstCellNotLogin.m
//  HiWiFiKoala
//
//  Created by chang hong on 14-10-9.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFSettingFirstCellNotLogin.h"

@interface HWFSettingFirstCellNotLogin()

@property (weak, nonatomic) IBOutlet UILabel *notLoginLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)doLogin:(id)sender;
@end

@implementation HWFSettingFirstCellNotLogin

- (void)loadData:(NSDictionary *)dict {
    self.notLoginLabel.text = @"未登录";
    [self.loginButton setTitle:@"点击登录" forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)doLogin:(id)sender {
    if([self.delegate respondsToSelector:@selector(loginButtonClick)]){
        [self.delegate loginButtonClick];
    }
}
@end
