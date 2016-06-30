//
//  HWFFileListViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFFileListViewController.h"

#import "HWFFile.h"
#import "HWFDisk.h"

#import "HWFService+Router.h"
#import "HWFService+Storage.h"
#import "HWFFileTableViewCell.h"

#import "NSString+Extension.h"

#import "HWFAudioPlayer.h"
#import "HWFAudioPlayerViewController.h"

#import "XMPullingRefreshTableView.h"
#import "HWFImagePaperViewController.h"
#import "HWFDocumentWebViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <pop/POP.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#define kControlViewAnimationDuration 0.2
#define kPullingRefreshDataCount 10

@interface HWFFileListViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, XMPullingRefreshTableViewDelegate, HWFImagePaperViewControllerDelegate, HWFImagePaperViewControllerDataSource>

@property (strong, nonatomic) NSMutableArray *files;
@property (weak, nonatomic) IBOutlet XMPullingRefreshTableView *fileListTableView;
@property (assign, nonatomic) BOOL isMultiOperation; // 是否正处于批量操作状态
@property (strong, nonatomic) NSMutableArray *multiOperationFiles;
@property (weak, nonatomic) IBOutlet UIView *multiOperationControlView;
@property (weak, nonatomic) IBOutlet UILabel *multiOperationInfoLabel;
@property (strong, nonatomic) IBOutlet UIView *shuffleHeaderView;
@property (assign, nonatomic) int totalFileCount; // 目录下文件的总个数

@end

@implementation HWFFileListViewController

- (NSMutableArray *)files {
    if (!_files) {
        _files = [[NSMutableArray alloc] init];
    }
    return _files;
}

- (NSMutableArray *)multiOperationFiles {
    if (!_multiOperationFiles) {
        _multiOperationFiles = [[NSMutableArray alloc] init];
    }
    return _multiOperationFiles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Init
    self.totalFileCount = -1;
    
    // View
    self.title = self.directory ? [self.directory displayName] : [self.partition displayName];
    [self addBackBarButtonItem];
    [self addRightBarButtonItemWithImage:nil activeImage:nil title:@"编辑" target:self action:@selector(multiOperation:)];
    
    // Table View
    self.fileListTableView.pullingDelegate = self;
    self.fileListTableView.headerOnly = NO;
    [self.fileListTableView registerNib:[UINib nibWithNibName:@"HWFFileTableViewCell" bundle:nil] forCellReuseIdentifier:@"FileCell"];
    
    // Data
    [self refreshData];
    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStateChangedHandler:) name:HWFPlayStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAudioChangedHandler:) name:HWFPlayAudioChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HWFPlayStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HWFPlayAudioChangedNotification object:nil];
}

- (void)loadDataWithStart:(NSInteger)start stop:(NSInteger)stop dealHandler:(void (^)(NSInteger code, NSString *msg, NSArray *files))dealHandler {
    NSString *directoryPath = self.directory ? self.directory.identity : ROOT_PATH;

    [[HWFService defaultService] loadFileListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] partition:self.partition path:directoryPath start:start stop:stop completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if (CODE_SUCCESS == code) {
            NSMutableArray *files = [[NSMutableArray alloc] init];
            
            NSArray *directoryArray = data[@"files"] ?: nil;
            for (NSDictionary *directoryDict in directoryArray) {
                HWFFile *file = [[HWFFile alloc] init];
                file.name = directoryDict[@"file"];
                file.path = data[@"path"] ?: ROOT_PATH;
                file.accessPath = data[@"access_path"];
                file.displayName = directoryDict[@"file_name"];
                file.type = directoryDict[@"type"];
                file.createTime = [NSDate dateWithTimeIntervalSince1970:[directoryDict[@"ctime"] doubleValue]];
                file.updateTime = [NSDate dateWithTimeIntervalSince1970:[directoryDict[@"mtime"] doubleValue]];
                file.size = [directoryDict[@"size"] doubleValue];
                file.mode = [directoryDict[@"modedec"] integerValue];
                file.modeDesc = directoryDict[@"modestr"];
                NSString *separator = ([[file.path substringFromIndex:file.path.length-1] isEqualToString:@"/"]) ? @"" : @"/";
                file.identity = [NSString stringWithFormat:@"%@%@%@", file.path, separator, file.name];
                file.URL = [[NSString stringWithFormat:@"%@%@/%@", [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_READ_FILE], file.accessPath, file.name] URLEncodedString];
                
                [files addObject:file];
            }
            
            if (dealHandler) {
                dealHandler(code, msg, files);
            }
        } else {
            if (dealHandler) {
                dealHandler(code, msg, nil);
            }
            
            [self showTipWithType:HWFTipTypeFailure code:code message:msg];
        }
    }];
}

