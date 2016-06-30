//
//  HWFDownloadListViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/29.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFDownloadListViewController.h"

#import "HWFDownloadTaskAddViewController.h"
#import "XMPullingRefreshTableView.h"

#import "HWFSegmentedControl.h"

#import "HWFDownloadTableViewCell.h"

#import "HWFService+Download.h"
#import "UIView+Animation.h"

#import "HWFDisk.h"

#import <MSWeakTimer/MSWeakTimer.h>
#import <pop/POP.h>

#define kControlViewAnimationDuration 0.2

#define kPullingRefreshDataCount 10
#define kReloadDownloadTaskListTimeInterval 3.0

#define kTagClearDownloadedTasksAlertView 7421
#define kTagRemoveDownloadingTasksAlertView 7422

@interface HWFDownloadListViewController () <UITableViewDelegate, UITableViewDataSource, XMPullingRefreshTableViewDelegate, HWFDownloadTaskAddViewControllerDelegate, HWFDownloadTableViewCellDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitleLable;
@property (strong, nonatomic) IBOutlet HWFSegmentedControl *downloadSegmentedControl;

@property (strong, nonatomic) NSMutableArray *downloadingTasks; // 正在下载
@property (strong, nonatomic) NSMutableArray *downloadedTasks; // 已下载
@property (weak, nonatomic) NSMutableArray *downloadTasks;

@property (weak, nonatomic) IBOutlet XMPullingRefreshTableView *downloadListTableView;

@property (assign, nonatomic) BOOL downloadTaskFlag; // NO:下载中 YES:已完成

@property (assign, nonatomic) int totalDownloadingTaskCount; // 下载中的任务总数
@property (assign, nonatomic) int totalDownloadedTaskCount; // 已完成的任务总数

@property (assign, nonatomic) BOOL isMultiOperation; // 是否正处于批量操作状态
@property (strong, nonatomic) NSMutableArray *multiOperationTasks;
@property (weak, nonatomic) IBOutlet UIView *multiOperationControlView;
@property (weak, nonatomic) IBOutlet UIButton *addDownloadTaskButton;
@property (weak, nonatomic) IBOutlet UIButton *resumeDownloadTasksButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseDownloadTasksButton;
@property (weak, nonatomic) IBOutlet UIButton *removeDownloadTasksButton;
@property (weak, nonatomic) IBOutlet UILabel *multiOperationInfoLabel;

@property (strong, nonatomic) MSWeakTimer *reloadDownloadTaskListTimer; // 下载任务列表轮询机制

@end

@implementation HWFDownloadListViewController

- (NSMutableArray *)downloadingTasks {
    if (!_downloadingTasks) {
        _downloadingTasks = [[NSMutableArray alloc] init];
    }
    return _downloadingTasks;
}

- (NSMutableArray *)downloadedTasks {
    if (!_downloadedTasks) {
        _downloadedTasks = [[NSMutableArray alloc] init];
    }
    return _downloadedTasks;
}

- (NSMutableArray *)multiOperationTasks {
    if (!_multiOperationTasks) {
        _multiOperationTasks = [[NSMutableArray alloc] init];
    }
    return _multiOperationTasks;
}

