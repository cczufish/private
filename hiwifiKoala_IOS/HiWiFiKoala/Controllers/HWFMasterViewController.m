//
//  HWFMasterViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFMasterViewController.h"

#import "HWFNavigationController.h"
#import "HWFLoginViewController.h"
#import "HWFSettingsViewController.h"
#import "HWFDeviceHistoryListViewController.h"
#import "HWFPartitionListViewController.h"
#import "HWFInstalledPluginListViewController.h"
#import "HWFControlViewController.h"
#import "HWFMessageListViewController.h"
#import "HWFWANManageViewController.h"
#import "HWFGatewayRouterManageViewController.h"
#import "HWFRPTManageViewController.h"
#import "HWFWebViewController.h"

#import "HWFService.h"
#import "HWFService+User.h"
#import "HWFService+Router.h"
#import "HWFService+Plugin.h"
#import "HWFService+MessageCenter.h"

#import "HWFRouterListCell.h"
#import "HWFControlBarButton.h"
#import "HWFTopologyView.h"

#import "HWFSmartDevice.h"
#import "HWFNetworkNode.h"
#import "HWFNetworkNodeView.h"

#import <pop/POP.h>
#import <MSWeakTimer/MSWeakTimer.h>
#import "UIViewExt.h"


#define kRouterListAnimationDuration 0.3
#define kRouterListCellHeight 44.0
#define kTopologyViewCorrectDuration 0.3

// 路由器列表轮询频率
#define kReloadRouterListTimeInterval 15.0

@interface HWFMasterViewController () <UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, HWFRouterListCellDelegate, HWFTopologyViewDelegate, HWFSettingsViewControllerDelegate, POPAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet UITableView *routerListTableView;
@property (weak, nonatomic) IBOutlet UIView *routerListView;
@property (strong, nonatomic) IBOutlet UIView *navigationTitleView;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *arrowView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *mask;
@property (assign, nonatomic) UIEdgeInsets routerListTableViewContentInset;

@property (weak, nonatomic) IBOutlet HWFControlBarButton *devicesBarButton;
@property (weak, nonatomic) IBOutlet HWFControlBarButton *storageBarButton;
@property (weak, nonatomic) IBOutlet HWFControlBarButton *pluginBarButton;
@property (weak, nonatomic) IBOutlet HWFControlBarButton *controlBarButton;

@property (weak, nonatomic) IBOutlet HWFTopologyView *topologyView;

@property (assign, nonatomic) BOOL isRouterListShow;
@property (assign, nonatomic) BOOL isBackgroundOperation; // 是否是后台操作，初始:NO

@property (strong, nonatomic) MSWeakTimer *reloadRouterListTimer; // 路由器列表轮询机制

@end

@implementation HWFMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // NavigationController
    self.navigationController.delegate = self;
    
    // NavigationBar
    [self addLeftBarButtonItemWithImage:[UIImage imageNamed:@"setting"] activeImage:[UIImage imageNamed:@"setting-avtive"] title:@"设置" target:self action:@selector(gotoAppSettings)];
    [self addRightBarButtonItemWithImage:[UIImage imageNamed:@"message"] activeImage:[UIImage imageNamed:@"message-avtive"] title:@"登录" target:self action:@selector(gotoMessageCenter)];
    self.navigationItem.titleView = self.navigationTitleView;
    
    // Control View
    [self loadControlView];
    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessHandler:) name:kNotificationUserLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutHandler:) name:kNotificationUserLogout object:nil];
    
    // TableView
    [self.routerListTableView registerNib:[UINib nibWithNibName:@"HWFRouterListCell" bundle:nil] forCellReuseIdentifier:@"RouterListCell"];
    
    // Action
    [self action];
    
    // TopologyView
    self.topologyView.delegate = self;
    
    // Gesture
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandler:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:panGesture];

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.reloadRouterListTimer) {
        self.reloadRouterListTimer = [MSWeakTimer scheduledTimerWithTimeInterval:kReloadRouterListTimeInterval
                                                                          target:self
                                                                        selector:@selector(loadRouterList)
                                                                        userInfo:nil
                                                                         repeats:YES
                                                                   dispatchQueue:dispatch_get_main_queue()];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isRouterListShow) {
        [self toggleRouterListShow];
    }
    
    if (self.reloadRouterListTimer) {
        [self.reloadRouterListTimer invalidate];
        self.reloadRouterListTimer = nil;
    }
}

- (void)viewWillLayoutSubviews {
    [self.topologyView refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserLogin object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationUserLogout object:nil];
}

