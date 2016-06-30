//
//  HWFMessageListTableViewCell.m
//  HiWiFiKoala
//
//  Created by chang hong on 14-10-20.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFMessageListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HWFTool.h"
@interface HWFMessageListTableViewCell()

@property (strong,nonatomic) HWFMessage *model;

@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *messageContent;
@property (weak, nonatomic) IBOutlet UIImageView *isReadImage;
@property (weak, nonatomic) IBOutlet UIImageView *messageImage;

@end

@implementation HWFMessageListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setData:(HWFMessage *) model {
    self.model = model;
    self.messageTitle.text = model.title;
    self.messageContent.text = model.content;
    [self.messageImage sd_setImageWithURL:[NSURL URLWithString:model.ICON] placeholderImage:nil];
    self.createTime.text = [HWFTool dateAgoWithDate:model.createTime];
    self.isReadImage.hidden = self.model.status;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
