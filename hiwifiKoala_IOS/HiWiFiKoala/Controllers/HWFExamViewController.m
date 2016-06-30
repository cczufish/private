//
//  HWFExamViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-17.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFExamViewController.h"
#import "HWFService+Router.h"
#import "HWFGeneralTableViewCell.h"
#import "HWFExamCell.h"
#import "HWFLineView.h"
#import "HWFModifyAdminPwdViewController.h"
#import "HWFWebViewController.h"

@interface HWFExamViewController ()<UITableViewDataSource,UITableViewDelegate,HWFExamCellDelegate>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *examTableView;

@property (nonatomic,strong) NSMutableArray *examArray;
@property (nonatomic,strong) NSMutableArray *unsafeExamArray;



@end

@implementation HWFExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"test");
    [self loadExamResult];

}

- (void)initData {
    self.examArray = [[NSMutableArray alloc]init];
    self.unsafeExamArray = [[NSMutableArray alloc]init];
}

- (void)initView {
    self.title = @"一键体检";
    [self addBackBarButtonItem];
    
    [self.examTableView registerNib:[UINib nibWithNibName:@"HWFExamCell" bundle:nil] forCellReuseIdentifier:@"ExamCell"];
}

- (void)loadExamResult {

    [self loadingViewShow];
    [[HWFService defaultService] loadRouterExamResultWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        NSLog(@"result:%@",data);
        if (code == CODE_SUCCESS) {
            if (self.examArray.count > 0) {
                [self.examArray removeAllObjects];
            }
            if (self.unsafeExamArray.count > 0) {
                [self.unsafeExamArray removeAllObjects];
            }
            
            if ([[data objectForKey:@"need_upgrade"]boolValue]) {//有升级
                 [self.examArray addObject:[[HWFExamItem alloc] initWithMessage:@"路由器固件" andWithDesc:@"有更新" andWithExamType:ExamItemDescUnSafe withIdentifier:@"1" withDescColor:COLOR_HEX(0x30b0f8)]];
            } else {
                [self.examArray addObject:[[HWFExamItem alloc] initWithMessage:@"路由器固件" andWithDesc:@"已是最新" andWithExamType:ExamItemDescSafe withIdentifier:@"1" withDescColor:COLOR_HEX(0x30b0f8)]];
            }
            
            if ([[data objectForKey:@"wifi_24g_has_pwd"]boolValue]) {//2.4g安全
                 [self.examArray addObject:[[HWFExamItem alloc] initWithMessage:@"2.4G WiFi密码" andWithDesc:@"安全" andWithExamType:ExamItemDescSafe withIdentifier:@"2" withDescColor:COLOR_HEX(0x30ce95)]];
            } else {
                [self.examArray addObject:[[HWFExamItem alloc] initWithMessage:@"2.4G WiFi密码" andWithDesc:@"点击设置" andWithExamType:ExamItemDescUnSafe withIdentifier:@"2" withDescColor:COLOR_HEX(0x999999)]];
            }
            
            if ([[data objectForKey:@"wifi_5g_has_pwd"] intValue] == -1) {
                
            } else if ([[data objectForKey:@"wifi_5g_has_pwd"]boolValue]) {//5g安全
                [self.examArray addObject:[[HWFExamItem alloc] initWithMessage:@"5G WiFi密码" andWithDesc:@"安全" andWithExamType:ExamItemDescSafe withIdentifier:@"3" withDescColor:COLOR_HEX(0x30ce95)]];
            } else {
                [self.examArray addObject:[[HWFExamItem alloc] initWithMessage:@"5G WiFi密码" andWithDesc:@"点击设置" andWithExamType:ExamItemDescUnSafe withIdentifier:@"3" withDescColor:COLOR_HEX(0x999999)]];
            }
            
            if ([[data objectForKey:@"sys_pwd_default"]boolValue]) {//后台密码安全
                [self.examArray addObject:[[HWFExamItem alloc] initWithMessage:@"路由器后台管理密码" andWithDesc:@"安全" andWithExamType:ExamItemDescSafe withIdentifier:@"4" withDescColor:COLOR_HEX(0x30ce95)]];
            } else {
                [self.examArray addObject:[[HWFExamItem alloc] initWithMessage:@"路由器后台管理密码" andWithDesc:@"点击设置" andWithExamType:ExamItemDescUnSafe withIdentifier:@"4" withDescColor:COLOR_HEX(0x999999)]];
            }
            [self.examTableView reloadData];
            
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor whiteColor];
    
    HWFLineView *lineView = [[HWFLineView alloc]initWithFrame:CGRectMake(0, 99, SCREEN_WIDTH, 1)];
    lineView.lineColor = COLOR_HEX(0x999999);
    [view addSubview:lineView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:view.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:36.0];
    for (HWFExamItem *item in self.examArray) {
        if (item.examStyle == ExamItemDescUnSafe) {
            [self.unsafeExamArray addObject:item];
        }
    }
    if (self.unsafeExamArray.count > 0) {
        label.textColor = [UIColor redColor];
    } else {
        label.textColor = COLOR_HEX(0x30ce95);
    }
    NSString *probleNum = [NSString stringWithFormat:@"发现 %lu 项问题",(unsigned long)[self.unsafeExamArray count]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:probleNum];
    [attString setAttributes:@{NSForegroundColorAttributeName: COLOR_HEX(0x333333) , NSFontAttributeName : [UIFont systemFontOfSize:16.0]} range:NSMakeRange(0, 2)];
    [attString setAttributes:@{NSForegroundColorAttributeName: COLOR_HEX(0x333333) , NSFontAttributeName : [UIFont systemFontOfSize:16.0]} range:NSMakeRange(attString.length-3, 3)];
    label.attributedText = attString;
    [view addSubview:label];
    if (self.examArray.count > 0) {
        label.hidden = NO;
        lineView.hidden = NO;
    } else {
        label.hidden = YES;
        lineView.hidden = YES;
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.examArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFExamCell *examCell = [tableView dequeueReusableCellWithIdentifier:@"ExamCell"];
    [examCell loadWithExamItem:self.examArray[indexPath.row]];
    examCell.delegate = self;
    return examCell;
}

#pragma mark - HWFExamCellDelegate
- (void)buttonClick:(HWFExamCell *)aCell {
    if ([aCell.examItem.message isEqualToString:@"路由器固件"]) {
        NSLog(@"路由器固件");
        
    } else if ([aCell.examItem.message isEqualToString:@"2.4G WiFi密码"]) {
        NSLog(@"2.4G WiFi密码");
        HWFWebViewController *webView = [[HWFWebViewController alloc]initWithNibName:@"HWFWebViewController" bundle:nil];
        webView.HTTPMethod = HTTPMethodGet;
        webView.URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_WEB_WIFI_CONFIG];
        [self.navigationController pushViewController:webView animated:YES];
    
    } else if ([aCell.examItem.message isEqualToString:@"5G WiFi密码"]) {
         NSLog(@"5G WiFi密码");
        HWFWebViewController *webView = [[HWFWebViewController alloc]initWithNibName:@"HWFWebViewController" bundle:nil];
        webView.HTTPMethod = HTTPMethodGet;
        webView.URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_WEB_WIFI_CONFIG];
        [self.navigationController pushViewController:webView animated:YES];
        
    } else if ([aCell.examItem.message isEqualToString:@"路由器后台管理密码"]) {
         NSLog(@"路由器后台管理密码");
         HWFModifyAdminPwdViewController * modifyVC = [[HWFModifyAdminPwdViewController alloc]initWithNibName:@"HWFModifyAdminPwdViewController" bundle:nil
                                                          ];
        [self.navigationController pushViewController:modifyVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