// Push完成后，开启滑动返回功能
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)action {
    if ([HWFUser defaultUser]) {
        [self loadInitialTopology];
        
        [self loadRouterList];
        
        [self loadProfileWithUser:[HWFUser defaultUser]];
        
        [self loadNewMessageFlag];
    } else {
        //!!!: ft
        self.navigationTitleLabel.text = @"请登录";
    }
    
}

#pragma mark - 登录
- (void)login {
    if ([HWFUser defaultUser]) {
        return;
    }
    
    HWFLoginViewController *loginViewController = [[HWFLoginViewController alloc] initWithNibName:@"HWFLoginViewController" bundle:nil];
    HWFNavigationController *navigationController = [[HWFNavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:navigationController animated:YES completion:^{
        // nothing.
    }];
}

- (void)loginSuccessHandler:(NSNotification *)notification {
    [self action];
    
    NSString *pToken = [[NSUserDefaults standardUserDefaults] objectForKey:kRemoteNotificationPushToken];
    if (pToken) {
        if ([HWFUser defaultUser] && [[HWFUser defaultUser] uToken]) {
            // 上报PushToken
            [[HWFService defaultService] uploadPushToken:pToken completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                // Nothing.
            }];
        }
    } else {
        NSNumber *remoteNotificationStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kRemoteNotificationStatus];
        if (!remoteNotificationStatus || [remoteNotificationStatus boolValue]) {
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) { // >= iOS 8.0
                [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
                
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            } else { // < iOS 8.0
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
            }
        }
    }
}

#pragma mark - 退出
- (void)logoutHandler:(NSNotification *)notification {
    [self action];
}

#pragma mark - 取用户详细信息
- (void)loadProfileWithUser:(HWFUser *)aUser {
    [[HWFService defaultService] loadProfileWithUser:aUser completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        
    }];
}

#pragma mark - 导航栏操作
- (IBAction)navigationTitleButtonClick:(UIButton *)sender {
    if ([HWFUser defaultUser]) {
        [self toggleRouterListShow];
    } else {
        [self login];
    }
}

// 打开App设置
- (void)gotoAppSettings {
    HWFSettingsViewController *settingsViewController = [[HWFSettingsViewController alloc] initWithNibName:@"HWFSettingsViewController" bundle:nil];
    settingsViewController.delegate = self;
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

// 打开消息中心
- (void)gotoMessageCenter {
    HWFMessageListViewController *messageListViewController = [[HWFMessageListViewController alloc] initWithNibName:@"HWFMessageListViewController" bundle:nil];
    [self.navigationController pushViewController:messageListViewController animated:YES];
    self.rightBarButtonBadgeView.hidden = YES;
}

// 获取是否有未读消息
- (void)loadNewMessageFlag {
    [[HWFService defaultService] loadNewMessageFlagWithUser:[HWFUser defaultUser] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        @try {
            if (CODE_SUCCESS == code && data[@"status"] && [data[@"status"] boolValue]) {
                self.rightBarButtonBadgeView.hidden = NO;
            } else {
                self.rightBarButtonBadgeView.hidden = YES;
            }
        }
        @catch (NSException *exception) {
            self.rightBarButtonBadgeView.hidden = YES;
        }
        @finally {
            
        }
    }];
}

#pragma mark - 底部操作栏
- (void)loadControlView {
//    self.devicesBarButton.info = @"";
    self.devicesBarButton.image = [UIImage imageNamed:@"device"];
    self.devicesBarButton.activeImage = [UIImage imageNamed:@"device-active"];
    self.devicesBarButton.title = @"连接设备";
    self.devicesBarButton.clickHandler = ^(HWFControlBarButton *sender) {
        [self gotoDeviceList:sender];
    };
    
    self.storageBarButton.image = [UIImage imageNamed:@"storage"];
    self.storageBarButton.activeImage = [UIImage imageNamed:@"storage-active"];
    self.storageBarButton.title = @"路由存储";
    self.storageBarButton.clickHandler = ^(HWFControlBarButton *sender) {
        [self gotoPartitionList:sender];
    };
    
    self.pluginBarButton.image = [UIImage imageNamed:@"plugin"];
    self.pluginBarButton.activeImage = [UIImage imageNamed:@"plugin-active"];
    self.pluginBarButton.title = @"智能插件";
    self.pluginBarButton.clickHandler = ^(HWFControlBarButton *sender) {
        [self gotoInstalledPluginList:sender];
    };
    
    //!!!: 增删智能控制功能时，更新此数字
    self.controlBarButton.info = @"5";
    self.controlBarButton.image = [UIImage imageNamed:@"control"];
    self.controlBarButton.activeImage = [UIImage imageNamed:@"control-active"];
    self.controlBarButton.title = @"智能控制";
    self.controlBarButton.clickHandler = ^(HWFControlBarButton *sender) {
        [self gotoRouterControl:sender];
    };
}

