//
//  LCLineChartView.m
//  
//
//  Created by Marcel Ruegenberg on 02.08.13.
//
//

#import "LCLineChartView.h"
#import "LCLegendView.h"
#import "LCInfoView.h"
#import "HWFTool.h"
#import "UIViewExt.h"

@interface LCLineChartDataItem ()

@property (readwrite) float x; // should be within the x range
@property (readwrite) float y; // should be within the y range
@property (readwrite) NSString *xLabel; // label to be shown on the x axis
@property (readwrite) NSString *dataLabel; // label to be shown directly at the data item
@property (readwrite) NSInteger xIndex;
@property (readwrite) BOOL dateFlag; // YES:today NO:yesterday

- (id)initWithhX:(float)x y:(float)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel xIndex:(NSInteger)xIndex dateFlag:(BOOL)dateFlag;

@end

@implementation LCLineChartDataItem

- (id)initWithhX:(float)x y:(float)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel xIndex:(NSInteger)xIndex dateFlag:(BOOL)dateFlag {
    if((self = [super init])) {
        self.x = x;
        self.y = y;
        self.xLabel = xLabel;
        self.dataLabel = dataLabel;
        self.xIndex = xIndex;
        self.dateFlag = dateFlag;
    }
    return self;
}

+ (LCLineChartDataItem *)dataItemWithX:(float)x y:(float)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel xIndex:(NSInteger)xIndex dateFlag:(BOOL)dateFlag {
    return [[LCLineChartDataItem alloc] initWithhX:x y:y xLabel:xLabel dataLabel:dataLabel xIndex:xIndex dateFlag:dateFlag];
}

@end



@implementation LCLineChartData

@end



@interface LCLineChartView ()

@property LCLegendView *legendView;
@property LCInfoView *infoView;
@property UIView *currentPosView;
@property UIView *currentPosYView;
@property UILabel *xAxisLabel;
@property UIImageView *rulerImageView;
@property (nonatomic, assign) CGPoint validPos; // 保存最后一个有效位置

- (BOOL)drawsAnyData;

@end


#define X_AXIS_SPACE 16
#define PADDING 0
#define Y_SPACE 30


@implementation LCLineChartView
@synthesize data=_data;

- (void)setDefaultValues {
    self.currentPosView = [[UIView alloc] initWithFrame:CGRectMake(PADDING, 20, 1 / self.contentScaleFactor, self.height-20)];
    self.currentPosView.backgroundColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
    self.currentPosView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.currentPosView.alpha = 0.0;
    [self addSubview:self.currentPosView];
    
    self.currentPosYView = [[UIView alloc] initWithFrame:CGRectMake(PADDING, PADDING, SCREEN_WIDTH, 1 / self.contentScaleFactor)];
    self.currentPosYView.backgroundColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
    self.currentPosYView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.currentPosYView.alpha = 0.0;
    [self addSubview:self.currentPosYView];
    
    self.legendView = [[LCLegendView alloc] init];
    self.legendView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.legendView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.legendView];
    self.legendView.hidden = YES;
    
    self.axisLabelColor = [UIColor grayColor];
    
    self.xAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    self.xAxisLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.xAxisLabel.font = [UIFont boldSystemFontOfSize:10];
    self.xAxisLabel.textColor = self.axisLabelColor;
    self.xAxisLabel.textAlignment = NSTextAlignmentCenter;
    self.xAxisLabel.alpha = 0.0;
    self.xAxisLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.xAxisLabel];
    
    self.backgroundColor = [UIColor whiteColor];
    self.scaleFont = [UIFont systemFontOfSize:10.0];
    
    self.autoresizesSubviews = YES;
    self.contentMode = UIViewContentModeRedraw;
    
    self.drawsDataPoints = YES;
    self.drawsDataLines  = YES;
    
    self.xAxisLabel.hidden = YES;
    
    self.rulerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height-11, SCREEN_WIDTH, 11)];
    self.rulerImageView.image = [UIImage imageNamed:@"timeline"];
    self.rulerImageView.backgroundColor = COLOR_GRAY(236);
    [self addSubview:self.rulerImageView];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super initWithCoder:aDecoder])) {
        [self setDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self setDefaultValues];
    }
    return self;
}

