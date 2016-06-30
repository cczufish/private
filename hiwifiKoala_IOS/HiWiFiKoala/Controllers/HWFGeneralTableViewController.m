//
//  HWFGeneralTableViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-9.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFGeneralTableViewController.h"

#import "HWFGeneralTableViewCell.h"

@interface HWFGeneralTableViewController () <HWFGeneralTableViewCellDelegate>

@property (strong, nonatomic) NSArray *items;

@end

@implementation HWFGeneralTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.items = @[
                   [[HWFGeneralTableViewItem alloc] initWithIdentity:@"1" style:GeneralTableViewCellStyleNone title:@"CellStyleNone" subTitle:@"SubTitle" desc:nil switchOn:NO buttonTitle:nil],
                   [[HWFGeneralTableViewItem alloc] initWithIdentity:@"2" style:GeneralTableViewCellStyleDesc title:@"CellStyleDesc" desc:@"Desc" switchOn:NO buttonTitle:nil],
                   [[HWFGeneralTableViewItem alloc] initWithIdentity:@"3" style:GeneralTableViewCellStyleArrow title:@"CellStyleArrow" desc:nil switchOn:NO buttonTitle:nil],
                   [[HWFGeneralTableViewItem alloc] initWithIdentity:@"4" style:GeneralTableViewCellStyleDescArrow title:@"CellStyleDescArrow" desc:@"DescArrow" switchOn:NO buttonTitle:nil],
                   [[HWFGeneralTableViewItem alloc] initWithIdentity:@"5" style:GeneralTableViewCellStyleSwitch title:@"CellStyleSwitch" desc:nil switchOn:YES buttonTitle:nil],
                   [[HWFGeneralTableViewItem alloc] initWithIdentity:@"6" style:GeneralTableViewCellStyleButton title:@"CellStyleButton" desc:nil switchOn:NO buttonTitle:@"发现新版本ROM"],
                   ];
    [self.tableView registerNib:[UINib nibWithNibName:@"HWFGeneralTableViewCell" bundle:nil] forCellReuseIdentifier:@"GeneralTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell"];
    
    [cell loadData:self.items[indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDLogDebug(@"SelectRow : %@", [(HWFGeneralTableViewItem *)self.items[indexPath.row] identity]);
}

#pragma mark - HWFGeneralTableViewCellDelegate
- (void)descButtonClick:(HWFGeneralTableViewCell *)aCell {
    DDLogDebug(@"Button Click : %@", aCell.item.title);
}

- (void)descSwitchChanged:(HWFGeneralTableViewCell *)aCell {
    DDLogDebug(@"Switch Changed : %@ / %d", aCell.item.title, aCell.item.isSwitchOn);
}

@end
