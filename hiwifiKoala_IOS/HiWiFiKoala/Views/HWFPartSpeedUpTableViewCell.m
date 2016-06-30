//
//  HWFPartSpeedUpTableViewCell.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFPartSpeedUpTableViewCell.h"
#import "XMGradientProgressView.h"
#import "HWFSpeedUpAnimationView.h"
#define TAG_BASESINGLESPEEDUP_CELL 400

@interface HWFPartSpeedUpTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *speedStatusView;
@property (weak, nonatomic) IBOutlet UIButton *speedUpButton;
@property (weak, nonatomic) IBOutlet UIView *speedUpAnimationView;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIView *speedUpTimeView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeOverLabel;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *standbyNameLabel;

@property (nonatomic,strong) XMGradientProgressView *gradientProgressView;
@property (nonatomic,strong) NSArray *colorArray;
@property (nonatomic,assign) CGFloat progress;


@end

@implementation HWFPartSpeedUpTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self initData];
}

- (void)initData {
    _colorArray = @[@[@(63), @(110), @(228)], @[@(234), @(40), @(26)]];
}

//加速
- (IBAction)doPartSpeedUp:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(doSpeedUpWithPartSpeedUpCell:)]) {
        [self.delegate performSelector:@selector(doSpeedUpWithPartSpeedUpCell:) withObject:self];
    }
}

- (void)pauseGradientPrgressViewAnimation
{
    [_gradientProgressView resetProgress];
}

//暂停
- (IBAction)partSpeedUpPause:(UIButton *)sender {
    [self pauseGradientPrgressViewAnimation];
    if ([self.delegate respondsToSelector:@selector(pauseWithPartSpeedUpCell:)]) {
        [self.delegate performSelector:@selector(pauseWithPartSpeedUpCell:) withObject:self];
    }
}

- (void)reloadCellWithSingleSpeedUpItem:(HWFPartSpeedUpItem *)partSpeedUpItem {
    NSLog(@"hhhhhhhhhh----hhhhhhhhhh%@",partSpeedUpItem);
    NSInteger timeOver = partSpeedUpItem.timeOver;
    if (partSpeedUpItem.status == 1) {
        timeOver = (int)partSpeedUpItem.finishTimeInterval - (int)[[NSDate date]timeIntervalSince1970];
    }
    if (timeOver <= 0) {
        timeOver = 0;
        partSpeedUpItem.status = 0;
    }
//    self.nameLabel.text = partSpeedUpItem.name;
//    self.standbyNameLabel.text = partSpeedUpItem.name;
    self.nameLabel.text = [partSpeedUpItem displayName];
    self.standbyNameLabel.text = [partSpeedUpItem displayName];
    [self updateTimeOverLabelWithTimeOver:timeOver];
    self.iconImageView.image = nil;
    self.iconImageView.backgroundColor = [UIColor greenColor];
    
    CGFloat animationDuration = timeOver;
    CGFloat progress = 1.0f - [@(timeOver) floatValue] / [@(partSpeedUpItem.timeTotal) floatValue];
    if (!_gradientProgressView) {
        _gradientProgressView = [[XMGradientProgressView alloc] initWithFrame:self.speedUpTimeView.bounds backColor:COLOR_HEX(0x424242) tintColors:_colorArray borderWidth:0.0f lineWidth:self.speedUpTimeView.frame.size.height animationDuration:animationDuration];
        [self.speedUpTimeView addSubview:_gradientProgressView];
    }
    _gradientProgressView.animationDuration = animationDuration;
    [_gradientProgressView setProgress:progress animated:NO];
    
    if (partSpeedUpItem.status == 1) {//加速中
        [self.standbyNameLabel setHidden:YES];
        [self.coverView setHidden:YES];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.timeOverLabel setBackgroundColor:[UIColor clearColor]];
        [self.speedUpAnimationView setHidden:NO];
        [self.pauseButton setHidden:NO];
        [self.speedUpButton setHidden:YES];
        
        if (self.speedUpAnimationView.subviews.count > 0) {
            for (UIView *subView in self.speedUpAnimationView.subviews) {
                [subView removeFromSuperview];
            }
        }
#warning -----加速动画－－－－－
        HWFSpeedUpAnimationView *speedUpAnimation = [[HWFSpeedUpAnimationView alloc] initWithFrame:CGRectMake(0, 0, 22, 37)];
        speedUpAnimation.backgroundColor = [UIColor redColor];
        speedUpAnimation.center = self.speedUpAnimationView.center;
        [self.speedUpAnimationView addSubview:speedUpAnimation];
        
        __weak typeof(self) weakSelf = self;
        [_gradientProgressView setProgress:1.0f animated:YES progressBlock:^(CGFloat aProgress) {
            if (aProgress <= 1) {
                weakSelf.progress = aProgress;
                partSpeedUpItem.timeOver = partSpeedUpItem.timeTotal * (1 - aProgress);
                [weakSelf updateTimeOverLabelWithTimeOver:partSpeedUpItem.timeOver];
                
                if (aProgress == 1) {
                    [weakSelf partSpeedUpPause:nil];
                }
            }
        }];
    } else {//未加速
        [self.coverView setHidden:NO];
        [self.standbyNameLabel setHidden:NO];
        [self.nameLabel setBackgroundColor:[UIColor colorWithRed:70.0/255.0 green:152.0/255.0 blue:236.0/255.0 alpha:1.0]];
        [self.timeOverLabel setBackgroundColor:[UIColor colorWithRed:70.0/255.0 green:152.0/255.0 blue:236.0/255.0 alpha:1.0]];
        [self.speedUpAnimationView setHidden:YES];
        [self.pauseButton setHidden:YES];
        [self.speedUpButton setHidden:NO];
    }

}

- (void)updateTimeOverLabelWithTimeOver:(NSInteger)timeOver
{
    NSString *timeOverText = nil;
    if (timeOver > 60 * 60) {
        timeOverText = [NSString stringWithFormat:@"剩余%ld时%ld分%ld秒", (long)timeOver/(60*60), (long)timeOver%(60*60)/60, (long)timeOver%(60*60)%60];
    } else if (timeOver > 60) {
        timeOverText = [NSString stringWithFormat:@"剩余%ld分%ld秒", (long)timeOver/60, (long)timeOver%60];
    } else {
        timeOverText = [NSString stringWithFormat:@"剩余%ld秒", (long)timeOver];
    }
    self.timeOverLabel.text = timeOverText;
}

- (void)drawRect:(CGRect)rect
{
    UIColor* strokeColor = [UIColor lightGrayColor];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(20, self.contentView.frame.size.height)];
    [bezierPath addLineToPoint: CGPointMake(self.contentView.frame.size.width-20, self.contentView.frame.size.height)];
    [strokeColor setStroke];
    bezierPath.lineWidth = 0.25f;
    [bezierPath stroke];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