- (void)setDownloadTaskFlag:(BOOL)downloadTaskFlag {
    if (_downloadTaskFlag != downloadTaskFlag) {
        _downloadTaskFlag = downloadTaskFlag;
        
        if (_downloadTaskFlag) { // 已完成
            _downloadTasks = self.downloadedTasks;
            [self.rightBarButton setTitle:@"清空" forState:UIControlStateNormal];
        } else { // 下载中
            _downloadTasks = self.downloadingTasks;
            [self.rightBarButton setTitle:@"编辑" forState:UIControlStateNormal];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Init
    self.totalDownloadingTaskCount = -1;
    self.totalDownloadedTaskCount = -1;
    
    // NavigationBar
    self.downloadSegmentedControl.segmentForegroundColor = [UIColor whiteColor];
    self.downloadSegmentedControl.segmentBackgroundColor = COLOR_HEX(0x30B0F8);
    self.downloadSegmentedControl.segmentTitles = @[ @"下载中", @"已完成" ];
    
    __weak typeof(self) weakSelf = self;
    self.downloadSegmentedControl.clickHandler = ^(HWFSegmentedControl *sender, int clickedSegmentIndex) {
        weakSelf.downloadTaskFlag = clickedSegmentIndex;
        [weakSelf refreshData];
    };
    self.navigationItem.titleView = self.navigationView;
    [self addRightBarButtonItemWithImage:nil activeImage:nil title:@"编辑" target:self action:@selector(rightBarButtonHandler:)];
    
    // View
    [self addBackBarButtonItem];
    
    // Table View
    self.downloadListTableView.pullingDelegate = self;
    self.downloadListTableView.headerOnly = NO;
    [self.downloadListTableView registerNib:[UINib nibWithNibName:@"HWFDownloadTableViewCell" bundle:nil] forCellReuseIdentifier:@"DownloadingCell"];
    
    // Data
    self.downloadTasks = self.downloadingTasks;
    [self refreshData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startTimers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self stopTimers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataWithLastTask:(HWFDownloadTask *)theLastTask dealHandler:(void (^)(NSInteger code, NSString *msg, NSArray *tasks))dealHandler {
    if (self.downloadTaskFlag) { // 已完成
        [self loadDownloadedTaskListWithLastTask:theLastTask dealHandler:dealHandler];
    } else { // 下载中
        [self loadDownloadingTaskListWithLastTask:theLastTask dealHandler:dealHandler];
    }
}

// 通过接口返回的数据字典生成HWFDownloadTask对象
- (HWFDownloadTask *)downloadTaskWithDict:(NSDictionary *)taskDict {
    if ([taskDict isKindOfClass:[NSDictionary class]]) {
        HWFDownloadTask *task = [[HWFDownloadTask alloc] init];
        task.GID = taskDict[@"gid"] ?: nil;
        task.dURL = taskDict[@"d_url"] ?: nil;
        task.iURL = taskDict[@"i_url"] ?: nil;
        if (taskDict[@"status"]) {
            if ([taskDict[@"status"] isEqualToString:@"active"]) {
                task.status = DownloadTaskStatusActive;
            } else if ([taskDict[@"status"] isEqualToString:@"paused"]) {
                task.status = DownloadTaskStatusPaused;
            } else if ([taskDict[@"status"] isEqualToString:@"waiting"]) {
                task.status = DownloadTaskStatusWaiting;
            } else if ([taskDict[@"status"] isEqualToString:@"complete"]) {
                task.status = DownloadTaskStatusComplete;
            } else if ([taskDict[@"status"] isEqualToString:@"error"]) {
                task.status = DownloadTaskStatusError;
            }
        }
        task.startTime = taskDict[@"time_start"] ? [NSDate dateWithTimeIntervalSince1970:[taskDict[@"time_start"] doubleValue]] : nil;
        task.stopTime = taskDict[@"time_stop"] ? [NSDate dateWithTimeIntervalSince1970:[taskDict[@"time_stop"] doubleValue]] : nil;
        task.fileName = taskDict[@"filename"] ?: nil;
        task.downloadTime = taskDict[@"download_time"] ? [NSDate dateWithTimeIntervalSince1970:[taskDict[@"download_time"] doubleValue]] : nil;
        task.completedSize = taskDict[@"completed_length"] ? [taskDict[@"completed_length"] doubleValue] : 0;
        task.totalSize = taskDict[@"total_length"] ? [taskDict[@"total_length"] doubleValue] : 0;
        task.downloadSpeed = taskDict[@"download_speed"] ? [taskDict[@"download_speed"] floatValue] : 0;
        task.filePath = taskDict[@"path"] ?: nil;
        task.errorCode = taskDict[@"error_code"] ? [taskDict[@"error_code"] integerValue] : CODE_NIL;
        task.errorMessage = taskDict[@"error_msg"] ?: nil;
        
        return task;
    } else {
        return nil;
    }
}

- (void)loadDownloadingTaskListWithLastTask:(HWFDownloadTask *)theLastTask dealHandler:(void (^)(NSInteger code, NSString *msg, NSArray *tasks))dealHandler {
    [[HWFService defaultService] loadDownloadingTaskListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] lastTask:theLastTask count:kPullingRefreshDataCount completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if (CODE_SUCCESS == code) {
            self.totalDownloadingTaskCount = data[@"task_total_num"] ? [data[@"task_total_num"] intValue] : -1;
            
            NSMutableArray *tasks = [[NSMutableArray alloc] init];
            for (NSDictionary *taskDict in data[@"task_list"]) {
                HWFDownloadTask *task = [self downloadTaskWithDict:taskDict];
                if (task) {
                    [tasks addObject:task];
                }
            }
            
            if (dealHandler) {
                dealHandler(code, msg, tasks);
            }
        } else {
            if (dealHandler) {
                dealHandler(code, msg, nil);
            }
            
            [self showTipWithType:HWFTipTypeFailure code:code message:msg];
        }
    }];
}

- (void)loadDownloadedTaskListWithLastTask:(HWFDownloadTask *)theLastTask dealHandler:(void (^)(NSInteger code, NSString *msg, NSArray *tasks))dealHandler {
    [[HWFService defaultService] loadDownloadedTaskListWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] lastTask:theLastTask count:kPullingRefreshDataCount completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if (CODE_SUCCESS == code) {
            self.totalDownloadingTaskCount = data[@"task_total_num"] ? [data[@"task_total_num"] intValue] : -1;
            
            NSMutableArray *tasks = [[NSMutableArray alloc] init];
            for (NSDictionary *taskDict in data[@"task_list"]) {
                HWFDownloadTask *task = [self downloadTaskWithDict:taskDict];
                if (task) {
                    [tasks addObject:task];
                }
            }
            
            if (dealHandler) {
                dealHandler(code, msg, tasks);
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
    [self loadDataWithLastTask:nil dealHandler:^(NSInteger code, NSString *msg, NSArray *tasks) {
        [self loadingViewHide];
        [self.downloadTasks removeAllObjects];
        
        if (CODE_SUCCESS == code) {
            [self.downloadTasks setArray:tasks];

            if (self.downloadTasks.count && !tasks.count) {
                [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"已到最后"];
            }
        }

        [self.downloadListTableView reloadData];

        [self.downloadListTableView tableViewDidFinishedLoading];
    }];
}

- (void)loadMoreData {
    [self loadDataWithLastTask:self.downloadTasks.lastObject dealHandler:^(NSInteger code, NSString *msg, NSArray *tasks) {
        if (CODE_SUCCESS == code) {
            [self.downloadTasks addObjectsFromArray:tasks];
            
            [self.downloadListTableView reloadData];
            
            if (self.downloadTasks.count && !tasks.count) {
                [self showTipWithType:HWFTipTypeMessage code:CODE_NIL message:@"已到最后"];
            }
        }
        
        [self.downloadListTableView tableViewDidFinishedLoading];
    }];
}

- (void)refreshTasksProgress {
    if (!self.downloadTasks.count) {
        return;
    }
    
    [[HWFService defaultService] loadDownloadTaskDetailWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] tasks:self.downloadTasks completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        
        if (CODE_SUCCESS == code) {
            NSArray *tasksProgress = data[@"task_list"];
            
            if (!tasksProgress || !tasksProgress.count) {
                return;
            }
            
            int i = 0;
            for (HWFDownloadTask *task in self.downloadTasks) {
                
                if ([tasksProgress[i][@"code"] integerValue] != 0) {
                    continue;
                }
                
                NSDictionary *taskDict = tasksProgress[i][@"data"];
                
                if (![task.GID isEqualToString:taskDict[@"gid"]]) {
                    continue;
                }

                if (taskDict[@"status"]) {
                    if ([taskDict[@"status"] isEqualToString:@"active"]) {
                        task.status = DownloadTaskStatusActive;
                    } else if ([taskDict[@"status"] isEqualToString:@"paused"]) {
                        task.status = DownloadTaskStatusPaused;
                    } else if ([taskDict[@"status"] isEqualToString:@"waiting"]) {
                        task.status = DownloadTaskStatusWaiting;
                    } else if ([taskDict[@"status"] isEqualToString:@"complete"]) {
                        task.status = DownloadTaskStatusComplete;
                    } else if ([taskDict[@"status"] isEqualToString:@"error"]) {
                        task.status = DownloadTaskStatusError;
                    }
                }
                
                if (!self.downloadTaskFlag && task.status == DownloadTaskStatusComplete) {
                    [self.downloadTasks removeObject:task];
                    continue;
                }
                
                task.dURL = taskDict[@"d_url"] ?: nil;
                task.iURL = taskDict[@"i_url"] ?: nil;
                task.startTime = taskDict[@"time_start"] ? [NSDate dateWithTimeIntervalSince1970:[taskDict[@"time_start"] doubleValue]] : nil;
                task.stopTime = taskDict[@"time_stop"] ? [NSDate dateWithTimeIntervalSince1970:[taskDict[@"time_stop"] doubleValue]] : nil;
                task.fileName = taskDict[@"filename"] ?: nil;
                task.downloadTime = taskDict[@"download_time"] ? [NSDate dateWithTimeIntervalSince1970:[taskDict[@"download_time"] doubleValue]] : nil;
                task.completedSize = taskDict[@"completed_length"] ? [taskDict[@"completed_length"] doubleValue] : 0;
                task.totalSize = taskDict[@"total_length"] ? [taskDict[@"total_length"] doubleValue] : 0;
                task.downloadSpeed = taskDict[@"download_speed"] ? [taskDict[@"download_speed"] floatValue] : 0;
                task.filePath = taskDict[@"path"] ?: nil;
                task.errorCode = taskDict[@"error_code"] ? [taskDict[@"error_code"] integerValue] : CODE_NIL;
                task.errorMessage = taskDict[@"error_msg"] ?: nil;
                
                i++;
            }
            
            [self.downloadListTableView reloadData];
        }
        
    }];
}

#pragma mark - Timer
- (void)startTimers {
    if (!self.reloadDownloadTaskListTimer) {
        self.reloadDownloadTaskListTimer = [MSWeakTimer scheduledTimerWithTimeInterval:kReloadDownloadTaskListTimeInterval
                                                                                target:self
                                                                              selector:@selector(refreshTasksProgress)
                                                                              userInfo:nil
                                                                               repeats:YES
                                                                         dispatchQueue:dispatch_get_main_queue()];
    }
}

- (void)stopTimers {
    if (self.reloadDownloadTaskListTimer) {
        [self.reloadDownloadTaskListTimer invalidate];
        self.reloadDownloadTaskListTimer = nil;
    }
}

#pragma mark - 新建下载
- (IBAction)addDownloadTask:(UIButton *)sender {
    HWFDownloadTaskAddViewController *downloadTaskAddViewController = [[HWFDownloadTaskAddViewController alloc] initWithNibName:@"HWFDownloadTaskAddViewController" bundle:nil];
    downloadTaskAddViewController.delegate = self;
    downloadTaskAddViewController.partitions = self.partitions;
    [self.navigationController pushViewController:downloadTaskAddViewController animated:YES];
}

// HWFDownloadTaskAddViewControllerDelegate
- (void)addTaskWithDownloadTaskAddViewController:(HWFDownloadTaskAddViewController *)downloadTaskAddViewController {
    [self refreshData];
}

#pragma mark - BarButton Handler
- (void)rightBarButtonHandler:(id)sender {
    if (self.downloadTaskFlag) { // 已完成
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"清空所有已下载任务?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = kTagClearDownloadedTasksAlertView;
        [alertView show];
    } else { // 下载中
        [self multiOperation];
    }
}

- (void)multiOperation {
    self.isMultiOperation = !self.isMultiOperation;
    [self.downloadListTableView setEditing:self.isMultiOperation animated:YES];
    [self.multiOperationTasks removeAllObjects];

    NSLayoutConstraint *controlViewBottomSpaceConstraint;
    for (controlViewBottomSpaceConstraint in self.multiOperationControlView.constraints) {
        if (controlViewBottomSpaceConstraint.firstAttribute == NSLayoutAttributeHeight) {
            break;
        }
    }
    
    if (self.isMultiOperation) { // 开始批量操作
        [self stopTimers];
        [self updateMultiOperationInfoLabel];
        [self.rightBarButton setTitle:@"完成" forState:UIControlStateNormal];
        //TODO: 全选
        [self.navigationTitleLable fadeIn];
        [self.downloadSegmentedControl fadeOut];
        
        POPBasicAnimation *controlViewUpAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        controlViewUpAnimation.toValue = @(80.0);
        controlViewUpAnimation.beginTime = CACurrentMediaTime();
        controlViewUpAnimation.duration = kControlViewAnimationDuration;
        controlViewUpAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        controlViewUpAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            if (finished) {
                
            }
        };
        [controlViewBottomSpaceConstraint pop_addAnimation:controlViewUpAnimation forKey:@"controlViewUpAnimation"];
        
        [self.resumeDownloadTasksButton fadeIn];
        [self.pauseDownloadTasksButton fadeIn];
        [self.removeDownloadTasksButton fadeIn];
        [self.multiOperationInfoLabel fadeIn];
        [self.addDownloadTaskButton fadeOut];
        
    } else { // 批量操作结束
        [self startTimers];
        [self.rightBarButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.downloadSegmentedControl fadeIn];
        [self.navigationTitleLable fadeOut];
        
        POPBasicAnimation *controlViewDownAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        controlViewDownAnimation.toValue = @(44.0);
        controlViewDownAnimation.beginTime = CACurrentMediaTime();
        controlViewDownAnimation.duration = kControlViewAnimationDuration;
        controlViewDownAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        controlViewDownAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            if (finished) {

            }
        };
        [controlViewBottomSpaceConstraint pop_addAnimation:controlViewDownAnimation forKey:@"controlViewDownAnimation"];
        
        [self.resumeDownloadTasksButton fadeOut];
        [self.pauseDownloadTasksButton fadeOut];
        [self.removeDownloadTasksButton fadeOut];
        [self.multiOperationInfoLabel fadeOut];
        [self.addDownloadTaskButton fadeIn];
    }
}

