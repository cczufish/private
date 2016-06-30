//
//  HWFDeviceHistoryDetailViewController.m
//  HiWiFi
//
//  Created by dp on 14-5-15.
//  Copyright (c) 2014年 HiWiFi. All rights reserved.
//

#import "HWFDeviceHistoryDetailViewController.h"

#import "XMPullingRefreshTableView.h"
//#import "HWFRecoverDeviceViewController.h"

#import "HWFTrafficHeaderView.h"
#import "HWFQosViewController.h"

//#import "HWFDeviceHistoryViewController.h"
#import "HWFDeviceHistoryDetailViewController.h"

#import "HWFDeviceTimeHistoryCell.h"

#import "HWFService+Device.h"

#import "UIViewExt.h"

#define TAG_TODAY_TABLEVIEW 120
#define TAG_YESTERDAY_TABLEVIEW 121


@interface HWFDeviceHistoryDetailViewController () <UITableViewDataSource, UITableViewDelegate, XMPullingRefreshTableViewDelegate, UITextFieldDelegate, HWFTrafficHeaderViewDelegate, UIActionSheetDelegate>

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

@property (strong, nonatomic) UIButton *maskButton;

@property (strong, nonatomic) IBOutlet UIView *aliasNameView;
@property (weak, nonatomic) IBOutlet UITextField *aliasNameField;
@property (weak, nonatomic) IBOutlet UIButton *renameButton;
@property (assign, nonatomic) BOOL isAliasNameViewShow;

@property (strong, nonatomic) UIView *guideView;

//@property (strong, nonatomic) HWFDeviceModel *currentDevice;
@property (assign, nonatomic) BOOL currentDateFlag;

@property (assign, nonatomic) NSInteger ysOffPointIndex;

@property (strong, nonatomic) NSString *sourceIdentifier;  // 跳转来源，标识从哪个界面条转过来；暂时用于区分正常跳转和消息中心跳转
@property (assign, nonatomic) NSInteger sourceRouterId;
//@property (strong, nonatomic) HWFRouterModel *validRouter; // 当前有效的Router对象，Source为消息中心时，使用传入的Router；其他情况默认为__CURRENT_ROUTER


//再创建两个字典来保存当前的总时间和总流量
@property (strong, nonatomic) NSMutableDictionary *tdTimeAndTraffic;
@property (strong, nonatomic) NSMutableDictionary *ysTimeAndTraffic;


@end

@implementation HWFDeviceHistoryDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.sourceIdentifier = @"Default";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil deviceModel:(HWFDeviceListModel *)aDeviceModel dateFlag:(BOOL)dateFlag
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.sourceIdentifier = @"DeviceHistoryList";
        self.acceptDeviceModel = aDeviceModel;
        
        self.currentDateFlag = dateFlag;
        //添加2:不是消息处理页面进来的需要传当前rid
        self.sourceRouterId = [[HWFRouter defaultRouter]RID];
        [self initData];
    }
    return self;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil routerId:(NSInteger)rid deviceName:(NSString *)aDeviceName deviceMAC:(NSString *)aDeviceMAC sourceIdentifier:(NSString *)aSourceIdentifier delegate:(id<HWFDeviceHistoryDetailViewControllerDelegate>)delegate
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        self.sourceIdentifier = aSourceIdentifier;
//        self.sourceRouterId = rid;
//        
////        self.currentDevice = [[HWFDeviceModel alloc] init];
////        self.currentDevice.aliasName = aDeviceName;
////        self.currentDevice.mac = aDeviceMAC;
//        
//        self.currentDateFlag = 1;
//        
//        self.delegate = delegate;
//        
//        [self initData];
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initData];
    [self initView];
    [self loadData];

    if (!self.currentDateFlag) {
        [self toggleToDate:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initData
{
    self.tdListDataSource = [[NSMutableArray alloc] init];
    self.tdTrafficDataSource = [[NSMutableDictionary alloc] init];
    
    self.ysListDataSource = [[NSMutableArray alloc] init];
    self.ysTrafficDataSource = [[NSMutableDictionary alloc] init];
    
    self.tdTimeAndTraffic = [[NSMutableDictionary alloc]init];
    self.ysTimeAndTraffic = [[NSMutableDictionary alloc]init];
}

- (void)initView
{
    self.title = @"连接报告";
    [self addBackBarButtonItem];
  
    [self.baseView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20-44)];
    [self.baseView setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1]];
    
    self.tdListTableView = [[XMPullingRefreshTableView alloc] initWithFrame:(self.baseView.bounds) pullingDelegate:self];
    self.tdListTableView.delegate = self;
    self.tdListTableView.dataSource = self;
    self.tdListTableView.headerOnly = YES;
    self.tdListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tdListTableView.tag = TAG_TODAY_TABLEVIEW;
    self.tdListTableView.backgroundColor = [UIColor whiteColor];
    [self.baseView addSubview:self.tdListTableView];
    
    self.ysListTableView = [[XMPullingRefreshTableView alloc] initWithFrame:(self.baseView.bounds) pullingDelegate:self];
    self.ysListTableView.center = CGPointMake(-SCREEN_WIDTH/2, self.baseView.center.y);
    self.ysListTableView.delegate = self;
    self.ysListTableView.dataSource = self;
    self.ysListTableView.headerOnly = YES;
    self.ysListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.ysListTableView.tag = TAG_YESTERDAY_TABLEVIEW;
    self.ysListTableView.backgroundColor = [UIColor whiteColor];
    [self.baseView addSubview:self.ysListTableView];
    
    self.tdListHeaderView = [HWFTrafficHeaderView instanceView];
    self.tdListHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 128.0+48.0+78.0);
    self.tdListHeaderView.delegate = self;
    self.tdListTableView.tableHeaderView = self.tdListHeaderView;
    
    self.ysListHeaderView = [HWFTrafficHeaderView instanceView];
    self.ysListHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 128.0+48.0+78.0);
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