// 跳转设备列表页
- (void)gotoDeviceList:(HWFControlBarButton *)sender {
    HWFDeviceHistoryListViewController *deviceHistoryViewController = [[HWFDeviceHistoryListViewController alloc] initWithNibName:@"HWFDeviceHistoryListViewController" bundle:nil];
    [self.navigationController pushViewController:deviceHistoryViewController animated:YES];
}

// 跳转路由存储页
- (void)gotoPartitionList:(HWFControlBarButton *)sender {
    HWFPartitionListViewController *partitionListViewController = [[HWFPartitionListViewController alloc] initWithNibName:@"HWFPartitionListViewController" bundle:nil];
    [self.navigationController pushViewController:partitionListViewController animated:YES];
}

// 跳转智能插件页
- (void)gotoInstalledPluginList:(HWFControlBarButton *)sender {
    HWFInstalledPluginListViewController *installedPluginListViewController = [[HWFInstalledPluginListViewController alloc] initWithNibName:@"HWFInstalledPluginListViewController" bundle:nil];
    [self.navigationController pushViewController:installedPluginListViewController animated:YES];
}

// 跳转智能控制页
- (void)gotoRouterControl:(HWFControlBarButton *)sender {
    HWFControlViewController *controlViewController = [[HWFControlViewController alloc] initWithNibName:@"HWFControlViewController" bundle:nil];
    [self.navigationController pushViewController:controlViewController animated:YES];
}

// 加载底部操作栏的各种数字
- (void)loadNumbersAboutControlView {
    [self loadNumberAboutInstalledPlugin];
    [self loadNumbersAboutRouter];
}

// 加载已安装插件数量
- (void)loadNumberAboutInstalledPlugin {
    [[HWFService defaultService] loadPluginInstalledNUMWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        @try {
            if (CODE_SUCCESS == code && data[@"data"] && data[@"data"][@"installed_num"]) {
                self.pluginBarButton.info = [NSString stringWithFormat:@"%ld", (long)[data[@"data"][@"installed_num"] integerValue]];
            }
        }
        @catch (NSException *exception) {
            self.pluginBarButton.info = nil;
        }
        @finally {
            
        }
    }];
}

// 加载路由器相关的各种数字(正在下载任务数、已连接设备数、存储容量)
- (void)loadNumbersAboutRouter {
    [[HWFService defaultService] loadRouterOverviewNumbersWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        @try {
            //TODO: downloading_quantity=49
            if (CODE_SUCCESS == code && data[@"online_device_quantity"]) {
                self.devicesBarButton.info = [NSString stringWithFormat:@"%ld", (long)[data[@"online_device_quantity"] integerValue]];
                self.storageBarButton.info = [HWFTool displaySizeWithUnitB:[data[@"storage_size"] floatValue]];
            }
        }
        @catch (NSException *exception) {
            self.devicesBarButton.info = nil;
            self.storageBarButton.info = nil;
        }
        @finally {
            
        }
    }];
}