- (void)setAxisLabelColor:(UIColor *)axisLabelColor {
    if(axisLabelColor != _axisLabelColor) {
        [self willChangeValueForKey:@"axisLabelColor"];
        _axisLabelColor = axisLabelColor;
        self.xAxisLabel.textColor = axisLabelColor;
        [self didChangeValueForKey:@"axisLabelColor"];
    }
}

- (void)showLegend:(BOOL)show animated:(BOOL)animated {
    if(! animated) {
        self.legendView.alpha = show ? 1.0 : 0.0;
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.legendView.alpha = show ? 1.0 : 0.0;
    }];
}
                           
- (void)layoutSubviews {
    [self.legendView sizeToFit];
    CGRect r = self.legendView.frame;
    r.origin.x = self.frame.size.width - self.legendView.frame.size.width - 3 - PADDING;
    r.origin.y = 3 + PADDING;
    self.legendView.frame = r;
    
    r = self.currentPosView.frame;
    CGFloat h = self.frame.size.height;
    r.size.height = h - 2 * PADDING;
    self.currentPosView.frame = r;
    
    r = self.currentPosYView.frame;
    CGFloat w = self.frame.size.width;
    r.size.width = w - 2 * PADDING;
    self.currentPosYView.frame = r;
    
    [self.xAxisLabel sizeToFit];
    r = self.xAxisLabel.frame;
    r.origin.y = self.frame.size.height - X_AXIS_SPACE - PADDING + 2;
    self.xAxisLabel.frame = r;
    
    [self bringSubviewToFront:self.legendView];
    
    
    if(! self.infoView) {
        self.infoView = [[LCInfoView alloc] init];
        LCLineChartData *chartData = [self.data firstObject];
        
        self.infoView.infoLabel.text = [NSString stringWithFormat:@"%@", chartData.maxPointText];
        
        CGFloat availableWidth = self.bounds.size.width - 2 * PADDING - self.yAxisLabelsWidth;
        CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE - Y_SPACE;

        CGFloat xStart = PADDING + self.yAxisLabelsWidth;
        CGFloat yStart = PADDING + Y_SPACE;
        CGFloat yRangeLen = self.yMax - self.yMin;
        if(yRangeLen == 0) yRangeLen = 1;
        float xRangeLen = chartData.xMax - chartData.xMin;
        if(xRangeLen == 0) xRangeLen = 1;
        LCLineChartDataItem *datItem = chartData.getData(chartData.maxPointIndex);
        
        CGFloat prevX = xStart + round(((datItem.x - chartData.xMin) / xRangeLen) * availableWidth);
        CGFloat prevY = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
        
        self.infoView.tapPoint = CGPointMake(prevX-5, prevY-6);
        [self.infoView sizeToFit];
        [self.infoView setNeedsLayout];
        [self.infoView setNeedsDisplay];
        [self addSubview:self.infoView];
        
        //        self.infoView.hidden = YES;
        if ([chartData.maxPointText integerValue] <= 0) {
            self.infoView.hidden = YES;
        }
    }
}

