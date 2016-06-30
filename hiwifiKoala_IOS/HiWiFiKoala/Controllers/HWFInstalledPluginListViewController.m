//
//  HWFInstalledPluginListViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFInstalledPluginListViewController.h"

#import "HWFInstalledPluginCollectionViewCell.h"
#import "HWFPluginListViewController.h"
#import "HWFPluginConfigViewController.h"

#import "HWFService+Plugin.h"

@interface HWFInstalledPluginListViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *installedPlugins;
@property (weak, nonatomic) IBOutlet UICollectionView *installedPluginCollectionView;

@end

@implementation HWFInstalledPluginListViewController

- (NSMutableArray *)installedPlugins {
    if (!_installedPlugins) {
        _installedPlugins = [[NSMutableArray alloc] init];
    }
    return _installedPlugins;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // View
    self.title = @"已安装插件";
    [self addBackBarButtonItem];
    
    // Collection View Cell
    [self.installedPluginCollectionView registerNib:[UINib nibWithNibName:@"HWFInstalledPluginCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"InstalledPluginCell"];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Data
    [self loadData];
}

- (void)viewWillLayoutSubviews {
    // Collection View
    UICollectionViewFlowLayout *pluginLayout = (UICollectionViewFlowLayout *)self.installedPluginCollectionView.collectionViewLayout;
    CGFloat itemSizeLength = (self.installedPluginCollectionView.bounds.size.width) * 0.5;
    pluginLayout.itemSize = CGSizeMake(itemSizeLength, 150.0);
    
    [self.installedPluginCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    [self loadingViewShow];
    [[HWFService defaultService] loadPluginInstalledListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        
        if (CODE_SUCCESS == code) {
            [self.installedPlugins removeAllObjects];
            
            NSArray *plugins = data[@"data"] ?: nil;
            for (NSDictionary *pluginDict in plugins) {
                HWFPlugin *plugin = [[HWFPlugin alloc] init];
                plugin.SID = [pluginDict[@"sid"] integerValue];
                plugin.name = pluginDict[@"name"];
                plugin.ICON = pluginDict[@"icon"];
                plugin.statusMessage = pluginDict[@"status_msg"];
                plugin.canUninstall = [pluginDict[@"can_uninstall"] boolValue];
                plugin.configURL = pluginDict[@"detail_conf_url"];
                
                [self.installedPlugins addObject:plugin];
            }
            
            HWFPlugin *installPlugin = [[HWFPlugin alloc] init];
            installPlugin.SID = kInstallPluginSID;
            installPlugin.name = @"安装插件";
            [self.installedPlugins addObject:installPlugin];
            
            if (self.installedPlugins.count % 2 != 0) {
                HWFPlugin *blankPlugin = [[HWFPlugin alloc] init];
                blankPlugin.SID = kBlankPluginSID;
                [self.installedPlugins addObject:blankPlugin];
            }
            
            [self.installedPluginCollectionView reloadData];
        } else {
            [self showTipWithType:HWFTipTypeFailure code:code message:msg];
        }
    }];
}

#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.installedPlugins.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HWFInstalledPluginCollectionViewCell *cell = (HWFInstalledPluginCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"InstalledPluginCell" forIndexPath:indexPath];
    
    HWFPlugin *plugin = self.installedPlugins[indexPath.row];
    [cell loadData:plugin indexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HWFPlugin *plugin = self.installedPlugins[indexPath.row];
    if (plugin.SID == kInstallPluginSID) { // 插件安装
        HWFPluginListViewController *pluginListViewController = [[HWFPluginListViewController alloc] initWithNibName:@"HWFPluginListViewController" bundle:nil];
        [self.navigationController pushViewController:pluginListViewController animated:YES];
    } else if (plugin.SID == kBlankPluginSID) { // 空白
        // Nothing.
    } else { // 插件配置
        HWFPluginConfigViewController *pluginConfigViewController = [[HWFPluginConfigViewController alloc] initWithNibName:@"HWFPluginConfigViewController" bundle:nil];
        pluginConfigViewController.plugin = plugin;
        [self.navigationController pushViewController:pluginConfigViewController animated:YES];
    }
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
