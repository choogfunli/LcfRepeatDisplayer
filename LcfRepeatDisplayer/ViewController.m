//
//  ViewController.m
//  LcfRepeatDisplayer
//
//  Created by choogfunli on 2021/8/17.
//

#import "ViewController.h"
#import "LcfCycCollectionViewLayout.h"
#import "LcfCycCollectionViewCell.h"

static NSInteger gSectionCount = 10;
static NSInteger gItemCount = 10;

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.collectionView];
    //滚动到屏幕中央
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:gSectionCount / 2] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.timer class];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerHandle:(NSTimer *)timer {
    NSArray *array = self.collectionView.indexPathsForVisibleItems;
    //取出最中间的cell的index
    array = [array sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *obj1, NSIndexPath *obj2) {
        if (obj1.section == obj2.section) {
            return obj1.row > obj2.row;
        } else {
            return obj1.section > obj2.section;
        }
    }];
    
    __block NSIndexPath *index = array[1];
    [UIView animateWithDuration:0.001 animations:^{
        if (index.row == gItemCount - 1) {
            index = [NSIndexPath indexPathForRow:index.row inSection:gSectionCount / 2 - 1];
        } else {
            index = [NSIndexPath indexPathForRow:index.row inSection:gSectionCount / 2];
        }
        [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    } completion:^(BOOL finished) {
        if (index.row == gItemCount - 1) {
            index = [NSIndexPath indexPathForRow:0 inSection:gSectionCount / 2];
            
        } else {
            index = [NSIndexPath indexPathForRow:index.row + 1 inSection:gSectionCount / 2];
        }
        [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }];
}

#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        LcfCycCollectionViewLayout *layout = [[LcfCycCollectionViewLayout alloc] init];
        layout.itemSize = CGSizeMake(180, 100);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 150) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[LcfCycCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    }
    return _collectionView;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerHandle:) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark - dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return gSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return gItemCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LcfCycCollectionViewCell *cell = (LcfCycCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"这是第 %ld 个Label", (long)indexPath.row];
    return cell;
}


@end
