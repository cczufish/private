//
//  HWFDirectoryListViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/31.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDirectoryListViewController.h"

#import "HWFFileListViewController.h"
#import "HWFDirectoryCollectionViewCell.h"

#import "HWFService+Storage.h"

#import "NSString+Extension.h"

#import "HWFDisk.h"
#import "HWFFile.h"

@interface HWFDirectoryListViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *directories;
@property (weak, nonatomic) IBOutlet UICollectionView *directoryCollectionView;

@end

@implementation HWFDirectoryListViewController

- (NSMutableArray *)directories {
    if (!_directories) {
        _directories = [[NSMutableArray alloc] init];
    }
    return _directories;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // View
    self.title = [self.partition displayName];
    [self addBackBarButtonItem];
    
    // Collection View
    [self.directoryCollectionView registerNib:[UINib nibWithNibName:@"HWFDirectoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DirectoryCell"];
    
    // Data
    [self loadData];
}

- (void)viewWillLayoutSubviews {
    // Collection View
    UICollectionViewFlowLayout *directoryLayout = (UICollectionViewFlowLayout *)self.directoryCollectionView.collectionViewLayout;
    CGFloat itemSizeLength = (self.directoryCollectionView.bounds.size.width) * 0.5;
    directoryLayout.itemSize = CGSizeMake(itemSizeLength, 150.0);
    
    [self.directoryCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data
- (void)loadData {
    [self loadingViewShow];
    [[HWFService defaultService] loadFileListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] partition:self.partition path:ROOT_PATH start:0 stop:10 completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        
        if (CODE_SUCCESS == code) {
            [self.directories removeAllObjects];
            
            NSArray *directoryArray = data[@"files"] ?: nil;
            for (NSDictionary *directoryDict in directoryArray) {
                HWFFile *directory = [[HWFFile alloc] init];
                directory.name = directoryDict[@"file"];
                directory.path = data[@"path"] ?: ROOT_PATH;
                directory.accessPath = data[@"access_path"];
                directory.displayName = directoryDict[@"file_name"];
                directory.type = directoryDict[@"type"];
                directory.createTime = [NSDate dateWithTimeIntervalSince1970:[directoryDict[@"ctime"] doubleValue]];
                directory.updateTime = [NSDate dateWithTimeIntervalSince1970:[directoryDict[@"mtime"] doubleValue]];
                directory.size = [directoryDict[@"size"] doubleValue];
                directory.mode = [directoryDict[@"modedec"] integerValue];
                directory.modeDesc = directoryDict[@"modestr"];
                NSString *separator = ([[directory.path substringFromIndex:directory.path.length-1] isEqualToString:@"/"]) ? @"" : @"/";
                directory.identity = [NSString stringWithFormat:@"%@%@%@", directory.path, separator, directory.name];
                directory.URL = [[NSString stringWithFormat:@"%@%@/%@", [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_READ_FILE], directory.accessPath, directory.name] URLEncodedString];

                if ([directory.type isEqualToString:@"dir"]) {
                    [self.directories addObject:directory];
                }
            }
            
            [self.directoryCollectionView reloadData];
        } else {
            [self showTipWithType:HWFTipTypeFailure code:code message:msg];
        }
    }];
}

#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.directories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HWFDirectoryCollectionViewCell *cell = (HWFDirectoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DirectoryCell" forIndexPath:indexPath];
    
    [cell loadData:self.directories[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HWFFile *directory = self.directories[indexPath.row];
    
    if ([directory.type isEqualToString:@"dir"]) { // 目录
        HWFFileListViewController *fileListViewController = [[HWFFileListViewController alloc] initWithNibName:@"HWFFileListViewController" bundle:nil];
        fileListViewController.partition = self.partition;
        fileListViewController.directory = directory;
        [self.navigationController pushViewController:fileListViewController animated:YES];
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