#pragma mark - 配置页 (HWFTopologyViewDelegate)
- (void)networkNodeClick:(HWFNetworkNode *)node {
    switch (node.type) {
        case NetworkNodeTypeWAN:
        {
            HWFWANManageViewController *WANManageViewController = [[HWFWANManageViewController alloc] initWithNibName:@"HWFWANManageViewController" bundle:nil];
            [self.navigationController pushViewController:WANManageViewController animated:YES];
        }
            break;
        case NetworkNodeTypeGatewayRouter:
        {
            HWFGatewayRouterManageViewController *gatewayRouterManageViewController = [[HWFGatewayRouterManageViewController alloc] initWithNibName:@"HWFGatewayRouterManageViewController" bundle:nil];
            [self.navigationController pushViewController:gatewayRouterManageViewController animated:YES];
        }
            break;
        case NetworkNodeTypeSmartDevice:
        {
            //TODO: 判断极卫星
            HWFRPTManageViewController *RPTManageViewController = [[HWFRPTManageViewController alloc] initWithNibName:@"HWFRPTManageViewController" bundle:nil];
            RPTManageViewController.node = node;
            [self.navigationController pushViewController:RPTManageViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ROM
- (void)loadRouterROMUpgradeInfo {
    [[HWFService defaultService] loadROMUpgradeInfoWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if (CODE_SUCCESS == code) {
            [self.topologyView refresh];
        } else {
            // Nothing.
        }
    }];
}

#pragma mark - 电信加速
- (IBAction)turboButtonClick:(id)sender {
    if (![HWFUser defaultUser] || ![HWFUser defaultUser].uToken) {
        [self showTipWithType:HWFTipTypeFailure code:12 message:[[HWFService defaultService] getMessageWithCode:12 defaultMessage:@""]];
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter]]) {
        [self showTipWithType:HWFTipTypeFailure code:13 message:[[HWFService defaultService] getMessageWithCode:12 defaultMessage:@""]];
        return;
    }
    
    HWFWebViewController *turboWebViewController = [[HWFWebViewController alloc] initWithNibName:@"HWFWebViewController" bundle:nil];
    turboWebViewController.URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_WEB_ROUTER_TURBO];
    turboWebViewController.HTTPMethod = HTTPMethodPost;
    turboWebViewController.paramDict = @{ @"token":[HWFUser defaultUser].uToken, @"rid":@([HWFRouter defaultRouter].RID) };
    [self.navigationController pushViewController:turboWebViewController animated:YES];
}

#pragma mark - 路由器列表
// 加载路由器列表
- (void)loadRouterList {
    if (![HWFUser defaultUser]) {
        //TODO: Show Tips
        return;
    }
    //TODO: Router From Cache
    self.isBackgroundOperation ?: [self loadingViewShow]; // loadRouterList Show
    
    NSInteger originalDefaultRouterRID = (self.isBackgroundOperation && [HWFRouter defaultRouter]) ? [[HWFRouter defaultRouter] RID] : RID_NIL;
    
    [[HWFService defaultService] loadBindRoutersWithUser:[HWFUser defaultUser] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        self.isBackgroundOperation ?: [self loadingViewHide];
        
        if (CODE_SUCCESS == code) {
            // TOP Arrow
            self.arrowView.hidden = NO;
            
            // RouterList TableView
            self.routerListTableViewContentInset = UIEdgeInsetsMake(kRouterListCellHeight * (5-[[[HWFUser defaultUser] bindRouterRIDs] count]), 0, 0, 0);
            self.routerListTableView.contentInset = self.routerListTableViewContentInset;
            [self.routerListTableView reloadData];
            
            if (originalDefaultRouterRID != [[HWFRouter defaultRouter] RID]) {
                [self firstBloodWithRouter:[HWFRouter defaultRouter]];
            }
            
            self.isBackgroundOperation = YES;
        } else {
            self.isBackgroundOperation ?: [self showTipWithType:HWFTipTypeFailure code:code message:msg];
        }
    }];
}

// 加载路由器的ClientSecret等信息
- (void)firstBloodWithRouter:(HWFRouter *)aRouter {
    self.navigationTitleLabel.text = aRouter.name;
    
    void (^unifiedHandler)(void) = ^(void) {
        [self loadRouterTopology];
        [self loadNumbersAboutControlView];
        [self loadRouterROMUpgradeInfo];
    };
    
    if (aRouter && (!aRouter.clientSecret || IS_STRING_EMPTY(aRouter.clientSecret))) {
        if (!aRouter.isOnline) {
            return;
        }
        
        [self loadingViewShow];
        [[HWFService defaultService] loadClientSecretWithUser:[HWFUser defaultUser] router:aRouter completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            [self loadingViewHide];
            
            if (CODE_SUCCESS == code) {
                unifiedHandler();
            } else {
                [self showTipWithType:HWFTipTypeFailure code:code message:msg];
            }
        }];
    } else {
        unifiedHandler();
    }
}

// RouterListShow
- (void)toggleRouterListShow {
    if (self.isRouterListShow) { // 隐藏
        [self hideRouterList];
    } else { // 显示
        [self showRouterList];
    }
}