- (void)refreshData {
    [self loadingViewShow];

    [self loadDataWithStart:0 stop:((self.files.count<kPullingRefreshDataCount ? kPullingRefreshDataCount : self.files.count) -1) dealHandler:^(NSInteger code, NSString *msg, NSArray *files) {
        [self loadingViewHide];
        if (CODE_SUCCESS == code) {
            [self.files removeAllObjects];
            [self.files setArray:files];
            
            [self.fileListTableView reloadData];
            
            if (self.files.count && !files.count) {
                [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"已到最后"];
            }
        }

        [self.fileListTableView tableViewDidFinishedLoading];
    }];
}

- (void)loadMoreData {
    [self loadDataWithStart:self.files.count stop:(self.files.count+kPullingRefreshDataCount)-1 dealHandler:^(NSInteger code, NSString *msg, NSArray *files) {
        if (CODE_SUCCESS == code) {
            [self.files addObjectsFromArray:files];
            
            [self.fileListTableView reloadData];
            
            if (self.files.count && !files.count) {
                [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"已到最后"];
            }
        }

        [self.fileListTableView tableViewDidFinishedLoading];
    }];
}

#pragma mark - 批量操作
- (void)multiOperation:(id)sender {
    self.isMultiOperation = !self.isMultiOperation;
    [self.fileListTableView setEditing:self.isMultiOperation animated:YES];
    [self.multiOperationFiles removeAllObjects];
    
    NSLayoutConstraint *controlViewBottomSpaceConstraint;
    for (controlViewBottomSpaceConstraint in self.multiOperationControlView.superview.constraints) {
        if (controlViewBottomSpaceConstraint.firstAttribute == NSLayoutAttributeBottom && controlViewBottomSpaceConstraint.secondItem == self.multiOperationControlView) {
            break;
        }
    }
    
    if (self.isMultiOperation) { // 开始批量操作
        [self updateMultiOperationInfoLabel];
        [self.rightBarButton setTitle:@"完成" forState:UIControlStateNormal];
        
        POPBasicAnimation *controlViewShowAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        controlViewShowAnimation.toValue = @(0.0);
        controlViewShowAnimation.beginTime = CACurrentMediaTime();
        controlViewShowAnimation.duration = kControlViewAnimationDuration;
        controlViewShowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [controlViewBottomSpaceConstraint pop_addAnimation:controlViewShowAnimation forKey:@"controlViewShowAnimation"];
    } else { // 批量操作结束
        [self.rightBarButton setTitle:@"编辑" forState:UIControlStateNormal];
        
        POPBasicAnimation *controlViewHideAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        controlViewHideAnimation.toValue = @(-44.0);
        controlViewHideAnimation.beginTime = CACurrentMediaTime();
        controlViewHideAnimation.duration = kControlViewAnimationDuration;
        controlViewHideAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [controlViewBottomSpaceConstraint pop_addAnimation:controlViewHideAnimation forKey:@"controlViewHideAnimation"];
    }
}

