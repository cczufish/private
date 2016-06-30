//
//  HWFImagePaperViewController.h
//  HWFImagePaper
//
//  Created by chang hong on 14-11-3.
//  Copyright (c) 2014年 chang hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HWFImagePaperViewControllerDelegate <NSObject>
@optional
- (void)indexPathChanged:(NSIndexPath *)indexPath;

@end

@protocol HWFImagePaperViewControllerDataSource <NSObject>

-(NSInteger)numberOfImagePapers;
-(NSURL *)urlForImagePaperAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface HWFImagePaperViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>


@property (assign,nonatomic) id<HWFImagePaperViewControllerDelegate> delegate;
@property (assign,nonatomic) id<HWFImagePaperViewControllerDataSource> dataSource;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil toIndexPath:(NSIndexPath *)indexPath;
- (void)reloadData;

@end
