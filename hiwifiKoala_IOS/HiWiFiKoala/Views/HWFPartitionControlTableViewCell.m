//
//  HWFPartitionControlTableViewCell.m
//  HiWiFiKoala
//
//  Created by dp on 14/11/5.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFPartitionControlTableViewCell.h"

@interface HWFPartitionControlTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HWFPartitionControlTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(HWFDisk *)disk {
    self.disk = disk;
    
    switch (disk.type) {
        case DiskTypeSD:
        {
            self.titleLabel.text = @"安全弹出SD卡";
        }
            break;
        case DiskTypeUSB:
        {
            self.titleLabel.text = @"安全弹出USB设备";
        }
            break;
        default:
            break;
    }
}

@end
