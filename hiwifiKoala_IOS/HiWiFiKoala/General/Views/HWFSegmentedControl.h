//
//  HWFSegmentedControl.h
//  HiWiFiKoala
//
//  Created by dp on 14/11/6.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWFSegmentedControl;

typedef void (^HWFSegmentedClickHandler)(HWFSegmentedControl *sender, int clickedSegmentIndex);

@interface HWFSegmentedControl : UIControl

@property (assign, nonatomic) int       selectedSegmentIndex; // 当前选中的元素索引
@property (strong, nonatomic) UIColor   *segmentForegroundColor; // 前景色
@property (strong, nonatomic) UIColor   *segmentBackgroundColor; // 背景色
@property (strong, nonatomic) NSArray   *segmentTitles; // 分段控件Title数组，内部元素为NSString类型的Title
@property (strong, nonatomic) HWFSegmentedClickHandler clickHandler; // 点击某个Segment时触发

@end