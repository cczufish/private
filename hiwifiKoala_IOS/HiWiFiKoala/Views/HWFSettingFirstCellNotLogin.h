//
//  HWFSettingFirstCellNotLogin.h
//  HiWiFiKoala
//
//  Created by chang hong on 14-10-9.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HWFSettingFirstCellNotLoginDelegate <NSObject>

@optional
- (void)loginButtonClick;

@end

@interface HWFSettingFirstCellNotLogin : UITableViewCell

@property (assign, nonatomic) id <HWFSettingFirstCellNotLoginDelegate> delegate;
@end