- (void)setData:(NSArray *)data {
    if(data != _data) {
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[data count]];
        NSMutableDictionary *colors = [NSMutableDictionary dictionaryWithCapacity:[data count]];
        for(LCLineChartData *dat in data) {
            NSString *key = dat.title;
            if(key == nil) key = @"";
            [titles addObject:key];
            [colors setObject:dat.color forKey:key];
        }
        self.legendView.titles = titles;
        self.legendView.colors = colors;
        
        _data = data;
        
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawScaleLineWithRect:rect];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE - Y_SPACE;
    
    CGFloat availableWidth = self.bounds.size.width - 2 * PADDING - self.yAxisLabelsWidth;
    CGFloat xStart = PADDING + self.yAxisLabelsWidth;
    CGFloat yStart = PADDING + Y_SPACE;
    
    static CGFloat dashedPattern[] = {4,2};
    
    // draw scale and horizontal lines
    CGFloat heightPerStep = self.ySteps == nil || [self.ySteps count] == 0 ? availableHeight : (availableHeight / ([self.ySteps count] - 1));
    
    NSUInteger i = 0;
    CGContextSaveGState(c);
    CGContextSetLineWidth(c, 1.0);
    NSUInteger yCnt = [self.ySteps count];
    for(NSString *step in self.ySteps) {
        [self.axisLabelColor set];
        CGFloat h = [self.scaleFont lineHeight];
        CGFloat y = yStart + heightPerStep * (yCnt - 1 - i);
        // TODO: replace with new text APIs in iOS 7 only version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [step drawInRect:CGRectMake(yStart, y - h / 2, self.yAxisLabelsWidth - 6, h) withFont:self.scaleFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
#pragma clagn diagnostic pop
        
        [[UIColor colorWithWhite:0.9 alpha:1.0] set];
        CGContextSetLineDash(c, 0, dashedPattern, 2);
        CGContextMoveToPoint(c, xStart, round(y) + 0.5);
        CGContextAddLineToPoint(c, self.bounds.size.width - PADDING, round(y) + 0.5);
        CGContextStrokePath(c);
        
        i++;
    }
    
    NSUInteger xCnt = self.xStepsCount;
    if(xCnt > 1) {
        CGFloat widthPerStep = availableWidth / (xCnt - 1);
        
        [[UIColor grayColor] set];
        for(NSUInteger i = 0; i < xCnt; ++i) {
            CGFloat x = xStart + widthPerStep * (xCnt - 1 - i);
            
            [[UIColor colorWithWhite:0.9 alpha:1.0] set];
            CGContextMoveToPoint(c, round(x) + 0.5, PADDING);
            CGContextAddLineToPoint(c, round(x) + 0.5, yStart + availableHeight);
            CGContextStrokePath(c);
        }
    }
    
    CGContextRestoreGState(c);


    if (!self.drawsAnyData) {
        NSLog(@"You configured LineChartView to draw neither lines nor data points. No data will be visible. This is most likely not what you wanted. (But we aren't judging you, so here's your chart background.)");
    } // warn if no data will be drawn
    
    CGFloat yRangeLen = self.yMax - self.yMin;
    if(yRangeLen == 0) yRangeLen = 1;
    for(LCLineChartData *data in self.data) {
        if (self.drawsDataLines) {
            float xRangeLen = data.xMax - data.xMin;
            if(xRangeLen == 0) xRangeLen = 1;
            if(data.itemCount >= 2) {
                LCLineChartDataItem *datItem = data.getData(0);
                CGMutablePathRef path = CGPathCreateMutable();
                CGFloat prevX = xStart + round(((datItem.x - data.xMin) / xRangeLen) * availableWidth);
                CGFloat prevY = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
                CGPathMoveToPoint(path, NULL, prevX, prevY);
                for(NSUInteger i = 1; i < data.itemCount; ++i) {
                    LCLineChartDataItem *datItem = data.getData(i);
                    CGFloat x = xStart + round(((datItem.x - data.xMin) / xRangeLen) * availableWidth);
                    CGFloat y = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
                    CGFloat xDiff = x - prevX;
                    CGFloat yDiff = y - prevY;
                    
//                    NSInteger trafficDataTM = [data.getData(i+1<data.itemCount ? i+1 : i).dataLabel integerValue];
                    NSInteger trafficDataTD = [data.getData(i).dataLabel integerValue];
                    NSInteger trafficDataYS = [data.getData(i-1<0 ? i-1 : i).dataLabel integerValue];
                    
                    if (y > self.height-X_AXIS_SPACE) {
                        y = self.height-X_AXIS_SPACE;
                    }
                    
                    NSArray *currentDate = [[HWFTool getDateStringFromDate:[NSDate date] withFormatter:@"HH:mm"] componentsSeparatedByString:@":"];
                    
                    float hour = [currentDate[0] floatValue];
                    float minute = [currentDate[1] floatValue];
                    
                    NSInteger currentIndex = hour*12 + minute/5;
                    
                    if (!datItem.dataLabel || (datItem.dateFlag && datItem.xIndex>currentIndex && [datItem.dataLabel integerValue]<0)) {
                        // nothing.
                    }
                    else if (xDiff != 0 && trafficDataTD < 0) {
                        CGPathMoveToPoint(path, NULL, x, y);
                        
                        _validPos.x = x;
                        _validPos.y = y;
                    }
                    else if (xDiff != 0 && trafficDataYS < 0) {
                        CGPathMoveToPoint(path, NULL, x, y);
                        
                        _validPos.x = x;
                        _validPos.y = y;
                    }
                    else if (xDiff != 0) {
                        CGFloat xSmoothing = self.smoothPlot ? MIN(30,xDiff) : 0;
                        CGFloat ySmoothing = 0.5;
                        CGFloat slope = yDiff / xDiff;
                        CGPoint controlPt1 = CGPointMake(prevX + xSmoothing, prevY + ySmoothing * slope * xSmoothing);
                        CGPoint controlPt2 = CGPointMake(x - xSmoothing, y - ySmoothing * slope * xSmoothing);
                        CGPathAddCurveToPoint(path, NULL, controlPt1.x, controlPt1.y, controlPt2.x, controlPt2.y, x, y);
                        
                        //                        [self showIndicatorWithPosition:CGPointMake(x, y)];
                        
                        _validPos.x = x;
                        _validPos.y = y;
                    }
                    else {
                        CGPathAddLineToPoint(path, NULL, x, y);
                        
//                        [self showIndicatorWithPosition:CGPointMake(x, y)];
                        _validPos.x = x;
                        _validPos.y = y;
                    }
                    prevX = x;
                    prevY = y;
                }
                
                CGContextAddPath(c, path);
                CGContextSetStrokeColorWithColor(c, [self.backgroundColor CGColor]);
                CGContextSetLineWidth(c, 2);
                CGContextStrokePath(c);
                
                CGContextAddPath(c, path);
                CGContextSetStrokeColorWithColor(c, [data.color CGColor]);
                CGContextSetLineWidth(c, 0.5);
                CGContextStrokePath(c);
                
                CGPathRelease(path);
                
                
                
                
                // 在线 / 离线
                for(NSUInteger i = 0; i < data.itemCount; ++i) {
                    
                    NSArray *currentDate = [[HWFTool getDateStringFromDate:[NSDate date] withFormatter:@"HH:mm"] componentsSeparatedByString:@":"];

                    float hour = [currentDate[0] floatValue];
                    float minute = [currentDate[1] floatValue];
                    float currentDateX = (hour*12.0 + minute/5.0) / 288.0 * SCREEN_WIDTH;
                    
                    
                    LCLineChartDataItem *datItem = data.getData(i);
                    NSInteger trafficDataTD = [datItem.dataLabel integerValue];
                    CGFloat x = xStart + round(((datItem.x - data.xMin) / xRangeLen) * availableWidth);
                    CGFloat pointHeight = 2.0;

                    CGRect rect = CGRectMake(x-self.width/data.itemCount/2, self.height-X_AXIS_SPACE+1, self.width/data.itemCount+((SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))?1.0:2.0), pointHeight);
                    if (datItem.dateFlag && x > currentDateX) {
                        [self drawRectangleWithRect:rect color:COLOR_RGB(218, 237, 232)];
                    } else if (trafficDataTD < 0) {
                        // 离线：画灰线
                        [self drawRectangleWithRect:rect color:COLOR_HEX(0xc6c6c6)];
                    } else {
                        // 在线：画绿线
                        [self drawRectangleWithRect:rect color:data.color];
                    }

                }

            }
            
            
            // 当前时间圆点
            NSArray *currentDate = [[HWFTool getDateStringFromDate:[NSDate date] withFormatter:@"HH:mm"] componentsSeparatedByString:@":"];

            float hour = [currentDate[0] floatValue];
            float minute = [currentDate[1] floatValue] + 10; // 向后推10分钟
            NSInteger currentIndex = hour*12 + minute/5;
            currentIndex = currentIndex>287? 287 : currentIndex; // 避免后推一个小时，造成数组越界，导致程序crash的BUG
            LCLineChartDataItem *datItem = nil; //data.getData(currentIndex);
            for (int i=currentIndex; i>=currentIndex-4; i--) {
                datItem = data.getData(i);
                if ([datItem.dataLabel integerValue] >= 0) {
                    if (datItem.dateFlag) {
                        CGFloat xVal = xStart + round((xRangeLen == 0 ? 0.5 : ((datItem.x - data.xMin) / xRangeLen)) * availableWidth);
                        CGFloat yVal = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
                        
                        [self drawEllipseWithRect:CGRectMake(xVal - 3, yVal - 3, 6, 6) color:COLOR_HEX(0x99CDFF)];
                    }
                    break;
                }
            }
            
            
            [self resetIndicator];
        } // draw actual chart data
        if (self.drawsDataPoints) {
            float xRangeLen = data.xMax - data.xMin;
            if(xRangeLen == 0) xRangeLen = 1;
            for(NSUInteger i = 0; i < data.itemCount; ++i) {
                LCLineChartDataItem *datItem = data.getData(i);

                CGFloat xVal = xStart + round((xRangeLen == 0 ? 0.5 : ((datItem.x - data.xMin) / xRangeLen)) * availableWidth);
                CGFloat yVal = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 3, yVal - 3, 6, 6));
                
                [data.color setFill];
                
                /*
                [self.backgroundColor setFill];
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 5.5, yVal - 5.5, 11, 11));
                [data.color setFill];
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 4, yVal - 4, 8, 8));
                {
                    CGFloat h,s,b,a;
                    if(CGColorGetNumberOfComponents([data.color CGColor]) < 3)
                        [data.color getWhite:&b alpha:&a];
                    else
                        [data.color getHue:&h saturation:&s brightness:&b alpha:&a];
                    if(b <= 0.5)
                        [[UIColor whiteColor] setFill];
                    else
                        [[UIColor blackColor] setFill];
                }
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 2, yVal - 2, 4, 4));
                 */
            } // for
        } // draw data points
    }
}

