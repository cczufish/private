//
//  HWFPluginListInCategoryViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFPluginListInCategoryViewController.h"

#import "HWFPlugin.h"

#import "HWFAppliedPluginTableViewCell.h"
#import "HWFPluginConfigViewController.h"

#import "HWFService+Plugin.h"

@interface HWFPluginListInCategoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *categoryPlugins;
@property (weak, nonatomic) IBOutlet UITableView *categoryPluginTableView;

@end

@implementation HWFPluginListInCategoryViewController

- (NSMutableArray *)categoryPlugins {
    if (!_categoryPlugins) {
        _categoryPlugins = [[NSMutableArray alloc] init];
    }
    return _categoryPlugins;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // View
    if (self.pluginCategory) {
        self.title = self.pluginCategory.name;
    }
    [self addBackBarButtonItem];
    
    // Table View Cell
    [self.categoryPluginTableView registerNib:[UINib nibWithNibName:@"HWFAppliedPluginTableViewCell" bundle:nil] forCellReuseIdentifier:@"AppliedPluginCell"];

    // Data
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    [self loadingViewShow];
    [[HWFService defaultService] loadPluginListInCategoryWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] category:self.pluginCategory completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        
        if (CODE_SUCCESS == code) {
            [self.categoryPlugins removeAllObjects];
            
            NSArray *plugins = data[@"data"] ?: nil;
            for (NSDictionary *pluginDict in plugins) {
                if (!pluginDict[@"sid"] || !pluginDict[@"name"] || [pluginDict[@"sid"] isKindOfClass:[NSNull class]] || [pluginDict[@"name"] isKindOfClass:[NSNull class]]) {
                    continue;
                }
                
                HWFPlugin *plugin = [[HWFPlugin alloc] init];
                plugin.SID = [pluginDict[@"sid"] integerValue];
                plugin.name = pluginDict[@"name"] ?: @"";
                plugin.ICON = pluginDict[@"icon"] ?: nil;
                plugin.info = pluginDict[@"function"] ?: nil;
                plugin.hasInstalled = [pluginDict[@"has_installed"] boolValue];
                plugin.statusMessage = pluginDict[@"status_msg"] ?: nil;
                plugin.canUninstall = NO; // 老版插件安装页没有显示“卸载”按钮的需求，这里统一置为NO
                plugin.configURL = pluginDict[@"detail_conf_url"];
                
                [self.categoryPlugins addObject:plugin];
            }
            
            [self.categoryPluginTableView reloadData];
        } else {
            [self showTipWithType:HWFTipTypeMessage code:code message:msg];
        }
    }];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryPlugins.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFAppliedPluginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppliedPluginCell"];
    
    HWFPlugin *plugin = self.categoryPlugins[indexPath.row];
    [cell loadData:plugin];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

    HWFPlugin *plugin = self.categoryPlugins[indexPath.row];
    
    HWFPluginConfigViewController *pluginConfigViewController = [[HWFPluginConfigViewController alloc] initWithNibName:@"HWFWebViewController" bundle:nil];
    pluginConfigViewController.plugin = plugin;
    [self.navigationController pushViewController:pluginConfigViewController animated:YES];
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
