//
//  MSPlayerControlView.h
//  VideoAndPic
//
//  Created by miss on 2017/6/26.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^closeMediaBlock)();
typedef void(^playMediaBlock)();
typedef void(^pauseMediaBlock)();
typedef void(^sliderChangedBlock)(CGFloat value);

@interface MSPlayerControlView : UIView

@property (weak, nonatomic) IBOutlet UISlider *mediaSlider;
@property (weak, nonatomic) IBOutlet UILabel  *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel  *mediaLengthLabel;
@property (weak, nonatomic) IBOutlet UIView   *panView;
@property (weak, nonatomic) IBOutlet UIView   *controlView;
@property (nonatomic, copy) closeMediaBlock closeBlock;
@property (nonatomic, copy) playMediaBlock playBlock;
@property (nonatomic, copy) pauseMediaBlock pauseBlock;
@property (nonatomic, copy) sliderChangedBlock sliderChangedBlock;

- (void)close:(closeMediaBlock)block;
- (void)play:(playMediaBlock)block;
- (void)pause:(pauseMediaBlock)block;
- (void)slider:(sliderChangedBlock)block;

@end