- (void)showRouterList {
    // 显示RouterList
    POPBasicAnimation *showRouterListAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    showRouterListAnimation.toValue  = [NSValue valueWithCGPoint:CGPointMake(self.routerListView.center.x, self.routerListView.height/2 + TOPBAR_EDGEINSET_TOP - self.routerListTableViewContentInset.top)];
    showRouterListAnimation.duration = kRouterListAnimationDuration;
    showRouterListAnimation.beginTime = CACurrentMediaTime() + 0.1;
    showRouterListAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    showRouterListAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            self.isRouterListShow = YES;
        }
    };
    [self.routerListView pop_addAnimation:showRouterListAnimation forKey:@"showRouterListAnimation"];
    
    // 隐藏导航栏按钮
    POPBasicAnimation *hideBarButtonViewAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    hideBarButtonViewAnimation.toValue = @(0.0);
    hideBarButtonViewAnimation.duration = kRouterListAnimationDuration;
    hideBarButtonViewAnimation.beginTime = CACurrentMediaTime() + 0.1;
    hideBarButtonViewAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    [self.leftBarButton pop_addAnimation:hideBarButtonViewAnimation forKey:@"hideBarButtonViewAnimation"];
    [self.rightBarButton pop_addAnimation:hideBarButtonViewAnimation forKey:@"hideBarButtonViewAnimation"];
    
    // Flip ArrowImage
    POPBasicAnimation *flipArrowImageAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    flipArrowImageAnimation.toValue = @(M_PI);
    flipArrowImageAnimation.duration = kRouterListAnimationDuration;
    flipArrowImageAnimation.beginTime = CACurrentMediaTime() + 0.1;
    flipArrowImageAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    [self.arrowImageView.layer pop_addAnimation:flipArrowImageAnimation forKey:@"flipArrowImageAnimation"];
    
    // 显示mask
    self.mask.hidden = NO;
    POPBasicAnimation *showMaskAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    showMaskAnimation.toValue = @(0.8);
    showMaskAnimation.duration = kRouterListAnimationDuration;
    showMaskAnimation.beginTime = CACurrentMediaTime() + 0.1;
    showMaskAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    [self.mask pop_addAnimation:showMaskAnimation forKey:@"showMaskAnimation"];
}

- (IBAction)hideRouterList {
    // 隐藏RouterList
    POPBasicAnimation *hideRouterListAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    hideRouterListAnimation.toValue  = [NSValue valueWithCGPoint:CGPointMake(self.routerListView.center.x, -self.routerListView.height/2 + TOPBAR_EDGEINSET_TOP)];
    hideRouterListAnimation.duration = kRouterListAnimationDuration;
    hideRouterListAnimation.beginTime = CACurrentMediaTime() + 0.1;
    //    hideRouterListAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    hideRouterListAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            self.isRouterListShow = NO;
        }
    };
    [self.routerListView pop_addAnimation:hideRouterListAnimation forKey:@"hideRouterListAnimation"];
    
    // 显示导航栏按钮
    POPBasicAnimation *showBarButtonViewAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    showBarButtonViewAnimation.toValue = @(1.0);
    showBarButtonViewAnimation.duration = kRouterListAnimationDuration;
    showBarButtonViewAnimation.beginTime = CACurrentMediaTime() + 0.1;
    showBarButtonViewAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    [self.leftBarButton pop_addAnimation:showBarButtonViewAnimation forKey:@"showBarButtonViewAnimation"];
    [self.rightBarButton pop_addAnimation:showBarButtonViewAnimation forKey:@"showBarButtonViewAnimation"];
    
    // Flip ArrowImage
    POPBasicAnimation *flipArrowImageAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    flipArrowImageAnimation.toValue = @(0);
    flipArrowImageAnimation.duration = kRouterListAnimationDuration;
    flipArrowImageAnimation.beginTime = CACurrentMediaTime() + 0.1;
    flipArrowImageAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    [self.arrowImageView.layer pop_addAnimation:flipArrowImageAnimation forKey:@"flipArrowImageAnimation"];
    
    // 隐藏mask
    POPBasicAnimation *hideMaskAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    hideMaskAnimation.toValue = @(0.0);
    hideMaskAnimation.duration = kRouterListAnimationDuration;
    hideMaskAnimation.beginTime = CACurrentMediaTime() + 0.1;
    hideMaskAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            self.mask.hidden = YES;
        }
    };
    [self.mask pop_addAnimation:hideMaskAnimation forKey:@"hideMaskAnimation"];
}

