//
//  XMGradientProgressView.h
//  XMGradientProgressViewDemo
//
//  Created by dp on 13-12-4.
//  Copyright (c) 2013年 Chief. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMGradientProgressViewDelegate;

typedef void (^XMGradientProgressBlock)(CGFloat progress);

@interface XMGradientProgressView : UIView

@property (weak, nonatomic) id<XMGradientProgressViewDelegate> delegate;
@property (strong, nonatomic) XMGradientProgressBlock progressBlock;

@property (strong, nonatomic) NSArray *tintColors;
@property (strong, nonatomic) UIColor *backColor;
@property (assign, nonatomic) CGFloat borderWidth;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) CGFloat progress;
@property (assign, nonatomic) CGFloat animationDuration;

- (id)initWithFrame:(CGRect)frame backColor:(UIColor *)backColor tintColors:(NSArray *)tintColors borderWidth:(CGFloat)borderWidth lineWidth:(CGFloat)lineWidth animationDuration:(CGFloat)duration;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated progressBlock:(XMGradientProgressBlock)aBlock;

- (void)resetProgress;

- (void)pauseProgress;

@end


@protocol XMGradientProgressViewDelegate <NSObject>

@optional
- (void)xmProgressView:(XMGradientProgressView *)xmProgressView progress:(CGFloat)progress;

@end
