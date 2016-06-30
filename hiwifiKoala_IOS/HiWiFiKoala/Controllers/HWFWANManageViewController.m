//
//  HWFWANManageViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/22.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFWANManageViewController.h"
#import "HWFGeneralTableViewCell.h"
#import "HWFService+Router.h"

@interface HWFWANManageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *WANTableView;
@property (nonatomic,strong) NSArray *WANStatusArray;
@property (nonatomic,strong) NSArray *WANMessageArray;

@end

@implementation HWFWANManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
   
}

- (void)initData {
    if ([[HWFRouter defaultRouter]isOnline]) {
//        //路由器在线---写这里会有停顿的感觉
//        self.WANStatusArray =  @[
//                                 [[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleDesc title:@"连接" desc:@"已连接" switchOn:NO buttonTitle:nil]
//                                 ];
        [self loadingViewShow];
        [[HWFService defaultService]loadWANInfoWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            [self loadingViewHide];
            if (code == CODE_SUCCESS) {
                //成功
                NSArray *dnsArray = [data objectForKey:@"dns"];
                NSString *dnsString = nil;
                if (dnsArray.count > 1) {
                    dnsString = [NSString stringWithFormat:@"%@ / %@",dnsArray[0],dnsArray[1]];
                }
                
                NSString *routerAddressStr = [data objectForKey:@"wan_ip"];
                self.WANMessageArray = @[
                                        [[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleDesc title:@"路由器地址" desc:routerAddressStr switchOn:NO buttonTitle:nil],
                                        [[HWFGeneralTableViewItem alloc] initWithIdentity:@"2" style:GeneralTableViewCellStyleDesc title:@"DNS服务器" desc:dnsString switchOn:NO buttonTitle:nil]
                                        ];
                //路由器在线
                self.WANStatusArray =  @[
                                         [[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleDesc title:@"连接" desc:@"已连接" switchOn:NO buttonTitle:nil]
                                         ];
                [self.WANTableView reloadData];
            } else {
                //失败
                [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
            }
        }];

    } else {
        //路由器不在线
        self.WANStatusArray =  @[
                                 [[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleDesc title:@"连接" desc:@"已断开连接" switchOn:NO buttonTitle:nil]
                                 ];
        [self.WANTableView reloadData];

    }
}

- (void)initView {
    self.title = @"互联网";
    [self addBackBarButtonItem];
    [self.WANTableView registerNib:[UINib nibWithNibName:@"HWFGeneralTableViewCell" bundle:nil] forCellReuseIdentifier:@"GeneralTableViewCell"];

}

#pragma mark - UITableViewDelegate / UITableViewDataSource
// 取消Section.HeaderView随动
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGFloat sectionHeaderHeight;
    if ([[HWFRouter defaultRouter]isOnline]) {
         sectionHeaderHeight = 30; //sectionHeaderHeight
    } else {
         sectionHeaderHeight = 10; //sectionHeaderHeight
    }
    
    if (aScrollView.contentOffset.y<=sectionHeaderHeight&&aScrollView.contentOffset.y>=0) {
        aScrollView.contentInset = UIEdgeInsetsMake(-aScrollView.contentOffset.y, 0, 0, 0);
    } else if (aScrollView.contentOffset.y>=sectionHeaderHeight) {
        aScrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[HWFRouter defaultRouter]isOnline]) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[HWFRouter defaultRouter]isOnline]) {
        //在线
        if (section == 0) {
            return self.WANStatusArray.count;
        } else if (section == 1) {
            return self.WANMessageArray.count;
        }
    } else {
        //不在线
        return self.WANStatusArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[HWFRouter defaultRouter]isOnline]) {
        //在线
        if (section == 0) {
            return 10;
        } else if (section == 1) {
            return 30;
        }
    } else {
        //不在线
        return 10;
    }
    return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFGeneralTableViewCell *WANCell = (HWFGeneralTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell"];
    if ([[HWFRouter defaultRouter] isOnline]) {
        //在线
        if (indexPath.section == 0) {
            [WANCell loadData:self.WANStatusArray[indexPath.row]];
        } else {
            [WANCell loadData:self.WANMessageArray[indexPath.row]];
        }
    } else {
        [WANCell loadData:self.WANStatusArray[indexPath.row]];
    }
    return WANCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
