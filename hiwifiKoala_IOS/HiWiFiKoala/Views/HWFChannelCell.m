//
//  HWFChannelCell.m
//  HiWiFiKoala
//
//  Created by chang hong on 14-11-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFChannelCell.h"
#import "UIViewExt.h"

@interface HWFChannelCell()


@property (weak, nonatomic) IBOutlet UIView *grayBackgroundMaskButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *histogram;
@property (weak, nonatomic) IBOutlet UIView *touchControl;
@property (weak, nonatomic) IBOutlet UIImageView *selectButton;
@property(nonatomic,assign) float acceptLength;
- (IBAction)buttonTouchDown:(id)sender;
- (IBAction)buttonTouchUpInside:(id)sender;
- (IBAction)buttonTouchDragExit:(id)sender;

@end

@implementation HWFChannelCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.grayBackgroundMaskButton.hidden = YES;
    self.selectButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected) {
        self.grayBackgroundMaskButton.hidden = NO;
        self.selectButton.hidden = NO;
    }else {
        self.grayBackgroundMaskButton.hidden = YES;
        self.selectButton.hidden = YES;
    }
    // Configure the view for the selected state
}

- (IBAction)buttonTouchDown:(id)sender {
    if([self.delegate respondsToSelector:@selector(didTouchDown:)]){
        [self.delegate didTouchDown:self];
    }
}

- (IBAction)buttonTouchUpInside:(id)sender {
    if([self.delegate respondsToSelector:@selector(didSelectRow:)]){
        [self.delegate didSelectRow:self];
    }
}

- (IBAction)buttonTouchDragExit:(id)sender {
    if([self.delegate respondsToSelector:@selector(didTouchDragExit:)]){
        [self.delegate didTouchDragExit:self];
    }
}

- (void)setIndex:(NSString *)index value:(float)value {
    self.title.text = index;
    self.acceptLength = value;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [UIView animateWithDuration:0.35 animations:^{
        self.histogram.width = self.acceptLength * self.bgView.width;
    } completion:^(BOOL finished) {
        
    }];
}
@end