- (void)updateMultiOperationInfoLabel {
    NSMutableAttributedString *multiOperationInfo = [[NSMutableAttributedString alloc] initWithString:@"已选中 " attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[UIColor lightGrayColor] }];
    [multiOperationInfo appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu", (unsigned long)self.multiOperationTasks.count] attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName:COLOR_HEX(0x30B0F8) }]];
    [multiOperationInfo appendAttributedString:[[NSAttributedString alloc] initWithString:@" 个任务" attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[UIColor lightGrayColor] }]];
    
    self.multiOperationInfoLabel.attributedText = multiOperationInfo;
}

#pragma mark - MultiOperation
- (IBAction)pauseTasks:(id)sender {
    if (!self.multiOperationTasks.count) {
        [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"请选择要暂停的任务"];
        return;
    }
    
    [self loadingViewShow];
    [[HWFService defaultService] pauseDownloadTaskWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] tasks:self.multiOperationTasks completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (CODE_SUCCESS == code) {
            [self refreshData];
            [self multiOperation];
            [self.multiOperationTasks removeAllObjects];
        }
        
    }];
}

- (IBAction)resumeTasks:(id)sender {
    if (!self.multiOperationTasks.count) {
        [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"请选择要开始的任务"];
        return;
    }
    
    [self loadingViewShow];
    [[HWFService defaultService] resumePausedDownloadTaskWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] tasks:self.multiOperationTasks completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        [self loadingViewHide];
        if (CODE_SUCCESS == code) {
            [self refreshData];
            [self multiOperation];
            [self.multiOperationTasks removeAllObjects];
        }
        
    }];
}