- (void)drawScaleLineWithRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* strokeColor = [UIColor lightGrayColor];
    
    float lineWidth = 0.25;
    
    UIBezierPath* bezierPath1 = [UIBezierPath bezierPath];
    [bezierPath1 moveToPoint:CGPointMake(0, 20.5)];
    [bezierPath1 addLineToPoint:CGPointMake(rect.size.width, 20.5)];
    [strokeColor setStroke];
    bezierPath1.lineWidth = lineWidth;
    [bezierPath1 stroke];
    
    UIBezierPath* bezierPath2 = [UIBezierPath bezierPath];
    [bezierPath2 moveToPoint:CGPointMake(0, 20.5+23)];
    [bezierPath2 addLineToPoint:CGPointMake(rect.size.width, 20.5+23)];
    [strokeColor setStroke];
    bezierPath2.lineWidth = lineWidth;
    [bezierPath2 stroke];
    
    UIBezierPath* bezierPath3 = [UIBezierPath bezierPath];
    [bezierPath3 moveToPoint:CGPointMake(0, 20.5+23*2)];
    [bezierPath3 addLineToPoint:CGPointMake(rect.size.width, 20.5+23*2)];
    [strokeColor setStroke];
    bezierPath3.lineWidth = lineWidth;
    [bezierPath3 stroke];
    
    UIBezierPath* bezierPath4 = [UIBezierPath bezierPath];
    [bezierPath4 moveToPoint:CGPointMake(0, 20.5+23*3)];
    [bezierPath4 addLineToPoint:CGPointMake(rect.size.width, 20.5+23*3)];
    [strokeColor setStroke];
    bezierPath4.lineWidth = lineWidth;
    [bezierPath4 stroke];
}

