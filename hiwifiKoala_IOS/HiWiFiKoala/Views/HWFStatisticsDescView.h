//
//  HWFStatisticsDescView.h
//  HiWiFi
//
//  Created by dp on 14-1-14.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

//#import "HWFBaseView.h"
#import "HWFView.h"

@class LCLineChartDataItem;

@protocol HWFStatisticsDescViewDelegate <NSObject>

- (void)toggleDateFromDateFlag:(BOOL)aDateFlag;

@end

@interface HWFStatisticsDescView : HWFView

@property (assign, nonatomic) id<HWFStatisticsDescViewDelegate> delegate;

//
@property (weak, nonatomic) IBOutlet UIImageView *routerIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *npLabel;
@property (weak, nonatomic) IBOutlet UIButton *feedBackButton;


// 实例化
+ (HWFStatisticsDescView *)instanceView;

- (void)reloadWithItem:(LCLineChartDataItem *)anItem dateFlag:(BOOL)dateFlag;

@end
