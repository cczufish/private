//
//  HWFImagePaperViewController.m
//  HWFImagePaper
//
//  Created by chang hong on 14-11-3.
//  Copyright (c) 2014年 chang hong. All rights reserved.
//

#import "HWFImagePaperViewController.h"
#import "HWFImagePaperItem.h"
#import "HWFCollectionViewFlowLayout.h"

@interface HWFImagePaperViewController ()

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) HWFCollectionViewFlowLayout *layout;
@property (strong,nonatomic) NSIndexPath *path;
@end

@implementation HWFImagePaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _path = [NSIndexPath indexPathForItem:0 inSection:0];
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        [self initFlowLayout];
        [self initCollectionView];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil toIndexPath:(NSIndexPath *)indexPath{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _path = indexPath;
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        [self initFlowLayout];
        [self initCollectionView];
    }
    return self;
}

- (void)initCollectionView {
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.directionalLockEnabled = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[HWFImagePaperItem class] forCellWithReuseIdentifier:@"HWFImagePaperItem"];
    [self.view addSubview:_collectionView];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:10];
    [self.view addConstraints:@[topConstraint,leadingConstraint,bottomConstraint,trailingConstraint]];
}

- (void)initFlowLayout {
    _layout = [[HWFCollectionViewFlowLayout alloc] init];
    _layout.minimumInteritemSpacing = 10;
    _layout.minimumLineSpacing = 10;
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if([self.dataSource respondsToSelector:@selector(numberOfImagePapers)]) {
        NSInteger num = [self.dataSource numberOfImagePapers];
        return num;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HWFImagePaperItem *item = (HWFImagePaperItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HWFImagePaperItem" forIndexPath:indexPath];
    if([self.dataSource respondsToSelector:@selector(urlForImagePaperAtIndexPath:)]) {
        NSURL *url = [self.dataSource urlForImagePaperAtIndexPath:indexPath];
        [item setImage:url];
    }
    return item;
}

- (void)viewWillLayoutSubviews {
    self.layout.itemSize = self.view.bounds.size;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self reloadData];
}

- (void)reloadData {
    [self.collectionView reloadData];
    if(self.path) {
        NSInteger index = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
        if(index != self.path.row) {
            [self.collectionView scrollToItemAtIndexPath:self.path atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            [self indexPathChanged];
        }
    }
}

- (void)indexPathChanged {
    if([self.delegate respondsToSelector:@selector(indexPathChanged)]) {
        [self.delegate indexPathChanged:self.path];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.path = [NSIndexPath indexPathForItem:index inSection:0];
    [self indexPathChanged];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(10, 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