// 绘制矩形
- (void)drawRectangleWithRect:(CGRect)rect color:(UIColor *)color {
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 在当前路径下添加一个矩形路径
	CGContextAddRect(ctx, rect);
    // 设置试图的当前填充色
	CGContextSetFillColorWithColor(ctx, color.CGColor);
    // 绘制当前路径区域
	CGContextFillPath(ctx);
}

// 绘制椭圆
- (void)drawEllipseWithRect:(CGRect)rect color:(UIColor *)color {
    
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
	CGContextRef ctx = UIGraphicsGetCurrentContext();

    // 在当前路径下添加一个椭圆路径
	CGContextAddEllipseInRect(ctx, rect);
    
    // 设置当前视图填充色
	CGContextSetFillColorWithColor(ctx, color.CGColor);
    
    // 绘制当前路径区域
	CGContextFillPath(ctx);
}

- (void)resetIndicator
{
    LCLineChartData *chartData = [self.data firstObject];
    
    if (chartData.getData(0).dateFlag) {
        NSArray *currentDate = [[HWFTool getDateStringFromDate:[NSDate date] withFormatter:@"HH:mm"] componentsSeparatedByString:@":"];
        
        float hour = [currentDate[0] floatValue];
        float minute = [currentDate[1] floatValue] + 10; // 向后推10分钟
        
        NSInteger currentIndex = hour*12 + minute/5;
        currentIndex = currentIndex>287? 287 : currentIndex; // 避免后推一个小时，造成数组越界，导致程序crash的BUG
        LCLineChartDataItem *datItem = nil; //data.getData(currentIndex);
        BOOL isBluePointShow = NO;
        for (int i=currentIndex; i>=currentIndex-4; i--) {
            datItem = ((LCLineChartData *)[self.data firstObject]).getData(i);
            if ([datItem.dataLabel integerValue] >=  0) {
                float posX = i / 288.0 * SCREEN_WIDTH;
                [self showIndicatorWithPosition:CGPointMake(posX, self.validPos.y)];
                isBluePointShow = YES;
                break;
            }
        }
        
        if (!isBluePointShow) {
            datItem = ((LCLineChartData *)[self.data firstObject]).getData(currentIndex);
            float posX = currentIndex / 288.0 * SCREEN_WIDTH;
            [self showIndicatorWithPosition:CGPointMake(posX, self.validPos.y)];
        }
    } else {
        CGFloat availableWidth = self.bounds.size.width - 2 * PADDING - self.yAxisLabelsWidth;
        CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE - Y_SPACE;
        
        CGFloat xStart = PADDING + self.yAxisLabelsWidth;
        CGFloat yStart = PADDING + Y_SPACE;
        CGFloat yRangeLen = self.yMax - self.yMin;
        if(yRangeLen == 0) yRangeLen = 1;
        float xRangeLen = chartData.xMax - chartData.xMin;
        if(xRangeLen == 0) xRangeLen = 1;
        LCLineChartDataItem *datItem = chartData.getData(chartData.maxPointIndex);
        
        CGFloat prevX = xStart + round(((datItem.x - chartData.xMin) / xRangeLen) * availableWidth);
        CGFloat prevY = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
        
        [self showIndicatorWithPosition:CGPointMake(prevX, prevY)];
    }
    
    
    
    self.currentPosView.hidden = YES;
    self.currentPosYView.hidden = YES;
    
//    [self showIndicatorWithPosition:self.validPos];
}