- (void)correctTopologyWithScale:(CGFloat)aScale {
    CGFloat scaleMinStateEnded = 0.6;
    CGFloat scaleMaxStateEnded = 1.2;
    
    CGFloat finalScale = aScale;
    
    if (aScale < scaleMinStateEnded) {
        finalScale = scaleMinStateEnded;
        
        POPBasicAnimation *positionCorrectAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        positionCorrectAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.baseView.center.x, self.baseView.center.y-self.controlView.height*0.5)];
        positionCorrectAnimation.beginTime = CACurrentMediaTime();
        positionCorrectAnimation.duration = kTopologyViewCorrectDuration;
        positionCorrectAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        positionCorrectAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                
            }
        };
        [self.topologyView pop_addAnimation:positionCorrectAnimation forKey:@"positionCorrectAnimation"];
    }
    
    if (aScale > scaleMaxStateEnded) {
        CGFloat topConstant = 0.0;
        for (NSLayoutConstraint *layoutConstraint in self.baseView.constraints) {
            if (layoutConstraint.firstAttribute == NSLayoutAttributeTop && [layoutConstraint.firstItem isKindOfClass:[HWFTopologyView class]]) {
                topConstant = layoutConstraint.constant;
                
            }
        }
        
        finalScale = scaleMaxStateEnded;
        
        POPBasicAnimation *positionCorrectAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        positionCorrectAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.baseView.center.x, self.baseView.height*0.5-topConstant)];
        positionCorrectAnimation.beginTime = CACurrentMediaTime();
        positionCorrectAnimation.duration = kTopologyViewCorrectDuration;
        positionCorrectAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        positionCorrectAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                
            }
        };
        [self.topologyView pop_addAnimation:positionCorrectAnimation forKey:@"positionCorrectAnimation"];
    }
    
    POPBasicAnimation *scaleCorrectAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleCorrectAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(finalScale, finalScale)];
    scaleCorrectAnimation.beginTime = CACurrentMediaTime();
    scaleCorrectAnimation.duration = kTopologyViewCorrectDuration;
    scaleCorrectAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    scaleCorrectAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    [self.topologyView pop_addAnimation:scaleCorrectAnimation forKey:@"scaleAnimation"];

}

- (BOOL)isTopologyViewOutsideOfBaseView {
//    CGFloat topConstant = 0.0;
//    CGFloat bottomConstant = 0.0;
//    CGFloat leftConstant = 0.0;
//    CGFloat rightConstant = 0.0;
//    
//    for (NSLayoutConstraint *layoutConstraint in self.baseView.constraints) {
//        if (layoutConstraint.firstAttribute == NSLayoutAttributeTop && [layoutConstraint.firstItem isKindOfClass:[HWFTopologyView class]]) {
//            topConstant = layoutConstraint.constant;
//        }
//        
//        if (layoutConstraint.secondAttribute == NSLayoutAttributeBottom && [layoutConstraint.secondItem isKindOfClass:[HWFTopologyView class]]) {
//            bottomConstant = layoutConstraint.constant;
//        }
//        
//        if (layoutConstraint.firstAttribute == NSLayoutAttributeLeading && [layoutConstraint.firstItem isKindOfClass:[HWFTopologyView class]]) {
//            leftConstant = layoutConstraint.constant;
//        }
//        
//        if (layoutConstraint.secondAttribute == NSLayoutAttributeTrailing && [layoutConstraint.secondItem isKindOfClass:[HWFTopologyView class]]) {
//            rightConstant = layoutConstraint.constant;
//        }
//    }
//    
//    CGRect actualRect = self.topologyView.frame;
//    actualRect.origin.x += (self.topologyView.bounds.size.width - self.topologyView.actualBounds.size.width) * 0.5;
//    actualRect.origin.y += (self.topologyView.bounds.size.height - self.topologyView.actualBounds.size.height) * 0.5;
//    actualRect.size.width = self.topologyView.actualBounds.size.width;
//    actualRect.size.height = self.topologyView.actualBounds.size.height;
//    DDLogDebug(@"%@     %@", NSStringFromCGRect(self.topologyView.frame), NSStringFromCGRect(actualRect));
//    BOOL isTopologyViewCenterOutsideOfBaseView = CGRectContainsRect(self.baseView.frame, actualRect);
//    return isTopologyViewCenterOutsideOfBaseView;
    
    return CGRectContainsPoint(self.baseView.frame, self.topologyView.center);
}

