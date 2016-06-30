//
//  HWFPartitionListViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/27.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFPartitionListViewController.h"

#import "HWFService+Storage.h"

#import "HWFDirectoryListViewController.h"
#import "HWFDownloadListViewController.h"

#import "HWFPartitionTableViewCell.h"
#import "HWFPartitionControlTableViewCell.h"

@interface HWFPartitionListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *partitions;
@property (weak, nonatomic) IBOutlet UITableView *partitionTableView;

@property (strong, nonatomic) NSMutableArray *disks;

@end

@implementation HWFPartitionListViewController

- (NSMutableArray *)partitions {
    if (!_partitions) {
        _partitions = [[NSMutableArray alloc] init];
    }
    return _partitions;
}

- (NSMutableArray *)disks {
    if (!_disks) {
        _disks = [[NSMutableArray alloc] init];
    }
    return _disks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // View
    self.title = @"路由存储";
    [self addBackBarButtonItem];
    [self addRightBarButtonItemWithImage:nil activeImage:nil title:@"下载" target:self action:@selector(gotoDownload:)];
    
    // Table View
    [self.partitionTableView registerNib:[UINib nibWithNibName:@"HWFPartitionTableViewCell" bundle:nil] forCellReuseIdentifier:@"PartitionCell"];
    [self.partitionTableView registerNib:[UINib nibWithNibName:@"HWFPartitionControlTableViewCell" bundle:nil] forCellReuseIdentifier:@"PartitionControlCell"];
    
    // Data
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    [self loadingViewShow];
    [[HWFService defaultService] loadPartitionListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        
        if (CODE_SUCCESS == code) {            
            [self.partitions removeAllObjects];
            [self.disks removeAllObjects];
            
            NSMutableDictionary *diskDictionary = [NSMutableDictionary dictionary];
            
            NSArray *partitionArray = data[@"app_data"] ?: nil;
            for (NSDictionary *partitionDict in partitionArray) {
                HWFPartition *partition = [[HWFPartition alloc] init];
                partition.identity = partitionDict[@"partition"];
                partition.name = partitionDict[@"partition_name"];
                partition.displayName = partitionDict[@"partition_name_show"];
                partition.label = partitionDict[@"label"];
                partition.fileSystem = partitionDict[@"fstype"];
                if (partitionDict[@"status"] && [partitionDict[@"stats"] isEqualToString:@"ro"]) {
                    partition.status = PartitionStatusReadOnly;
                } else if (partitionDict[@"status"] && [partitionDict[@"stats"] isEqualToString:@"rw"]) {
                    partition.status = PartitionStatusReadWrite;
                }
                partition.mountPoint = partitionDict[@"mount_point"];
                partition.totalSize = [partitionDict[@"size"] doubleValue];
                partition.availableSize = [partitionDict[@"available"] doubleValue];
                partition.systemUseSize = [partitionDict[@"sys_use"] doubleValue];
                partition.userUsableSize = [partitionDict[@"mobile_use"] doubleValue];
                
                HWFDisk *disk = [[HWFDisk alloc] init];
                disk.identity = partitionDict[@"device"];
                disk.name = partitionDict[@"device_name"];
                if (partitionDict[@"device_type"] && [partitionDict[@"device_type"] isEqualToString:@"SD"]) {
                    disk.type = DiskTypeSD;
                } else if (partitionDict[@"device_type"] && [partitionDict[@"device_type"] isEqualToString:@"USB"]) {
                    disk.type = DiskTypeUSB;
                } else if (partitionDict[@"device_type"] && [partitionDict[@"device_type"] isEqualToString:@"SATA"]) {
                    disk.type = DiskTypeSATA;
                } else {
                    disk.type = DiskTypeUnknown;
                }
                partition.disk = disk;
                
                // 只有SD卡和USB磁盘支持安全弹出
                if (disk.type == DiskTypeSD || disk.type == DiskTypeUSB) {
                    [diskDictionary setObject:disk forKey:disk.identity];
                }
                
                [self.partitions addObject:partition];
            }
            
            self.disks = [[diskDictionary.allValues sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [(HWFDisk *)obj1 type] < [(HWFDisk *)obj2 type];
            }] mutableCopy];
            
            [self.partitionTableView reloadData];
        } else {
            [self showTipWithType:HWFTipTypeFailure code:code message:msg];
        }
    }];
}

#pragma mark - 下载
- (void)gotoDownload:(id)sender {
    HWFDownloadListViewController *downloadListViewController = [[HWFDownloadListViewController alloc] initWithNibName:@"HWFDownloadListViewController" bundle:nil];
    downloadListViewController.partitions = self.partitions;
    [self.navigationController pushViewController:downloadListViewController animated:YES];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = 0;
    if (self.disks.count && self.partitions.count) {
        numberOfSections = 2;
    } else if (self.disks.count || self.partitions.count) {
        numberOfSections = 1;
    }
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0: // 分区列表
        {
            numberOfRows = self.partitions.count;
        }
            break;
        case 1: // 分区操作
        {
            numberOfRows = self.disks.count;
        }
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRow = 0.0;
    switch (indexPath.section) {
        case 0: // 分区列表
        {
            heightForRow = 65.0;
        }
            break;
        case 1: // 分区操作
        {
            heightForRow = 45.0;
        }
            break;
        default:
            break;
    }
    return heightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat heightForHeader = 0.0;
    if (section == 1) {
        heightForHeader = 15.0;
    }
    return heightForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0: // 分区列表
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PartitionCell"];
            
            [(HWFPartitionTableViewCell *)cell loadData:self.partitions[indexPath.row]];
        }
            break;
        case 1: // 分区操作
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PartitionControlCell"];
            
            [(HWFPartitionControlTableViewCell *)cell loadData:self.disks[indexPath.row]];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    switch (indexPath.section) {
        case 0: // 分区列表
        {
            HWFPartition *partition = self.partitions[indexPath.row];
            
            HWFDirectoryListViewController *directoryListViewController = [[HWFDirectoryListViewController alloc] initWithNibName:@"HWFDirectoryListViewController" bundle:nil];
            directoryListViewController.partition = partition;
            [self.navigationController pushViewController:directoryListViewController animated:YES];
        }
            break;
        case 1: // 分区操作
        {
            HWFDisk *disk = self.disks[indexPath.row];
            
            [self loadingViewShow];
            [[HWFService defaultService] removeDiskSafeWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] disk:disk completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self loadingViewHide];
                
                if (CODE_SUCCESS == code) {
                    [self.disks removeObject:disk];
                    [self.partitionTableView reloadData];
                }
            }];
        }
            break;
        default:
            break;
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
