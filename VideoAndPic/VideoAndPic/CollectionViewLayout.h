//
//  CollectionViewLayout.h
//  瀑布流
//
//  Created by mac on 16/9/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat (^HeightBlock)(NSIndexPath *indexPath);

@interface CollectionViewLayout : UICollectionViewLayout

@property (nonatomic,assign)CGFloat colMargin;

@property (nonatomic,assign)CGFloat colCount;

@property (nonatomic,assign)CGFloat rolMargin;

//数组存放每列的总高度
@property (nonatomic,strong) NSMutableArray *colsHeight;

//单元格的宽度
@property (nonatomic,assign)CGFloat colWidth;

@property (nonatomic,strong)HeightBlock heightBlock;

-(instancetype)initWithItemsHeightBlock:(HeightBlock)block;




@end
