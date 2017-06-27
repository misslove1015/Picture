//
//  MSPlayerPanGestureRecognizer.m
//  VideoAndPic
//
//  Created by miss on 2017/6/26.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import "MSPlayerPanGestureRecognizer.h"

@implementation MSPlayerPanGestureRecognizer

- (instancetype)initWithHorizontalBlock:(panHorizontalMovedBlock)horizontalBlock
                           VerticalBloc:(panVerticalMovedBlock)verticalBlock {
    if (self = [super init]) {
        [self addTarget:self action:@selector(panDirection:)];
        [self setMaximumNumberOfTouches:1];
        [self setDelaysTouchesBegan:YES];
        [self setDelaysTouchesEnded:YES];
        [self setCancelsTouchesInView:YES];
        self.panHorizontalMovedBlock = horizontalBlock;
        self.panVerticalMovedBlock = verticalBlock;
    }
    return self;
}

- (void)panDirection:(UIPanGestureRecognizer *)pan {
    CGPoint veloctyPoint = [pan velocityInView:self.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { //横向移动
                self.panDirection = PanDirectionHorizontalMoved;
                if (self.panHorizontalMovedBlock) {
                    self.panHorizontalMovedBlock(veloctyPoint.x);
                }
            }else if (x < y){ //纵向移动
                self.panDirection = PanDirectionVerticalMoved;
                if (self.panVerticalMovedBlock) {
                    self.panVerticalMovedBlock(veloctyPoint.y);
                }
            }
        }
            break;
        
        case UIGestureRecognizerStateChanged:{
            if (self.panDirection == PanDirectionHorizontalMoved) {
                if (self.panHorizontalMovedBlock) {
                    self.panHorizontalMovedBlock(veloctyPoint.x);
                }
            }else {
                if (self.panVerticalMovedBlock) {
                    self.panVerticalMovedBlock(veloctyPoint.y);
                }
            }
        }
            break;
        
        case UIGestureRecognizerStateEnded:{
            if (self.panDirection == PanDirectionHorizontalMoved) {
                if (self.panHorizontalMovedBlock) {
                    self.panHorizontalMovedBlock(veloctyPoint.x);
                }
            }else {
                if (self.panVerticalMovedBlock) {
                    self.panVerticalMovedBlock(veloctyPoint.y);
                }
            }
            
        }
            break;
            
        default:
            break;
    }
}


@end
