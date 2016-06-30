//
//  XMLineChartView.m
//  HiWiFi
//
//  Created by dp on 14-3-13.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import "XMChartView.h"

#import "XMChartModel.h"

@interface XMLineChartView ()

@property (assign, nonatomic) CGFloat scale;
@property (strong, nonatomic) CAShapeLayer *lineLayer;
@property (assign, nonatomic) CGPathRef linePath;

@property (strong, nonatomic) CAShapeLayer *pointLayer;
@property (assign, nonatomic) CGPathRef pointPath;

@property (strong, nonatomic) CAShapeLayer *barLayer;
@property (assign, nonatomic) CGPathRef barPath;

@property (strong, nonatomic) UIView *indicatorViewX;
@property (strong, nonatomic) UIView *indicatorViewY;

@end

@implementation XMLineChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.scale = 1.0;
    self.lineLayer = [CAShapeLayer layer];
    self.pointLayer = [CAShapeLayer layer];
    self.barLayer = [CAShapeLayer layer];
    
    [self.layer addSublayer:self.lineLayer];
    [self.layer addSublayer:self.pointLayer];
    [self.layer addSublayer:self.barLayer];
    
    self.lineColor = [UIColor greenColor];
    self.lineWidth = 1.0;
    self.pointColor = [UIColor darkGrayColor];
    self.pointRadius = 2.0;
    self.minY = 0;
    self.maxY = 100;
    self.totalX = -1;
    self.edge = UIEdgeInsetsZero;
}

- (void)layoutSubviews
{
    if (!self.indicatorViewX) {
        self.indicatorViewX = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.5)];
        self.indicatorViewX.backgroundColor = self.indicatorColor;
        self.indicatorViewX.hidden = YES;
        [self addSubview:self.indicatorViewX];
    }
    
    if (!self.indicatorViewY) {
        self.indicatorViewY = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.bounds.size.height)];
        self.indicatorViewY.backgroundColor = self.indicatorColor;
        self.indicatorViewY.hidden = YES;
        [self addSubview:self.indicatorViewY];
    }
}

- (void)refreshChartView
{
    [self otherInitDataWithMaxFlagRefresh:YES];
    
    if (self.type == XMChartViewTypeBar || self.type == XMChartViewTypeBoth) {
        [self drawBar];
    }
    
    if (self.type == XMChartViewTypeLine || self.type == XMChartViewTypeBoth) {
        [self drawLine];
    }
    
    if (self.isPointDisplay) {
        [self drawPoint];
    }
    
    [self setNeedsDisplay];
}

- (void)otherInitDataWithMaxFlagRefresh:(BOOL)isMaxFlagRefresh
{
    self.totalX = (self.totalX==-1) ? [self.dataSource count] : self.totalX;
    
    // fix dateSource
    if ([self.dataSource count] > self.totalX) {
        [self.dataSource removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.dataSource count]-self.totalX)]];
    } else if ([self.dataSource count] < self.totalX) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i=0; i<self.totalX-[self.dataSource count]; i++) {
            XMChartModel *chartModel = [[XMChartModel alloc] init];
            chartModel.dataX = i;
            chartModel.dataY = XMChartModelDataYNil;
            chartModel.displayX = nil;
            chartModel.displayY = nil;
            [tempArray addObject:chartModel];
        }
        [self.dataSource addObjectsFromArray:tempArray];
    }
    
    if (isMaxFlagRefresh) {
        
        float minData = [(XMChartModel *)[self.dataSource firstObject] dataY];
        float maxData = [(XMChartModel *)[self.dataSource firstObject] dataY];
        
        for (XMChartModel *chartModel in self.dataSource) {
            if (chartModel.dataY < minData) {
                minData = chartModel.dataY;
            }
            
            if (chartModel.dataY > maxData) {
                maxData = chartModel.dataY;
            }
        }
        
        self.minY = (minData < self.minY) ? minData : self.minY;
        self.maxY = (maxData > self.maxY) ? maxData : self.maxY;
    }
}

- (void)refreshWithAppendChartModel:(XMChartModel *)aChartModel
{
    [self.dataSource addObject:aChartModel];
    
    [self otherInitDataWithMaxFlagRefresh:YES];
    
    if (self.type == XMChartViewTypeBar || self.type == XMChartViewTypeBoth) {
        [self drawBar];
    }
    
    if (self.type == XMChartViewTypeLine || self.type == XMChartViewTypeBoth) {
        [self drawLine];
    }
    
    if (self.isPointDisplay) {
        [self drawPoint];
    }
    
    [self setNeedsDisplay];
}

