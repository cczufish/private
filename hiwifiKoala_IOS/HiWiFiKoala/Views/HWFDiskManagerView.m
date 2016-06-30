//
//  HWFDiskManagerView.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDiskManagerView.h"

@interface HWFDiskManagerView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation HWFDiskManagerView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


+ (HWFDiskManagerView *)sharedInstance {
    return (HWFDiskManagerView*)[[[NSBundle mainBundle]loadNibNamed:@"HWFDiskManagerView" owner:self options:nil]firstObject];
}

- (void)reloadWithPartition:(HWFPartition *)partition {
    if (partition.disk.type == DiskTypeSD) {
        self.imgView.image = [UIImage imageNamed:@"sd"];
    } else if (partition.disk.type == DiskTypeSATA) {
        self.imgView.image = [UIImage imageNamed:@"sata"];
    } else if (partition.disk.type == DiskTypeUSB) {
        //usb的图片和sata一样
        self.imgView.image = [UIImage imageNamed:@"sata"];
    }
    self.titleLabel.text = partition.displayName;
    self.contentLabel.text = [NSString stringWithFormat:@"可用%@|%@",partition.displayAvailableSize,partition.displayTotalSize];
}


@end
