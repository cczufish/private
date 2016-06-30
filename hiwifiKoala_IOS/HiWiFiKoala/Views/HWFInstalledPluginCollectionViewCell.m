//
//  HWFInstalledPluginCollectionViewCell.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFInstalledPluginCollectionViewCell.h"

#import "HWFPlugin.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface HWFInstalledPluginCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ICONImageView;
@property (weak, nonatomic) IBOutlet UILabel *pluginNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;


@end

@implementation HWFInstalledPluginCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)loadData:(HWFPlugin *)plugin indexPath:(NSIndexPath *)indexPath {
    self.plugin = plugin;
    self.indexPath = indexPath;
    
    if (plugin.SID == kBlankPluginSID) { // 空白
        self.ICONImageView.hidden = YES;
        self.pluginNameLabel.hidden = YES;
    } else {
        self.ICONImageView.hidden = NO;
        self.pluginNameLabel.hidden = NO;
    }
    
    if (plugin.SID == kInstallPluginSID) { // 插件安装
        self.ICONImageView.image = [UIImage imageNamed:@"add"];
    } else if (plugin.SID == kBlankPluginSID) { // 空白
        self.ICONImageView.image = nil;
    } else {
        [self.ICONImageView sd_setImageWithURL:[NSURL URLWithString:plugin.ICON] placeholderImage:nil];
    }
    self.pluginNameLabel.text = plugin.name ?: @"";
    
    // Status Message
    [self.statusButton setBackgroundImage:[[UIImage imageNamed:@"app-tip"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:8.0] forState:UIControlStateNormal];
    [self.statusButton setBackgroundImage:[[UIImage imageNamed:@"app-tip"] stretchableImageWithLeftCapWidth:8.0 topCapHeight:8.0] forState:UIControlStateHighlighted];
    if (plugin.statusMessage && !IS_STRING_EMPTY(plugin.statusMessage)) {
        self.statusButton.hidden = NO;
    } else {
        self.statusButton.hidden = YES;
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    CGFloat gap = 20.0;
    if (self.indexPath && self.indexPath.row%2==0) {
        [linePath moveToPoint:CGPointMake(gap, self.bounds.size.height)];
        [linePath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
        
        [linePath moveToPoint:CGPointMake(self.bounds.size.width, 0)];
        [linePath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    } else {
        [linePath moveToPoint:CGPointMake(0, self.bounds.size.height)];
        [linePath addLineToPoint:CGPointMake(self.bounds.size.width-gap, self.bounds.size.height)];
    }
    
    [[UIColor colorWithWhite:0.800 alpha:1.000] setStroke];
    [linePath stroke];
}

@end
