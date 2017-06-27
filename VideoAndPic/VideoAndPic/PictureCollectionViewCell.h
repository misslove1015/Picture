//
//  ImageCollectionViewCell.h
//  VideoAndPic
//
//  Created by miss on 17/3/17.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (copy, nonatomic) NSString *path;
@end
