//
//  HWFAPITableViewCell.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFAPITableViewCell.h"

#import "HWFAPI.h"

@interface HWFAPITableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HWFAPITableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(HWFAPI *)API {
    NSString *title = nil;
    switch (API.result) {
        case API_RESULT_DEFAULT:
        {
            self.titleLabel.textColor = [UIColor colorWithRed:(60/255.0) green:(180/255.0) blue:(255/255.0) alpha:1.0];
            title = [@" " stringByAppendingString:API.name];
        }
            break;
        case API_RESULT_SUCCESS:
        {
            self.titleLabel.textColor = [UIColor colorWithRed:(60/255.0) green:(180/255.0) blue:(60/255.0) alpha:1.0];
            title = [@"✔︎ " stringByAppendingString:API.name];
        }
            break;
        case API_RESULT_FAILURE:
        {
            self.titleLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(60/255.0) blue:(160/255.0) alpha:1.0];
            title = [@"✘ " stringByAppendingString:API.name];
        }
            break;
        default:
        {
            self.titleLabel.textColor = [UIColor colorWithRed:(60/255.0) green:(180/255.0) blue:(255/255.0) alpha:1.0];
            title = [@" " stringByAppendingString:API.name];
        }
            break;
    }
    self.titleLabel.text = title;
}

@end
