//
//  VideoTableViewCell.h
//  VideoAndPic
//
//  Created by miss on 2017/6/22.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoScreenshotImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoSizeLabel;

@end
