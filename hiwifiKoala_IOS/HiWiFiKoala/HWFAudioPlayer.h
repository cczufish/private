//
//  HWFAudioPlayer.h
//  SambaTest
//
//  Created by chang hong on 14-10-27.
//  Copyright (c) 2014年 chang hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWFFile.h"

extern NSString * const HWFPlayStateChangedNotification;
extern NSString * const HWFPlayAudioChangedNotification;

typedef NS_ENUM(NSInteger,PlayMode){
    PlayModeNormal = 0,
    PlayModeSingle,
    PlayModeSingleRepeat,
    PlayModeRandom
};
typedef NS_ENUM(NSInteger, PlayState){
    PlayStateReady = 0,
    PlayStateLoading,
    PlayStatePlaying,
    PlayStatePaused,
    PlayStateStoped,
    PlayStateError
};

@interface HWFAudioPlayer : UIResponder

@property(assign,nonatomic) PlayMode playMode;
@property(nonatomic,readonly) PlayState playState;
@property(nonatomic,readonly) NSMutableDictionary *metaData;
@property(assign,nonatomic) BOOL autoStart;
@property(assign,nonatomic) float volume;
@property(readonly,nonatomic) HWFFile *currentAudio;
+ (instancetype)defaultPlayer;
- (void)updatePlayList:(NSArray *)ary;
- (BOOL)isPlaying;
- (void)next;
- (void)preve;
- (void)play;
- (void)pause;
- (void)stop;
- (void)seek:(double)newTime;
- (double)position;
- (double)duration;
@end
