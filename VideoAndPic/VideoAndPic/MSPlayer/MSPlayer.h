//
//  MSPlayer.h
//  VideoAndPic
//
//  Created by miss on 2017/6/26.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSPlayer : UIView

@property (nonatomic, strong, nonnull) NSURL *mediaURL;

- (void)showInView:(UIView *_Nonnull)view;

@end
