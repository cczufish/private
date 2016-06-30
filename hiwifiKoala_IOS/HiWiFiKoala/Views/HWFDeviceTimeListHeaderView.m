//
//  HWFDeviceTimeListHeaderView.m
//  HiWiFi
//
//  Created by dp on 14-4-1.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import "HWFDeviceTimeListHeaderView.h"

@interface HWFDeviceTimeListHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTrafficLabel;

@end

@implementation HWFDeviceTimeListHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (HWFDeviceTimeListHeaderView *)instanceView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HWFDeviceTimeListHeaderView" owner:self options:nil] firstObject];
}

- (void)loadWithTime:(NSInteger)aTime traffic:(double)aTraffic
{
    NSInteger hour = aTime / 60;
    NSInteger minute = aTime % 60;
    
    // 在线时长：23小时45分钟 / 总流量：867MB
    NSString *timeText = [NSString stringWithFormat:@"在线时长:%02d小时%02d分钟", hour, minute];
    
    NSString *trafficText;
    if (aTraffic < 102.4) {
        trafficText = @"总流量：0 KB";
    } else if (aTraffic < 1024.0*1024.0) {
        trafficText = [NSString stringWithFormat:@"总流量：%.1f KB", aTraffic/1024.0];
    } else if (aTraffic < 1024.0*1024.0*1024.0) {
        trafficText = [NSString stringWithFormat:@"总流量：%.1f MB", aTraffic/1024.0/1024.0];
    } else if (aTraffic < 1024.0*1024.0*1024.0*1024.0) {
        trafficText = [NSString stringWithFormat:@"总流量：%.1f GB", aTraffic/1024.0/1024.0/1024.0];
    }
    NSMutableAttributedString *timeAttString = [[NSMutableAttributedString alloc]initWithString:timeText];
    [timeAttString setAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor] , NSFontAttributeName : [UIFont systemFontOfSize:12.0]} range:NSMakeRange(0, 5)];
    self.descLabel.attributedText = timeAttString;
    
    NSMutableAttributedString *trafficAttString = [[NSMutableAttributedString alloc]initWithString:trafficText];
    [trafficAttString setAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor] , NSFontAttributeName : [UIFont systemFontOfSize:12.0]} range:NSMakeRange(0, 4)];
    self.totalTrafficLabel.attributedText = trafficAttString;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIColor* strokeColor = COLOR_GRAY(168);

    float lineWidth = 0.25;

    UIBezierPath* bezierPath1 = [UIBezierPath bezierPath];
    [bezierPath1 moveToPoint:CGPointMake(0, rect.size.height-lineWidth)];
    [bezierPath1 addLineToPoint:CGPointMake(rect.size.width, rect.size.height-lineWidth)];
    [strokeColor setStroke];
    bezierPath1.lineWidth = lineWidth;
    [bezierPath1 stroke];

    UIBezierPath* bezierPath2 = [UIBezierPath bezierPath];
    [bezierPath2 moveToPoint:CGPointMake(SCREEN_WIDTH*0.5, rect.size.height)];
    [bezierPath2 addLineToPoint:CGPointMake(SCREEN_WIDTH*0.5, rect.size.height-6)];
    [strokeColor setStroke];
    bezierPath2.lineWidth = lineWidth;
    [bezierPath2 stroke];
}

@end
