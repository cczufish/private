//
//  HWFMessageListViewController.m
//  HiWiFiKoala
//
//  Created by dp on 14-10-16.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFMessageListViewController.h"
#import "HWFMessageListTableViewCell.h"
#import "HWFService+MessageCenter.h"
#import "HWFDoubtDeviceController.h"
#import "HWFPartSpeedUpViewController.h"
#import "HWFMessage.h"
#import "HWFMessageSettingViewController.h"

@interface HWFMessageListViewController ()

@property (strong, nonatomic)  XMPullingRefreshTableView *messageTableView;
@property (strong, nonatomic) NSMutableArray *messageArray;
@property (strong, nonatomic) NSMutableDictionary *messageDetailsDict;
@end

@implementation HWFMessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initData {
    _messageArray = [[NSMutableArray alloc] initWithCapacity:0];
    _messageDetailsDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *uidString = [NSString stringWithFormat:@"%ld",(long)[HWFUser defaultUser].UID];
    [_messageDetailsDict setObject:[[NSMutableDictionary alloc] initWithCapacity:0] forKey:uidString];
}

- (void)initView {
    self.title = @"消息列表";
    UIButton *messageSettingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageSettingButton setFrame:CGRectMake(0, 0, 35, 44)];
    [messageSettingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    messageSettingButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [messageSettingButton setTitle:@"设置" forState:UIControlStateNormal];
    [messageSettingButton addTarget:self action:@selector(messageSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mesSwitchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageSettingButton];
    self.navigationItem.rightBarButtonItem = mesSwitchBarButtonItem;
    
    _messageTableView = [[XMPullingRefreshTableView alloc] initWithFrame:self.view.bounds pullingDelegate:self];
    _messageTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_messageTableView];

    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_messageTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_messageTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:_messageTableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:_messageTableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.view addConstraints:@[topConstraint,bottomConstraint,leadingConstraint,trailingConstraint]];
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];

    
    [_messageTableView registerNib:[UINib nibWithNibName:@"HWFMessageListTableViewCell" bundle:nil] forCellReuseIdentifier:@"HWFMessageListTableViewCell"];
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    _messageTableView.headerOnly = NO;
    
    [self loadMsgFromArichive];
    [self loadDetailsFromArichive];
    if(self.messageArray.count >0 ){
        [self.messageTableView reloadData];
    }else{
        [self refreshMessage];
    }
    
}

- (void) refreshMessage {
    [[HWFService defaultService] loadMessageListWithUser:[HWFUser defaultUser] start:0 count:20 completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if( code == CODE_SUCCESS ) {
            [self.messageArray removeAllObjects];
            for( id message in [data objectForKey:@"msg"]) {
                NSMutableDictionary *msgDict = [[data objectForKey:@"msg"] objectForKey:message];
                if([msgDict isKindOfClass:[NSDictionary class]]) {
                    HWFMessage *model = [self messageCenterModelWithDic:msgDict];
                    if(model.type != 0) {
                        [self.messageArray addObject:model];
                    }
                }
            }
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
            [self.messageArray sortUsingDescriptors:sortDescriptors];
            [self.messageTableView reloadData];
            [self writeArichiveMessage];
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
        [self.messageTableView tableViewDidFinishedLoading];
    } ];
}

- (void) loadMoreMessage {
    [[HWFService defaultService] loadMessageListWithUser:[HWFUser defaultUser] start:[self.messageArray count] count:20 completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
        if( code == CODE_SUCCESS ) {
            for( id message in [data objectForKey:@"msg"]) {
                NSMutableDictionary *msgDict = [[data objectForKey:@"msg"] objectForKey:message];
                if([msgDict isKindOfClass:[NSDictionary class]]) {
                    HWFMessage *model = [self messageCenterModelWithDic:msgDict];
                    if(model.type != 0) {
                        [self.messageArray addObject:model];
                    }
                }
            }
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
            [self.messageArray sortUsingDescriptors:sortDescriptors];
            [self.messageTableView reloadData];
            [self writeArichiveMessage];
        } else {
            [self showTipWithType:HWFTipTypeFailure code:CODE(data) message:msg];
        }
        [self.messageTableView tableViewDidFinishedLoading];
    } ];
}

#pragma mark - read write messageListArichive

