//
//  XMPullingRefreshTableView.h
//  Fuchin
//
//  Created by Fox on 12-12-1.
//  Copyright (c) 2012年 C1618. All rights reserved.
//

/*  eg:
 _tableView = [[XMPullingRefreshTableView alloc] initWithFrame:frame pullingDelegate:aPullingDelegate];
 [self.view addSubview:_tableView];
 _tableView.autoScrollToNextPage = NO;
 _tableView.delegate = self;
 _tableView.dataSource = self;
 */



#import <UIKit/UIKit.h>

typedef enum {
    kPRStateNormal = 0,         //正常状态
    kPRStatePulling = 1,        //拉动中
    kPRStateLoading = 2,        //加载中
    kPRStateHitTheEnd = 3       //遇到底部
} PRStatue;

@interface LoadingView : UIView
{
    UILabel *_stateLabel;
    UILabel *_dateLabel;
    UIImageView *_arrowView;
    UIActivityIndicatorView *_activityView;
    CALayer *_arrow;
    
    BOOL _loading;
}

@property (nonatomic, getter = isLoading) BOOL  loading;
@property (nonatomic, getter = isAtTop) BOOL    atTop;
@property (nonatomic) PRStatue state;

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top;
- (void)updateRefreshDate:(NSDate *)date;

@end

@protocol XMPullingRefreshTableViewDelegate;

@interface XMPullingRefreshTableView : UITableView <UIScrollViewDelegate>
{
    LoadingView *_headerView;               /** < 表格头部视图*/
    LoadingView *_footerView;               /** < 表格根部视图*/
    
    UILabel *_msgLabel;                     /** < 消息标签*/
    BOOL _loading;                          /** < 是否在加载中*/
    BOOL _isFooterInAction;                 /** < 是否加载更多中*/
    NSInteger _bottomRow;                   /** < 底部的行数*/
}

@property (nonatomic, assign) id<XMPullingRefreshTableViewDelegate> pullingDelegate;
@property (nonatomic) BOOL autoScrollToNextPage;
@property (nonatomic) BOOL reachedTheEnd;
@property (nonatomic,getter = isHeaderOnly) BOOL headerOnly;
@property (nonatomic,getter = isNeedHeader) BOOL needHeader;

//init
- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<XMPullingRefreshTableViewDelegate>)aPullingDelegate;


- (void)tableViewDidScroll:(UIScrollView *)scrollView;
- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;
- (void)tableViewDidFinishedLoading;
- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg;
- (void)launchRefreshing;

@end


@protocol XMPullingRefreshTableViewDelegate <NSObject>

@required
- (void)pullingTableViewDidStartRefreshing:(XMPullingRefreshTableView *)tableView;

@optional
//Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(XMPullingRefreshTableView *)tableView;

//Implement the follows to set date you want,Or Ignore them to use current date 
- (NSDate *)pullingTableViewRefreshingFinishedDate;
- (NSDate *)pullingTableViewLoadingFinishedDate;
@end




