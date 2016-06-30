//
//  HWFRenameView.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-31.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFView.h"

@protocol HWFRenameViewDelegate <NSObject>

- (void)renameViewCancleAction;

- (void)renameViewRenameAction;

@end

@interface HWFRenameView : HWFView

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (assign,nonatomic)id <HWFRenameViewDelegate> delegate;


+(id)sharedInstance;

@end
