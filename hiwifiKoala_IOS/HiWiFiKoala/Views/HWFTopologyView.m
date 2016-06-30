//
//  HWFTopologyView.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-17.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFTopologyView.h"

#import "HWFNetworkNode.h"
#import "HWFSmartDevice.h"

#import "HWFNetworkNodeView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

// 基准视图大小
#define kViewBaseSize CGSizeMake(self.bounds.size.width*self.scale, self.bounds.size.height*self.scale)
// 视图边界
#define kEdgeInset UIEdgeInsetsMake(20.0*self.scale, 0.0*self.scale, 40.0*self.scale, 0.0*self.scale)
// 实际视图大小
#define kViewSize CGSizeMake(kViewBaseSize.width-kEdgeInset.left-kEdgeInset.right, kViewBaseSize.height-kEdgeInset.top-kEdgeInset.bottom)

// WAN NetworkNode View Y轴偏移量
#define WANOffsetY 20.0*self.scale

// 实际视图中心点(视图 中1/3 中心点)
#define kViewCenter CGPointMake((self.bounds.size.width/2+(kEdgeInset.left-kEdgeInset.right)), (self.bounds.size.height/2+(kEdgeInset.top-kEdgeInset.bottom)))
// 视图 上1/3 中心点
#define kViewCenter_UP_1_3 CGPointMake(kViewCenter.x, kViewCenter.y-kViewSize.height/3+WANOffsetY)
// 视图 下1/3 中心点
#define kViewCenter_DOWN_1_3 CGPointMake(kViewCenter.x, kViewCenter.y+kViewSize.height/3)

// 视图 上半部分 中心点
#define kViewCenter_UP_1_2 CGPointMake(kViewCenter.x, kViewCenter.y-kViewSize.height/4)
// 视图 下半部分 中心点
#define kViewCenter_DOWN_1_2 CGPointMake(kViewCenter.x, kViewCenter.y+kViewSize.height/4)


// NetworkNodeView 基准大小
#define kNetworkNodeViewBaseSize CGSizeMake(100.0*self.scale*self.scale, 120.0*self.scale*self.scale)
// NetworkNodeView 横向间隔
#define kNetworkNodeViewHorizontalGap 10.0*self.scale

//// 视图 左下1/3 中心点
//#define kViewCenter_Left_DOWN_1_3 CGPointMake(kViewCenter.x-kViewSize.width/3, kViewCenter_DOWN_1_3.y)
//// 视图 中下1/3 中心点
//#define kViewCenter_Middle_DOWN_1_3 CGPointMake(kViewCenter.x, kViewCenter_DOWN_1_3.y)
//// 视图 右下1/3 中心点
//#define kViewCenter_Right_DOWN_1_3 CGPointMake(kViewCenter.x+kViewSize.width/3, kViewCenter_DOWN_1_3.y)

//// 视图 左下1/2 中心点
//#define kViewCenter_Left_DOWN_1_2 CGPointMake(kViewCenter.x-kViewSize.width/4, kViewCenter_DOWN_1_3.y)
//// 视图 右下1/2 中心点
//#define kViewCenter_Right_DOWN_1_2 CGPointMake(kViewCenter.x-kViewSize.width/4, kViewCenter_DOWN_1_3.y)

//// 视图 左下1/4 中心点
//#define kViewCenter_Left_DOWN_1_4 CGPointMake(kViewCenter.x-kViewSize.width/8*3, kViewCenter_DOWN_1_3.y)
//// 视图 左下2/4 中心点
//#define kViewCenter_Left_DOWN_2_4 CGPointMake(kViewCenter.x-kViewSize.width/8, kViewCenter_DOWN_1_3.y)
//// 视图 右下1/4 中心点
//#define kViewCenter_Right_DOWN_1_4 CGPointMake(kViewCenter.x+kViewSize.width/8, kViewCenter_DOWN_1_3.y)
//// 视图 右下2/4 中心点
//#define kViewCenter_Right_DOWN_2_4 CGPointMake(kViewCenter.x+kViewSize.width/8*3, kViewCenter_DOWN_1_3.y)


@interface HWFTopologyView()

