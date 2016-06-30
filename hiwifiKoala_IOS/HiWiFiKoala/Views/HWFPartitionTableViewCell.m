//
//  HWFPartitionTableViewCell.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/31.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFPartitionTableViewCell.h"

@interface HWFPartitionTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ICONImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation HWFPartitionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(HWFPartition *)partition {
    self.partition = partition;
    
    switch (partition.disk.type) {
        case DiskTypeSD:
        {
            self.ICONImageView.image = [UIImage imageNamed:@"sd-1"];
        }
            break;
        case DiskTypeUSB:
        {
            self.ICONImageView.image = [UIImage imageNamed:@"disk"];
        }
            break;
        case DiskTypeSATA:
        {
            self.ICONImageView.image = [UIImage imageNamed:@"disk"];
        }
            break;
        default:
            break;
    }
    self.titleLabel.text = partition.displayName;
    self.detailLabel.text = [NSString stringWithFormat:@"可用 %@ | 共 %@", [partition displayAvailableSize], [partition displayTotalSize]];
    
}

@end