- (IBAction)multiDelete:(id)sender {
    if (self.multiOperationFiles.count==0) {
        [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"无选中文件"];
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"删除选中的%ld个文件？", (long)self.multiOperationFiles.count] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)updateMultiOperationInfoLabel {
    NSMutableAttributedString *multiOperationInfo = [[NSMutableAttributedString alloc] initWithString:@"共 " attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName:COLOR_HEX(0x999999) }];
    [multiOperationInfo appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu", (unsigned long)self.multiOperationFiles.count] attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName:COLOR_HEX(0x39B1F5) }]];
    [multiOperationInfo appendAttributedString:[[NSAttributedString alloc] initWithString:@" 首音乐，" attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName:COLOR_HEX(0x999999) }]];
    
    long filesTotalSize = 0;
    for (HWFFile *file in self.multiOperationFiles) {
        filesTotalSize += file.size;
    }
    NSString *filesTotalSizeString = [HWFTool displaySizeWithUnitB:filesTotalSize];
    
    [multiOperationInfo appendAttributedString:[[NSAttributedString alloc] initWithString:[filesTotalSizeString substringToIndex:filesTotalSizeString.length-2] attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName:COLOR_HEX(0x39B1F5) }]];
    [multiOperationInfo appendAttributedString:[[NSAttributedString alloc] initWithString:[filesTotalSizeString substringFromIndex:filesTotalSizeString.length-2] attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName:COLOR_HEX(0x999999) }]];
    
    self.multiOperationInfoLabel.attributedText = multiOperationInfo;
}

#pragma mark - 随机播放
- (IBAction)playWithShuffle:(id)sender {
    [[HWFService defaultService] loadIsConnectedRouterWithRouter:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if (CODE_SUCCESS == code) {
            [[HWFAudioPlayer defaultPlayer] setPlayMode:PlayModeRandom]; // 随机播放
            [[HWFAudioPlayer defaultPlayer] updatePlayList:self.files];
            
            HWFAudioPlayerViewController *audioPlayerViewController = [[HWFAudioPlayerViewController alloc] initWithNibName:@"HWFAudioPlayerViewController" bundle:nil];
            [self.navigationController pushViewController:audioPlayerViewController animated:YES];
            
            [self.fileListTableView reloadData];
        } else {
            //TODO: 文案
            [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"请直连路由器播放"];
        }
    }];
}

#pragma mark - Notification Handler
- (void)playStateChangedHandler:(NSNotification *)notify {
    [self.fileListTableView reloadData];
}

