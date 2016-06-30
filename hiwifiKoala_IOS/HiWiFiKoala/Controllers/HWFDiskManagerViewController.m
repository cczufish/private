//
//  HWFDiskManagerViewController.m
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-23.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDiskManagerViewController.h"
#import "HWFDiskManagerCell.h"
#import "HWFService+Storage.h"
#import "HWFDiskManagerView.h"

#define Tag_DiskTypeSATA 300
//#define Tag_DiskTypeUSB 301
#define Tag_DiskTypeSD 302

@interface HWFDiskManagerViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (weak,   nonatomic) IBOutlet UITableView *diskManagerTableView;
@property (strong, nonatomic) NSMutableArray *partitions;
@property (strong, nonatomic) HWFPartition *selectedPartition;

@property (weak, nonatomic) IBOutlet UIButton *pushSDButton;

@property (weak, nonatomic) IBOutlet UIButton *pushUSBButton;

@property (assign,nonatomic) BOOL isSD;
@property (assign,nonatomic) BOOL isUSB;

@end

@implementation HWFDiskManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
    [self loadData];
}

#warning -----------usb不可以格式化，但是上面的headerview显示。

- (void)initData {
    self.isSD = NO;
    self.isUSB = NO;
    self.partitions = [[NSMutableArray alloc]init];
}

- (void)initView {
    self.title = self.title = [[HWFRouter defaultRouter] name];
    [self addBackBarButtonItem];
    [self.diskManagerTableView registerNib:[UINib nibWithNibName:@"HWFDiskManagerCell" bundle:nil] forCellReuseIdentifier:@"DiskManagerCell"];
    
    [self.pushSDButton setTitle:@"弹出SD卡" forState:UIControlStateNormal];
    UIImage *pushSDImage = [[UIImage imageNamed:@"btn1"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    UIImage *highPushSDImage = [[UIImage imageNamed:@"btn3"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self.pushSDButton setBackgroundImage:pushSDImage forState:UIControlStateNormal];
    [self.pushSDButton setBackgroundImage:highPushSDImage forState:UIControlStateHighlighted];

    [self.pushUSBButton setTitle:@"弹出USB" forState:UIControlStateNormal];
    UIImage *pushUSBImage = [[UIImage imageNamed:@"btn1"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    UIImage *highPushUSBImageImage = [[UIImage imageNamed:@"btn3"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 20, 40)];
    [self.pushUSBButton setBackgroundImage:pushUSBImage forState:UIControlStateNormal];
    [self.pushUSBButton setBackgroundImage:highPushUSBImageImage forState:UIControlStateHighlighted];
}

- (void)loadData {
    [self loadingViewShow];
    [[HWFService defaultService] loadPartitionListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        
        [self loadingViewHide];
        if (CODE_SUCCESS == code) {
            if (self.partitions.count > 0) {
                [self.partitions removeAllObjects];
            }
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
                    self.isSD = YES;
                } else if (partitionDict[@"device_type"] && [partitionDict[@"device_type"] isEqualToString:@"USB"]) {
                    disk.type = DiskTypeUSB;
                    self.isUSB = YES;
                } else if (partitionDict[@"device_type"] && [partitionDict[@"device_type"] isEqualToString:@"SATA"]) {
                    disk.type = DiskTypeSATA;
                }
                partition.disk = disk;
                [self.partitions addObject:partition];
            }

            if (self.isSD && self.isUSB) {
                self.pushSDButton.hidden = NO;
                self.pushUSBButton.hidden = NO;
            } else if (!self.isSD && !self.isUSB) {
                self.pushSDButton.hidden = YES;
                self.pushUSBButton.hidden = YES;
            } else if (self.isSD && !self.isUSB) {
                self.pushSDButton.hidden = NO;
                self.pushUSBButton.hidden = YES;
            } else if (!self.isSD && self.isUSB) {
                self.pushSDButton.hidden = YES;
                self.pushUSBButton.hidden = NO;
            }
            
            [self.diskManagerTableView reloadData];
            
        } else {
            [self showTipWithType:HWFTipTypeFailure code:code message:msg];
        }
    }];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.partitions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HWFDiskManagerView *managerView = [HWFDiskManagerView sharedInstance];
    [managerView reloadWithPartition:self.partitions[section]];
    return managerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFDiskManagerCell *diskCell = [tableView dequeueReusableCellWithIdentifier:@"DiskManagerCell"];
    [diskCell loadDataWithInfo:[NSString stringWithFormat:@"格式化%@", [self.partitions[indexPath.section] displayName]]];
    return diskCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"test:%@",[(HWFPartition *)self.partitions[indexPath.section]displayName]);
    self.selectedPartition = self.partitions[indexPath.section];

    if (self.selectedPartition .disk.type == DiskTypeSATA) {
        // SATA硬盘
        UIActionSheet *rebootSheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"格式化%@将会清除所有数据.是否继续?",self.selectedPartition.displayName] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"格式化", nil];
        rebootSheet.tag = Tag_DiskTypeSATA;
        rebootSheet.destructiveButtonIndex = 0;
        [rebootSheet showInView:self.view];
        
    } else if (self.selectedPartition .disk.type == DiskTypeUSB) {
        // USB磁盘
//        UIActionSheet *rebootSheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"格式化%@将会清除所有数据.是否继续?",self.selectedPartition.displayName] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"格式化", nil];
//        rebootSheet.tag = Tag_DiskTypeUSB;
//        rebootSheet.destructiveButtonIndex = 0;
//        [rebootSheet showInView:self.view];
        [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"不能格式化USB"];
    
    }else if (self.selectedPartition .disk.type == DiskTypeSD){
        // SD卡
        UIActionSheet *rebootSheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"格式化%@将会清除所有数据.是否继续?",self.selectedPartition.displayName] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"格式化", nil];
        rebootSheet.tag = Tag_DiskTypeSD;
        rebootSheet.destructiveButtonIndex = 0;
        [rebootSheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (actionSheet.tag) {
        case Tag_DiskTypeSD:
        {
            if (buttonIndex == 0) {
                
            } else {
                [self formatePartition];
            }
        }
            break;
        case Tag_DiskTypeSATA:
        {
            if (buttonIndex == 0) {
                
            } else {
                [self formatePartition];
            }
        }
            break;
        default:
            break;
    }
    if (buttonIndex == 0) {
        [self formatePartition];
    } else {
        //取消
    }
}

- (void)formatePartition {
    [self loadingViewShow];
    [[HWFService defaultService]formatPartitionWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] partition:self.selectedPartition completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (code == CODE_SUCCESS) {
            
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
    }];
}

#pragma mark - 弹出设备－－－缺接口??????????
#pragma mark - 弹出sd卡
- (IBAction)pushSDAction:(UIButton *)sender {
    NSLog(@" 弹出sd卡");
}

#pragma mark - 弹出usb卡
- (IBAction)pushUSBAction:(UIButton *)sender {
     NSLog(@" 弹出usb卡");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
