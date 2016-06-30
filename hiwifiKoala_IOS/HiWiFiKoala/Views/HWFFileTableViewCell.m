//
//  HWFFileTableViewCell.m
//  HiWiFiKoala
//
//  Created by dp on 14/11/1.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFFileTableViewCell.h"

#import "HWFAudioPlayer.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface HWFFileTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ICONImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playingImageView;

@end

@implementation HWFFileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    HWFAudioPlayer *audioPlayer = (HWFAudioPlayer *)[HWFAudioPlayer defaultPlayer];
    HWFFile *playingAudio = audioPlayer.currentAudio;
    if (playingAudio && [self.file.URL isEqualToString:playingAudio.URL]) {
        switch (audioPlayer.playState) {
            case PlayStateReady:
            case PlayStateLoading:
            case PlayStatePaused:
            {
                self.playingImageView.hidden = NO;
                [self.playingImageView stopAnimating];
            }
                break;
            case PlayStatePlaying:
            {
                self.playingImageView.hidden = NO;
                [self.playingImageView startAnimating];
            }
                break;
            case PlayStateStoped:
            case PlayStateError:
            {
                [self.playingImageView stopAnimating];
                self.playingImageView.hidden = YES;
            }
                break;
            default:
            {
                [self.playingImageView stopAnimating];
                self.playingImageView.hidden = YES;
            }
                break;
        }
    } else {
        [self.playingImageView stopAnimating];
        self.playingImageView.hidden = YES;
    }
}

- (void)loadDataWithDirectory:(HWFFile *)directory file:(HWFFile *)file {
    self.directory = directory;
    self.file = file;
    
    if ([file.type isEqualToString:@"dir"]) {
        self.ICONImageView.image = [UIImage imageNamed:@"other-file"];
    } else {
        switch (file.mediaType) {
            case MediaTypeVideo:
            {
                self.ICONImageView.image = [UIImage imageNamed:@"media-video"];
            }
                break;
            case MediaTypeAudio:
            {
                self.ICONImageView.image = [UIImage imageNamed:@"media-music"];
                
                self.playingImageView.image = [UIImage imageNamed:@"note2"];
                self.playingImageView.animationImages = @[ [UIImage imageNamed:@"note1"], [UIImage imageNamed:@"note2"], [UIImage imageNamed:@"note3"] ];
                self.playingImageView.animationDuration = 0.3;
            }
                break;
            case MediaTypeImage:
            {
                self.ICONImageView.image = [UIImage imageNamed:@"media-photo"];
            }
                break;
            case MediaTypeDocument:
            {
                self.ICONImageView.image = [UIImage imageNamed:@"media-doc"];
            }
                break;
            default:
            {
                self.ICONImageView.image = [UIImage imageNamed:@"media-other"];
            }
                break;
        }
    }
    
    self.titleLabel.text = file.displayName;
    self.detailLabel.text = [NSString stringWithFormat:@"%@ %@", [HWFTool getDateStringFromDate:file.createTime withFormatter:@"yyyy-MM-dd HH:mm"], file.displaySize];
}

@end
