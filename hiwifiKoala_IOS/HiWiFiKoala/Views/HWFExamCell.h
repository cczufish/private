//
//  HWFExamCell.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-11-7.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWFExamCell;

@protocol HWFExamCellDelegate <NSObject>

@optional
- (void)buttonClick:(HWFExamCell *)aCell;

@end




#pragma mark - HWFExamItem

typedef NS_ENUM(NSInteger, ExamItemStyle) {
    ExamItemDescSafe,  //安全,说明
    ExamItemDescUnSafe //不安全,说明,剪头
};

@interface HWFExamItem : HWFObject

@property (nonatomic,assign) ExamItemStyle examStyle;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) UIColor *descColor;
@property (nonatomic,strong) NSString *identifier;

- (instancetype)initWithMessage:(NSString *)message andWithDesc:(NSString *)desc andWithExamType:(ExamItemStyle)type withIdentifier:(NSString *)identifier withDescColor:(UIColor *)color;

@end




@interface HWFExamCell : UITableViewCell

@property (nonatomic,assign) id<HWFExamCellDelegate>delegate;
@property (nonatomic,strong)HWFExamItem *examItem;
- (void)loadWithExamItem:(HWFExamItem *)examItem;

@end


