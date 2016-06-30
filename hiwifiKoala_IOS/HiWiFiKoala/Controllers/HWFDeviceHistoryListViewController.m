//
//  HWFDeviceHistoryListViewController.m
//  HiWiFi
//
//  Created by dp on 14-5-12.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import "HWFDeviceHistoryListViewController.h"
#import "XMPullingRefreshTableView.h"
#import "HWFTrafficHeaderView.h"
#import "HWFDeviceInfoCell.h"
#import "HWFQosViewController.h"
#import "HWFDeviceHistoryDetailViewController.h"
#import "UIViewExt.h"
#import "HWFService+Router.h"
#import "HWFDeviceListModel.h"
#import "HWFDeviceHistoryDetailViewController.h"
#import "HWFDeviceListModel.h"
#import "HWFDeviceDetailViewController.h"
#import "HWFBlackListViewController.h"

#define TAG_TODAY_TABLEVIEW 120
#define TAG_YESTERDAY_TABLEVIEW 121

@interface HWFDeviceHistoryListViewController () <UITableViewDataSource,
                                                  UITableViewDelegate,
                                                  XMPullingRefreshTableViewDelegate,
                                                  HWFDeviceInfoCellDelegate,
                                                  UITextFieldDelegate,
                                                  HWFTrafficHeaderViewDelegate,
                                                  HWFDeviceDetailViewControllerDelegate,
                                                  HWFRecoverDeviceViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (strong, nonatomic) XMPullingRefreshTableView *tdListTableView;
@property (strong, nonatomic) XMPullingRefreshTableView *ysListTableView;
@property (weak, nonatomic) XMPullingRefreshTableView *currentPullingRefreshTableView;
@property (strong, nonatomic) HWFTrafficHeaderView *tdListHeaderView;
@property (strong, nonatomic) HWFTrafficHeaderView *ysListHeaderView;

@property (strong, nonatomic) NSMutableArray *tdListDataSource;
@property (strong, nonatomic) NSMutableDictionary *tdTrafficDataSource;
@property (strong, nonatomic) NSMutableArray *ysListDataSource;
@property (strong, nonatomic) NSMutableDictionary *ysTrafficDataSource;

@property (strong, nonatomic) NSArray *pushDevices;
@property (strong, nonatomic) NSString *pushAction;
@property (strong, nonatomic) NSString *pushTitle;
@property (assign, nonatomic) BOOL isPush;

@property (strong, nonatomic) UILabel *blockCloseLabel;

@property (strong, nonatomic) UIButton *maskButton;

@property (strong, nonatomic) IBOutlet UIView *aliasNameView;
@property (weak, nonatomic) IBOutlet UITextField *aliasNameField;
@property (weak, nonatomic) IBOutlet UIButton *renameButton;
@property (assign, nonatomic) BOOL isAliasNameViewShow;

@property (strong, nonatomic) UIView *guideView;

@property (strong, nonatomic) HWFDeviceListModel *currentDevice;

@property (strong, nonatomic) NSTimer *refreshDeviceListTimer;

@property (assign, nonatomic) NSTimeInterval loadListDataInterval;

@property (assign, nonatomic) NSInteger focusCellIndex;

@property (assign, nonatomic) BOOL isGetTrafficFinish;
@property (assign, nonatomic) BOOL isGetListFinish;

//新增加  - NP，IP
@property (strong, nonatomic)NSString *npStr;
@property (strong, nonatomic)NSString *routerIpStr;

//今昨在线设备
@property (assign, nonatomic)NSInteger tdOnlineDeviceCount;
@property (assign, nonatomic)NSInteger ydOnlineDeviceCount;

@end

@implementation HWFDeviceHistoryListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    [self initView];
    //折线条
    [self loadTrafficData];
    [self loadDeviceListithLoadingFlag:YES];
    
    //NP信息
    [self getCurrentRouterNP];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self stopTimer];
}

