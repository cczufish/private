//
//  HWFGatewayRouterCell.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWFGatewayRouterCell : UITableViewCell

- (void)loadDataWithInfo:(NSString *)infoStr;

@property (nonatomic,strong)NSString *identifier;

@end