#pragma mark - 连线
- (CGPathRef)loadLinePath
{
    CGFloat width = self.bounds.size.width - self.edge.left - self.edge.right;
    CGFloat height = self.bounds.size.height - self.edge.top - self.edge.bottom;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    int i=0;
    for (XMChartModel *chartModel in self.dataSource) {
        XMChartModel *chartModelPrev = (i==0) ? nil : [self.dataSource objectAtIndex:(i-1)];
        
        if (i==0 || chartModel.dataY==XMChartModelDataYNil || chartModelPrev.dataY==XMChartModelDataYNil) {
            CGPathMoveToPoint(path, NULL, (width/(self.totalX-1))*i+self.edge.left, height-((chartModel.dataY-self.minY)/(self.maxY-self.minY))*height+self.edge.top-self.statusLineWidth);
        } else if (chartModel.dataY!=XMChartModelDataYNil && chartModelPrev.dataY!=XMChartModelDataYNil) {
            CGPathAddLineToPoint(path, NULL, (width/(self.totalX-1))*i+self.edge.left, height-((chartModel.dataY-self.minY)/(self.maxY-self.minY))*height+self.edge.top-self.statusLineWidth);
        }
        
        i++;
    }
    
    CGAffineTransform t = CGAffineTransformMakeScale(self.scale, self.scale);
    CGPathRef retPath = CGPathCreateCopyByTransformingPath(path, &t);
    CGPathRelease(path);
    return retPath;
}

- (void)drawLine
{
    CGPathRelease(self.linePath);
    self.linePath = [self loadLinePath];
    self.lineLayer.path = self.linePath;
    self.lineLayer.strokeColor = self.lineColor.CGColor;
    self.lineLayer.fillColor   = [UIColor clearColor].CGColor;
    self.lineLayer.lineCap   = kCALineCapRound;
    self.lineLayer.lineJoin  = kCALineJoinRound;
    self.lineLayer.position = CGPointMake(self.bounds.size.width*(1-self.scale)/2, self.bounds.size.width*(1-self.scale)/2);
    self.lineLayer.lineWidth = self.lineWidth;
//    self.lineLayer.speed = 0.5;
    self.lineLayer.strokeEnd = 1.0;
    
//    [self performSelector:@selector(drawLineAnimationStart) withObject:nil afterDelay:0.0];
}

- (void)drawLineAnimationStart
{
    self.lineLayer.strokeEnd = 1.0;
}

#pragma mark - 画柱状图
- (CGPathRef)loadBarPath
{
    CGFloat width = self.bounds.size.width - self.edge.left - self.edge.right;
    CGFloat height = self.bounds.size.height - self.edge.top - self.edge.bottom;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    int i=0;
    for (XMChartModel *chartModel in self.dataSource) {
        CGPathMoveToPoint(path, NULL, (width/(self.totalX-1))*i+self.edge.left, self.bounds.size.height-self.edge.bottom-self.statusLineHeight);
        
        if (chartModel.dataY != XMChartModelDataYNil && chartModel.dataY != 0) {
            CGFloat pointY = height-((chartModel.dataY-self.minY)/(self.maxY-self.minY))*height+self.edge.top-self.statusLineWidth;
            
            if ((self.bounds.size.height-self.edge.bottom-self.statusLineHeight) - pointY < 1) {
                pointY = (self.bounds.size.height-self.edge.bottom-self.statusLineHeight) - 1;
            }
            
            CGPathAddLineToPoint(path, NULL, (width/(self.totalX-1))*i+self.edge.left, pointY);
        }
        
        i++;
    }
    
    CGAffineTransform t = CGAffineTransformMakeScale(self.scale, self.scale);
    CGPathRef retPath = CGPathCreateCopyByTransformingPath(path, &t);
    CGPathRelease(path);
    return retPath;
}

- (void)drawBar
{
    CGPathRelease(self.barPath);
    self.barPath = [self loadBarPath];
    self.barLayer.path = self.barPath;
    self.barLayer.strokeColor = self.barColor.CGColor;
    self.barLayer.fillColor   = [UIColor clearColor].CGColor;
//    self.barLayer.lineCap   = kCALineCapSquare;
//    self.barLayer.lineJoin  = kCALineJoinBevel;
    self.barLayer.position = CGPointMake(self.bounds.size.width*(1-self.scale)/2, self.bounds.size.width*(1-self.scale)/2);
    self.barLayer.lineWidth = self.barWidth;
//    self.barLayer.speed = 0.5;
    self.barLayer.strokeEnd = 1.0;
    
//    [self performSelector:@selector(drawBarAnimationStart) withObject:nil afterDelay:0.0];
}

- (void)drawBarAnimationStart
{
    self.barLayer.strokeEnd = 1.0;
}

#pragma mark - 画点
- (CGPathRef)loadPointPath
{
    CGFloat width = self.bounds.size.width - self.edge.left - self.edge.right;
    CGFloat height = self.bounds.size.height - self.edge.top - self.edge.bottom;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    int i=0;
    for (XMChartModel *chartModel in self.dataSource) {
        if (chartModel.dataY != XMChartModelDataYNil) {
            CGPathAddEllipseInRect(path, NULL, CGRectMake((width/(self.totalX-1))*i+self.edge.left-self.pointRadius, height-(chartModel.dataY/(self.maxY-self.minY))*height+self.edge.top-self.pointRadius, self.pointRadius*2, self.pointRadius*2));
        }
        
        i++;
    }
    
    CGAffineTransform t = CGAffineTransformMakeScale(self.scale, self.scale);
    CGPathRef retPath = CGPathCreateCopyByTransformingPath(path, &t);
    CGPathRelease(path);
    return retPath;
}