- (void)playAudioChangedHandler:(NSNotification *)notify {
    [self.fileListTableView reloadData];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: // 删除
        {
            [self loadingViewShow];
            [[HWFService defaultService] deleteFilesWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] partition:self.partition path:self.directory.identity files:self.multiOperationFiles completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self loadingViewHide];
                
                if (CODE_SUCCESS == code) {
                    int i = 0;
                    for (NSDictionary *resultDict in data[@"app_data"]) {
                        if ([resultDict[@"code"] integerValue] == 0) {
                            [self.files removeObject:self.multiOperationFiles[i]];
                        }
                        i++;
                    }
                    
                    [self multiOperation:nil];
                    
                    [self.fileListTableView reloadData];
                    
                    if ([[HWFAudioPlayer defaultPlayer] playMode] == PlayModeRandom) {
                        [[HWFAudioPlayer defaultPlayer] updatePlayList:self.files];
                    } else if ([[HWFAudioPlayer defaultPlayer] playMode] == PlayModeSingle) {
                        [[HWFAudioPlayer defaultPlayer] stop];
                    }
                } else {
                    [self showTipWithType:HWFTipTypeFailure code:code message:msg];
                }
            }];
        }
            break;
        case 1: // 取消
        {
            [self multiOperation:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 下拉刷新
- (void)pullingTableViewDidStartRefreshing:(XMPullingRefreshTableView *)tableView
{
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:1.f];
}

- (void)pullingTableViewDidStartLoading:(XMPullingRefreshTableView *)tableView {
    [self performSelector:@selector(loadMoreData) withObject:nil afterDelay:1.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [NSDate date];
    return date;
}

- (NSDate *)pullingTableViewLoadingFinishedDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [NSDate date];
    return date;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [self.fileListTableView tableViewDidScroll:aScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate
{
    [self.fileListTableView tableViewDidEndDragging:aScrollView];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerViewHeight = 0.0;
    if ([self.directory.name isEqualToString:@"music"]) {
        headerViewHeight = 44.0;
    }
    return headerViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileCell"];
    
    HWFFile *file = self.files[indexPath.row];
    if ([self.multiOperationFiles containsObject:file]) {
        [cell setSelected:YES];
    } else {
        [cell setSelected:NO];
    }
    
    [cell loadDataWithDirectory:self.directory file:file];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *shuffleHeaderView = nil;
    if ([self.directory.name isEqualToString:@"music"]) {
        shuffleHeaderView = self.shuffleHeaderView;
    }
    return shuffleHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFFile *file = self.files[indexPath.row];

    if (!self.isMultiOperation) {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        if ([file.type isEqualToString:@"reg"]) { // 文件
            [[HWFService defaultService] loadIsConnectedRouterWithRouter:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                if (CODE_SUCCESS == code) {
                    //TODO: 播放
                    DDLogDebug(@"File URL: %@", file.URL);
                    
                    switch (file.mediaType) {
                        case MediaTypeVideo:
                        {
                            MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:file.URL]];
                            [moviePlayerViewController.moviePlayer play];
                            [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
                        }
                            break;
                        case MediaTypeAudio:
                        {
                            if (![[HWFAudioPlayer defaultPlayer] currentAudio] || ![file.URL isEqualToString:[[HWFAudioPlayer defaultPlayer] currentAudio].URL]) {
                                [[HWFAudioPlayer defaultPlayer] setPlayMode:PlayModeSingle]; // 单曲播放不循环
                                [[HWFAudioPlayer defaultPlayer] updatePlayList:@[ file ]];
                            }
                            
                            HWFAudioPlayerViewController *audioPlayerViewController = [[HWFAudioPlayerViewController alloc] initWithNibName:@"HWFAudioPlayerViewController" bundle:nil];
                            [self.navigationController pushViewController:audioPlayerViewController animated:YES];
                        }
                            break;
                        case MediaTypeImage:
                        {
                            HWFImagePaperViewController *imagePaperViewController = [[HWFImagePaperViewController alloc] initWithNibName:@"HWFImagePaperViewController" bundle:nil toIndexPath:indexPath];
                            imagePaperViewController.delegate = self;
                            imagePaperViewController.dataSource = self;
                            [self.navigationController pushViewController:imagePaperViewController animated:YES];
                        }
                            break;
                        case MediaTypeDocument:
                        default:
                        {
                            HWFDocumentWebViewController *documentWebViewController = [[HWFDocumentWebViewController alloc] initWithNibName:@"HWFDocumentWebViewController" bundle:nil];
                            documentWebViewController.URL = file.URL;
                            documentWebViewController.title = file.displayName;
                            [self.navigationController pushViewController:documentWebViewController animated:YES];
                        }
                            break;
                    }
                } else {
                    //TODO: 文案
                    [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"请直连路由器播放"];
                }
            }];
        } else if ([file.type isEqualToString:@"dir"]) { // 目录
            HWFFileListViewController *fileListViewController = [[HWFFileListViewController alloc] initWithNibName:@"HWFFileListViewController" bundle:nil];
            fileListViewController.partition = self.partition;
            fileListViewController.directory = file;
            [self.navigationController pushViewController:fileListViewController animated:YES];
        }
    } else {
        [self.multiOperationFiles addObject:file];
        
        [self updateMultiOperationInfoLabel];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFFile *file = self.files[indexPath.row];
    [self.multiOperationFiles removeObject:file];
    
    [self updateMultiOperationInfoLabel];
}

#pragma mark - HWFImagePaperViewControllerDelegate / HWFImagePaperViewControllerDataSource
- (NSInteger)numberOfImagePapers {
    return (self.totalFileCount==-1) ? self.totalFileCount : self.files.count;
}

- (NSURL *)urlForImagePaperAtIndexPath:(NSIndexPath *)indexPath {
    HWFFile *file = self.files[indexPath.row];
    
    return [NSURL URLWithString:file.URL];
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
