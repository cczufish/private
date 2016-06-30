//
//  HWFTopologyView.h
//  HiWiFiKoala
//
//  Created by dp on 14-10-17.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWFNetworkNode;
@class HWFTopologyView;

@protocol HWFTopologyViewDelegate <NSObject>

- (void)networkNodeClick:(HWFNetworkNode *)node;

@end

@interface HWFTopologyView : UIView

@property (assign, nonatomic) id < HWFTopologyViewDelegate> delegate;
@property (strong, nonatomic) HWFNetworkNode *root; // 根节点
@property (strong, nonatomic) NSArray        *leaves; // 叶子节点(数组)
@property (assign, nonatomic) CGFloat        scale; // 缩放比例

/**
 *  @brief  重置布局
 */
- (void)reload;

/**
 *  @brief  刷新布局
 */
- (void)refresh;

- (CGRect)actualBounds;

@end
