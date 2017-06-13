//
//  CollectionViewLayout.m
//  瀑布流
//
//  Created by mac on 16/9/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CollectionViewLayout.h"

@implementation CollectionViewLayout

-(instancetype)initWithItemsHeightBlock:(HeightBlock)block{
    self = [super init];
    if (self) {
        self.heightBlock = block;
        _colMargin = 1;
        _colCount = 3;
    }
    return self;
}

-(NSMutableArray *)colsHeight{
    if(!_colsHeight){
        NSMutableArray * array = [NSMutableArray array];
        for(int i = 0;i<_colCount;i++){
            //这里可以设置初始高度
            [array addObject:@(0)];
        }
        _colsHeight = [array mutableCopy];
    }
    return _colsHeight;
}

//需要复写5个方法

//布局前的的初始工作
- (void)prepareLayout{
   
    [super prepareLayout];
    self.colWidth = (self.collectionView.frame.size.width - (self.colCount-1)*self.colMargin)/self.colCount;
   
    //重新加载
    self.colsHeight = nil;
}


//内容尺寸
-(CGSize)collectionViewContentSize{
   
    NSNumber *longest = self.colsHeight[0];
    
    for (int i = 0; i < self.colsHeight.count; i++) {
        NSNumber *rolHeight = self.colsHeight[i];
        if (longest.floatValue<rolHeight.floatValue) {
            longest = rolHeight;
        }
    }
    return CGSizeMake(self.collectionView.frame.size.width, longest.floatValue);
    
}


//为每一个item设置属性

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSNumber *shortest = self.colsHeight[0];
    NSInteger shortCol = 0;
    for (int i=0; i<self.colsHeight.count; i++) {
        NSNumber *rolHeight = self.colsHeight[i];
        if (shortest.floatValue>rolHeight.floatValue) {
            shortest = rolHeight;
            shortCol = i;
        }
    }
    
   
    CGFloat x = shortCol*self.colMargin + shortCol*self.colWidth;
    CGFloat y = shortest.floatValue + self.colMargin;
    
    //获取cell的高度
    CGFloat height = 0;
//    NSAssert(self.heightBlock!=nil, @"为实现计算高度的block");
    if (self.heightBlock) {
        height = self.heightBlock(indexPath);

    }
    
    attributes.frame = CGRectMake(x, y, self.colWidth, height);
    self.colsHeight[shortCol] = @(shortest.floatValue + self.colMargin+height);
    return attributes;
    
}

//获取item的属性
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *mutArr = [NSMutableArray array];
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<items; i++) {
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [mutArr addObject:att];
    }
    return mutArr;
}

//这个方法是会在cell时重新布局并调用repareLayout方法
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