- (void)drawPoint
{
    CGPathRelease(self.pointPath);
    self.pointPath = [self loadPointPath];
    self.pointLayer.path = self.pointPath;
    self.pointLayer.strokeColor = self.pointColor.CGColor;
    self.pointLayer.fillColor   = self.pointColor.CGColor;
    self.pointLayer.lineCap   = kCALineCapRound;
    self.pointLayer.lineJoin  = kCALineJoinRound;
    self.pointLayer.position = CGPointMake(self.bounds.size.width*(1-self.scale)/2, self.bounds.size.width*(1-self.scale)/2);
    self.pointLayer.lineWidth = 0.0;
//    self.pointLayer.speed = 0.1;
    self.pointLayer.strokeEnd = 1.0;
}

#pragma mark - Indicator
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self showIndicatorWithTouch:[touches anyObject]];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self showIndicatorWithTouch:[touches anyObject]];
//}

// 根据touch显示Indicator
- (void)showIndicatorWithTouch:(UITouch *)touch
{
    CGPoint touchLocation = [touch locationInView:self];
    
    [self showIndicatorWithPosition:[self fixPosition:touchLocation]];
}

// 根据坐标显示Indicator
- (void)showIndicatorWithPosition:(CGPoint)position
{
    XMChartModel *touchChartModel = [self chartModelWithPosition:position];
    if (touchChartModel.dataY < 0) {
        self.indicatorViewX.hidden = YES;
        self.indicatorViewY.hidden = YES;
    } else {
        self.indicatorViewX.hidden = NO;
        self.indicatorViewY.hidden = NO;
    }
    
    self.indicatorViewX.center = CGPointMake(self.indicatorViewX.center.x, position.y);
    self.indicatorViewY.center = CGPointMake(position.x+self.lineWidth/2, self.indicatorViewY.center.y);
}

// 修正坐标
- (CGPoint)fixPosition:(CGPoint)position
{
    CGFloat width = self.bounds.size.width - self.edge.left - self.edge.right;
    CGFloat height = self.bounds.size.height - self.edge.top - self.edge.bottom;
    
    NSInteger touchIndex = [self indexWithPosition:position];
    
    return CGPointMake((width/(self.totalX-1))*touchIndex+self.edge.left-self.pointRadius, height-([self chartModelWithIndex:touchIndex].dataY/(self.maxY-self.minY))*height+self.edge.top-self.pointRadius);
}

// 根据坐标换算Index
- (NSInteger)indexWithPosition:(CGPoint)position
{
    return (int)(position.x / self.bounds.size.width * self.totalX);
}

// 根据Index获取对应的ChartModel
- (XMChartModel *)chartModelWithIndex:(NSInteger)index
{
    return [self.dataSource objectAtIndex:index];
}

// 根据坐标获取对应的ChartModel
- (XMChartModel *)chartModelWithPosition:(CGPoint)position
{
    return [self.dataSource objectAtIndex:[self indexWithPosition:position]];
}

// 绘制矩形
- (void)drawRectangleWithRect:(CGRect)rect color:(UIColor *)color {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextAddRect(ctx, rect);
	CGContextSetFillColorWithColor(ctx, color.CGColor);
	CGContextFillPath(ctx);
}

// 绘制椭圆
- (void)drawEllipseWithRect:(CGRect)rect color:(UIColor *)color {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextAddEllipseInRect(ctx, rect);
	CGContextSetFillColorWithColor(ctx, color.CGColor);
	CGContextFillPath(ctx);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGFloat width = self.bounds.size.width - self.edge.left - self.edge.right;
//    CGFloat height = self.bounds.size.height - self.edge.top - self.edge.bottom;
    
    int i=0;
    for (XMChartModel *chartModel in self.dataSource) {
        CGRect statusRect = CGRectMake((width/(self.totalX-1))*i+self.edge.left-self.statusLineWidth/2, self.bounds.size.height-self.edge.bottom-self.statusLineHeight, self.statusLineWidth, self.statusLineHeight);
        
//        if (datItem.dateFlag && x > currentDateX) {
//            [self drawRectangleWithRect:rect color:[UIColor whiteColor]];
//        } else
        if (chartModel.dataY < 0) {
            // 离线：画灰线
            [self drawRectangleWithRect:statusRect color:self.statusOffColor];
        } else {
            // 在线：画绿线
            [self drawRectangleWithRect:statusRect color:self.statusOnColor];
        }
        
        i++;
    }
    
    UIColor* strokeColor = COLOR_GRAY(178);
    
    float lineWidth = 0.25;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, rect.size.height-lineWidth)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height-lineWidth)];
    [strokeColor setStroke];
    bezierPath.lineWidth = lineWidth;
    [bezierPath stroke];
}


@end