- (void)loadData
{
    [self loadingViewShow];
    
    __block BOOL isGetTrafficFinish = NO;
    __block BOOL isGetListFinish = NO;
    
    // 日线(设备)
     [[HWFService defaultService]loadDeviceTrafficHistoryDetailWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] device:self.acceptDeviceModel completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
         [self loadingViewHide];
         isGetTrafficFinish = YES;
        if (code == CODE_SUCCESS) {
            NSDictionary *appData = data;
            
            if (![appData objectForKey:@"cnt"] || ![appData objectForKey:@"day_list"][0] || ![appData objectForKey:@"day_list"][1]) {
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
            
            NSArray *hisYSTraffic = [appData objectForKey:@"day_list"][1];
            for (int i=[hisYSTraffic count]-1; i>=0; i--) {
                if ([[hisYSTraffic objectAtIndex:i] integerValue] < 0) {
                    continue;
                } else {
                    self.ysOffPointIndex = i;
                    break;
                }
            }
            
            if (isGetTrafficFinish && isGetListFinish) {
                
                [self reloadListData];
                
                [self showGuideView];
            }
        } else {
        }
         
    }];
    
    // 设备列表
    [self loadingViewShow];
    [[HWFService defaultService]loadDeviceOnlineHistoryDetailWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] device:self.acceptDeviceModel completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {

        isGetListFinish = YES;
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            NSDictionary *appData = data;
            
            if (![appData objectForKey:@"day_list"][0] || ![appData objectForKey:@"day_list"][1]) {
                return;
            }
            
            [self.tdListDataSource removeAllObjects];
            [self.ysListDataSource removeAllObjects];
    
            NSInteger tdTime =[[appData objectForKey:@"day_list"][0] objectForKey:@"time"] ? [[[appData objectForKey:@"day_list"][0] objectForKey:@"time"] integerValue] : 0;
            NSInteger ysTime =[[appData objectForKey:@"day_list"][1] objectForKey:@"time"] ? [[[appData objectForKey:@"day_list"][1] objectForKey:@"time"] integerValue] : 0;
            float tdTraffic = [[appData objectForKey:@"day_list"][0] objectForKey:@"traffic"] ? [[[appData objectForKey:@"day_list"][0] objectForKey:@"traffic"] floatValue] : 0.0;
            float ysTraffic = [[appData objectForKey:@"day_list"][1] objectForKey:@"traffic"] ? [[[appData objectForKey:@"day_list"][1] objectForKey:@"traffic"] floatValue] : 0.0;
            
            [self.tdTimeAndTraffic setObject:@(tdTime) forKey:@"tdTime"];
            [self.tdTimeAndTraffic setObject:@(tdTraffic) forKey:@"tdTraffic"];
            [self.ysTimeAndTraffic setObject:@(ysTime) forKey:@"ysTime"];
            [self.ysTimeAndTraffic setObject:@(ysTraffic) forKey:@"ysTraffic"];
            
            NSMutableArray *hisTdArray = [[[appData objectForKey:@"day_list"][0] objectForKey:@"time_range"] mutableCopy];
            NSMutableArray *hisYsArray = [[[appData objectForKey:@"day_list"][1] objectForKey:@"time_range"] mutableCopy];
            
            for (NSArray *arr in hisTdArray) {
                if ([arr count] == 0) {
                    [hisTdArray removeObject:arr];
                }
            }
            
            for (NSArray *arr in hisYsArray) {
                if ([arr count] == 0) {
                    [hisYsArray removeObject:arr];
                }
            }
            
            [self.tdListDataSource setArray:hisTdArray];
            [self.ysListDataSource setArray:hisYsArray];
            
            if (isGetTrafficFinish && isGetListFinish) {
                
                [self reloadListData];
                
                [self showGuideView];
            }
        
        } else {
            
        }
    }];
}

