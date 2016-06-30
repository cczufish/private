//
//  HWFRouterListCell.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFRouterListCell.h"

#import "HWFTool.h"

@interface HWFRouterListCell ()

@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@end

@implementation HWFRouterListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(HWFRouter *)aRouter {
    self.router = aRouter;
    
    UIColor *normalBackgroundColor;
    UIColor *highlightedBackgroundColor;
    
    NSMutableAttributedString *normalTitleButtonText = [[NSMutableAttributedString alloc] initWithString:aRouter.name attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0] }];
    [normalTitleButtonText appendAttributedString:[[NSAttributedString alloc] initWithString:(aRouter.isOnline ? @"" : @" 离线") attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.0] }]];
    
    NSMutableAttributedString *highlightedTitleButtonText = [[NSMutableAttributedString alloc] initWithString:aRouter.name attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0] }];
    [highlightedTitleButtonText appendAttributedString:[[NSAttributedString alloc] initWithString:(aRouter.isOnline ? @"" : @" 离线") attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.0] }]];
    
    if (aRouter.RID == [[HWFRouter defaultRouter] RID]) {
        normalBackgroundColor = [UIColor HWFBlueColor];
        highlightedBackgroundColor = COLOR_HEX(0xD6DEE3);
        
        [normalTitleButtonText addAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor] } range:NSMakeRange(0, normalTitleButtonText.length)];
        [highlightedTitleButtonText addAttributes:@{ NSForegroundColorAttributeName:[UIColor HWFGrayFontColor] } range:NSMakeRange(0, highlightedTitleButtonText.length)];
    } else {
        normalBackgroundColor = COLOR_HEX(0xD6DEE3);
        highlightedBackgroundColor = [UIColor HWFBlueColor];
        
        [normalTitleButtonText addAttributes:@{ NSForegroundColorAttributeName:[UIColor HWFGrayFontColor] } range:NSMakeRange(0, normalTitleButtonText.length)];
        [highlightedTitleButtonText addAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor] } range:NSMakeRange(0, highlightedTitleButtonText.length)];
    }
    
    [self.titleButton setAttributedTitle:normalTitleButtonText forState:UIControlStateNormal];
    [self.titleButton setAttributedTitle:highlightedTitleButtonText forState:UIControlStateHighlighted];
    [self.titleButton setBackgroundImage:[HWFTool imageWithColor:normalBackgroundColor] forState:UIControlStateNormal];
    [self.titleButton setBackgroundImage:[HWFTool imageWithColor:highlightedBackgroundColor] forState:UIControlStateHighlighted];
}

- (IBAction)onButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickRouterListCell:)]) {
        [self.delegate performSelector:@selector(clickRouterListCell:) withObject:self];
    }
}

@end
