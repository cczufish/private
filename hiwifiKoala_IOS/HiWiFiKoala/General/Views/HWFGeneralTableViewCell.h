//
//  HWFGeneralTableViewCell.h
//  HiWiFiKoala
//
//  Created by dp on 14-10-9.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFTableViewCell.h"

#import "HWFObject.h"

@class HWFGeneralTableViewItem;
@class HWFGeneralTableViewCell;

typedef NS_ENUM(NSInteger, GeneralTableViewCellStyle) {
    GeneralTableViewCellStyleNone = 0,  // 无
    GeneralTableViewCellStyleDesc,    // 说明
    GeneralTableViewCellStyleArrow,  // 箭头
    GeneralTableViewCellStyleDescArrow, // 说明+箭头
    GeneralTableViewCellStyleSwitch, // 开关
    GeneralTableViewCellStyleButton, // 按钮
};

#pragma mark - HWFGeneralTableViewCellDelegate
@protocol HWFGeneralTableViewCellDelegate <NSObject>

@optional
- (void)descButtonClick:(HWFGeneralTableViewCell *)aCell;
- (void)descSwitchChanged:(HWFGeneralTableViewCell *)aCell;

@end

#pragma mark - HWFGeneralTableViewCell
@interface HWFGeneralTableViewCell : HWFTableViewCell

@property (strong, nonatomic) HWFGeneralTableViewItem *item;
@property (assign, nonatomic) id <HWFGeneralTableViewCellDelegate> delegate;

- (void)loadData:(HWFGeneralTableViewItem *)anItem;

@end

#pragma mark - HWFGeneralTableViewItem
@interface HWFGeneralTableViewItem : HWFObject

@property (strong, nonatomic) NSString *identity;
@property (assign, nonatomic) GeneralTableViewCellStyle style;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) NSString *desc;
@property (assign, nonatomic) BOOL isSwitchOn;
@property (assign, nonatomic) NSString *buttonTitle;

- (instancetype)initWithIdentity:(NSString *)identity
                           style:(GeneralTableViewCellStyle)style
                           title:(NSString *)title
                            desc:(NSString *)desc
                        switchOn:(BOOL)isSwitchOn
                     buttonTitle:(NSString *)buttonTitle;

- (instancetype)initWithIdentity:(NSString *)identity
                           style:(GeneralTableViewCellStyle)style
                           title:(NSString *)title
                        subTitle:(NSString *)subTitle
                            desc:(NSString *)desc
                        switchOn:(BOOL)isSwitchOn
                     buttonTitle:(NSString *)buttonTitle;

@end
