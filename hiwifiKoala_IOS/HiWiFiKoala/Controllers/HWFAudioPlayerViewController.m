//
//  HWFAudioPlayerViewController.m
//  HWFAudioPlayer
//
//  Created by chang hong on 14-10-31.
//  Copyright (c) 2014年 chang hong. All rights reserved.
//

#import "HWFAudioPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HWFAudioPlayer.h"
@interface HWFAudioPlayerViewController ()

@property (weak, nonatomic) IBOutlet UIView *volumeContainer;
@property (weak, nonatomic) IBOutlet UIView *progressContainer;
@property (strong,nonatomic) HWFAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UILabel *audioTitle;
@property (weak, nonatomic) IBOutlet UILabel *audioArtist;
@property (weak, nonatomic) IBOutlet UILabel *audioAlbum;
@property (weak, nonatomic) IBOutlet UIImageView *audioArtwork;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (strong,nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIButton *minVolumeBtn;

@property (weak, nonatomic) IBOutlet UIButton *maxVolumeBtn;

@end

@implementation HWFAudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    MPVolumeView *myVolumeView =[[MPVolumeView alloc] initWithFrame: CGRectZero];
    myVolumeView.translatesAutoresizingMaskIntoConstraints = NO;
    myVolumeView.backgroundColor = [UIColor redColor];
    //[self.volumeContainer setHidden:YES];
    self.volumeContainer.alpha = 0.001;
    [self performSelector:@selector(showVolume) withObject:nil afterDelay:.5];
    //UIImage *image = [UIImage imageNamed:@"Play_volume_normal"];
    //[myVolumeView setVolumeThumbImage:image forState:(UIControlStateNormal)];
    [self.volumeContainer addSubview:myVolumeView];
    [self.volumeContainer bringSubviewToFront:self.maxVolumeBtn];
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:myVolumeView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.volumeContainer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:40];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:myVolumeView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.volumeContainer attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-40];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:myVolumeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:myVolumeView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.volumeContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.volumeContainer addConstraints:@[leadingConstraint,trailingConstraint,heightConstraint,centerYConstraint]];
    
    
    self.player = [HWFAudioPlayer defaultPlayer];
    if(self.player.playState == PlayStatePlaying || self.player.playState == PlayStatePaused) {
        [self playStateChanged:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStateChanged:) name:HWFPlayStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAudioChanged:) name:HWFPlayAudioChangedNotification object:nil];
    
    
    [self.progressSlider addTarget:self action:@selector(progressTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.progressSlider addTarget:self action:@selector(progressTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider addTarget:self action:@selector(progressTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    // Do any additional setup after loading the view from its nib.
}

- (void)progressTouchDown:(id)sender {
    [self stopProgress];
}

- (void)progressTouchUp:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [self.player seek:slider.value * self.player.duration];
}

- (void)showVolume {
   // [self.volumeContainer setHidden:NO];
    self.volumeContainer.alpha = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)playStateChanged:(NSNotification *)notify {
    void (^updateMetaDataHandler)(void) = ^(void) {
        if([self.player.metaData objectForKey:MPMediaItemPropertyTitle]) {
            self.audioTitle.text =[self.player.metaData objectForKey:MPMediaItemPropertyTitle];
        }
        if([self.player.metaData objectForKey:MPMediaItemPropertyAlbumTitle]) {
            self.audioAlbum.text =[NSString stringWithFormat:@"专辑:%@",[self.player.metaData objectForKey:MPMediaItemPropertyAlbumTitle]];
        }
        if([self.player.metaData objectForKey:MPMediaItemPropertyArtist]) {
            self.audioArtist.text = [NSString stringWithFormat:@"歌手:%@",[self.player.metaData objectForKey:MPMediaItemPropertyArtist]];
        }
        if([self.player.metaData objectForKey:MPMediaItemPropertyArtwork]) {
            self.audioArtwork.image = [[self.player.metaData objectForKey:MPMediaItemPropertyArtwork] imageWithSize:self.audioArtwork.frame.size];
        }
        
        [self startProgress];
    };
    
    if (self.player.playState == PlayStatePlaying) {
        NSLog(@"get info");
        
        updateMetaDataHandler();
        
        [self.playBtn setHidden:YES];
        [self.playBtn setEnabled:NO];
        [self.pauseBtn setHidden:NO];
        [self.pauseBtn setEnabled:YES];
        
    } else if(self.player.playState == PlayStatePaused) {
        updateMetaDataHandler();
        
        [self.playBtn setHidden:NO];
        [self.pauseBtn setHidden:YES];
        [self.playBtn setEnabled:YES];
        [self.pauseBtn setEnabled:NO];
    } else if (self.player.playState == PlayStateStoped) {
        [self.playBtn setHidden:NO];
        [self.pauseBtn setHidden:YES];
        [self.playBtn setEnabled:YES];
        [self.pauseBtn setEnabled:NO];
        
        [self stopProgress];
    }
}

- (void)playAudioChanged:(NSNotification *)notify {
    [self clearLabel];
    self.progressSlider.value = 0;
    [self startProgress];
}

- (void)startProgress {
    if(!self.timer){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onProgress) userInfo:nil repeats:YES];
    }
}

- (void)stopProgress {
    [self.timer invalidate];
    self.timer = nil;
//    self.progressSlider.value = 0;
}

- (void)onProgress {
    if(self.player.playState == PlayStatePlaying || self.player.playState == PlayStatePaused) {
        self.progressSlider.value = self.player.position / self.player.duration;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopProgress];
}

- (void)clearLabel {
    self.audioTitle.text = @"";
    self.audioAlbum.text = @"";
    self.audioArtist.text = @"";
    self.audioArtwork.image = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextAudio:(id)sender {
    [self.player next];
}

- (IBAction)playAudio:(id)sender {
    [self.player play];
}

- (IBAction)pauseAudio:(id)sender {
    [self.player pause];
}

- (IBAction)minVolume:(id)sender {
    self.player.volume = 0;
}

- (IBAction)maxVolume:(id)sender {
    self.player.volume = 1;
}
@end
