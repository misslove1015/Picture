//
//  MSPlayerControlView.m
//  VideoAndPic
//
//  Created by miss on 2017/6/26.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import "MSPlayerControlView.h"

@interface MSPlayerControlView ()

@end

@implementation MSPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        UIView *selfView = [nibView objectAtIndex:0];
        selfView.frame = frame;
        self = (MSPlayerControlView *)selfView;
        [self.mediaSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    };
    return self;
}

- (IBAction)closeButtonClick:(UIButton *)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (IBAction)playOrPauseButtonClick:(UIButton *)sender {
   if (sender.selected) {
        if (self.playBlock) {
            self.playBlock();
        }
    }else {
        if (self.pauseBlock) {
            self.pauseBlock();
        }    
    }
    sender.selected = !sender.selected;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    if (self.sliderChangedBlock) {
        self.sliderChangedBlock(sender.value);
    }
}

- (void)close:(closeMediaBlock)block {
    self.closeBlock = block;
}

- (void)play:(playMediaBlock)block {
    self.playBlock = block;
}

- (void)pause:(pauseMediaBlock)block {
    self.pauseBlock = block;
}

- (void)slider:(sliderChangedBlock)block {
    self.sliderChangedBlock = block;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