//- (void)showIndicatorForTouch:(UITouch *)touch {
//    CGPoint pos = [touch locationInView:self];
//    [self showIndicatorWithPosition:pos];
//}

- (void)showIndicatorWithPosition:(CGPoint)pos
{
    self.currentPosView.hidden = NO;
    self.currentPosYView.hidden = NO;
    
    CGFloat xStart = PADDING + self.yAxisLabelsWidth;
    CGFloat yStart = PADDING;
    CGFloat yRangeLen = self.yMax - self.yMin;
    if(yRangeLen == 0) yRangeLen = 1;
    CGFloat xPos = pos.x - xStart;
    CGFloat yPos = pos.y - yStart;
    CGFloat availableWidth = self.bounds.size.width - 2 * PADDING - self.yAxisLabelsWidth;
    CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE - Y_SPACE;
    
    LCLineChartDataItem *closest = nil;
    float minDist = FLT_MAX;
    float minDistY = FLT_MAX;
    CGPoint closestPos = CGPointZero;
    
    for(LCLineChartData *data in self.data) {
        float xRangeLen = data.xMax - data.xMin;
        
        
        NSUInteger targetIndex = ((xPos<0?0:xPos)/SCREEN_WIDTH)*288;

        for(NSUInteger i = (targetIndex<=10?0:targetIndex-10); i < (targetIndex+10>=288?288:targetIndex+10); ++i) {
            LCLineChartDataItem *datItem = data.getData(i);
            CGFloat xVal = round((xRangeLen == 0 ? 0.5 : ((datItem.x - data.xMin) / xRangeLen)) * availableWidth);
            CGFloat yVal = round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
            
            float dist = fabsf(xVal - xPos);
            float distY = fabsf(yVal - yPos);
            if(dist < minDist || (dist == minDist && distY < minDistY)) {
                minDist = dist;
                minDistY = distY;
                closest = datItem;
                closestPos = CGPointMake(xStart + xVal - 3, yStart + yVal);
            }
        }
    }

    NSArray *currentDate = [[HWFTool getDateStringFromDate:[NSDate date] withFormatter:@"HH:mm"] componentsSeparatedByString:@":"];

    float hour = [currentDate[0] floatValue];
    float minute = [currentDate[1] floatValue];
    
    NSInteger currentIndex = hour*12 + minute/5;
    
    if (!closest.dataLabel || (closest.dateFlag && closest.xIndex>currentIndex && [closest.dataLabel integerValue]<0)) {
        [self showIndicatorWithPosition:self.validPos];
        return;
    } else {
        _chartItemText(closest, closest.dataLabel);
    }
    
    if ([closest.dataLabel integerValue] < 0) {
        self.currentPosYView.hidden = YES;
    } else {
        self.currentPosYView.hidden = NO;
    }
    
//    if(self.currentPosView.alpha == 0.0) {
//        CGRect r = self.currentPosView.frame;
//        r.origin.x = closestPos.x + 3 - 0.5;
//        self.currentPosView.frame = r;
//    }
//    
//    if(self.currentPosYView.alpha == 0.0) {
//        CGRect r = self.currentPosYView.frame;
//        r.origin.y = closestPos.y - Y_SPACE;
//        self.currentPosYView.frame = r;
//    }
    
//    self.infoView.tapPoint = CGPointMake(closest.x, 50);
//    [self.infoView setNeedsLayout];
//    [self.infoView setNeedsDisplay];
    
    [UIView animateWithDuration:0.1 animations:^{
//        self.infoView.alpha = 1.0;
        self.currentPosView.alpha = 1.0;
        self.currentPosYView.alpha = 1.0;
        self.xAxisLabel.alpha = 1.0;
        
        CGRect r = self.currentPosView.frame;
        r.origin.x = closestPos.x + 3;
        self.currentPosView.frame = r;
        
        r = self.currentPosYView.frame;
        r.origin.y = closestPos.y + Y_SPACE;
        self.currentPosYView.frame = r;
        
//        self.xAxisLabel.text = closest.xLabel;
//        if(self.xAxisLabel.text != nil) {
//            [self.xAxisLabel sizeToFit];
//            r = self.xAxisLabel.frame;
//            r.origin.x = round(closestPos.x - r.size.width / 2);
//            self.xAxisLabel.frame = r;
//        }
    }];
}

- (void)hideIndicator {
    [UIView animateWithDuration:0.1 animations:^{
//        self.infoView.alpha = 0.0;
        self.currentPosView.alpha = 0.0;
        self.currentPosYView.alpha = 0.0;
        self.xAxisLabel.alpha = 0.0;
    }];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self showIndicatorForTouch:[touches anyObject]];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self showIndicatorForTouch:[touches anyObject]];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
////    [self hideIndicator];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
////    [self hideIndicator];
//}


#pragma mark Helper methods

- (BOOL)drawsAnyData {
    return self.drawsDataPoints || self.drawsDataLines;
}

// TODO: This should really be a cached value. Invalidated iff ySteps changes.
- (CGFloat)yAxisLabelsWidth {
    float maxV = 0;
    for(NSString *label in self.ySteps) {
        CGSize labelSize = [label sizeWithFont:self.scaleFont];
        if(labelSize.width > maxV) maxV = labelSize.width;
    }
    return maxV + PADDING;
}

- (void)setChartItemText:(void (^) (LCLineChartDataItem *anItem, NSString *aText))aChartItemText
{
    _chartItemText = aChartItemText;
}

@end
