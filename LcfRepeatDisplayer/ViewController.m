//
//  ViewController.m
//  LcfRepeatDisplayer
//
//  Created by choogfunli on 2021/8/17.
//

#import "ViewController.h"
#import "LcfCycCollectionViewLayout.h"
#import "LcfCycCollectionViewCell.h"

#define LEFTTABLEVIEWWIDTH      [UIScreen mainScreen].bounds.size.width * 0.27
#define RIGHTTABLEVIEWWIDTH     [UIScreen mainScreen].bounds.size.width * 0.73
#define SCREENWIDTH             [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT            [UIScreen mainScreen].bounds.size.height

static NSInteger gSectionCount = 10;
static NSInteger gItemCount = 10;
static NSString * const leftCellIdentifier = @"leftCellIdentifier";
static NSString * const rightCellIdentifier = @"rightCellIdentifier";

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
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
    array = [array sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *obj1, NSIndexPath *obj2) {
        if (obj1.section == obj2.section) {
            return obj1.row > obj2.row;
        } else {
            return obj1.section > obj2.section;
        }
    }];
    
    __block NSIndexPath *index = array[1];
    [UIView animateWithDuration:0.1 animations:^{
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
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
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

// MARK: - 左边的 tableView
- (UITableView *)leftTableView {
 
    if (!_leftTableView) {
 
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LEFTTABLEVIEWWIDTH, SCREENHEIGHT)];
 
        [self.view addSubview:tableView];
 
        _leftTableView = tableView;
 
        tableView.dataSource = self;
        tableView.delegate = self;
 
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:leftCellIdentifier];
        tableView.backgroundColor = [UIColor redColor];
        tableView.tableFooterView = [[UIView alloc] init];
 
    }
    return _leftTableView;
}
 
// MARK: - 右边的 tableView
- (UITableView *)rightTableView {
 
    if (!_rightTableView) {
 
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(LEFTTABLEVIEWWIDTH, 0, RIGHTTABLEVIEWWIDTH, SCREENHEIGHT)];
 
        [self.view addSubview:tableView];
 
        _rightTableView = tableView;
 
        tableView.dataSource = self;
        tableView.delegate = self;
 
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:rightCellIdentifier];
        tableView.backgroundColor = [UIColor cyanColor];
        tableView.tableFooterView = [[UIView alloc] init];
 
    }
    return _rightTableView;
}

#pragma mark - UICollectionViewDataSource
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return 40;
    }
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.leftTableView) {
        return 1;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (tableView == self.leftTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:leftCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:rightCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld组-第%ld行", indexPath.section, indexPath.row];
    }
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
    if (tableView == self.rightTableView) {
        return [NSString stringWithFormat:@"第 %ld 组", section];
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.leftTableView) {
        return;
    }
    //取出显示在视图且最靠上的cell的indexpath
    NSIndexPath *topHeaderViewIndexPath = [[self.rightTableView indexPathsForVisibleRows] firstObject];
    //左侧tableview移动的indexpath
    NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:topHeaderViewIndexPath.section inSection:0];
    //移动左侧tableview到指定indexpath居中显示
    [self.leftTableView selectRowAtIndexPath:moveToIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        //将右侧tableview移动到指定位置
        [self.rightTableView selectRowAtIndexPath:moveToIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        //取消选中效果
        [self.rightTableView deselectRowAtIndexPath:moveToIndexPath animated:YES];
    }
}

@end
