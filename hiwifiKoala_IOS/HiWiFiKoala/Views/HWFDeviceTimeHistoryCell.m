//
//  HWFDeviceTimeHistoryCell.m
//  HiWiFi
//
//  Created by dp on 14-1-17.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import "HWFDeviceTimeHistoryCell.h"

@interface HWFDeviceTimeHistoryCell ()

@property (weak, nonatomic) IBOutlet UIImageView *nowIcon;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end

@implementation HWFDeviceTimeHistoryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)reloadCellWithStartTime:(NSString *)startTime endTime:(NSString *)endTime dateFlag:(BOOL)dateFlag ysOffPointIndex:(NSInteger)offPointIndex row:(NSInteger)aRow
{
    self.nowIcon.hidden = YES;
//    self.endTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    
    NSString *offPointTimeString = [NSString stringWithFormat:@"%02d:%02d", offPointIndex/12, (offPointIndex%12)*5];

    if ([endTime isEqualToString:@"现在"]) {
//        self.timeLabel.text = [NSString stringWithFormat:@"%@     ~     %@", startTime, offPointTimeString];
        self.startTimeLabel.text = startTime;
//        self.endTimeLabel.text = offPointTimeString;
        if (dateFlag) {
            self.endTimeLabel.text = endTime;
        } else {
            self.endTimeLabel.text = offPointTimeString;
        }
//        if (dateFlag) {
//            self.nowIcon.hidden = NO;
//        } else {
//            self.nowIcon.hidden = YES;
//        }
    } else if (!dateFlag && [endTime isEqualToString:@"现在"]) {
//        self.timeLabel.text = [NSString stringWithFormat:@"%@     ~     %@", startTime, offPointTimeString];
        self.startTimeLabel.text = startTime;
        self.endTimeLabel.text = offPointTimeString;
//        self.nowIcon.hidden = YES;
    } else {
//        self.timeLabel.text = [NSString stringWithFormat:@"%@     ~     %@", startTime, endTime];
        self.startTimeLabel.text = startTime;
        self.endTimeLabel.text = endTime;
//        self.nowIcon.hidden = YES;
    }
    
//    if (!__SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        self.timeLabel.font = [UIFont systemFontOfSize:30.0];
//    }
    
//    if ((aRow+1) % 2 == 0) {
//        self.contentView.backgroundColor = COLOR_GRAY(236);
//    } else {
//        self.contentView.backgroundColor = COLOR_GRAY(230);
//    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    UIImageView *lineImageView=[[UIImageView alloc] initWithFrame:self.contentView.frame];
//    [self.contentView addSubview:lineImageView];
//    
//    UIGraphicsBeginImageContext(lineImageView.frame.size);
//    [lineImageView.image drawInRect:CGRectMake(0, 0, lineImageView.frame.size.width, lineImageView.frame.size.height)];
//    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 0.5f);
//    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
//    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 200.0/255.0, 200.0/255.0, 200.0/255.0, 1.0);
//    CGContextBeginPath(UIGraphicsGetCurrentContext());
//    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, self.contentView.height);
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 320, self.contentView.height);
//    CGContextStrokePath(UIGraphicsGetCurrentContext());
//    lineImageView.image=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
}


@end
