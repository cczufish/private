//
//  HWFService+Download.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/28.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFService+Download.h"

#import "NSString+Extension.h"

@implementation HWFService (Download)

#pragma mark - 查询

- (void)loadDownloadingTaskListWithUser:(HWFUser *)aUser
                                 router:(HWFRouter *)aRouter
                               lastTask:(HWFDownloadTask *)theLastTask
                                  count:(NSInteger)count
                             completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *theTaskGID = theLastTask ? theLastTask.GID : @"0"; // gid为上次取列表时取到的最后一个任务id，如果是第一次取，gid = "0"
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_DOWNLOADING_TASKS];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_DOWNLOADING_TASKS];
    NSDictionary *paramDict = @{ @"last_gid":theTaskGID, @"task_count":@(count) };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadDownloadedTaskListWithUser:(HWFUser *)aUser
                                router:(HWFRouter *)aRouter
                              lastTask:(HWFDownloadTask *)theLastTask
                                 count:(NSInteger)count
                            completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *theTaskGID = theLastTask ? theLastTask.GID : @"0";

    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_DOWNLOADED_TASKS];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_DOWNLOADED_TASKS];
    NSDictionary *paramDict = @{ @"last_gid":theTaskGID, @"task_count":@(count) };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

#pragma mark - 操作
- (void)addDownloadTaskWithUser:(HWFUser *)aUser
                         router:(HWFRouter *)aRouter
                      partition:(HWFPartition *)aPartition
                           URLs:(NSArray *)theURLs
                forceReDownload:(BOOL)isForceReDownload
                     completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSMutableArray *tasks = [NSMutableArray array];
    for (NSString *aURL in theURLs) {
        NSMutableDictionary *taskDictionary = [@{ @"d_url":[aURL URLEncodedString], @"force_redownload":@(isForceReDownload ? 1 : 0) } mutableCopy];
        if (aPartition) {
            [taskDictionary setObject:aPartition.identity forKey:@"partition"];
        }
        [tasks addObject:taskDictionary];
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_ADD_DOWNLOAD_TASK];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_ADD_DOWNLOAD_TASK];
    NSDictionary *paramDict = @{ @"task_list":tasks };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)removeDownloadTaskWithUser:(HWFUser *)aUser
                            router:(HWFRouter *)aRouter
                             tasks:(NSArray *)theTasks
                        removeFile:(BOOL)isRemoveFile
                        completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSMutableArray *tasks = [NSMutableArray array];
    for (HWFDownloadTask *task in theTasks) {
        if ([task isKindOfClass:[HWFDownloadTask class]]) {
            NSMutableDictionary *taskDictionary = [@{ @"key":@"gid", @"value":task.GID } mutableCopy];
            [taskDictionary setObject:@(isRemoveFile ? 1 : 0) forKey:@"rmfile"];
            [tasks addObject:taskDictionary];
        }
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_REMOVE_DOWNLOAD_TASK];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_REMOVE_DOWNLOAD_TASK];
    NSDictionary *paramDict = @{ @"task_list":tasks };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)pauseDownloadTaskWithUser:(HWFUser *)aUser
                           router:(HWFRouter *)aRouter
                            tasks:(NSArray *)theTasks
                       completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSMutableArray *tasks = [NSMutableArray array];
    for (HWFDownloadTask *task in theTasks) {
        if ([task isKindOfClass:[HWFDownloadTask class]]) {
            [tasks addObject:@{ @"key":@"gid", @"value":task.GID }];
        }
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_PAUSE_DOWNLOAD_TASK];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_PAUSE_DOWNLOAD_TASK];
    NSDictionary *paramDict = @{ @"task_list":tasks };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)pauseAllDownloadTaskWithUser:(HWFUser *)aUser
                              router:(HWFRouter *)aRouter
                          completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_PAUSE_ALL_DOWNLOAD_TASKS];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_PAUSE_ALL_DOWNLOAD_TASKS];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)resumePausedDownloadTaskWithUser:(HWFUser *)aUser
                                  router:(HWFRouter *)aRouter
                                   tasks:(NSArray *)theTasks
                              completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSMutableArray *tasks = [NSMutableArray array];
    for (HWFDownloadTask *task in theTasks) {
        if ([task isKindOfClass:[HWFDownloadTask class]]) {
            [tasks addObject:@{ @"key":@"gid", @"value":task.GID }];
        }
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_RESUME_PAUSED_DOWNLOAD_TASK];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_RESUME_PAUSED_DOWNLOAD_TASK];
    NSDictionary *paramDict = @{ @"task_list":tasks };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)resumeAllPausedDownloadTaskWithUser:(HWFUser *)aUser
                                     router:(HWFRouter *)aRouter
                                 completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_RESUME_ALL_PAUSED_DOWNLOAD_TASKS];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_RESUME_ALL_PAUSED_DOWNLOAD_TASKS];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadDownloadTaskDetailWithUser:(HWFUser *)aUser
                                router:(HWFRouter *)aRouter
                                 tasks:(NSArray *)theTasks
                            completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSMutableArray *tasks = [NSMutableArray array];
    for (HWFDownloadTask *task in theTasks) {
        if ([task isKindOfClass:[HWFDownloadTask class]]) {
            [tasks addObject:@{ @"key":@"gid", @"value":task.GID }];
        }
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_DOWNLOAD_TASK_DETAIL];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_DOWNLOAD_TASK_DETAIL];
    NSDictionary *paramDict = @{ @"task_list":tasks };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)clearDownloadingTasksWithUser:(HWFUser *)aUser
                               router:(HWFRouter *)aRouter
                           completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_CLEAR_DOWNLOADING_TASKS];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_CLEAR_DOWNLOADING_TASKS];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)clearDownloadedTasksWithUser:(HWFUser *)aUser
                              router:(HWFRouter *)aRouter
                          completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_CLEAR_DOWNLOADED_TASKS];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_CLEAR_DOWNLOADED_TASKS];
    NSDictionary *paramDict = nil;
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

