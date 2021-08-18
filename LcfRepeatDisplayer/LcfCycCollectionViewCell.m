//
//  LcfCycCollectionViewCell.m
//  LcfRepeatDisplayer
//
//  Created by choogfunli on 2021/8/18.
//

#import "LcfCycCollectionViewCell.h"

@implementation LcfCycCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.4 green:0.6 blue:0.6 alpha:1];
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    self.label.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:12];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

@end
