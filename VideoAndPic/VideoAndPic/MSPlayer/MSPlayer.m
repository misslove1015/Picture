//
//  MSPlayer.m
//  VideoAndPic
//
//  Created by miss on 2017/6/26.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import "MSPlayer.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "MSPlayerControlView.h"
#import "MSPlayerPanGestureRecognizer.h"

const CGFloat animationDuration = 0.3;

@interface MSPlayer ()<VLCMediaPlayerDelegate>

@property (nonatomic, strong) VLCMediaPlayer *player;
@property (nonatomic, strong) MSPlayerControlView *controlView;
@property (nonatomic, strong) MSPlayerPanGestureRecognizer *pan;
@property (nonatomic, assign) BOOL showControlView;
@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, assign) CGRect initRect;

@end

@implementation MSPlayer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showOrHideControlView)];
        [self addGestureRecognizer:tap];
       
    };
    return self;
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    [self play];
    self.alpha = 0;

    [UIView animateWithDuration:animationDuration animations:^{
        self.alpha = 1;
    }completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self addSubview:self.controlView];
        self.controlView.mediaLengthLabel.text = self.player.media.length.stringValue;
        [self showMediaControlViewHideAfter:3];
    }];
    
    self.bounds = CGRectMake(0, 0, self.superview.frame.size.height, self.superview.frame.size.width);
    self.center = self.superview.center;
    self.transform = CGAffineTransformMakeRotation(M_PI_2);
}

- (void)setMediaURL:(NSURL *)mediaURL {
    [self.player setDrawable:self];
    self.player.media = [[VLCMedia alloc]initWithURL:mediaURL];
}

- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

/*
- (void)fullScreen {    
    self.controlView.hidden = YES;
    if (self.isFullScreen) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.initRect = self.frame;
            self.bounds = CGRectMake(0, 0, self.superview.frame.size.height, self.superview.frame.size.width);
            self.center = self.superview.center;
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
        }completion:^(BOOL finished) {
            self.controlView.hidden = NO;
        }];
    }else {
        [UIView animateWithDuration:animationDuration animations:^{
            self.transform = CGAffineTransformIdentity;
            self.frame = self.initRect;
        }completion:^(BOOL finished) {
            self.controlView.hidden = NO;
        }];
    }
    self.controlView.frame = self.bounds;
    self.isFullScreen = !self.isFullScreen;

}
*/

- (void)close {
    [self.player stop];
    self.player.delegate = nil;
    self.player.drawable = nil;
    self.player = nil;
    [UIView animateWithDuration:animationDuration animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
   [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)showOrHideControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:nil];
    
    if (self.showControlView) {
        self.controlView.controlView.hidden = YES;
    }else {
        [self showMediaControlViewHideAfter:10];
        [self bringSubviewToFront:self.controlView];        
    }
    self.showControlView = !self.showControlView;

}

- (void)showMediaControlViewHideAfter:(NSInteger)delay {
    self.controlView.controlView.hidden = NO;
    [self performSelector:@selector(hideControlView) withObject:nil afterDelay:delay];
}

- (void)hideControlView {
    self.controlView.controlView.hidden = YES;
    self.showControlView = NO;
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    float precentValue = ([self.player.time.value floatValue]) / ([self.player.media.length.value floatValue]);
    [self.controlView.mediaSlider setValue:precentValue animated:YES];
    self.controlView.currentTimeLabel.text = _player.time.stringValue;
}

- (MSPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[MSPlayerControlView alloc]init];
        _controlView.frame = self.bounds;
        __weak typeof(self)weakSelf = self;
        _controlView.closeBlock = ^{
            [weakSelf close];
        };
        _controlView.playBlock = ^{
            [weakSelf play];
        };
        _controlView.pauseBlock = ^{
            [weakSelf pause];
        };
        _controlView.sliderChangedBlock = ^(CGFloat value) {
            int targetIntvalue = (int)(value * (float)self.player.media.length.intValue);
            VLCTime *targetTime = [[VLCTime alloc] initWithInt:targetIntvalue];
            [weakSelf.player setTime:targetTime];
        };
        [_controlView.panView addGestureRecognizer:self.pan];
                
    }
    return _controlView;
}

- (MSPlayerPanGestureRecognizer *)pan {
    if (!_pan) {
        __weak typeof(self)weakSelf = self;
        _pan = [[MSPlayerPanGestureRecognizer alloc]initWithHorizontalBlock:^(CGFloat x) {
            [self showMediaControlViewHideAfter:5];
            if (x > 0) {
                [weakSelf.player extraShortJumpForward];
            }else {
                [weakSelf.player extraShortJumpBackward];
            }
        } VerticalBloc:^(CGFloat y) {
            [UIScreen mainScreen].brightness -= y / 10000;
        }];
    }
    return _pan;
}

- (VLCMediaPlayer *)player {
    if (!_player) {
        _player = [[VLCMediaPlayer alloc] init];
        _player.delegate = self;
    }
    return _player;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
