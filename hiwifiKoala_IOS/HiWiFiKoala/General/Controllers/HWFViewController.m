//
//  HWFViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface HWFViewController () <MBProgressHUDDelegate>

@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) MBProgressHUD *loadingView;
@property (assign, nonatomic) NSInteger loadingCount;

@property (strong, nonatomic) UIButton *leftBarButton;
@property (strong, nonatomic) UIButton *rightBarButton;
@property (strong, nonatomic) HWFBadgeView *rightBarButtonBadgeView;

@end

@implementation HWFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusChangeHandle:) name:kNotificationReachabilityStatusChange object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationReachabilityStatusChange object:nil];
}

- (void)reachabilityStatusChangeHandle:(NSNotification *)notification {
    AFNetworkReachabilityStatus status = [notification.userInfo[@"status"] integerValue];
    DDLogDebug(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
}

#pragma mark - StatusBar
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - NavigationBar
- (void)addLeftBarButtonItemWithImage:(UIImage *)image activeImage:(UIImage *)activeImage title:(NSString *)title target:(id)target action:(SEL)action {
    if (!self.navigationController) {
        return;
    }
    
    self.leftBarButton = [[UIButton alloc] init];
    if (image) { // image
        [self.leftBarButton setFrame:CGRectMake(0, 0, 22, 22)];
        [self.leftBarButton setImage:image forState:UIControlStateNormal];
        [self.leftBarButton setImage:activeImage?:image forState:UIControlStateHighlighted];
        [self.leftBarButton setTitle:nil forState:UIControlStateNormal];
    } else { // title
        self.leftBarButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        CGSize titleTextSize = [title sizeWithFont:self.rightBarButton.titleLabel.font constrainedToSize:CGSizeMake(60, 44) lineBreakMode:NSLineBreakByCharWrapping];
        [self.leftBarButton setFrame:CGRectMake(0, 0, titleTextSize.width, 44)];
        [self.leftBarButton setImage:nil forState:UIControlStateNormal];
        [self.leftBarButton setImage:nil forState:UIControlStateHighlighted];
        [self.leftBarButton setTitle:title forState:UIControlStateNormal];
        [self.leftBarButton setTitleColor:[UIColor baseTintColor] forState:UIControlStateNormal];
        [self.leftBarButton setTitleColor:[UIColor baseTintColor] forState:UIControlStateHighlighted];
    }
    [self.leftBarButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBarButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)addRightBarButtonItemWithImage:(UIImage *)image activeImage:(UIImage *)activeImage title:(NSString *)title target:(id)target action:(SEL)action {
    if (!self.navigationController) {
        return;
    }
    
    self.rightBarButton = [[UIButton alloc] init];
    if (image) { // image
        [self.rightBarButton setFrame:CGRectMake(0, 0, 22, 22)];
        [self.rightBarButton setImage:image forState:UIControlStateNormal];
        [self.rightBarButton setImage:activeImage?:image forState:UIControlStateHighlighted];
        [self.rightBarButton setTitle:nil forState:UIControlStateNormal];
    } else { // title
        self.rightBarButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        CGSize titleTextSize = [title sizeWithFont:self.rightBarButton.titleLabel.font constrainedToSize:CGSizeMake(60, 44) lineBreakMode:NSLineBreakByCharWrapping];
        [self.rightBarButton setFrame:CGRectMake(0, 0, titleTextSize.width, 44)];
        [self.rightBarButton setImage:nil forState:UIControlStateNormal];
        [self.rightBarButton setImage:nil forState:UIControlStateHighlighted];
        [self.rightBarButton setTitle:title forState:UIControlStateNormal];
        [self.rightBarButton setTitleColor:[UIColor baseTintColor] forState:UIControlStateNormal];
        [self.rightBarButton setTitleColor:[UIColor baseTintColor] forState:UIControlStateHighlighted];
    }
    
    // badgeView
    CGFloat badgeViewRadius = self.rightBarButton.bounds.size.height*0.2;
    self.rightBarButtonBadgeView = [[HWFBadgeView alloc] initWithFrame:CGRectMake(self.rightBarButton.bounds.size.width-badgeViewRadius*2, 0, badgeViewRadius*2, badgeViewRadius*2)];
    self.rightBarButtonBadgeView.badgeForegroundColor = [UIColor whiteColor];
    self.rightBarButtonBadgeView.badgeBackgroundColor = [UIColor redColor];
    self.rightBarButtonBadgeView.hidden = YES;
    [self.rightBarButton addSubview:self.rightBarButtonBadgeView];
    
    [self.rightBarButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)addBackBarButtonItem {
    [self addLeftBarButtonItemWithImage:[UIImage imageNamed:@"arrow-left"] activeImage:[UIImage imageNamed:@"arrow-left-blue"] title:@"返回" target:self action:@selector(backBarButtonHandler)];
}

- (void)backBarButtonHandler {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - HUD
- (void)showTipWithType:(HWFTipType)type code:(NSInteger)code message:(NSString *)message {
    // HWFTipTypeError表现形式为UIAlertView
    if (type == HWFTipTypeError) {
        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    // 如果当前有HUD在展现，则移除
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CGFloat duration = 2.0;
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    
    switch (type) {
        case HWFTipTypeSuccess:
        {
            duration = 2.0;
            
            self.HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:customView.bounds];
            iconImageView.image = [UIImage imageNamed:@"success-w"];
            [customView addSubview:iconImageView];
        }
            break;
        case HWFTipTypeMessage:
        {
            duration = 2.0;
            
            self.HUD.mode = MBProgressHUDModeText;
        }
            break;
        case HWFTipTypeWarning:
        {
            duration = 2.0;
            
            self.HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:customView.bounds];
            iconImageView.image = [UIImage imageNamed:@"alert-w"];
            [customView addSubview:iconImageView];
        }
            break;
        case HWFTipTypeFailure:
        {
            duration = 3.0;
            
            self.HUD.mode = MBProgressHUDModeCustomView;
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:customView.bounds];
            iconImageView.image = [UIImage imageNamed:@"alert-w"];
            [customView addSubview:iconImageView];
        }
            break;
        default:
            break;
    }
    
    self.HUD.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
    self.HUD.detailsLabelText = message;
    self.HUD.customView = customView;
    self.HUD.animationType = MBProgressHUDAnimationZoomOut;
    self.HUD.delegate = self;
    self.HUD.margin = 30.0;
    self.HUD.userInteractionEnabled = NO; // 非阻塞
    
    [self.HUD showAnimated:YES whileExecutingBlock:^{
        sleep(duration);
    } completionBlock:^{
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }];
}

- (void)showTipWithCustomView:(UIView *)aCustomView code:(NSInteger)code message:(NSString *)message {
    // 如果当前有HUD在展现，则移除
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CGFloat duration = 2.0;
    self.HUD.mode = MBProgressHUDModeCustomView;
    // hud.labelText = labelText; // 标题
    self.HUD.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
    self.HUD.detailsLabelText = message;
    self.HUD.customView = aCustomView;
    self.HUD.animationType = MBProgressHUDAnimationZoomOut;
    self.HUD.delegate = self;
    self.HUD.userInteractionEnabled = NO; // 非阻塞

    [self.HUD showAnimated:YES whileExecutingBlock:^{
        sleep(duration);
    } completionBlock:^{
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }];
}

- (void)loadingViewInit {
    self.loadingView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingView.mode = MBProgressHUDModeIndeterminate;
    self.loadingView.labelText = @"正在加载";
    self.loadingView.animationType = MBProgressHUDAnimationFade;
    self.loadingView.dimBackground = YES;
    self.loadingView.delegate = self;
}

- (void)loadingViewShow {
    if (!self.loadingView) {
        [self loadingViewInit];
    }
    
    if (self.loadingCount <= 0) {
        [self.loadingView show:YES];
        self.loadingCount = 0;
    }
    
    self.loadingCount++;
}

- (void)loadingViewHide {
    self.loadingCount--;
    if (self.loadingCount <= 0) {
        [self.loadingView hide:YES];
        self.loadingCount = 0;
    }
}

- (void)loadingViewAllHide {
    self.loadingCount = 0;
    [self.loadingView hide:YES];
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
