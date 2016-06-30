//
//  HWFAudioPlayer.m
//  SambaTest
//
//  Created by chang hong on 14-10-27.
//  Copyright (c) 2014年 chang hong. All rights reserved.
//

#import "HWFAudioPlayer.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

NSString * const HWFPlayStateChangedNotification = @"HWFPlayStateChangedNotification";
NSString * const HWFPlayAudioChangedNotification = @"HWFPlayAudioChangedNotification";
@interface HWFAudioPlayer ()

@property (strong,nonatomic) NSMutableArray *playList;
@property (strong,nonatomic) NSMutableArray *randomList;
@property (strong,nonatomic) HWFFile *currentAudio;
@property (assign,nonatomic) NSInteger currentIndex;
@property (assign,nonatomic) NSInteger randomIndex;
@property (strong,nonatomic) AVPlayer *audio;
@property (assign,nonatomic) PlayState playState;
@property (strong,nonatomic) NSMutableDictionary *metaData;

@end

@implementation HWFAudioPlayer
+ (instancetype)defaultPlayer
{
    static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if(self) {
        [self initData];
        [self initClass];
    }
    return self;
}

- (void)initData {
    _currentIndex = -1;
    _randomIndex = -1;
    _autoStart = YES;
    _playList = [[NSMutableArray alloc] initWithCapacity:0];
    _randomList = [[NSMutableArray alloc] initWithCapacity:0];
    _metaData = [[NSMutableDictionary alloc] initWithCapacity:0];
}

- (void)initClass {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    _audio = [[AVPlayer alloc] initWithPlayerItem:nil];
    [_audio addObserver:self forKeyPath:@"currentItem.status" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [_audio addObserver:self forKeyPath:@"currentItem.playbackBufferEmpty" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [_audio addObserver:self forKeyPath:@"currentItem.playbackBufferFull" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [_audio addObserver:self forKeyPath:@"currentItem.loadedTimeRanges" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playComplete) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)updatePlayList:(NSArray *)ary {
    if(ary.count > 0 ) {
        [self.playList setArray:ary];
        [self.randomList setArray:ary];
        [self sortRandomList];
        self.currentIndex = 0;
        self.randomIndex = 0;
        [self initStreamer];
        if(!self.autoStart) {
            [self pause];
        }
    }
}

- (void)initStreamer {
    if(self.playState != PlayStateReady) {
        [self.metaData removeAllObjects];
//        self.currentAudio = nil;
//        [self stop];
    }
    self.playState = PlayStateReady;
    self.playState = PlayStateLoading;
    if (self.playMode == PlayModeRandom) {
        self.currentAudio = (HWFFile *) [self.randomList objectAtIndex:self.randomIndex];
    } else {
        self.currentAudio = (HWFFile *) [self.playList objectAtIndex:self.currentIndex];
    }
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.currentAudio.URL]];
    [self.audio replaceCurrentItemWithPlayerItem:item];
    [[NSNotificationCenter defaultCenter] postNotificationName:HWFPlayAudioChangedNotification object:self];
    [self.audio play];
}

- (void)playComplete {
    if(!self.audio.currentItem.isPlaybackBufferFull) {
        self.playState = PlayStateError;
    }
    if(self.playMode == PlayModeNormal) {
        [self next];
    }else if(self.playMode == PlayModeRandom) {
        [self next];
    }else if(self.playMode == PlayModeSingle) {
        [self stop];
//        [self initStreamer];
//        [self pause];
    }else if(self.playMode == PlayModeSingleRepeat) {
        [self initStreamer];
    }
}

- (void)playFailed {
    self.playState = PlayStateError;
    self.currentAudio = nil;
    [self playComplete];
}

- (void)configPlayingInfo
{
    [self.metaData removeAllObjects];
    AVAsset *mp3Asset = self.audio.currentItem.asset;
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            if ([metadataItem.commonKey isEqualToString:AVMetadataCommonKeyTitle]) {
                NSString *title = (NSString *)metadataItem.value;
                
                [self.metaData setObject:title forKey:MPMediaItemPropertyTitle];
            }else if ([metadataItem.commonKey isEqualToString:AVMetadataCommonKeyArtist]) {
                NSString *title = (NSString *)metadataItem.value;
                [self.metaData setObject:title forKey:MPMediaItemPropertyArtist];
                
            }else if ([metadataItem.commonKey isEqualToString:AVMetadataCommonKeyAlbumName]) {
                NSString *title = (NSString *)metadataItem.value;
                [self.metaData setObject:title forKey:MPMediaItemPropertyAlbumTitle];
            }else if([metadataItem.commonKey isEqualToString:AVMetadataCommonKeyArtwork]) {
                NSData *data = [[NSData alloc] init];
                if([metadataItem.value isKindOfClass:[NSData class]]) {
                    data = (NSData *)metadataItem.value;
                }else if([metadataItem.value isKindOfClass:[NSDictionary class]]){
                    data = [(NSDictionary *) metadataItem.value objectForKey:@"data"];
                }
                UIImage *image = [UIImage imageWithData:data];
                [self.metaData setObject:[[MPMediaItemArtwork alloc] initWithImage:image] forKey:MPMediaItemPropertyArtwork];
            }
        }
    }
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        [self.metaData setObject:[NSNumber numberWithDouble:self.position] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [self.metaData setObject:[NSNumber numberWithDouble:self.duration] forKey:MPMediaItemPropertyPlaybackDuration];
        if(self.playState == PlayStatePlaying) {
            [self.metaData setObject:[NSNumber numberWithInt:1] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        }else{
            [self.metaData setObject:[NSNumber numberWithFloat:0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        }
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:self.metaData];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"currentItem.status"]) {
        if([change objectForKey:@"new"] != [NSNull null]) {
            if([[change objectForKey:@"new"] intValue] == AVPlayerStatusReadyToPlay) {
                NSLog(@"read to config");
                [self configPlayingInfo];
                self.playState = PlayStatePlaying;
            }else if([[change objectForKey:@"new"] intValue] == AVPlayerStatusFailed) {
                [self playFailed];
            }
        }
    }else if([keyPath isEqualToString:@"currentItem.playbackBufferEmpty"]) {
        if(self.audio.currentItem.isPlaybackBufferEmpty) {
            if([change objectForKey:@"old"] != [NSNull null]) {
                self.playState = PlayStateLoading;
                [self.audio pause];
                [self configPlayingInfo];
            }
        }
    }else if ([keyPath isEqualToString:@"currentItem.playbackBufferFull"]) {
    }else if([keyPath isEqualToString:@"currentItem.loadedTimeRanges"]) {
        if([change objectForKey:@"old"] != [NSNull null]) {
            if(self.playState == PlayStateLoading) {
                if([self.audio.currentItem.loadedTimeRanges count] >= 1) {
                    NSValue *timeRangeValue =  [self.audio.currentItem.loadedTimeRanges objectAtIndex:0];
                    CMTimeRange timeRange = [timeRangeValue CMTimeRangeValue];
                    if( timeRange.duration.value/timeRange.duration.timescale >= 3) {
                        [self play];
                    }
                }
            }
        }
    }
}

