//
//  HWFDeviceListHeaderView.m
//  HiWiFi
//
//  Created by dp on 14-4-1.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import "HWFDeviceListHeaderView.h"

@interface HWFDeviceListHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *deviceCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation HWFDeviceListHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (HWFDeviceListHeaderView *)instanceView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HWFDeviceListHeaderView" owner:self options:nil] firstObject];
}

- (void)reloadWithDeviceCount:(NSInteger)aDeviceCount withOnlineDeviceCount:(NSInteger)onlineCount
{
    NSString *deviceCountStr = [NSString stringWithFormat:@"接入设备 %ld/%ld", (long)onlineCount,(long)aDeviceCount];
    NSMutableAttributedString *deviceCountAttr = [[NSMutableAttributedString alloc]initWithString:deviceCountStr];
    [deviceCountAttr setAttributes:@{NSForegroundColorAttributeName: COLOR_HEX(0x333333) , NSFontAttributeName : [UIFont systemFontOfSize:16.0]} range:NSMakeRange(0, 4)];
//    [deviceCountAttr setAttributes:@{NSForegroundColorAttributeName: COLOR_HEX(0x30B0F8) , NSFontAttributeName : [UIFont systemFontOfSize:18.0]} range:NSMakeRange(deviceCountStr.length - 4, deviceCountStr.length - 4)];
    self.deviceCountLabel.attributedText = deviceCountAttr;
    self.infoLabel.text = @"当前流量";
    self.infoLabel.textColor = COLOR_HEX(0x333333);
    
}

- (void)drawRect:(CGRect)rect
{
    UIColor* strokeColor = COLOR_GRAY(168);
    
    float lineWidth = 0.25;
    
    UIBezierPath* bezierPath1 = [UIBezierPath bezierPath];
    [bezierPath1 moveToPoint:CGPointMake(0, rect.size.height-lineWidth)];
    [bezierPath1 addLineToPoint:CGPointMake(rect.size.width, rect.size.height-lineWidth)];
    [strokeColor setStroke];
    bezierPath1.lineWidth = lineWidth;
    [bezierPath1 stroke];
    
//    UIBezierPath* bezierPath2 = [UIBezierPath bezierPath];
//    [bezierPath2 moveToPoint:CGPointMake(210, rect.size.height)];
//    [bezierPath2 addLineToPoint:CGPointMake(210, rect.size.height-6)];
//    [strokeColor setStroke];
//    bezierPath2.lineWidth = lineWidth;
//    [bezierPath2 stroke];
//    
//    UIBezierPath* bezierPath3 = [UIBezierPath bezierPath];
//    [bezierPath3 moveToPoint:CGPointMake(280, rect.size.height)];
//    [bezierPath3 addLineToPoint:CGPointMake(280, rect.size.height-6)];
//    [strokeColor setStroke];
//    bezierPath3.lineWidth = lineWidth;
//    [bezierPath3 stroke];
}

@end