- (void)loadDownloadedTasksNumWithUser:(HWFUser *)aUser
                                router:(HWFRouter *)aRouter
                                  date:(NSDate *)theDate
                            completion:(ServiceCompletionHandler)theCompletionHandler {
    if (!aUser || !aUser.uToken) {
        if (theCompletionHandler) {
            NSInteger code = 12;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(12, msg, nil, nil);
        }
        return;
    }
    
    if (![[HWFDataCenter defaultCenter] isAuthWithUser:aUser router:aRouter]) {
        if (theCompletionHandler) {
            NSInteger code = 13;
            NSString *msg = [self getMessageWithCode:code defaultMessage:@""];
            
            theCompletionHandler(code, msg, nil, nil);
        }
        return;
    }
    
    NSString *URL = [[HWFAPIFactory defaultFactory] URLWithAPIIdentity:API_GET_DOWNLOADED_TASKS_NUM_AFTER_TIME];
    NSString *method = [[HWFAPIFactory defaultFactory] methodWithAPIIdentity:API_GET_DOWNLOADED_TASKS_NUM_AFTER_TIME];
    NSDictionary *paramDict = @{ @"last_check":@([theDate timeIntervalSince1970]) };
    
    [[HWFNetworkCenter defaultCenter] OpenAPI:URL method:method paramDict:paramDict user:aUser router:aRouter success:^(AFHTTPRequestOperation *option, id data) {
        
        [self OpenAPIDeal:^(NSInteger code, NSString *msg, NSMutableDictionary *respDict) {
            
            // Nothing.
            
        } afterSuccessWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option data:data completion:theCompletionHandler];
        
    } failure:^(AFHTTPRequestOperation *option, NSError *error) {
        [self OpenAPIDealAfterFailureWithURL:URL method:method paramDict:paramDict user:aUser router:aRouter requestOption:option error:error completion:theCompletionHandler];
    }];
}

@end
