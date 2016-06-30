//
//  HWFGeneralTableViewCell.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-9.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFGeneralTableViewCell.h"

#pragma mark - HWFGeneralTableViewCell
@interface HWFGeneralTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UISwitch *descSwitch;
@property (weak, nonatomic) IBOutlet UIButton *descButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation HWFGeneralTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    UIView *cellSelectedBackgoundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    cellSelectedBackgoundView.backgroundColor = [UIColor backgroundColorForGeneralTableViewCellSelected];
    self.selectedBackgroundView = cellSelectedBackgoundView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)loadData:(HWFGeneralTableViewItem *)anItem {
    self.item = anItem;
    
    self.descLabel.hidden = YES;
    self.descSwitch.hidden = YES;
    self.descButton.hidden = YES;
    self.arrowImageView.hidden = YES;
    
    for (NSLayoutConstraint *layoutConstraint in self.arrowImageView.constraints) {
        if (layoutConstraint.firstAttribute == NSLayoutAttributeWidth) {
            layoutConstraint.constant = 11.0;
        }
    }
    
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:anItem.title attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16.0] }];
    if (anItem.subTitle && !IS_STRING_EMPTY(anItem.subTitle)) {
        [titleAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[@" " stringByAppendingString:anItem.subTitle] attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[UIColor orangeColor] }]];
    }
    self.titleLabel.attributedText = titleAttributedString;

    switch (anItem.style) {
        case GeneralTableViewCellStyleNone:
        {
            
        }
            break;
        case GeneralTableViewCellStyleDesc:
        {
            for (NSLayoutConstraint *layoutConstraint in self.arrowImageView.constraints) {
                if (layoutConstraint.firstAttribute == NSLayoutAttributeWidth) {
                    layoutConstraint.constant = 0.0;
                }
            }
            
            self.descLabel.hidden = NO;
            self.descLabel.text = anItem.desc;
        }
            break;
        case GeneralTableViewCellStyleArrow:
        {
            self.arrowImageView.hidden = NO;
        }
            break;
        case GeneralTableViewCellStyleDescArrow:
        {
            self.descLabel.hidden = NO;
            self.descLabel.text = anItem.desc;
            self.arrowImageView.hidden = NO;
        }
            break;
        case GeneralTableViewCellStyleSwitch:
        {
            self.descSwitch.hidden = NO;
            self.descSwitch.on = anItem.isSwitchOn;
        }
            break;
        case GeneralTableViewCellStyleButton:
        {
            self.descButton.hidden = NO;
            [self.descButton setTitle:anItem.buttonTitle forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (IBAction)descButtonClickHandler:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(descButtonClick:)]) {
        [self.delegate descButtonClick:self];
    }
}

- (IBAction)descSwitchChangedHandler:(UISwitch *)sender {
    self.item.isSwitchOn = sender.on;
    
    if ([self.delegate respondsToSelector:@selector(descSwitchChanged:)]) {
        [self.delegate descSwitchChanged:self];
    }
}

@end

#pragma mark - HWFGeneralTableViewItem
@implementation HWFGeneralTableViewItem

- (instancetype)initWithIdentity:(NSString *)identity
                           style:(GeneralTableViewCellStyle)style
                           title:(NSString *)title
                            desc:(NSString *)desc
                        switchOn:(BOOL)isSwitchOn
                     buttonTitle:(NSString *)buttonTitle {
    self = [self initWithIdentity:identity style:style title:title subTitle:nil desc:desc switchOn:isSwitchOn buttonTitle:buttonTitle];
    if (self) {

    }
    return self;
}

- (instancetype)initWithIdentity:(NSString *)identity
                           style:(GeneralTableViewCellStyle)style
                           title:(NSString *)title
                        subTitle:(NSString *)subTitle
                            desc:(NSString *)desc
                        switchOn:(BOOL)isSwitchOn
                     buttonTitle:(NSString *)buttonTitle {
    self = [super init];
    if (self) {
        self.identity = identity;
        self.style = style;
        self.title = title;
        self.subTitle = subTitle;
        self.desc = desc;
        self.isSwitchOn = isSwitchOn;
        self.buttonTitle = buttonTitle;
    }
    return self;
}

// @Override MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identity" : @"identity",
             @"style" : @"style",
             @"title" : @"title",
             @"subTitle" : @"subTitle",
             @"desc" : @"desc",
             @"isSwitchOn" : @"isSwitchOn",
             @"buttonTitle" : @"buttonTitle",
             };
}

@end
