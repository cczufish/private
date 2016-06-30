//
//  HWFStatisticsDescView.m
//  HiWiFi
//
//  Created by dp on 14-1-14.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import "HWFStatisticsDescView.h"
#import "HWFTool.h"
#import "LCLineChartView.h"
#import "HWFBroadbandMsgFeedBackViewController.h"

@interface HWFStatisticsDescView ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *trafficLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIImageView *dateImageView;
@property (assign, nonatomic) BOOL dateFlag; // NO-昨天 YES-今天



@end

@implementation HWFStatisticsDescView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.dateFlag = YES;
    
#warning ------------的判断一下是不是极路由
}

+ (HWFStatisticsDescView *)instanceView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HWFStatisticsDescView" owner:self options:nil] firstObject];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor backgroundColorForDeviceHistoryChart];
    
//    self.clockIcon = [[HWFClockIconView alloc] initWithFrame:self.clockIconView.bounds];
//    [self.clockIconView addSubview:self.clockIcon];
    
//    self.clockLabel = [[RTLabel alloc] initWithFrame:self.clockLabelView.bounds];
//    [self.clockLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:25.0]];
//    [self.clockLabel setTextColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0]];
//    [self.clockLabel setTextAlignment:RTTextAlignmentLeft];
//    [self.clockLabelView addSubview:self.clockLabel];
    
//    self.trafficLabel = [[RTLabel alloc] initWithFrame:self.trafficLabelView.bounds];
//    [self.trafficLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:25.0]];
//    [self.trafficLabel setTextColor:[UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:87.0/255.0 alpha:1.0]];
//    [self.trafficLabel setTextAlignment:RTTextAlignmentLeft];
//    [self.trafficLabelView addSubview:self.trafficLabel];
    
    LCLineChartDataItem *item = [LCLineChartDataItem dataItemWithX:0 y:0 xLabel:@"00:00" dataLabel:@"0" xIndex:0 dateFlag:NO];
    [self reloadWithItem:item dateFlag:NO];
}

- (void)reloadWithItem:(LCLineChartDataItem *)anItem dateFlag:(BOOL)dateFlag
{
    self.dateFlag = dateFlag;
    self.routerIconImgView.image = [UIImage imageNamed:@"logo"];

    
    if (dateFlag) {
        self.dateImageView.image = [UIImage imageNamed:@"today"];
    } else {
        self.dateImageView.image = [UIImage imageNamed:@"yesterday"];
    }
    
    NSString *chartX = anItem.xLabel;
    NSString *chartY = anItem.dataLabel;
    
//    NSArray *dateArray = [chartX componentsSeparatedByString:@":"];
//    NSString *suffix = @"";
//    switch ([dateArray[0] integerValue]) {
//        case 0:
//        case 1:
//        case 2:
//        case 3:
//        case 4:
//        {
//            suffix = @"凌晨";
//        }
//            break;
//        case 5:
//        case 6:
//        case 7:
//        case 8:
//        {
//            suffix = @"早晨";
//        }
//            break;
//        case 9:
//        case 10:
//        {
//            suffix = @"上午";
//        }
//            break;
//        case 11:
//        case 12:
//        case 13:
//        {
//            suffix = @"中午";
//        }
//            break;
//        case 14:
//        case 15:
//        case 16:
//        case 17:
//        {
//            suffix = @"下午";
//        }
//            break;
//        case 18:
//        case 19:
//        case 20:
//        case 21:
//        case 22:
//        case 23:
//        {
//            suffix = @"晚上";
//        }
//            break;
//        default:
//            break;
//    }
//    
//    NSInteger h = [dateArray[0] integerValue];
//    if ([dateArray[0] integerValue] > 12) {
//        h -= 12;
//    }
//    NSString *timeString = [NSString stringWithFormat:@"%d:%@", h, dateArray[1]];
    
//    [self.clockIcon drawPointerWithIndex:anItem.xIndex];
//    [self.clockLabel setText:chartX];
//    self.timeLabel.text = chartX;
    
    
    NSArray *currentDate = [[HWFTool getDateStringFromDate:[NSDate date] withFormatter:@"HH:mm"] componentsSeparatedByString:@":"];
    float hour = [currentDate[0] floatValue];
    float minute = [currentDate[1] floatValue];
    float currentDateIndex = hour*12.0 + minute/5.0;
    
    self.timeLabel.text = (dateFlag && anItem.x>=currentDateIndex) ? [HWFTool getDateStringFromDate:[NSDate date] withFormatter:@"HH:mm"] : chartX;
    
    NSString *defaultText = @"离线";
    if (dateFlag && anItem.x>currentDateIndex) {
        defaultText = @"未知";
    }
//    if ([chartY integerValue]<0) {
//        self.trafficLabel.height = 20;
//        self.trafficLabel.top = 2;
//        [self.trafficLabel setText:[NSString stringWithFormat:@"<font size=18>%@</font>", defaultText]];
//    } else if ([chartY integerValue]<1024*1024) {
//        self.trafficLabel.frame = self.trafficLabelView.bounds;
//        NSArray *unit = [[HWFTools formatKBTraffic:[chartY floatValue]] componentsSeparatedByString:@" "];
//        [self.trafficLabel setText:[NSString stringWithFormat:@"<font size=18>%@</font> <font size=12>%@</font>", unit[0], unit[1]]];
//    } else {
//        self.trafficLabel.frame = self.trafficLabelView.bounds;
//        NSArray *unit = [[HWFTools formatKBTraffic:[chartY floatValue]] componentsSeparatedByString:@" "];
//        [self.trafficLabel setText:[NSString stringWithFormat:@"<font size=16>%@</font> <font size=12>%@</font>", unit[0], unit[1]]];
//    }
    
    if ([chartY integerValue] < 0) {
        self.trafficLabel.text = defaultText;
        self.unitLabel.text = @"";
    } else {
//        NSArray *unitArray = [[HWFTool formatKBTraffic:[chartY floatValue]] componentsSeparatedByString:@" "];
        NSArray *unitArray = [[HWFTool displayTrafficWithUnitKB:[chartY floatValue]] componentsSeparatedByString:@" "];
        self.trafficLabel.text = unitArray[0];
        self.unitLabel.text = unitArray[1];
    }
}

- (IBAction)changeDate:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toggleDateFromDateFlag:)]) {
        [self.delegate toggleDateFromDateFlag:self.dateFlag];
    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    UIColor* strokeColor = [UIColor whiteColor];
//    
//    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
//    [bezierPath moveToPoint: CGPointMake(self.center.x, 0)];
//    [bezierPath addLineToPoint: CGPointMake(self.center.x, self.height)];
//    [strokeColor setStroke];
//    bezierPath.lineWidth = 1;
//    [bezierPath stroke];
}


- (IBAction)doFeedBack:(UIButton *)sender {

    HWFBroadbandMsgFeedBackViewController *broad = [[HWFBroadbandMsgFeedBackViewController alloc]initWithNibName:@"HWFBroadbandMsgFeedBackViewController" bundle:nil];
    [self.viewController.navigationController pushViewController:broad animated:YES];
}


@end