@property (strong, nonatomic) HWFNetworkNode *WANNode;
@property (assign, nonatomic) NSUInteger verticalCount;
@property (assign, nonatomic) NSUInteger horizontalCount;

@property (strong, nonatomic) HWFNetworkNodeView *WANNodeView;
@property (strong, nonatomic) HWFNetworkNodeView *rootNodeView;
@property (strong, nonatomic) NSMutableArray *leafNodeViewArray;

@end

@implementation HWFTopologyView

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    self.leafNodeViewArray = [[NSMutableArray alloc] init];
    self.scale = 1.0;
}

#pragma mark - Properties
- (void)setRoot:(HWFNetworkNode *)root {
    if (_root != root) {
        _root = root;
        
        _WANNode = [[HWFNetworkNode alloc] init];
        _WANNode.type = NetworkNodeTypeWAN;
        _WANNode.nodeEntity = root.nodeEntity; //TODO:
        
        [self setNeedsDisplay];
    }
}

- (void)setLeaves:(NSArray *)leaves {
    if (_leaves != leaves) {
        _leaves = leaves;
        
        [self setNeedsDisplay];
    }
}

- (void)setScale:(CGFloat)scale {
    if (_scale != scale) {
        _scale = scale;
    }
    
    [self reload];
}

#pragma mark - 布局
- (void)layoutWAN {
    self.WANNodeView = [[HWFNetworkNodeView alloc] init];
    
    self.WANNodeView.frame = CGRectMake(0, 0, kNetworkNodeViewBaseSize.width, kNetworkNodeViewBaseSize.height);
    self.WANNodeView.center = [self WANNodeCenter];
    self.WANNodeView.backgroundColor = [UIColor clearColor];
    self.WANNodeView.node = self.WANNode;
    __weak typeof(self) weakSelf = self;
    self.WANNodeView.clickHandler = ^(HWFNetworkNodeView *sender){
        if ([weakSelf.delegate respondsToSelector:@selector(networkNodeClick:)]) {
            [weakSelf.delegate performSelector:@selector(networkNodeClick:) withObject:sender.node];
        }
    };
    
    if ([(HWFRouter *)self.WANNode.nodeEntity isOnline]) {
        self.WANNodeView.alpha = 1.0;
    } else {
        self.WANNodeView.alpha = 0.5;
    }
    
    [self addSubview:self.WANNodeView];
}

- (void)layoutRoot {
    self.rootNodeView = [[HWFNetworkNodeView alloc] init];
    
    self.rootNodeView.frame = CGRectMake(0, 0, kNetworkNodeViewBaseSize.width, kNetworkNodeViewBaseSize.height);
    self.rootNodeView.center = [self gatewayRouterNodeCenter];
    self.rootNodeView.backgroundColor = [UIColor clearColor];
    
    self.rootNodeView.node = self.root;
    __weak typeof(self) weakSelf = self;
    self.rootNodeView.clickHandler = ^(HWFNetworkNodeView *sender){
        if ([weakSelf.delegate respondsToSelector:@selector(networkNodeClick:)]) {
            [weakSelf.delegate performSelector:@selector(networkNodeClick:) withObject:sender.node];
        }
    };
    
    if ([(HWFRouter *)self.root.nodeEntity isOnline]) {
        self.rootNodeView.alpha = 1.0;
    } else {
        self.rootNodeView.alpha = 0.5;
    }
    
    [self addSubview:self.rootNodeView];
}

- (void)layoutLeaves {
    int index = 0;
    for (HWFNetworkNode *leaf in self.leaves) {
        HWFNetworkNodeView *leafNodeView = [[HWFNetworkNodeView alloc] init];
        
        leafNodeView.frame = CGRectMake(0, 0, kNetworkNodeViewBaseSize.width, kNetworkNodeViewBaseSize.height);
        leafNodeView.center = [self smartDeviceNodeCenterWithIndex:index];
        leafNodeView.backgroundColor = [UIColor clearColor];
        
        leafNodeView.node = leaf;
        leafNodeView.clickHandler = ^(HWFNetworkNodeView *sender){
            if ([self.delegate respondsToSelector:@selector(networkNodeClick:)]) {
                [self.delegate performSelector:@selector(networkNodeClick:) withObject:sender.node];
            }
        };
        
        //TODO: matchStatus
        if ([(HWFSmartDevice *)leaf.nodeEntity matchStatus]) {
            leafNodeView.alpha = 1.0;
        } else {
            leafNodeView.alpha = 0.5;
        }
        
        [self addSubview:leafNodeView];
        
        [self.leafNodeViewArray addObject:leafNodeView];
        
        index++;
    }
}

