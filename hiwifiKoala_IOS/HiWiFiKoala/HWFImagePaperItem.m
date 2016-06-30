//
//  HWFImagePaperItem.m
//  HWFImagePaper
//
//  Created by chang hong on 14-11-7.
//  Copyright (c) 2014年 chang hong. All rights reserved.
//

#import "HWFImagePaperItem.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface HWFImagePaperItem()

@property(strong,nonatomic) UIScrollView *scrollView;
@property(strong,nonatomic) UIActivityIndicatorView *loading;

@end

@implementation HWFImagePaperItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.clipsToBounds = YES;
        [self initView];
    }
    return self;
}

- (void)initView {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.contentView addSubview:_scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:imageView];
    
    self.loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.contentView addSubview:self.loading];
    self.loading.center = self.contentView.center;
}

- (void)setImage:(NSURL *)url {
    [self.loading startAnimating];

    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeZero;
    if(self.scrollView.subviews.count > 0) {
        self.scrollView.zoomScale = 1;
        for(UIImageView *view in self.scrollView.subviews) {
            [view removeFromSuperview];
        }
    }
    if(url) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.loading stopAnimating];
        }];
        self.scrollView.frame = self.bounds;
        [self.scrollView addSubview:imageView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return scrollView.subviews[0];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(CGFloat)scale {
}
@end
