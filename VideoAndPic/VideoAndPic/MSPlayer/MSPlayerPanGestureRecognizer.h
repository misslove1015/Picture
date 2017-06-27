//
//  MSPlayerPanGestureRecognizer.h
//  VideoAndPic
//
//  Created by miss on 2017/6/26.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved,
    PanDirectionVerticalMoved
};

typedef void(^panHorizontalMovedBlock)(CGFloat x);
typedef void(^panVerticalMovedBlock)(CGFloat y);

@interface MSPlayerPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, copy) panHorizontalMovedBlock panHorizontalMovedBlock;
@property (nonatomic, copy) panVerticalMovedBlock panVerticalMovedBlock;
@property (nonatomic, assign) PanDirection panDirection;

- (instancetype)initWithHorizontalBlock:(panHorizontalMovedBlock)horizontalBlock
                           VerticalBloc:(panVerticalMovedBlock)verticalBlock;


@end




