//
//  HWFDownloadTableViewCell.m
//  HiWiFiKoala
//
//  Created by dp on 14/11/10.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDownloadTableViewCell.h"

#import "HWFProgressView.h"

@interface HWFDownloadTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusICON;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet HWFProgressView *downloadingProgressView;

@end

@implementation HWFDownloadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.editing) {
        self.statusButton.hidden = YES;
        self.statusICON.hidden = YES;
    } else {
        self.statusButton.hidden = NO;
        
        switch (self.task.status) {
            case DownloadTaskStatusActive:
            {
                self.downloadingProgressView.hidden = NO;
                [self.downloadingProgressView setProgress:(CGFloat)self.task.completedSize/(CGFloat)self.task.totalSize animated:YES];
                self.infoLabel.text = [NSString stringWithFormat:@"%@  %@/%@", [HWFTool displayTrafficWithUnitB:self.task.downloadSpeed], [HWFTool displaySizeWithUnitB:self.task.completedSize], [HWFTool displaySizeWithUnitB:self.task.totalSize]];
                self.statusICON.hidden = NO;
                self.statusICON.image = [UIImage imageNamed:@"pause"];
            }
                break;
            case DownloadTaskStatusComplete:
            {
                self.downloadingProgressView.hidden = YES;
                self.infoLabel.text = [NSString stringWithFormat:@"%@  %@  下载完成", [HWFTool getDateStringFromDate:self.task.stopTime withFormatter:@"yyyy-MM-dd"], [HWFTool displaySizeWithUnitB:self.task.totalSize]];
                self.statusICON.hidden = YES;
            }
                break;
            case DownloadTaskStatusPaused:
            {
                self.downloadingProgressView.hidden = NO;
                [self.downloadingProgressView setProgress:(CGFloat)self.task.completedSize/(CGFloat)self.task.totalSize animated:NO];
                self.infoLabel.text = [NSString stringWithFormat:@"%@/%@  暂停", [HWFTool displaySizeWithUnitB:self.task.completedSize], [HWFTool displaySizeWithUnitB:self.task.totalSize]];
                self.statusICON.hidden = NO;
                self.statusICON.image = [UIImage imageNamed:@"play"];
            }
                break;
            case DownloadTaskStatusWaiting:
            {
                self.downloadingProgressView.hidden = NO;
                [self.downloadingProgressView setProgress:(CGFloat)self.task.completedSize/(CGFloat)self.task.totalSize animated:NO];
                self.infoLabel.text = [NSString stringWithFormat:@"%@/%@  等待中", [HWFTool displaySizeWithUnitB:self.task.completedSize], [HWFTool displaySizeWithUnitB:self.task.totalSize]];
                self.statusICON.hidden = NO;
                self.statusICON.image = [UIImage imageNamed:@"play"];
            }
                break;
            case DownloadTaskStatusError:
            {
                self.downloadingProgressView.hidden = NO;
                [self.downloadingProgressView setProgress:(CGFloat)self.task.completedSize/(CGFloat)self.task.totalSize animated:NO];
                self.infoLabel.text = self.task.errorMessage;
                self.statusICON.hidden = NO;
                self.statusICON.image = [UIImage imageNamed:@"play"];
            }
                break;
            case DownloadTaskStatusNone:
            default:
            {
                self.downloadingProgressView.hidden = NO;
                [self.downloadingProgressView setProgress:(CGFloat)self.task.completedSize/(CGFloat)self.task.totalSize animated:NO];
                self.infoLabel.text = @"";
                self.statusICON.hidden = NO;
                self.statusICON.image = [UIImage imageNamed:@"play"];
            }
                break;
        }
    }
}

- (void)loadData:(HWFDownloadTask *)task {
    self.task = task;
    self.titleLabel.text = (task.fileName && !IS_STRING_EMPTY(task.fileName)) ? task.fileName : task.dURL;
}

- (IBAction)statusButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(downloadStatusButtonClick:)]) {
        [self.delegate downloadStatusButtonClick:self];
    }
}

@end
