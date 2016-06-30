//
//  HWFDeviceHistoryDetailViewController.h
//  HiWiFi
//
//  Created by dp on 14-5-15.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

//#import "HWFBaseViewController.h"
#import "HWFViewController.h"
#import "HWFDeviceListModel.h"

//@protocol HWFDeviceHistoryDetailViewControllerDelegate <NSObject>
//
//@optional
//- (void)refreshDeviceList;
//
//// 供消息中心刷新设备名称
//- (void)reloadDeviceName:(NSString *)newDeviceName;
//
//@end

@interface HWFDeviceHistoryDetailViewController : HWFViewController

//@property (assign, nonatomic) id<HWFDeviceHistoryDetailViewControllerDelegate> delegate;

@property (strong, nonatomic)HWFDeviceListModel *acceptDeviceModel;
@property (strong, nonatomic)NSString *acceptNPStr;
@property (strong, nonatomic)NSString *acceptRouterIpStr;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil deviceModel:(HWFDeviceListModel *)aDeviceModel dateFlag:(BOOL)dateFlag;

/**
 *  暂时仅供消息中心调用的初始化方法
 *
 *  @param nibNameOrNil         nib
 *  @param nibBundleOrNil       bundle
 *  @param rid                  路由器rid
 *  @param deviceName           设备名称
 *  @param deviceMAC            设备MAC(大写，无冒号)
 *  @param aSourceIdentifier    调用来源，消息中心调用时固定传"MessageCenter"
 *
 *  @return 对象实例
 */
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil routerId:(NSInteger)rid deviceName:(NSString *)aDeviceName deviceMAC:(NSString *)aDeviceMAC sourceIdentifier:(NSString *)aSourceIdentifier delegate:(id<HWFDeviceHistoryDetailViewControllerDelegate>)delegate;

@end
