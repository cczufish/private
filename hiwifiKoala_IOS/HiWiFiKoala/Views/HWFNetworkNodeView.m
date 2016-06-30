//
//  HWFNetworkNodeView.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-16.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFNetworkNodeView.h"

#import "HWFSmartDevice.h"

// 基准视图大小
#define kViewBaseSize CGSizeMake(100.0, 120.0)

// 实际视图大小
#define kViewSize self.bounds.size
// 实际视图中心点
#define kViewCenter CGPointMake(kViewSize.width/2, kViewSize.height/2)


// ICON 中心点
#define kICONCenter CGPointMake(kViewSize.width/2, kViewSize.height/3)
// ICON Radius
#define kICONRadius (kViewSize.height/3)
// ICON Frame
#define kICONFrame CGRectMake(kICONCenter.x-kICONRadius, kICONCenter.y-kICONRadius, kICONRadius*2, kICONRadius*2)


// Extra 中心点
#define kExtraCenter CGPointMake(kICONCenter.x*0.4, kICONCenter.y*0.4)
// Extra Radius
#define kExtraRadius (7.0*self.scale)
// Extra Frame
#define kExtraFrame CGRectMake(kExtraCenter.x-kExtraRadius, kExtraCenter.y-kExtraRadius, kExtraRadius*2, kExtraRadius*2)


// Place 中心点
#define kPlaceCenter CGPointMake(kViewSize.width-(kViewSize.width-kStatusPointViewLength)/2, kViewSize.height/4*3)
// Place 基准大小
#define kPlaceBaseSize CGSizeMake(kViewSize.width-kStatusPointViewLength, kViewSize.height/6)
// Place 字体
#define kPlaceFont [UIFont systemFontOfSize:14.0*self.scale]
// Place 字体颜色
#define kPlaceColor [UIColor whiteColor]


// StatusPointView 边长
#define kStatusPointViewLength (kViewSize.width/12)
// StatusPoint Radius
#define kStatusPointRadius (kStatusPointViewLength/3*2)

// Alias 中心点
#define kAliasCenter CGPointMake(kViewSize.width/2, kViewSize.height/12*11)
// Alias Size
#define kAliasSize CGSizeMake(kViewSize.width, kViewSize.height/6)
// Place 字体
#define kAliasFont [UIFont systemFontOfSize:12.0*self.scale]
// Place 字体颜色
#define kAliasColor [UIColor whiteColor]

//TODO: 闪烁 #F9DC00 alpha=0.3
@interface HWFNetworkNodeView ()

@property (assign, nonatomic) CGFloat scale;

@end

@implementation HWFNetworkNodeView

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
    self.scale = 1.0;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.scale = self.bounds.size.width / kViewBaseSize.width;
}

#pragma mark - Properties
- (void)setNode:(HWFNetworkNode *)node {
    if (_node != node) {
        _node = node;
        
        [self setNeedsDisplay];
    }
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self drawICON];
    
    [self drawPlace];
    
    [self drawAlias];
    
    if (self.node.type == NetworkNodeTypeGatewayRouter) {
        [self drawExtra];
    }
}

- (void)drawICON {
    UIImage *ICON;
    switch (self.node.type) {
        case NetworkNodeTypeWAN: // 互联网
        {
            if (self.state == UIControlStateHighlighted) {
                ICON = [UIImage imageNamed:@"network-active"];
            } else {
                ICON = [UIImage imageNamed:@"network"];
            }
        }
            break;
        case NetworkNodeTypeGatewayRouter: // 网关路由器
        {
            //TODO: 各种类型路由器ICON适配
            if (self.state == UIControlStateHighlighted) {
                ICON = [UIImage imageNamed:@"j2-active"];
            } else {
                ICON = [UIImage imageNamed:@"j2"];
            }
        }
            break;
        case NetworkNodeTypeSmartDevice: // 智能设备
        {
            //TODO: 各种类型智能设备ICON适配
            if (self.state == UIControlStateHighlighted) {
                ICON = [UIImage imageNamed:@"jwx-active"];
            } else {
                ICON = [UIImage imageNamed:@"jwx"];
            }
        }
            break;
        default:
            break;
    }
    
    if (ICON) {
        [ICON drawInRect:kICONFrame];
    }
}