#pragma mark - 刷新数据
- (void)reloadListData
{
    [self.tdListTableView reloadData];
    [self.ysListTableView reloadData];
    
    NSInteger todayTime = [[self.tdTimeAndTraffic objectForKey:@"tdTime"]integerValue];
    float todayTraffic = [[self.tdTimeAndTraffic objectForKey:@"tdTraffic"]floatValue];
    NSInteger yesterdayTime = [[self.ysTimeAndTraffic objectForKey:@"ysTime"]integerValue];
    float yesterdayTraffic = [[self.ysTimeAndTraffic objectForKey:@"ysTraffic"]floatValue];
    [self.tdListHeaderView reloadWithChartDict:self.tdTrafficDataSource withOnlineDevice:0 deviceCount:self.tdListDataSource.count dateFlag:YES headerViewType:HWFHeaderViewTypeDeviceTimeList totalTime:todayTime totalTraffic:todayTraffic];
    [self.ysListHeaderView reloadWithChartDict:self.ysTrafficDataSource withOnlineDevice:0 deviceCount:self.ysListDataSource.count dateFlag:NO headerViewType:HWFHeaderViewTypeDeviceTimeList totalTime:yesterdayTime totalTraffic:yesterdayTraffic];
}

#pragma mark - Guide View
- (void)showGuideView
{
    /*
    if ((!USER_DEFAULT_GET(@"DeviceHistoryListGuide") || ![__USER_DEFAULT_GET(@"DeviceHistoryListGuide") boolValue]) && self.tdListDataSource.count > 0) {
        
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


//#pragma mark - HWFDeviceHistoryViewControllerDelegate / HWFRecoverDeviceViewControllerDelegate
//- (void)refreshDeviceList
//{
////    [self loadData];
//}

#pragma mark - HWFTrafficHeaderViewDelegate
- (void)scrollTop
{
    [self.currentPullingRefreshTableView setContentOffset:CGPointZero animated:YES];
}

- (void)toggleToDate:(BOOL)dateFlag // NO-从昨天到今天 YES-从今天到昨天
{
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
    HWFDeviceTimeHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceTimeHistoryCell"];
    if (!cell) {
        cell = (HWFDeviceTimeHistoryCell *)[[[NSBundle mainBundle] loadNibNamed:@"HWFDeviceTimeHistoryCell" owner:self options:nil] firstObject];
    }
    
    switch (tableView.tag) {
        case TAG_TODAY_TABLEVIEW: // 今天
        {
            NSArray *deviceTimeHisArr = [self.tdListDataSource objectAtIndex:indexPath.row];
            NSString *startTime = [self getFullDateStringWithString:[NSString stringWithFormat:@"%ld", [[deviceTimeHisArr firstObject] integerValue]]];
            NSString *endTime = deviceTimeHisArr.count==2 ? [self getFullDateStringWithString:[NSString stringWithFormat:@"%ld", [[deviceTimeHisArr lastObject] integerValue]]] : @"现在";
            [cell reloadCellWithStartTime:startTime endTime:endTime dateFlag:YES ysOffPointIndex:self.ysOffPointIndex row:indexPath.row];
        }
            break;
        case TAG_YESTERDAY_TABLEVIEW: // 昨天
        {
            NSArray *deviceTimeHisArr = [self.ysListDataSource objectAtIndex:indexPath.row];
            NSString *startTime = [self getFullDateStringWithString:[NSString stringWithFormat:@"%ld", [[deviceTimeHisArr firstObject] integerValue]]];
            NSString *endTime = deviceTimeHisArr.count==2 ? [self getFullDateStringWithString:[NSString stringWithFormat:@"%ld", [[deviceTimeHisArr lastObject] integerValue]]] : @"现在";
            [cell reloadCellWithStartTime:startTime endTime:endTime dateFlag:NO ysOffPointIndex:self.ysOffPointIndex row:indexPath.row];
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
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

#pragma mark - 下拉刷新
- (void)doRefresh
{
    
    [self.currentPullingRefreshTableView tableViewDidFinishedLoading];
    [self.currentPullingRefreshTableView reloadData];
    [self loadData];
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

// 格式化返回的WiFi健康定时时间
- (NSString *)getFullDateStringWithString:(NSString *)dateString
{
    NSMutableString *retString = [NSMutableString stringWithString:dateString];
    for (int i=0; i<4-[dateString length]; i++) {
        [retString insertString:@"0" atIndex:0];
    }
    
    [retString insertString:@":" atIndex:2];
    
    return retString;
}


@end
