//
//  HWFAppliedPluginTableViewCell.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFAppliedPluginTableViewCell.h"

#import "HWFPlugin.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface HWFAppliedPluginTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ICONImageView;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UIImageView *isInstalledImageView;

@end

@implementation HWFAppliedPluginTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(HWFPlugin *)plugin {
    self.plugin = plugin;
    
    self.titleLabel.text = (plugin.name && [plugin.name isKindOfClass:[NSString class]]) ? plugin.name : @"";
    //TODO:
    self.infoLabel.text = (plugin.info && [plugin.info isKindOfClass:[NSString class]]) ? plugin.info : @"";
    
    if (plugin.ICON && [plugin.ICON isKindOfClass:[NSString class]] && !IS_STRING_EMPTY(plugin.ICON)) {
        [self.ICONImageView sd_setImageWithURL:[NSURL URLWithString:plugin.ICON] placeholderImage:nil];
    } else {
        //TODO: 默认ICON
    }
    
    // Status Message
    [self.statusButton setBackgroundImage:[[UIImage imageNamed:@"app-tip"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:8.0] forState:UIControlStateNormal];
    [self.statusButton setBackgroundImage:[[UIImage imageNamed:@"app-tip"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:8.0] forState:UIControlStateHighlighted];
    if (plugin.statusMessage && !IS_STRING_EMPTY(plugin.statusMessage)) {
        self.statusButton.hidden = NO;
    } else {
        self.statusButton.hidden = YES;
    }

    self.isInstalledImageView.hidden = !plugin.hasInstalled;
}

@end