- (void)startTimer
{
    if (!self.refreshDeviceListTimer) {
        self.refreshDeviceListTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(loadDeviceListithLoadingFlag:) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer
{
    if (self.refreshDeviceListTimer) {
        [self.refreshDeviceListTimer invalidate];
        self.refreshDeviceListTimer = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    // 读取缓存数据
//    NSDate *deviceHistoryArchivedDate = __APP_DELEGATE.deviceHistoryArchivedDate;
//    if ([[NSDate date] timeIntervalSince1970] - [deviceHistoryArchivedDate timeIntervalSince1970] <= 10*60) { // 10分钟内
//        self.tdListDataSource = __APP_DELEGATE.deviceHistoryTdListCache;
//        self.ysListDataSource = __APP_DELEGATE.deviceHistoryYsListCache;
//        self.tdTrafficDataSource = __APP_DELEGATE.deviceHistoryTdTrafficCache;
//        self.ysTrafficDataSource = __APP_DELEGATE.deviceHistoryYsTrafficCache;
//        
//        __APP_DELEGATE.deviceHistoryTdListCache = nil;
//        __APP_DELEGATE.deviceHistoryYsListCache = nil;
//        __APP_DELEGATE.deviceHistoryTdTrafficCache = nil;
//        __APP_DELEGATE.deviceHistoryYsTrafficCache = nil;
//        __APP_DELEGATE.deviceHistoryArchivedDate = nil;
//        
//        [self reloadListData];
//    }
}

- (void)initData
{
    self.focusCellIndex = -1;
    
    self.tdListDataSource = [[NSMutableArray alloc] init];
    self.tdTrafficDataSource = [[NSMutableDictionary alloc] init];
    
    self.ysListDataSource = [[NSMutableArray alloc] init];
    self.ysTrafficDataSource = [[NSMutableDictionary alloc] init];
}

- (void)initView
{
    if (self.isPush && self.pushTitle && ![self.pushTitle isEqualToString:@""]) {
        self.title = self.pushTitle;
    } else {
        self.title = @"我查查";
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName:[UIColor whiteColor] };
    }
    
    UIView *blockCloseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 84, 44)];
    blockCloseView.backgroundColor = [UIColor clearColor];
    
    self.blockCloseLabel = [[UILabel alloc] initWithFrame:blockCloseView.bounds];
    self.blockCloseLabel.backgroundColor = [UIColor clearColor];
    self.blockCloseLabel.textColor = [UIColor whiteColor];
    self.blockCloseLabel.font = [UIFont systemFontOfSize:16.0];
    self.blockCloseLabel.textAlignment = NSTextAlignmentRight;
    self.blockCloseLabel.text = @"黑名单";
    [blockCloseView addSubview:self.blockCloseLabel];
    
    UIButton *blockCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    blockCloseButton.frame = blockCloseView.bounds;
    blockCloseView.backgroundColor = [UIColor clearColor];
    [blockCloseView addSubview:blockCloseButton];
    [blockCloseButton addTarget:self action:@selector(doBlockClose:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *blockCloseBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:blockCloseView];
    self.navigationItem.rightBarButtonItem = blockCloseBarButtonItem;
    
    [self.baseView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20-44)];
    [self.baseView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1]];

    // 返回
    [self addBackBarButtonItem];

    self.tdListTableView = [[XMPullingRefreshTableView alloc] initWithFrame:(self.baseView.bounds) pullingDelegate:self];
    self.tdListTableView.delegate = self;
    self.tdListTableView.dataSource = self;
    self.tdListTableView.headerOnly = YES;
    self.tdListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tdListTableView.tag = TAG_TODAY_TABLEVIEW;
    self.tdListTableView.backgroundColor = [UIColor whiteColor];
    [self.baseView addSubview:self.tdListTableView];
    
    self.ysListTableView = [[XMPullingRefreshTableView alloc] initWithFrame:(self.baseView.bounds) pullingDelegate:self];
    self.ysListTableView.center = CGPointMake(-SCREEN_WIDTH/2, self.baseView.center.y);
    self.ysListTableView.delegate = self;
    self.ysListTableView.dataSource = self;
    self.ysListTableView.headerOnly = YES;
    self.ysListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ysListTableView.tag = TAG_YESTERDAY_TABLEVIEW;
    self.ysListTableView.backgroundColor = [UIColor whiteColor];
    [self.baseView addSubview:self.ysListTableView];
    
    self.tdListHeaderView = [HWFTrafficHeaderView instanceView];
    self.tdListHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 128.0+48.0+39.0);
    self.tdListHeaderView.delegate = self;
    self.tdListTableView.tableHeaderView = self.tdListHeaderView;
    
    self.ysListHeaderView = [HWFTrafficHeaderView instanceView];
    self.ysListHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 128.0+48.0+39.0);
    self.ysListHeaderView.delegate = self;
    self.ysListTableView.tableHeaderView = self.ysListHeaderView;

    
    self.ysListTableView.hidden = YES;
    self.currentPullingRefreshTableView = self.tdListTableView;
    
    [self.aliasNameView setCenter:CGPointMake((self.view.width)/2, (-1*(self.aliasNameView.height)/2))];
    [self.view addSubview:self.aliasNameView];
    
    self.aliasNameField.delegate = self;
    
    [self.renameButton setBackgroundImage:[[UIImage imageNamed:@"Speed_BtnTop01.9.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.renameButton setBackgroundImage:[[UIImage imageNamed:@"Speed_BtnTop02.9.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    
    self.maskButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.maskButton.frame = self.baseView.bounds;
    self.maskButton.backgroundColor = [UIColor blackColor];
    self.maskButton.alpha = 0.0;
    self.maskButton.hidden = YES;
    [self.maskButton addTarget:self action:@selector(hideAliasNameViewAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:self.maskButton];
}

- (void)loadTrafficData
{
    self.loadListDataInterval = [[NSDate date] timeIntervalSince1970];
    [self loadingViewShow];
    // 日线(总)
   [[HWFService defaultService] loadRouterTrafficHistoryDetailWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
       [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            self.isGetTrafficFinish = YES;
            NSDictionary *appData = data;
            
            if (![appData objectForKey:@"cnt"] || ![appData objectForKey:@"day_list"]) {
                return;
            }
            
            float tdMax = [appData objectForKey:@"day_list"][0] ? [[[appData objectForKey:@"day_list"][0] valueForKeyPath:@"@max.floatValue"] floatValue] : -1;
            float ysMax = [appData objectForKey:@"day_list"][1] ? [[[appData objectForKey:@"day_list"][1] valueForKeyPath:@"@max.floatValue"] floatValue] : -1;
            
            NSInteger tdMaxIndex = tdMax<0 ? -1 : [[appData objectForKey:@"day_list"][0] indexOfObject:@(tdMax)];
            NSInteger ysMaxIndex = ysMax<0 ? -1 : [[appData objectForKey:@"day_list"][1] indexOfObject:@(ysMax)];
            
            float maxPointY = (tdMax>=ysMax) ? tdMax : ysMax;
            
            NSMutableDictionary *tdChartDict = [NSMutableDictionary dictionary];
            [tdChartDict setObject:@(([appData objectForKey:@"cnt"]) ? [[appData objectForKey:@"cnt"] unsignedIntegerValue] : 288) forKey:@"pointCount"];
            [tdChartDict setObject:@(tdMaxIndex) forKey:@"maxPointIndex"];
            [tdChartDict setObject:[appData objectForKey:@"day_list"][0] forKey:@"trafficData"];
            [tdChartDict setObject:@(tdMax) forKey:@"maxTraffic"];
            [tdChartDict setObject:@(maxPointY) forKey:@"maxPointY"];
            [self.tdTrafficDataSource setDictionary:tdChartDict];
            
            NSMutableDictionary *ysChartDict = [NSMutableDictionary dictionary];
            [ysChartDict setObject:@([[appData objectForKey:@"cnt"] unsignedIntegerValue]) forKey:@"pointCount"];
            [ysChartDict setObject:@(ysMaxIndex) forKey:@"maxPointIndex"];
            [ysChartDict setObject:[appData objectForKey:@"day_list"][1] forKey:@"trafficData"];
            [ysChartDict setObject:@(ysMax) forKey:@"maxTraffic"];
            [tdChartDict setObject:@(maxPointY) forKey:@"maxPointY"];
            [self.ysTrafficDataSource setDictionary:ysChartDict];
            
            if (self.isGetTrafficFinish && self.isGetListFinish) {
               
                [self reloadListData];
                
                [self showGuideView];
                
                [self archivedData];
            }
	    } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

- (void)archivedData
{
//    __APP_DELEGATE.deviceHistoryTdListCache = self.tdListDataSource;
//    __APP_DELEGATE.deviceHistoryYsListCache = self.ysListDataSource;
//    __APP_DELEGATE.deviceHistoryTdTrafficCache = self.tdTrafficDataSource;
//    __APP_DELEGATE.deviceHistoryYsTrafficCache = self.ysTrafficDataSource;
//    __APP_DELEGATE.deviceHistoryArchivedDate = [NSDate date];
}

#pragma mark - 调用连接设备列表实时接口刷新数据
- (void)loadDeviceListithLoadingFlag:(BOOL)aLoadingFlag
{
    __block BOOL isGetListFinish = NO;
    if (aLoadingFlag) {
        [self loadingViewShow];
    }
    // 设备列表
    [[HWFService defaultService] loadRouterOnlineHistoryDetailWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if (aLoadingFlag) {
            [self loadingViewHide];
        }
        if (code == CODE_SUCCESS) {
            self.isGetListFinish = YES;
            NSDictionary *appData = data;
            
            if ([appData objectForKey:@"block_cnt"]) {
                self.blockCloseLabel.text = [NSString stringWithFormat:@"黑名单(%ld)", [[appData objectForKey:@"block_cnt"] integerValue]];
            }
            
            if (![appData objectForKey:@"day_list"][0] || ![appData objectForKey:@"day_list"][1]) {
                return;
            }
            
            [self.tdListDataSource removeAllObjects];
            
            for (NSDictionary *deviceDict in [appData objectForKey:@"day_list"][0]) {
                HWFDeviceListModel *deviceModel = [[HWFDeviceListModel alloc] init];
                deviceModel.trafficDown = [[deviceDict objectForKey:@"down"]doubleValue];
                deviceModel.isBlock = [[deviceDict objectForKey:@"is_block"] boolValue];
                deviceModel.MAC = [deviceDict objectForKey:@"mac"];
                deviceModel.name = [deviceDict objectForKey:@"name"];
                deviceModel.isOnline = [[deviceDict objectForKey:@"online"] boolValue];
                deviceModel.QoSDown = [[deviceDict objectForKey:@"qos_down"] floatValue];
                deviceModel.QoSStatus = [[deviceDict objectForKey:@"qos_status"] boolValue];
                deviceModel.QoSUp = [[deviceDict objectForKey:@"qos_up"] floatValue];
                deviceModel.RPT = [[deviceDict objectForKey:@"rpt"] boolValue];
                deviceModel.signal = [[deviceDict objectForKey:@"signal"]integerValue];
                deviceModel.totalTime = [[deviceDict objectForKey:@"time"] integerValue];
                deviceModel.trafficTotal = [[deviceDict objectForKey:@"traffic"] floatValue];
#warning ----- connectType
                //                deviceModel.connectType =
                deviceModel.trafficUp = [[deviceDict objectForKey:@"up"]doubleValue];
#warning -----ICON
                deviceModel.ComICON = nil;
                
                [self.tdListDataSource addObject:deviceModel];
            }
            
            [self.ysListDataSource removeAllObjects];
            
            for (NSDictionary *deviceDict in [appData objectForKey:@"day_list"][1]) {
                HWFDeviceListModel *deviceModel = [[HWFDeviceListModel alloc] init];
                deviceModel.trafficDown = [[deviceDict objectForKey:@"down"]doubleValue];
                deviceModel.isBlock = [[deviceDict objectForKey:@"is_block"] boolValue];
                deviceModel.MAC = [deviceDict objectForKey:@"mac"];
                deviceModel.name = [deviceDict objectForKey:@"name"];
                deviceModel.isOnline = [[deviceDict objectForKey:@"online"] boolValue];
                deviceModel.QoSDown = [[deviceDict objectForKey:@"qos_down"] floatValue];
                deviceModel.QoSStatus = [[deviceDict objectForKey:@"qos_status"] boolValue];
                deviceModel.QoSUp = [[deviceDict objectForKey:@"qos_up"] floatValue];
                deviceModel.RPT = [[deviceDict objectForKey:@"rpt"] boolValue];
                deviceModel.signal = [[deviceDict objectForKey:@"signal"]integerValue];
                deviceModel.totalTime = [[deviceDict objectForKey:@"time"] integerValue];
                deviceModel.trafficTotal = [[deviceDict objectForKey:@"traffic"] floatValue];
#warning ----- connectType
                //                deviceModel.connectType =
                deviceModel.trafficUp = [[deviceDict objectForKey:@"up"]doubleValue];
#warning -----ICON
                deviceModel.ComICON = nil;
                
                [self.ysListDataSource addObject:deviceModel];
            }
            
            if (self.isGetTrafficFinish && self.isGetListFinish) {
                
                [self reloadListData];
                
                [self showGuideView];
                
                [self archivedData];
            }
            
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - 获得当前路由器的IP和NP(运营商)信息
- (void)getCurrentRouterNP {
    
    [[HWFService defaultService]loadRouterIPNPWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if (code == CODE_SUCCESS) {
            self.npStr = [data objectForKey:@"np"] ? [data objectForKey:@"np"] : @"";
            self.routerIpStr = [data objectForKey:@"ip"];
        } else {
            
        }
    }];
}

#pragma mark - 刷新数据
- (void)reloadListData
{
    self.tdListDataSource = [[self sortDeviceList:self.tdListDataSource] mutableCopy];
    self.ysListDataSource = [[self sortDeviceList:self.ysListDataSource] mutableCopy];
    NSMutableArray *tdOnlineArr = [NSMutableArray array];
    for (HWFDeviceListModel *deviceModel in self.tdListDataSource) {
        if (deviceModel.isOnline) {
            [tdOnlineArr addObject:deviceModel];
        }
    }
    
    NSMutableArray *ydOnlineArr = [NSMutableArray array];
    for (HWFDeviceListModel *deviceModel in self.ysListDataSource) {
        if (deviceModel.isOnline) {
            [ydOnlineArr addObject:deviceModel];
        }
    }
    
    self.tdOnlineDeviceCount = tdOnlineArr.count;
    self.ydOnlineDeviceCount = ydOnlineArr.count;
    
    [self.tdListHeaderView reloadWithChartDict:self.tdTrafficDataSource withOnlineDevice:self.tdOnlineDeviceCount deviceCount:self.tdListDataSource.count dateFlag:YES headerViewType:HWFHeaderViewTypeDeviceInfoList totalTime:0 totalTraffic:0];
    [self.ysListHeaderView reloadWithChartDict:self.ysTrafficDataSource withOnlineDevice:self.ydOnlineDeviceCount deviceCount:self.ysListDataSource.count dateFlag:NO headerViewType:HWFHeaderViewTypeDeviceInfoList totalTime:0 totalTraffic:0 ];
    
    [self.tdListTableView reloadData];
    [self.ysListTableView reloadData];
}

#pragma mark - Guide View
- (void)showGuideView
{
    /*
    if ((!__USER_DEFAULT_GET(@"DeviceHistoryListGuide") || ![__USER_DEFAULT_GET(@"DeviceHistoryListGuide") boolValue]) && self.tdListDataSource.count > 0) {
        
        [__USER_DEFAULT setObject:@(YES) forKey:@"DeviceHistoryListGuide"];
        __USER_DEFAULT_SYNC;
        
        self.guideView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.guideView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.guideView];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.guideView.bounds];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.6;
        [self.guideView addSubview:backgroundView];
        
        UIImageView *swipeLeftTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(83, 226, 154, 30)];
        swipeLeftTipImageView.image = [UIImage imageNamed:@"SwipeLeftTip"];
        [self.guideView addSubview:swipeLeftTipImageView];
        
        UIImageView *fingerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 258, 66, 82)];
        fingerImageView.image = [UIImage imageNamed:@"Finger"];
        [self.guideView addSubview:fingerImageView];
        
        CABasicAnimation *fingerAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        fingerAnimation.duration = 1.0;
        fingerAnimation.autoreverses = NO;
        fingerAnimation.repeatCount = NSIntegerMax;
        fingerAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        fingerAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DIdentity, -150, 0, 0)];
        [fingerImageView.layer addAnimation:fingerAnimation forKey:@"fingerImageView"];
        
        [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:nil];
        
        UIButton *guideMaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        guideMaskButton.frame = self.guideView.bounds;
        guideMaskButton.backgroundColor = [UIColor clearColor];
        [guideMaskButton addTarget:self action:@selector(hideGuideView) forControlEvents:UIControlEventTouchUpInside];
        [self.guideView addSubview:guideMaskButton];
    }
     */
}

- (void)hideGuideView
{
    [UIView animateWithDuration:0.1 animations:^{
        self.guideView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.guideView removeFromSuperview];
    }];
}

- (NSArray *)sortDeviceList:(NSArray *)array
{
    NSMutableArray *onlineArr = [NSMutableArray array];
    NSMutableArray *offlineArr = [NSMutableArray array];
    for (HWFDeviceListModel *deviceModel in array) {
        if (deviceModel.isOnline) {
            [onlineArr addObject:deviceModel];
        } else {
            [offlineArr addObject:deviceModel];
        }
    }
    [onlineArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(HWFDeviceListModel *)obj1 trafficTotal] < [(HWFDeviceListModel *)obj2 trafficTotal];
    }];
    [offlineArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(HWFDeviceListModel *)obj1 trafficTotal] < [(HWFDeviceListModel *)obj2 trafficTotal];
    }];
    
    NSMutableArray *retArr = [NSMutableArray array];
    [retArr addObjectsFromArray:onlineArr];
    [retArr addObjectsFromArray:offlineArr];
    
    return retArr;
}

#pragma mark - 黑名单
- (void)doBlockClose:(id)sender
{
    if (self.isAliasNameViewShow) {
        return;
    }
    HWFBlackListViewController *blackListVC = [[HWFBlackListViewController alloc]initWithNibName:@"HWFBlackListViewController" bundle:nil];
    blackListVC.delegate = self;
    [self.navigationController pushViewController:blackListVC animated:YES];
}

#pragma mark - 改名
- (void)showAliasNameViewAnimation
{
//    NSString *deviceName = @"adfasdf";
//    self.aliasNameField.text  = deviceName;
//    [self.aliasNameField becomeFirstResponder];
//    
//    [self.maskButton setHidden:NO];
//    if (!self.isAliasNameViewShow) {
//        [UIView animateWithDuration:0.3f animations:^{
//            [self.aliasNameView setCenter:CGPointMake((self.view.width)/2, (self.aliasNameView.height)/2)];
//            [self.maskButton setAlpha:0.5f];
//        } completion:^(BOOL finished) {
//            self.isAliasNameViewShow = YES;
//        }];
//    }
}

- (void)hideAliasNameViewAnimation
{
//    [self.aliasNameField resignFirstResponder];
//    if (self.isAliasNameViewShow) {
//        [UIView animateWithDuration:0.3f animations:^{
//            [self.aliasNameView setCenter:CGPointMake((self.aliasNameView.center.x), (-1*(self.aliasNameView.height)/2))];
//            [self.maskButton setAlpha:0.0f];
//        } completion:^(BOOL finished) {
//            [self.maskButton setHidden:YES];
//            self.isAliasNameViewShow = NO;
//        }];
//    }
}

- (IBAction)doRename:(id)sender {
//    if ([[self.aliasNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
//        [self showTipWithType:HWFTipTypeMessage code:nil message:@"请输入设备名称"];
//        return;
//    } else if (self.aliasNameField.text.length > 30) {
//        [self showTipWithType:HWFTipTypeMessage code:nil message:@"您输入的设备名称超过30个字符"];
//        return;
//    }
//    
//    [self loadingViewShow];
//    [__NETWORK_CENTER JSONRequestTWXWithPath:@"api/network/set_device_name" token:__TOKEN routerId:__CURRENT_ROUTER.routerId params:@{@"name":self.aliasNameField.text, @"mac":[self.currentDevice.mac uppercaseString]} source:self success:^(NSDictionary *params, id data) {
//        [self loadingViewHide];
//        
//        data = (NSDictionary *)data;
//        if (data && __CODE_SUCCESS==__CODE(data)) {
//            [self hideAliasNameViewAnimation];
//            
//            [self showTipWithType:HWFTipTypeSuccess code:__CODE_SUCCESS message:@"操作成功!"];
//            
//            self.currentDevice.aliasName = self.aliasNameField.text;
//            
//            [self loadDataWithLoadingFlag:NO];
//        } else {
//            [self showTipWithType:HWFTipTypeFailure code:__CODE(data) message:__MSG_LOCAL(data)];
//        }
//    } failure:^(NSDictionary *params, id data, NSError *error) {
//        [self loadingViewHide];
//        
//        [self showTipWithType:HWFTipTypeFailure code:error.code message:__MSG_DEFAULT];
//    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doRename:nil];
    return YES;
}

#pragma mark - HWFDeviceHistoryDetailViewControllerDelegate / HWFRecoverDeviceViewControllerDelegate
- (void)refreshDeviceList
{
    [self loadDeviceListithLoadingFlag:NO];
}

/*
#pragma mark - HWFQosViewControllerDelegate
- (void)qosSuccessWithDeviceModel:(HWFDeviceListModel *)aDeviceModel
{
    [self loadDeviceListithLoadingFlag:NO];
}
 */

#pragma mark - HWFDeviceHistoryCellDelegate
- (void)clickCell:(HWFDeviceInfoCell *)aCell withDeviceModel:(HWFDeviceListModel *)aDeviceModel dateFlag:(BOOL)aDateFlag
{
    
    UIColor *originalColor = aCell.contentView.backgroundColor;
    aCell.contentView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [aCell.contentView performSelector:@selector(setBackgroundColor:) withObject:originalColor afterDelay:0.5];
    
    for (UITableViewCell *cell in [self.tdListTableView visibleCells]) {
        if ([cell isKindOfClass:[HWFDeviceInfoCell class]]) {
            [(HWFDeviceInfoCell *)cell hideControlView];
        }
    }
    
    HWFDeviceDetailViewController *deviceDetailVC = [[HWFDeviceDetailViewController alloc]initWithNibName:@"HWFDeviceDetailViewController" bundle:nil];
    deviceDetailVC.deviceModel = aDeviceModel;
    deviceDetailVC.acceptNPStr = self.npStr;
    deviceDetailVC.acceptRouterIpStr = self.routerIpStr;
    deviceDetailVC.delegate = self;
    [self.navigationController pushViewController:deviceDetailVC animated:YES];

}

- (void)clickQosWithCell:(HWFDeviceInfoCell *)aCell withDeviceModel:(HWFDeviceListModel *)aDeviceModel
{
//    [HWFTools analyticsWithEvent:@"click_device_qos_from_his_list"];
//    
//    self.currentDevice = aDeviceModel;
//    
//    HWFQosViewController *qosViewController = [[HWFQosViewController alloc] initWithNibName:@"HWFQosViewController" bundle:nil device:self.currentDevice];
//    qosViewController.delegate = self;
//    [self presentController:qosViewController animated:YES completion:^{
//        
//    }];
//    [aCell hideControlView];
}

- (void)clickRenameWithCell:(HWFDeviceInfoCell *)aCell withDeviceModel:(HWFDeviceListModel *)aDeviceModel
{
    
//    self.currentDevice = aDeviceModel;
//    
//    [self showAliasNameViewAnimation];
//    [aCell hideControlView];
}

- (void)handleShowControlViewWithCell:(HWFDeviceInfoCell *)aCell
{
    for (UITableViewCell *cell in [self.tdListTableView visibleCells]) {
        if ([cell isKindOfClass:[HWFDeviceInfoCell class]] && cell != aCell) {
            [(HWFDeviceInfoCell *)cell hideControlView];
        }
    }
    
    self.focusCellIndex = aCell.tag - BASETAG_DEVICEHISTORYCELL;
}

- (void)handleHideControlViewWithCell:(HWFDeviceInfoCell *)aCell
{
    if (self.focusCellIndex == aCell.tag - BASETAG_DEVICEHISTORYCELL) {
        self.focusCellIndex = -1;
    }
}

#pragma mark - HWFTrafficHeaderViewDelegate
- (void)scrollTop
{
    [self.currentPullingRefreshTableView setContentOffset:CGPointZero animated:YES];
}

- (void)toggleToDate:(BOOL)dateFlag // NO-从昨天到今天 YES-从今天到昨天
{
    self.focusCellIndex = -1;
    [self.ysListTableView reloadData];
    [self.tdListTableView reloadData];
    
    if (dateFlag) {
        self.ysListTableView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.tdListTableView.center = CGPointMake(self.tdListTableView.center.x+self.tdListTableView.width, self.tdListTableView.center.y);
            self.ysListTableView.center = CGPointMake(self.ysListTableView.center.x+self.ysListTableView.width, self.ysListTableView.center.y);
        } completion:^(BOOL finished) {
            self.currentPullingRefreshTableView = self.ysListTableView;
            self.tdListTableView.hidden = YES;
        }];
    } else {
        self.tdListTableView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.tdListTableView.center = CGPointMake(self.tdListTableView.center.x-self.tdListTableView.width, self.tdListTableView.center.y);
            self.ysListTableView.center = CGPointMake(self.ysListTableView.center.x-self.ysListTableView.width, self.ysListTableView.center.y);
        } completion:^(BOOL finished) {
            self.currentPullingRefreshTableView = self.tdListTableView;
            self.ysListTableView.hidden = YES;
        }];
    }
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWFDeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceInfoCell"];
    if (!cell) {
        cell = (HWFDeviceInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"HWFDeviceInfoCell" owner:self options:nil] firstObject];
        cell.delegate = self;
    }
    
    cell.tag = BASETAG_DEVICEHISTORYCELL + indexPath.row;
    
    if (self.focusCellIndex >= 0 && indexPath.row == self.focusCellIndex) {
        cell.showControlViewFlag = YES;
    } else {
        cell.showControlViewFlag = NO;
    }
    
    switch (tableView.tag) {
        case TAG_TODAY_TABLEVIEW:
        {
            HWFDeviceListModel *deviceModel = [self.tdListDataSource objectAtIndex:indexPath.row];
            [cell reloadCellWithModel:deviceModel dateFlag:YES];
        }
            break;
        case TAG_YESTERDAY_TABLEVIEW:
        {
            HWFDeviceListModel *deviceModel = [self.ysListDataSource objectAtIndex:indexPath.row];
            [cell reloadCellWithModel:deviceModel dateFlag:NO];
        }
            break;
        default:
            break;
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsNumber = 0;
    switch (tableView.tag) {
        case TAG_TODAY_TABLEVIEW:
        {
            rowsNumber = [self.tdListDataSource count];
        }
            break;
        case TAG_YESTERDAY_TABLEVIEW:
        {
            rowsNumber = [self.ysListDataSource count];
        }
            break;
        default:
            break;
    }
    return rowsNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0;
}

#pragma mark - 下拉刷新
- (void)doRefresh
{
    [self loadDeviceListithLoadingFlag:NO];
    [self.currentPullingRefreshTableView tableViewDidFinishedLoading];
}

- (void)pullingTableViewDidStartRefreshing:(XMPullingRefreshTableView *)tableView
{
    [self performSelector:@selector(doRefresh) withObject:nil afterDelay:1.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [NSDate date];
    return date;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [self.currentPullingRefreshTableView tableViewDidScroll:aScrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate
{
    [self.currentPullingRefreshTableView tableViewDidEndDragging:aScrollView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