- (void) loadMsgFromArichive {
    NSString *tempPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *realPath = [tempPath stringByAppendingPathComponent:@"MessageList.data"];
    NSData *archiveData = [NSData dataWithContentsOfFile:realPath];
    if (archiveData && [archiveData isKindOfClass:[NSData class]]) {
        NSMutableDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
        NSDate *date = (NSDate *)[dict objectForKey:@"messageListArchivedTime"];
        if ([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970] <= 30*60) {
            NSString *uidString = [NSString stringWithFormat:@"%ld",(long)[HWFUser defaultUser].UID];
            if([dict objectForKey:uidString]) {
                self.messageArray = (NSMutableArray *) [dict objectForKey:uidString];
            }
        }
    }
}

- (void) clearArichiveMessage {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *tempPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *realPath = [tempPath stringByAppendingPathComponent:@"MessageList.data"];
    if ([fm fileExistsAtPath:realPath]) {
        [fm removeItemAtPath:realPath error:nil];
    }
}

- (void) writeArichiveMessage {
    [self clearArichiveMessage];
    if(self.messageArray.count == 0) {
        return;
    }
    NSString *uidString = [NSString stringWithFormat:@"%ld",(long)[HWFUser defaultUser].UID];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:self.messageArray forKey:uidString];
    [dict setObject:[NSDate date] forKey:@"messageListArchivedTime"];
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:dict];
    NSString *tempPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *realPath = [tempPath stringByAppendingPathComponent:@"MessageList.data"];
    [archiveData writeToFile:realPath atomically:YES];
}

#pragma mark - read write detailsArichive

- (void)loadDetailsFromArichive {
    NSString *tempPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *realPath = [tempPath stringByAppendingPathComponent:@"MessageDetails.data"];
    NSData *archiveData = [NSData dataWithContentsOfFile:realPath];
    if (archiveData && [archiveData isKindOfClass:[NSData class]]) {
        NSMutableDictionary *tempDict = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
        NSString *uidString = [NSString stringWithFormat:@"%ld",(long)[HWFUser defaultUser].UID];
        if([tempDict objectForKey:uidString]) {
            self.messageDetailsDict = tempDict;
        }else{
            [self clearDetailsArichive];
        }
    }
    
}

- (void)clearDetailsArichive {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *tempPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *realPath = [tempPath stringByAppendingPathComponent:@"MessageDetails.data"];
    if ([fm fileExistsAtPath:realPath]) {
        [fm removeItemAtPath:realPath error:nil];
    }
}

- (void)writeDetailsToArichive {
    [self clearDetailsArichive];
    NSString *uidString = [NSString stringWithFormat:@"%ld",(long)[HWFUser defaultUser].UID];
    if([[self.messageDetailsDict objectForKey:uidString] count] == 0) {
        return;
    }
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:self.messageDetailsDict];
    NSString *tempPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *realPath = [tempPath stringByAppendingPathComponent:@"MessageDetails.data"];
    [archiveData writeToFile:realPath atomically:YES];
}


