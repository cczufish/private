//
//  HWFNavigationController.m
//  HiWiFiKoala
//
//  Created by dp on 14-9-15.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFNavigationController.h"

#import "HWFTool.h"

@interface HWFNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation HWFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationBar setBackgroundImage:[HWFTool imageWithColor:[UIColor navigationBarColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTitleTextAttributes:@{ UITextAttributeTextColor:[UIColor baseTintColor] }];
    
    // 滑动返回
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Fix: 避免Push过程中，由于出发滑动返回手势导致Crash
// Push过程中，关闭滑动返回功能
// 与 HWFMasterViewController 中的 navigationController:didShowViewController:animated: 代理方法配合使用
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // fix 'nested pop animation can result in corrupted navigation bar'
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
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
