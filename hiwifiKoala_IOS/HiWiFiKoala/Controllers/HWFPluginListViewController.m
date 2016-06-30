//
//  HWFPluginListViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFPluginListViewController.h"

#import "HWFPluginViewController.h"
#import "HWFPluginListInCategoryViewController.h"

#import "HWFAppliedPluginTableViewCell.h"

#import "HWFService+Plugin.h"

@interface HWFPluginListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *appliedPlugins; // 应用型插件
@property (weak, nonatomic) IBOutlet UITableView *appliedPluginTableView;
@property (weak, nonatomic) IBOutlet UIButton *labPluginCategoryButton; // 实验室
@property (weak, nonatomic) IBOutlet UIButton *payPluginCategoryButton; // 极智专区

@end

@implementation HWFPluginListViewController

- (NSMutableArray *)appliedPlugins {
    if (!_appliedPlugins) {
        _appliedPlugins = [[NSMutableArray alloc] init];
    }
    return _appliedPlugins;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // View
    self.title = @"云插件";
    [self addBackBarButtonItem];
    
    // Button
    // 实验室
    [self.labPluginCategoryButton setBackgroundImage:[[UIImage imageNamed:@"btn-2"] stretchableImageWithLeftCapWidth:23.0 topCapHeight:23.0] forState:UIControlStateNormal];
    [self.labPluginCategoryButton setBackgroundImage:[[UIImage imageNamed:@"btn-1"] stretchableImageWithLeftCapWidth:23.0 topCapHeight:23.0] forState:UIControlStateHighlighted];

    // 极智
    [self.payPluginCategoryButton setBackgroundImage:[[UIImage imageNamed:@"btn-3"] stretchableImageWithLeftCapWidth:23.0 topCapHeight:23.0] forState:UIControlStateNormal];
    [self.payPluginCategoryButton setBackgroundImage:[[UIImage imageNamed:@"btn-1"] stretchableImageWithLeftCapWidth:23.0 topCapHeight:23.0] forState:UIControlStateHighlighted];
    
    // Table View Cell
    [self.appliedPluginTableView registerNib:[UINib nibWithNibName:@"HWFAppliedPluginTableViewCell" bundle:nil] forCellReuseIdentifier:@"AppliedPluginCell"];
    
    // Data
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    [self loadingViewShow];
    HWFPluginCategory *appliedPluginCategory = [[HWFPluginCategory alloc] init];
    appliedPluginCategory.CID = 1;
    [[HWFService defaultService] loadPluginListInCategoryWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] category:appliedPluginCategory completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        
        if (CODE_SUCCESS == code) {
            [self.appliedPlugins removeAllObjects];
            
            NSArray *plugins = data[@"data"] ?: nil;
            for (NSDictionary *pluginDict in plugins) {
                HWFPlugin *plugin = [[HWFPlugin alloc] init];
                plugin.SID = [pluginDict[@"sid"] integerValue];
                plugin.name = pluginDict[@"name"] ?: @"";
                plugin.ICON = pluginDict[@"icon"] ?: nil;
                plugin.info = pluginDict[@"function"] ?: nil;
                plugin.hasInstalled = [pluginDict[@"has_installed"] boolValue];
                plugin.statusMessage = pluginDict[@"status_msg"] ?: nil;
                plugin.canUninstall = [pluginDict[@"can_uninstall"] boolValue];
                plugin.configURL = pluginDict[@"detail_conf_url"];
                
                [self.appliedPlugins addObject:plugin];
            }
            
            [self.appliedPluginTableView reloadData];
        } else {
            [self showTipWithType:HWFTipTypeMessage code:code message:msg];
        }
    }];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appliedPlugins.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFAppliedPluginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppliedPluginCell"];
    
    HWFPlugin *plugin = self.appliedPlugins[indexPath.row];
    [cell loadData:plugin];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

    HWFPlugin *plugin = self.appliedPlugins[indexPath.row];
    
    HWFPluginViewController *pluginViewController = [[HWFPluginViewController alloc] initWithNibName:@"HWFPluginViewController" bundle:nil];
    pluginViewController.plugin = plugin;
    [self.navigationController pushViewController:pluginViewController animated:YES];
}

// 跳转到实验室
- (IBAction)gotoLabPluginCategory:(UIButton *)sender {
    HWFPluginCategory *labPluginCategory = [[HWFPluginCategory alloc] init];
    labPluginCategory.CID = 2;
    labPluginCategory.name = @"实验室";
    
    HWFPluginListInCategoryViewController *labPluginCategoryViewController = [[HWFPluginListInCategoryViewController alloc] initWithNibName:@"HWFPluginListInCategoryViewController" bundle:nil];
    labPluginCategoryViewController.pluginCategory = labPluginCategory;
    [self.navigationController pushViewController:labPluginCategoryViewController animated:YES];
}

// 跳转到极智专区
- (IBAction)gotoPayPluginCategory:(UIButton *)sender {
    HWFPluginCategory *payPluginCategory = [[HWFPluginCategory alloc] init];
    payPluginCategory.CID = 3;
    payPluginCategory.name = @"极智专区";
    
    HWFPluginListInCategoryViewController *payPluginCategoryViewController = [[HWFPluginListInCategoryViewController alloc] initWithNibName:@"HWFPluginListInCategoryViewController" bundle:nil];
    payPluginCategoryViewController.pluginCategory = payPluginCategory;
    [self.navigationController pushViewController:payPluginCategoryViewController animated:YES];
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
