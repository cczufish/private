//
//  HWFLocationCell.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWFLocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

- (void)loadUIWithData:(NSString *)string;

@end