- (void)correctTopologyPosition {
    CGFloat currentScale = self.topologyView.frame.size.width / self.topologyView.bounds.size.width;
    
    if (currentScale <= 1.0) {
        POPBasicAnimation *positionCorrectAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        positionCorrectAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.baseView.center.x, self.baseView.center.y-self.controlView.height*0.5)];
        positionCorrectAnimation.beginTime = CACurrentMediaTime();
        positionCorrectAnimation.duration = kTopologyViewCorrectDuration;
        positionCorrectAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        positionCorrectAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                
            }
        };
        [self.topologyView pop_addAnimation:positionCorrectAnimation forKey:@"positionCorrectAnimation"];
    }
    
    if (currentScale > 1.0) {
        CGFloat topConstant = 0.0;
        for (NSLayoutConstraint *layoutConstraint in self.baseView.constraints) {
            if (layoutConstraint.firstAttribute == NSLayoutAttributeTop && [layoutConstraint.firstItem isKindOfClass:[HWFTopologyView class]]) {
                topConstant = layoutConstraint.constant;
                
            }
        }
        
        POPBasicAnimation *positionCorrectAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        positionCorrectAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.baseView.center.x, self.baseView.height*0.5-topConstant)];
        positionCorrectAnimation.beginTime = CACurrentMediaTime();
        positionCorrectAnimation.duration = kTopologyViewCorrectDuration;
        positionCorrectAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        positionCorrectAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                
            }
        };
        [self.topologyView pop_addAnimation:positionCorrectAnimation forKey:@"positionCorrectAnimation"];
    }
}

#pragma mark - Gesture
- (void)pinchHandler:(UIPinchGestureRecognizer *)pinchGesture {
    CGFloat currentScale = self.topologyView.frame.size.width / self.topologyView.bounds.size.width;
    CGFloat newScale = currentScale * pinchGesture.scale;

    switch (pinchGesture.state) {
        case UIGestureRecognizerStateBegan:
        {

        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat scaleMinStateChanged = 0.3;
            CGFloat scaleMaxStateChanged = 1.8;
            
            newScale = (newScale < scaleMinStateChanged) ? scaleMinStateChanged : newScale;
            newScale = (newScale > scaleMaxStateChanged) ? scaleMaxStateChanged : newScale;

            POPBasicAnimation *scaleCorrectAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            scaleCorrectAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(newScale, newScale)];
            scaleCorrectAnimation.beginTime = CACurrentMediaTime();
            scaleCorrectAnimation.duration = 0.0;
            scaleCorrectAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            scaleCorrectAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    
                }
            };
            [self.topologyView pop_addAnimation:scaleCorrectAnimation forKey:@"scaleAnimation"];
            
            pinchGesture.scale = 1.0;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self correctTopologyWithScale:newScale];
        }
        default:
            break;
    }
}

- (void)panHandler:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            POPDecayAnimation *moveDecayAnimation = [self.topologyView pop_animationForKey:@"moveDecayAnimation"];
            if (moveDecayAnimation) {
                moveDecayAnimation.velocity = [NSValue valueWithCGPoint:CGPointZero];
            }
        }
            // no break
        case UIGestureRecognizerStateChanged:
        {
            CGPoint location = [panGesture translationInView:self.view];
            self.topologyView.center = CGPointMake(self.topologyView.center.x+location.x, self.topologyView.center.y+location.y);
            [panGesture setTranslation:CGPointZero inView:self.view];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (![self isTopologyViewOutsideOfBaseView]) {
                [self correctTopologyPosition];
            } else {
                CGPoint velocity = [panGesture velocityInView:self.view];
                POPDecayAnimation *moveDecayAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPViewCenter];
                moveDecayAnimation.velocity = [NSValue valueWithCGPoint:velocity];
                moveDecayAnimation.deceleration = 0.995;
                moveDecayAnimation.delegate = self;
                moveDecayAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                    if (finished) {
                        if (![self isTopologyViewOutsideOfBaseView]) {
                            [self correctTopologyPosition];
                        }
                    }
                };
                [self.topologyView pop_addAnimation:moveDecayAnimation forKey:@"moveDecayAnimation"];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - POPAnimationDelegate
- (void)pop_animationDidApply:(POPAnimation *)anim {
    if (![self isTopologyViewOutsideOfBaseView]) {
        [self.topologyView pop_removeAnimationForKey:@"moveDecayAnimation"];
        [self correctTopologyPosition];
    }
}

#pragma mark - 拓扑图
// 加载初始的拓扑结构
- (void)loadInitialTopology {
    // 未登录 或 没有绑定路由 或 没有默认路由器
    if (![HWFUser defaultUser] || ![[[HWFUser defaultUser] bindRouterRIDs] count] || ![HWFRouter defaultRouter]) {
        return;
    }
    
    // Root Node
    HWFNetworkNode *rootNode = [[HWFNetworkNode alloc] init];
    rootNode.type = NetworkNodeTypeGatewayRouter;
    rootNode.nodeEntity = [HWFRouter defaultRouter];
    
    self.topologyView.root = rootNode;
    self.topologyView.leaves = nil;
    
    if (SCREEN_HEIGHT < 500) { // 3.5寸屏
        self.topologyView.scale = 0.8;
    } else {
        self.topologyView.scale = 1.0;
    }
    
    [self correctTopologyWithScale:0.0];
    [self correctTopologyWithScale:0.8];
}