#pragma mark - Drawing
- (void)reload {
    self.WANNodeView = nil;
    self.rootNodeView = nil;
    [self.leafNodeViewArray removeAllObjects];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (self.leaves && self.leaves.count>0) {
        self.verticalCount = 3;
        self.horizontalCount = self.leaves.count;
    } else {
        self.verticalCount = 2;
        self.horizontalCount = 0;
    }
    
    [self layoutWAN];
    
    [self layoutRoot];
    
    [self layoutLeaves];
    
    [self setNeedsDisplay];
    
//    // iOS 8.0 以下: 监控self.bounds的改变，如果有变化，则调用refresh方法刷新布局
//    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
//        [RACObserve(self, bounds) subscribeNext:^(id x) {
//            [self refresh];
//        }];
//    }
}

- (void)refresh {
    if (self.bounds.size.height <= 500 && self.bounds.size.height > 450) {
        self.scale = 0.8;
    } else if (self.bounds.size.height <= 450) {
        self.scale = 0.7;
    } else {
        self.scale = 1.0;
    }
    
    self.WANNodeView.center = [self WANNodeCenter];
    
    self.rootNodeView.center = [self gatewayRouterNodeCenter];
    
    int index = 0;
    for (HWFNetworkNodeView *smartDeviceNodeView in self.leafNodeViewArray) {
        smartDeviceNodeView.center = [self smartDeviceNodeCenterWithIndex:index];
        index++;
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.root) {
        [self drawLineBetweenPointA:CGPointMake(self.WANNodeView.center.x, self.WANNodeView.center.y-kNetworkNodeViewBaseSize.height/5) andPointB:self.rootNodeView.center isDash:NO];
        
        for (HWFNetworkNodeView *smartDeviceNodeView in self.leafNodeViewArray) {
            HWFSmartDevice *smartDevice = (HWFSmartDevice *)smartDeviceNodeView.node.nodeEntity;
            //TODO: matchStatus定义
            [self drawLineBetweenPointA:self.rootNodeView.center andPointB:smartDeviceNodeView.center isDash:!smartDevice.matchStatus];
        }
    }
}

/**
 *  两点划线
 *
 *  @param pointA 起点
 *  @param pointB 终点
 */
- (void)drawLineBetweenPointA:(CGPoint)pointA andPointB:(CGPoint)pointB isDash:(BOOL)isDash {
    pointA.y += kNetworkNodeViewBaseSize.height/2 + kNetworkNodeViewHorizontalGap;
    pointB.y -= kNetworkNodeViewBaseSize.height/2 + kNetworkNodeViewHorizontalGap;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef startColor = [UIColor HWFBlueColor].CGColor;
    CGColorRef endColor = [UIColor whiteColor].CGColor;
    CGFloat lineWidth = .5;
    
    if (pointA.x == pointB.x && pointB.y < self.rootNodeView.center.y) {
        drawLinearGradient(context, lineWidth, pointA, pointB, @[ @(.05), @(.5), @(.95) ], @[ (__bridge id)startColor, (__bridge id)endColor, (__bridge id)startColor ]);
    } else {
        drawLinearGradient(context, lineWidth, pointA, CGPointMake(pointA.x, (pointA.y+pointB.y)/2), @[ @(.05), @(.5) ], @[ (__bridge id)startColor, (__bridge id)endColor ]);

        {
            [[UIColor whiteColor] set];
            UIBezierPath *fullLine = [UIBezierPath bezierPath];
            [fullLine moveToPoint:CGPointMake(pointA.x, (pointA.y+pointB.y)/2)];
            [fullLine addLineToPoint:CGPointMake(pointB.x, (pointA.y+pointB.y)/2)];
            [fullLine stroke];
        }
        
        if (isDash) { // 虚线
            [[UIColor whiteColor] set];
            UIBezierPath *dashLine = [UIBezierPath bezierPath];
            [dashLine moveToPoint:CGPointMake(pointB.x, (pointA.y+pointB.y)/2)];
            [dashLine addLineToPoint:pointB];
            double dashPattern[] = {2, 2};
            [dashLine setLineDash:dashPattern count:2 phase:1];
            [dashLine stroke];
        } else {
            drawLinearGradient(context, lineWidth, CGPointMake(pointB.x, (pointA.y+pointB.y)/2), pointB, @[ @(.5), @(.95) ], @[ (__bridge id)endColor, (__bridge id)startColor ]);
        }
    }
}

