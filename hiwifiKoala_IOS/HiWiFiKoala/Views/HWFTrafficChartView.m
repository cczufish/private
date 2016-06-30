//
//  HWFTrafficChartView.m
//  HiWiFi
//
//  Created by dp on 14-3-31.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import "HWFTrafficChartView.h"

#import "LCLineChartView.h"
#import "HWFTool.h"

@interface HWFTrafficChartView ()
{
    LCLineChartData *_statisticsData;
}

@property (strong, nonatomic) LCLineChartView *statisticsLineChartView;

@end

@implementation HWFTrafficChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setup
{
    self.trafficData = [[NSMutableArray alloc] init];
    _statisticsData = [LCLineChartData new];
}

- (void)layoutSubviews
{
    self.backgroundColor = COLOR_RGB(218, 237, 232);
}

- (void)reloadWithChartDict:(NSDictionary *)aChartDict dateFlag:(BOOL)aDateFlag
{
    [self.trafficData removeAllObjects];
    [self.trafficData setArray:[aChartDict objectForKey:@"trafficData"]];
    
    self.pointCount = [[aChartDict objectForKey:@"pointCount"] unsignedIntegerValue];
    
    NSLog(@"%ld",self.pointCount);
    
    self.maxPointIndex = [[aChartDict objectForKey:@"maxPointIndex"] integerValue];
    self.maxTraffic = [[aChartDict objectForKey:@"maxTraffic"] floatValue];
    self.maxPointY = [[aChartDict objectForKey:@"maxPointY"] floatValue];
    self.dateFlag = aDateFlag;
    
    _statisticsData.xMin = 0;
    _statisticsData.xMax = 288;
    _statisticsData.title = @"";
    _statisticsData.color = COLOR_HEX(0x2ECDA5);
    _statisticsData.itemCount = self.pointCount;
    
    _statisticsData.maxPoint = self.maxTraffic;
    _statisticsData.maxPointIndex = self.maxPointIndex;
    _statisticsData.maxPointText = [NSString stringWithFormat:@"%@", [HWFTool displayTrafficWithUnitKB:self.maxTraffic]];
    
    __weak typeof(self) weakSelf = self;
    _statisticsData.getData = ^(NSUInteger item) {
        float posX ;
        posX = (([@(item) floatValue]) / ([@(weakSelf.pointCount) floatValue])) * weakSelf.pointCount;
        
        float posY = CGFLOAT_MAX;
        
        NSString *labelTextX = [NSString stringWithFormat:@"%02d:%02d", item/12, (item%12)*5];
        NSString *labelTextY = @"-1";
        
        if (weakSelf.maxPointIndex != -1) {
            posY = [[weakSelf.trafficData objectAtIndex:item] floatValue];
            
            labelTextX = [NSString stringWithFormat:@"%02d:%02d", item/12, (item%12)*5];
            labelTextY = [NSString stringWithFormat:@"%.1f", [[weakSelf.trafficData objectAtIndex:item] floatValue]];
        }
        //        NSLog(@"posX:%.2f, posY:%.2f, xLabel:%@, yLabel:%@", posX, posY, labelTextX, labelTextY);
        return [LCLineChartDataItem dataItemWithX:posX y:posY xLabel:labelTextX dataLabel:labelTextY xIndex:item dateFlag:weakSelf.dateFlag];
    };
    
    

    if (!_statisticsData) {
        return;
    }
    
    if (!self.statisticsLineChartView) {
//        self.statisticsLineChartView = [[LCLineChartView alloc] initWithFrame:self.bounds];
        self.statisticsLineChartView = [[LCLineChartView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, 128)];
        [self addSubview:self.statisticsLineChartView];
    }
    
    self.statisticsLineChartView.yMin = 0;
    self.statisticsLineChartView.yMax = self.maxTraffic;
    self.statisticsLineChartView.ySteps = nil;
    self.statisticsLineChartView.data = @[_statisticsData];
    self.statisticsLineChartView.drawsDataPoints = NO;
    self.statisticsLineChartView.backgroundColor = [UIColor backgroundColorForDeviceHistoryChart];
    
    [self.statisticsLineChartView setChartItemText:^(LCLineChartDataItem *anItem, NSString *aText) {
        if ([weakSelf.delegate respondsToSelector:@selector(refreshCallbackWithTrafficChartView:chartItem:)]) {
            [weakSelf.delegate performSelector:@selector(refreshCallbackWithTrafficChartView:chartItem:) withObject:weakSelf withObject:anItem];
        }
    }];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.statisticsLineChartView addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPressGesture.minimumPressDuration = 0.1;
    [self addGestureRecognizer:longPressGesture];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(gestureRecognizerBegan)]) {
        [self.delegate performSelector:@selector(gestureRecognizerBegan)];
        
        CGPoint location = [gestureRecognizer locationInView:self.statisticsLineChartView];
        float offsetX = (location.x-SCREEN_WIDTH*0.5)/SCREEN_WIDTH*0.5 * SCREEN_WIDTH*0.3;
        
        [self.statisticsLineChartView showIndicatorWithPosition:CGPointMake(location.x + offsetX, location.y)];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if ([self.delegate respondsToSelector:@selector(gestureRecognizerBegan)]) {
                [self.delegate performSelector:@selector(gestureRecognizerBegan)];
            }
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint location = [gestureRecognizer locationInView:self.statisticsLineChartView];
            float offsetX = (location.x-SCREEN_WIDTH*0.5)/SCREEN_WIDTH*0.5 * SCREEN_WIDTH*0.3;
            
            [self.statisticsLineChartView showIndicatorWithPosition:CGPointMake(location.x + offsetX, location.y)];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
            break;
        default:
            break;
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if ([self.delegate respondsToSelector:@selector(gestureRecognizerBegan)]) {
                [self.delegate performSelector:@selector(gestureRecognizerBegan)];
            }
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint location = [gestureRecognizer locationInView:self.statisticsLineChartView];
            float offsetX = (location.x-SCREEN_WIDTH*0.5)/SCREEN_WIDTH*0.5 * SCREEN_WIDTH*0.3;
            
            [self.statisticsLineChartView showIndicatorWithPosition:CGPointMake(location.x + offsetX, location.y)];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
            break;
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
