//
//  ImageCollectionViewCell.m
//  VideoAndPic
//
//  Created by miss on 17/3/17.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import "PictureCollectionViewCell.h"

@implementation PictureCollectionViewCell

- (void)setPath:(NSString *)path{
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),path]];
    _cellImageView.image = image;
}

@end
