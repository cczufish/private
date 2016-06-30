//
//  HWFViewController.h
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HWFBadgeView.h"

typedef NS_ENUM(NSInteger, HWFTipType) {
    HWFTipTypeSuccess = 1,  // 对号
    HWFTipTypeMessage = 2,  // 无ICON
    HWFTipTypeWarning = 3,  // 叹号
    HWFTipTypeFailure = 4,  // 叉号
    HWFTipTypeError = 5,    // 报错，需要用户点击确定
};

@interface HWFViewController : UIViewController

@property (readonly, nonatomic) UIButton *leftBarButton;
@property (readonly, nonatomic) UIButton *rightBarButton;
@property (readonly, nonatomic) HWFBadgeView *rightBarButtonBadgeView;

/**
 *  @brief  展示提醒，除类型[HWFTipTypeError]外，自动消失；[HWFTipTypeError]表现形式是AlertView，其他为HUD
 *
 *  @param type    提醒类型
 *  @param code    错误码 没有传 CODE_NIL
 *  @param message 提醒消息内容
 */
- (void)showTipWithType:(HWFTipType)type code:(NSInteger)code message:(NSString *)message;

/**
 *  @brief  展现HUD浮层提醒，自定义View，自动消失
 *
 *  @param aCustomView 自定义View
 *  @param code        错误码 没有传CODE_NIL
 *  @param message     提醒消息内容
 */
- (void)showTipWithCustomView:(UIView *)aCustomView code:(NSInteger)code message:(NSString *)message;

/**
 *  @brief  显示loadingView
 */
- (void)loadingViewShow;

/**
 *  @brief  隐藏loadingView
 */
- (void)loadingViewHide;

/**
 *  @brief  全量隐藏loadingView
 */
- (void)loadingViewAllHide;

#pragma mark - NavigationBar
/**
 *  @brief  增加按钮到导航栏左侧
 *
 *  @param image        按钮图片
 *  @param activeImage  活跃状态按钮图片
 *  @param title        按钮标题(image==nil时有效)
 *  @param target       target
 *  @param action       action
 */
- (void)addLeftBarButtonItemWithImage:(UIImage *)image activeImage:(UIImage *)activeImage title:(NSString *)title target:(id)target action:(SEL)action;

/**
 *  @brief  增加按钮到导航栏右侧
 *
 *  @param image        按钮图片
 *  @param activeImage  活跃状态按钮图片
 *  @param title        按钮标题(image==nil时有效)
 *  @param target       target
 *  @param action       action
 */
- (void)addRightBarButtonItemWithImage:(UIImage *)image activeImage:(UIImage *)activeImage title:(NSString *)title target:(id)target action:(SEL)action;

/**
 *  @brief  增加返回按钮到导航栏左侧
 */
- (void)addBackBarButtonItem;

@end