// 加载路由器拓扑结构
- (void)loadRouterTopology {
    [[HWFService defaultService] loadRouterTopologyWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if (CODE_SUCCESS == code) {
            NSDictionary *nodesDict = data[@"smart_device"];
            
            if (!nodesDict) {
                //TODO: Tip
                return;
            }
            
            // Root Node
            HWFRouter *rootRouter = [HWFRouter defaultRouter];
            rootRouter.MAC = nodesDict[@"mac"];
//            rootRouter.name = nodesDict[@"name"];
            rootRouter.SSID24G = nodesDict[@"ssid"];
            rootRouter.model = nodesDict[@"device_model"];
            rootRouter.place = [nodesDict[@"place"] integerValue];
            rootRouter.isOnline = [nodesDict[@"is_connect"] boolValue];
            rootRouter.IP = nodesDict[@"ip"];

            HWFNetworkNode *rootNode = [[HWFNetworkNode alloc] init];
            rootNode.type = NetworkNodeTypeGatewayRouter;
            rootNode.nodeEntity = rootRouter;
            
            self.topologyView.root = rootNode;
            
            // Leaf Node
            NSMutableArray *leafNodes = [NSMutableArray array];
            for (NSDictionary *smartDeviceDict in nodesDict[@"smart_devices"]) {
                HWFSmartDevice *smartDevice = [[HWFSmartDevice alloc] init];
                smartDevice.MAC = smartDeviceDict[@"mac"];
                smartDevice.name = smartDeviceDict[@"name"];
                smartDevice.model = smartDeviceDict[@"device_model"];
                smartDevice.place = [smartDeviceDict[@"place"] integerValue];
                smartDevice.matchStatus = [smartDeviceDict[@"bind_state"] integerValue];
                smartDevice.IP = smartDeviceDict[@"ip"];
                
                HWFNetworkNode *leafNode = [[HWFNetworkNode alloc] init];
                leafNode.type = NetworkNodeTypeSmartDevice;
                leafNode.nodeEntity = smartDevice;
                
                [leafNodes addObject:leafNode];
            }
            
            self.topologyView.leaves = leafNodes;
            
            if (SCREEN_HEIGHT < 500) { // 3.5寸屏
                self.topologyView.scale = 0.8;
            } else {
                self.topologyView.scale = 1.0;
            }
            
//            // iOS 8.0 以下: Constraint Correct
//            if (SYSTEM_VERSION_LESS_THAN(@"8.0") && leafNodes.count > 0) {
//                CGFloat networkNodeViewWidth = 100.0;
//                for (NSLayoutConstraint *layoutConstraint in self.baseView.constraints) {
//                    if ([layoutConstraint.firstItem isKindOfClass:[HWFTopologyView class]] && layoutConstraint.firstAttribute==NSLayoutAttributeLeading) {
//                        layoutConstraint.constant = -1 * networkNodeViewWidth * leafNodes.count;
//                    }
//                    if ([layoutConstraint.secondItem isKindOfClass:[HWFTopologyView class]] && layoutConstraint.firstAttribute==NSLayoutAttributeTrailing) {
//                        layoutConstraint.constant = -1 * networkNodeViewWidth * leafNodes.count;
//                    }
//                }
//            }

            [self correctTopologyWithScale:0.8];
        }
    }];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[HWFUser defaultUser] bindRouters] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFRouterListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RouterListCell"];
    cell.delegate = self;
    
    HWFRouter *router = [[HWFUser defaultUser] bindRouters][indexPath.row];
    if (router) {
        [cell loadData:router];
    }
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    HWFRouter *router = [[HWFUser defaultUser] bindRouters][indexPath.row];
//    [[HWFDataCenter defaultCenter] setDefaultRouter:router];
//    
//    [self firstBloodWithRouter:[HWFRouter defaultRouter]];
//    
//    [self toggleRouterListShow];
//}

#pragma mark - HWFRouterListCellDelegate
- (void)clickRouterListCell:(HWFRouterListCell *)aCell {
    [[HWFDataCenter defaultCenter] setDefaultRouter:aCell.router];
    
    [self.routerListTableView reloadData];
    
    [self firstBloodWithRouter:[HWFRouter defaultRouter]];
    
    [self toggleRouterListShow];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
