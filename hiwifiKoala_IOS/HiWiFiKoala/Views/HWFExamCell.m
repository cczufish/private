//
//  HWFExamCell.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-11-7.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFExamCell.h"

@interface HWFExamCell ()
@property (weak, nonatomic) IBOutlet UIImageView *sinalImgView;
@property (weak, nonatomic) IBOutlet UILabel *messgaLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrorImgView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation HWFExamCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)loadWithExamItem:(HWFExamItem *)examItem {
    self.examItem = examItem;
    self.arrorImgView.hidden = YES;
    self.button.hidden = YES;
    self.messgaLabel.text = examItem.message;
    self.tipLabel.text = examItem.desc;
    self.tipLabel.textColor = examItem.descColor;

    switch (examItem.examStyle) {
        case ExamItemDescUnSafe:
        {
            self.sinalImgView.image = [UIImage imageNamed:@"alert-big"];
            self.arrorImgView.hidden = NO;
            self.button.hidden = NO;
            
        }
            break;
  
        case ExamItemDescSafe :
        {
            self.sinalImgView.image = [UIImage imageNamed:@"checked"];
            self.arrorImgView.hidden = YES;
            self.button.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 箭头事件
- (IBAction)buttonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(buttonClick:)]) {
        [self.delegate buttonClick:self];
    }
}

@end

@implementation HWFExamItem

- (instancetype)initWithMessage:(NSString *)message andWithDesc:(NSString *)desc andWithExamType:(ExamItemStyle)type  withIdentifier:(NSString *)identifier withDescColor:(UIColor *)color {
    self = [super init];
    if (self) {
        self.message = message;
        self.desc = desc;
        self.examStyle = type;
        self.identifier = identifier;
        self.descColor = color;
    }
    return self;
}

@end
