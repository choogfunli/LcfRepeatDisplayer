//
//  LcfCycCollectionViewLayout.m
//  LcfRepeatDisplayer
//
//  Created by choogfunli on 2021/8/18.
//

#import "LcfCycCollectionViewLayout.h"

@interface LcfCycCollectionViewLayout ()

@property (nonatomic, assign) CGFloat scaleFactor;  //缩放系数
@property (nonatomic, assign) CGFloat activeDistance;

@end

@implementation LcfCycCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scaleFactor = 0.15;
        self.activeDistance = 150;
    }
    return self;
}

//  为所有item返回一个layout attributes数组，数组中元素的类型为UICollectionViewLayoutAttributes。UICollectionViewLayoutAttributes记录了一个layout的位置、大小、透明度等信息
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];

    CGRect frame = CGRectZero;
    frame.origin = self.collectionView.contentOffset;
    frame.size = self.collectionView.bounds.size;

    for (UICollectionViewLayoutAttributes *attribute in array) {
        //确保cell相对于屏幕中央的距离
        CGFloat distance = CGRectGetMidX(frame) - attribute.center.x;

        //到中心位置的相对于x的比例，原则是越近越大，越远越小
        CGFloat normalDistance = fabs(distance / self.activeDistance);

        CGFloat scale = 1 - self.scaleFactor * normalDistance;

        attribute.transform3D = CATransform3DMakeScale(scale, scale, 1);
    }
    return array;
}

//  确定最终滚到的位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect targetRect = CGRectMake(proposedContentOffset.x, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];

    CGFloat horizontalCenterX = proposedContentOffset.x + self.collectionView.bounds.size.width / 2;
    CGFloat offsetAdjustment = CGFLOAT_MAX;
    for (UICollectionViewLayoutAttributes *attribute in array) {
        //
        CGFloat tempCenterX = attribute.center.x;
        if (fabs(horizontalCenterX - tempCenterX) < fabs(offsetAdjustment)) {
            offsetAdjustment = tempCenterX - horizontalCenterX;
        }
    }

    CGPoint resultPoint = CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);

    return resultPoint;
}

//  判定为布局需要被无效化并重新计算的时候,布局对象会被询问以提供新的布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
