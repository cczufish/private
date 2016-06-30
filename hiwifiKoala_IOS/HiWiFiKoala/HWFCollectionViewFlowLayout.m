//
//  HWFCollectionViewFlowLayout.m
//  HWFImagePaper
//
//  Created by chang hong on 14-11-9.
//  Copyright (c) 2014年 chang hong. All rights reserved.
//

#import "HWFCollectionViewFlowLayout.h"

@implementation HWFCollectionViewFlowLayout


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}

@end
