//
//  HWFModifyDataViewController.h
//  HiWiFiKoala
//
//  Created by ajiao on 14-10-9.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFViewController.h"

@protocol HWFModifyDataViewControllerDelegate <NSObject>

@optional
- (void)modifyDataSuccess;

@end

@interface HWFModifyDataViewController : HWFViewController <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (assign, nonatomic) id <HWFModifyDataViewControllerDelegate> delegate;
@end