void drawLinearGradient(CGContextRef context,
                        CGFloat lineWidth,
                        CGPoint startPoint,
                        CGPoint endPoint,
                        NSArray *locations,
                        NSArray *colors) {
    CGFloat x = (startPoint.x < endPoint.x) ? startPoint.x : endPoint.x;
    CGFloat y = (startPoint.y < endPoint.y) ? startPoint.y : endPoint.y;
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    if (startPoint.x == endPoint.x) {
        width = lineWidth;
        height = (startPoint.y > endPoint.y) ? startPoint.y : endPoint.y;
    } else if (startPoint.y == endPoint.y) {
        width = (startPoint.x > endPoint.x) ? startPoint.x : endPoint.x;
        height = lineWidth;
    }
    CGRect rangeRect = CGRectMake(x, y, width, height);
    
//    CGFloat locations[] = { .05, .5, .95 }; //颜色所在位置
//    NSArray *colors = @[ (__bridge id)startColor, (__bridge id)endColor, (__bridge id)startColor ];
    
    CGFloat cfLocations[locations.count];
    int i = 0;
    for (NSNumber *location in locations) {
        cfLocations[i] = [location floatValue];
        i++;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, cfLocations);//构造渐变
    
    CGContextSaveGState(context);//保存状态，主要是因为下面用到裁剪。用完以后恢复状态。不影响以后的绘图
    CGContextAddRect(context, rangeRect);//设置绘图的范围
    CGContextClip(context);//裁剪
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);//绘制渐变效果图
    CGContextRestoreGState(context);//恢复状态
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

#pragma mark - Layout
- (CGPoint)WANNodeCenter {
    return kViewCenter_UP_1_3;
}

- (CGPoint)gatewayRouterNodeCenter {
    return kViewCenter;
}

- (CGPoint)smartDeviceNodeCenterWithIndex:(int)idx {
    CGPoint nodePoint;
    nodePoint.y = kViewCenter_DOWN_1_3.y;
    
    if (self.leaves.count % 2 == 0) { // 偶数
        float middleIndex = (int)(self.leaves.count / 2) - 0.5;
        nodePoint.x = kViewCenter_DOWN_1_3.x + (CGFloat)(idx - middleIndex)*(kNetworkNodeViewBaseSize.width + kNetworkNodeViewHorizontalGap);
    } else { // 奇数
        int middleIndex = (int)(self.leaves.count / 2);
        nodePoint.x = kViewCenter_DOWN_1_3.x + (CGFloat)(idx - middleIndex)*(kNetworkNodeViewBaseSize.width + kNetworkNodeViewHorizontalGap);
    }
    
    return nodePoint;
}

- (CGRect)actualBounds {
    CGRect theActualBounds = CGRectZero;
    
    theActualBounds.size.width = self.rootNodeView.bounds.size.width;

    if (self.leafNodeViewArray && self.leafNodeViewArray.count>0) {
        HWFNetworkNodeView *leafNodeView = self.leafNodeViewArray.firstObject;
        theActualBounds.size.height = leafNodeView.center.y - self.WANNodeView.center.y;
        if (self.leafNodeViewArray.count > 1) {
            HWFNetworkNodeView *firstLeafNodeView = self.leafNodeViewArray.firstObject;
            HWFNetworkNodeView *lastLeafNodeView = self.leafNodeViewArray.firstObject;
            theActualBounds.size.width = lastLeafNodeView.center.x - firstLeafNodeView.center.x;
        }
    } else {
        theActualBounds.size.height = self.rootNodeView.center.y - self.WANNodeView.center.y;
    }
    
    return theActualBounds;
}

@end