- (void)sortRandomList {
    [self.randomList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int rand = arc4random() % 3;
        NSInteger returnValue = -1;
        switch (rand) {
            case 0:
                returnValue = (NSComparisonResult) NSOrderedAscending;
                break;
            case 1:
                returnValue = (NSComparisonResult) NSOrderedSame;
                break;
            case 2:
                returnValue = (NSComparisonResult) NSOrderedDescending;
                break;
            default:
                break;
        }
        return returnValue;
    }];
}

- (void)play {
    if (self.playState == PlayStateStoped) {
        [self initStreamer];
    } else {
        self.playState = PlayStatePlaying;
        [self.audio play];
    }
    [self configPlayingInfo];
}

- (void)pause {
    self.playState = PlayStatePaused;
    [self configPlayingInfo];
    [self.audio pause];
}

- (void)stop {
    [self.audio pause];
//    [self.audio replaceCurrentItemWithPlayerItem:nil];
//    [self.metaData removeAllObjects];
//    self.currentAudio = nil;
    self.playState = PlayStateStoped;
}

- (void)seek:(double)newTime {
    self.playState = PlayStateLoading;
    [self.audio pause];
    [self.audio seekToTime:CMTimeMakeWithSeconds(newTime, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        [self play];
    }];
}

- (void)next {
    if(self.playList.count > 0) {
        [self getCurrentSongIndex];
        if(self.playMode == PlayModeNormal) {
            if(self.currentIndex == self.playList.count - 1) {
                self.currentIndex = 0;
            }else{
                self.currentIndex++;
            }
        }else if(self.playMode == PlayModeRandom) {
            DDLogDebug(@"%ld, %ld", (long)self.randomIndex, (long)self.randomList.count);
            if(self.randomIndex == self.randomList.count - 1) {
                self.randomIndex = 0;
            }else{
                self.randomIndex++;
            }
        }
        [self initStreamer];
    }
}

- (void)preve {
    if(self.playList.count > 0) {
        [self getCurrentSongIndex];
        if(self.playMode == PlayModeNormal) {
            if(self.currentIndex <= 0) {
                self.currentIndex = self.playList.count - 1;
            }else{
                self.currentIndex--;
            }
        }else if(self.playMode == PlayModeRandom) {
            if(self.randomIndex <= 0) {
                self.randomIndex = self.playList.count - 1;
            }else{
                self.randomIndex--;
            }
        }
        [self initStreamer];
    }
}

- (void)getCurrentSongIndex {
    self.currentIndex = -1;
    self.randomIndex = -1;
    for(int i = 0; i<self.playList.count;i++) {
        HWFFile *file = (HWFFile *)[self.playList objectAtIndex:i];
        if([self.currentAudio.identity isEqualToString: file.identity]) {
            self.currentIndex = i;
            break;
        }
    }
    for(int i = 0; i<self.randomList.count;i++) {
        HWFFile *file = (HWFFile *)[self.randomList objectAtIndex:i];
        if([self.currentAudio.identity isEqualToString: file.identity]) {
            self.randomIndex = i;
            break;
        }
    }
}

- (void)setPlayState:(PlayState)newState {
    if(_playState != newState) {
        _playState = newState;
        [[NSNotificationCenter defaultCenter] postNotificationName:HWFPlayStateChangedNotification object:self];
    }
}

- (BOOL)isPlaying {
    return (self.playState == PlayStatePlaying);
}

- (double)position {
    if(self.playState == PlayStateReady) {
        return 0.0;
    }else{
        CMTime time = self.audio.currentTime;
        if (self.duration > 0){
            return ((double)time.value / time.timescale);
        }else{
            return 0;
        }
    }
}
- (double)duration {
    if(self.playState == PlayStateReady) {
        return 0.0;
    }else{
        CMTime time = self.audio.currentItem.duration;
        return (double)(time.value / time.timescale);
    }
}

- (NSTimeInterval)availableDuration;
{
    NSArray *loadedTimeRanges = self.audio.currentItem.loadedTimeRanges;
    if ([loadedTimeRanges count] > 0){
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval result = startSeconds + durationSeconds;
        return result;
    }
    return 0;
}

- (void)setVolume:(float)volume {
    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
    mpc.volume = volume;
}

- (float)volume {
    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
    return mpc.volume;
}

@end