- (void)drawPlace {
    NSString *place;
    switch (self.node.type) {
        case NetworkNodeTypeWAN: // 互联网
        {
            //TODO:
            place = @"互联网";
        }
            break;
        case NetworkNodeTypeGatewayRouter: // 网关路由器
        {
            //TODO:
            place = @"客厅";
        }
            break;
        case NetworkNodeTypeSmartDevice: // 智能设备
        {
            //TODO:
            place = @"主卧";
        }
            break;
        default:
            break;
    }
    
    if (place) {
        CGSize placeSize = [place sizeWithFont:kPlaceFont constrainedToSize:kPlaceBaseSize lineBreakMode:NSLineBreakByWordWrapping];
        CGPoint placePoint = CGPointMake(kPlaceCenter.x-placeSize.width/2, kPlaceCenter.y-placeSize.height/2);

        [kPlaceColor setFill];
        [place drawAtPoint:placePoint withFont:kPlaceFont];
        
        [self drawStatusPointWithPlacePoint:placePoint];
    }
}

- (void)drawStatusPointWithPlacePoint:(CGPoint)placePoint {
    CGPoint statusPointViewCenter = CGPointMake(placePoint.x-kStatusPointViewLength, kPlaceCenter.y);
    
    id nodeEntity = self.node.nodeEntity;

    if ([nodeEntity isKindOfClass:[HWFSmartDevice class]]) {
        //TODO: matchStatus
        if ([(HWFSmartDevice *)nodeEntity matchStatus]) {
            [COLOR_HEX(0x00FF00) setFill];
        } else {
            [COLOR_HEX(0x97CEEC) setFill];
        }
    } else if ([nodeEntity isKindOfClass:[HWFRouter class]]) {
        if ([(HWFRouter *)nodeEntity isOnline]) {
            [COLOR_HEX(0x00FF00) setFill];
        } else {
            [COLOR_HEX(0x97CEEC) setFill];
        }
    }
    
    [[UIBezierPath bezierPathWithArcCenter:statusPointViewCenter radius:kStatusPointRadius startAngle:0 endAngle:2*M_PI clockwise:YES] fill];
}

- (void)drawAlias {
    NSString *alias;
    switch (self.node.type) {
        case NetworkNodeTypeWAN: // 互联网
        {
            alias = @"";
        }
            break;
        case NetworkNodeTypeGatewayRouter: // 网关路由器
        {
            NSString *routerName = ((HWFRouter *)self.node.nodeEntity).name;
            NSString *routerSSID = ((HWFRouter *)self.node.nodeEntity).SSID24G;
            alias = (routerName && !IS_STRING_EMPTY(routerName)) ? routerName : routerSSID;
        }
            break;
        case NetworkNodeTypeSmartDevice: // 智能设备
        {
            NSString *smartDeviceName = ((HWFSmartDevice *)self.node.nodeEntity).name;
            NSString *smartDeviceMAC = [@"极卫星_" stringByAppendingString:[((HWFSmartDevice *)self.node.nodeEntity).standardMAC substringFromIndex:6]];
            alias = (smartDeviceName && !IS_STRING_EMPTY(smartDeviceName)) ? smartDeviceName : smartDeviceMAC;
            
//            alias = ((HWFSmartDevice *)self.node.nodeEntity).name;
        }
            break;
        default:
            break;
    }
    
    if (alias) {
        CGSize aliasSize = [alias sizeWithFont:kAliasFont constrainedToSize:kAliasSize lineBreakMode:NSLineBreakByWordWrapping];
        CGPoint aliasPoint = CGPointMake(kAliasCenter.x-aliasSize.width/2, kAliasCenter.y-aliasSize.height/2);
        
        [kAliasColor setFill];
        [alias drawAtPoint:aliasPoint withFont:kAliasFont];        
    }
}

- (void)drawExtra {
    if ([self.node.nodeEntity isKindOfClass:[HWFRouter class]] && [(HWFRouter *)self.node.nodeEntity isNeedUpgrade]) {
        UIImage *extraImage = [UIImage imageNamed:@"alert"];
        [extraImage drawInRect:kExtraFrame];
    }
}

#pragma mark - Action
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setNeedsDisplay];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setNeedsDisplay];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setNeedsDisplay];
    if ([self isValidTouch:touch]) {
        if (self.clickHandler) {
            self.clickHandler(self);
        }
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    self.highlighted = NO;
    [self setNeedsDisplay];
}

/**
 *  @brief  验证Touch是否有效(在Button范围内)
 *
 *  @param aTouch Touch对象
 *
 *  @return YES:有效 NO:无效
 */
- (BOOL)isValidTouch:(UITouch *)aTouch {
    CGPoint location = [aTouch locationInView:self];
    
    BOOL valid = NO;
    if (location.x >= 0 && location.x <= self.bounds.size.width && location.y >= 0 && location.y <= self.bounds.size.height) {
        valid = YES;
    }
    
    return valid;
}

@end
