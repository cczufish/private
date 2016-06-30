//
//  HWFCircleView.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-11-3.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFCircleView.h"

@implementation HWFCircleView


- (void)drawRect:(CGRect)rect {
    
    float lineWidth = 5;
    
    
    UIColor* strokeColor7 =  self.acceptColorArr[0];
    UIBezierPath* bezierPath7 = [UIBezierPath bezierPath];
    //yes是顺时针，no是逆时针
    [bezierPath7 addArcWithCenter:CGPointMake(160, 160) radius:106 startAngle:179 *M_PI /180.0  endAngle: 152 *M_PI /180.0 clockwise:NO];
    [strokeColor7 setStroke];
    bezierPath7.lineWidth = lineWidth;
    [bezierPath7 stroke];
    
    UIColor* strokeColor6 =  self.acceptColorArr[1];
    UIBezierPath* bezierPath6 = [UIBezierPath bezierPath];
    //yes是顺时针，no是逆时针
    [bezierPath6 addArcWithCenter:CGPointMake(160, 160) radius:106 startAngle:209 *M_PI /180.0  endAngle: 181 *M_PI /180.0 clockwise:NO];
    [strokeColor6 setStroke];
    bezierPath6.lineWidth = lineWidth;
    [bezierPath6 stroke];
    
    UIColor* strokeColor5 =  self.acceptColorArr[2];
    UIBezierPath* bezierPath5 = [UIBezierPath bezierPath];
    //yes是顺时针，no是逆时针
    [bezierPath5 addArcWithCenter:CGPointMake(160, 160) radius:106 startAngle:239 *M_PI /180.0  endAngle: 211 *M_PI /180.0 clockwise:NO];
    [strokeColor5 setStroke];
    bezierPath5.lineWidth = lineWidth;
    [bezierPath5 stroke];
    
    UIColor* strokeColor4 =  self.acceptColorArr[3];
    UIBezierPath* bezierPath4 = [UIBezierPath bezierPath];
    //yes是顺时针，no是逆时针
    [bezierPath4 addArcWithCenter:CGPointMake(160, 160) radius:106 startAngle: 269*M_PI /180.0  endAngle:  241*M_PI /180.0 clockwise:NO];
    [strokeColor4 setStroke];
    bezierPath4.lineWidth = lineWidth;
    [bezierPath4 stroke];
    
    UIColor* strokeColor3 =  self.acceptColorArr[4];
    UIBezierPath* bezierPath3 = [UIBezierPath bezierPath];
    //yes是顺时针，no是逆时针
    [bezierPath3 addArcWithCenter:CGPointMake(160, 160) radius:106 startAngle:299 *M_PI /180.0  endAngle: 271 *M_PI /180.0 clockwise:NO];
    [strokeColor3 setStroke];
    bezierPath3.lineWidth = lineWidth;
    [bezierPath3 stroke];
    
    UIColor* strokeColor2 =  self.acceptColorArr[5];
    UIBezierPath* bezierPath2 = [UIBezierPath bezierPath];
    //yes是顺时针，no是逆时针
    [bezierPath2 addArcWithCenter:CGPointMake(160, 160) radius:106 startAngle:329 *M_PI /180.0  endAngle: 301*M_PI /180.0 clockwise:NO];
    [strokeColor2 setStroke];
    bezierPath2.lineWidth = lineWidth;
    [bezierPath2 stroke];
    
    UIColor* strokeColor1 =  self.acceptColorArr[6];
    UIBezierPath* bezierPath1 = [UIBezierPath bezierPath];
    //yes是顺时针，no是逆时针
    [bezierPath1 addArcWithCenter:CGPointMake(160, 160) radius:106 startAngle:359 *M_PI /180.0  endAngle: 331 *M_PI /180.0 clockwise:NO];
    [strokeColor1 setStroke];
    bezierPath1.lineWidth = lineWidth;
    [bezierPath1 stroke];
    
    UIColor* strokeColor0 =  self.acceptColorArr[7];
    UIBezierPath* bezierPath0 = [UIBezierPath bezierPath];
    //yes是顺时针，no是逆时针
    [bezierPath0 addArcWithCenter:CGPointMake(160, 160) radius:106 startAngle:28 *M_PI /180.0  endAngle: 1 *M_PI /180.0 clockwise:NO];
    [strokeColor0 setStroke];
    bezierPath0.lineWidth = lineWidth;
    [bezierPath0 stroke];
    
    
    
    
}

@end