- (void)messageSetting {
    HWFMessageSettingViewController *controller = [[HWFMessageSettingViewController alloc] initWithNibName:@"HWFMessageSettingViewController" bundle:nil];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (HWFMessage *)messageCenterModelWithDic:(NSDictionary *)msgCenterDic
{
    HWFMessage *msgCenterModel = [[HWFMessage alloc] init];
    msgCenterModel.content = [NSString stringWithFormat:@"%@",[msgCenterDic objectForKey:@"content"]];
    NSTimeInterval interval = [[msgCenterDic objectForKey:@"createtime"] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    msgCenterModel.createTime = date;
    msgCenterModel.status = [[msgCenterDic objectForKey:@"is_read"] boolValue];
    msgCenterModel.MID =  [[NSString stringWithFormat:@"%@",[msgCenterDic objectForKey:@"mid"]] intValue];
    msgCenterModel.title = [NSString stringWithFormat:@"%@",[msgCenterDic objectForKey:@"title"]];
    msgCenterModel.type = [self getMessageType:[[msgCenterDic objectForKey:@"type"] intValue]];
    msgCenterModel.RID = [[NSString stringWithFormat:@"%@",[msgCenterDic objectForKey:@"rid"]] intValue];
    return msgCenterModel;
}

- (MessageType)getMessageType:(NSInteger)num {
    MessageType messageType;
    switch (num) {
        case 10:
            messageType = MessageTypeWeb;
            break;
        case 11:
            messageType = MessageTypeNotice;
            break;
        case 12:
            messageType = MessageTypeNews;
            break;
        case 13:
            messageType = MessageTypeDownloadURL;
            break;
        case 21:
            messageType = MessageTypeNewDevice;
            break;
        case 22:
            messageType = MessageTypePartSpeedUpEnd;
            break;
        case 61:
            messageType = MessageTypeDownloadCompletion;
            break;
        case 51:
            messageType = MessageTypePluginInstall;
            break;
        case 52:
            messageType = MessageTypePluginUpgrade;
            break;
        case 53:
            messageType = MessageTypePluginConfig;
        default:
            messageType = 0;
            break;
    }
    return messageType;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openDetailsView:(HWFMessage *)msg {
    switch (msg.type) {
        case MessageTypeWeb:
            break;
        case MessageTypeNotice:
            break;
        case MessageTypeNews:
            break;
        case MessageTypeDownloadURL:
            break;
        case MessageTypeNewDevice:
            [self openDoubtDevice:msg];
            break;
        case MessageTypePartSpeedUpEnd:
            [self openPartSpeedUp:msg];
            break;
        case MessageTypeDownloadCompletion:
            break;
        case MessageTypePluginInstall:
            break;
        case MessageTypePluginUpgrade:
            break;
        case MessageTypePluginConfig:
            break;
        default:
            break;
    }
}

- (void)openDoubtDevice:(HWFMessage *)msg {
    HWFDoubtDeviceController *controller = [[HWFDoubtDeviceController alloc] initWithNibName:@"HWFDoubtDeviceController" bundle:nil];
    controller.delegate = self;
    NSString *midString = [NSString stringWithFormat:@"%ld",(long)msg.MID];
    NSString *uidString = [NSString stringWithFormat:@"%ld",(long)[HWFUser defaultUser].UID];
    if([[self.messageDetailsDict objectForKey:uidString] objectForKey:midString]) {
        HWFMessage *message = [[self.messageDetailsDict objectForKey:uidString] objectForKey:midString];
        controller.message = message;
    }else{
        controller.message = msg;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)openPartSpeedUp:(HWFMessage *)msg {
    HWFPartSpeedUpViewController *controller = [[HWFPartSpeedUpViewController alloc] initWithNibName:@"HWFPartSpeedUpViewController" bundle:nil];
    //controller.message = msg;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 下拉刷新
- (void)pullingTableViewDidStartRefreshing:(XMPullingRefreshTableView *)tableView
{
    [self performSelector:@selector(refreshMessage) withObject:nil afterDelay:1.f];
}

- (void)pullingTableViewDidStartLoading:(XMPullingRefreshTableView *)tableView {
    [self performSelector:@selector(loadMoreMessage) withObject:nil afterDelay:1.f];
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
    [self.messageTableView tableViewDidScroll:aScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate
{
    [self.messageTableView tableViewDidEndDragging:aScrollView];
}

#pragma mark - DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HWFMessageListTableViewCell *cell = (HWFMessageListTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"HWFMessageListTableViewCell"];
    [cell setData:[self.messageArray objectAtIndex:indexPath.row]];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HWFMessage *message = [self.messageArray objectAtIndex:indexPath.row];
    if( message.status ) {
        [self openDetailsView:message];
    } else {
        [[HWFService defaultService] setMessageStatusWithUser:[HWFUser defaultUser] message:message status:YES completion:^(NSInteger code, NSString *msg, id data, AFHTTPRequestOperation *option) {
            if(code == CODE_SUCCESS) {
                //成功
            } else {
                //失败
            }
            message.status = YES;
            [self.messageTableView reloadData];
            [self writeArichiveMessage];
            [self openDetailsView:message];
        }];
    }
}

#pragma mark - HWFMessageSettingViewControllerDelegate

- (void)setAllReadHandle {
    for (HWFMessage *message in self.messageArray) {
        message.status = YES;
    }
    [self writeArichiveMessage];
    [self.messageTableView reloadData];
}

- (void)deleteAllMessageHandle {
    [self.messageArray removeAllObjects];
    [self clearArichiveMessage];
    [self.messageTableView reloadData];
}

#pragma mark - HWFDoubtDeviceControllerDelegate

- (void)messageDetailChanged:(HWFMessage *)msg {
    NSString *uidString = [NSString stringWithFormat:@"%ld",(long)[HWFUser defaultUser].UID];
    NSString *midString = [NSString stringWithFormat:@"%ld",(long)msg.MID];
    [[self.messageDetailsDict objectForKey:uidString] setObject:msg forKey:midString];
    [self writeDetailsToArichive];
}

@end
