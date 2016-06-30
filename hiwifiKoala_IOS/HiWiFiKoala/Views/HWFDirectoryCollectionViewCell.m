//
//  HWFDirectoryCollectionViewCell.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/31.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDirectoryCollectionViewCell.h"

@interface HWFDirectoryCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ICONImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HWFDirectoryCollectionViewCell

- (void)loadData:(HWFFile *)directory {
    self.directory = directory;
    
    if ([directory.name isEqualToString:@"video"]) {
        self.ICONImageView.image = [UIImage imageNamed:@"video"];
    } else if ([directory.name isEqualToString:@"music"]) {
        self.ICONImageView.image = [UIImage imageNamed:@"radio"];
    } else if ([directory.name isEqualToString:@"picture"]) {
        self.ICONImageView.image = [UIImage imageNamed:@"pic"];
    } else if ([directory.name isEqualToString:@"document"]) {
        self.ICONImageView.image = [UIImage imageNamed:@"doc"];
    } else {
        self.ICONImageView.image = [UIImage imageNamed:@"other"];
    }
    
    self.titleLabel.text = directory.displayName;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