- (IBAction)removeTasks:(id)sender {
    if (!self.multiOperationTasks.count) {
        [self showTipWithType:HWFTipTypeWarning code:CODE_NIL message:@"请选择要删除的任务"];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"删除已选中下载任务及相关文件?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = kTagClearDownloadedTasksAlertView;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case kTagClearDownloadedTasksAlertView:
        {
            switch (buttonIndex) {
                case 0: // 取消
                {
                    // Nothing.
                }
                    break;
                case 1: // 确定
                {
                    [self loadingViewShow];
                    [[HWFService defaultService] clearDownloadedTasksWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                        [self loadingViewHide];
                        if (CODE_SUCCESS == code) {
                            [self.downloadedTasks removeAllObjects];
                            [self.downloadListTableView reloadData];
                        }
                    }];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case kTagRemoveDownloadingTasksAlertView:
        {
            [self loadingViewShow];
            [[HWFService defaultService] removeDownloadTaskWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] tasks:self.multiOperationTasks removeFile:YES completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
                [self loadingViewHide];
                if (CODE_SUCCESS == code) {
                    [self refreshData];
                    [self multiOperation];
                    [self.multiOperationTasks removeAllObjects];
                }
                
            }];
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
    [self.downloadListTableView tableViewDidScroll:aScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate
{
    [self.downloadListTableView tableViewDidEndDragging:aScrollView];
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.downloadTasks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadingCell"];
    cell.delegate = self;
    
    HWFDownloadTask *task = self.downloadTasks[indexPath.row];
    if ([self.multiOperationTasks containsObject:task]) {
        [cell setSelected:YES];
    } else {
        [cell setSelected:NO];
    }
    
    [cell loadData:task];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFDownloadTask *task = self.downloadTasks[indexPath.row];
    if (self.isMultiOperation) {
        [self.multiOperationTasks addObject:task];
        [self updateMultiOperationInfoLabel];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFDownloadTask *task = self.downloadTasks[indexPath.row];
    [self.multiOperationTasks removeObject:task];
    [self updateMultiOperationInfoLabel];
}

#pragma mark - HWFDownloadTableViewCellDelegate
- (void)downloadStatusButtonClick:(HWFDownloadTableViewCell *)aCell {
    HWFDownloadTask *task = aCell.task;
    if (task.status == DownloadTaskStatusActive) {
        [self loadingViewShow];
        [[HWFService defaultService] pauseDownloadTaskWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] tasks:@[ aCell.task ] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            [self loadingViewHide];
            if (CODE_SUCCESS == code) {
                [self refreshTasksProgress];
            }
            
        }];
    } else {
        [self loadingViewShow];
        [[HWFService defaultService] resumePausedDownloadTaskWithUser:[HWFUser defaultUser] router:[HWFRouter defaultRouter] tasks:@[ aCell.task ] completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            [self loadingViewHide];
            if (CODE_SUCCESS == code) {
                [self refreshTasksProgress];
            }
            
        }];
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
