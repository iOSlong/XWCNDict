//
//  XWRadicalInfoView.m
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWRadicalInfoView.h"
#import "XWRadicalBtn.h"

@interface XWRadicalInfoView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation XWRadicalInfoView
{
    PlistReader *_PR;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        _PR = [PlistReader sharePlistReader];

    }
    return self;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    }
    return _scrollView;
}

- (void)reloadRadicalWith:(NSString *)fontChar {
    //移除原有的东西。
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }

    //取得数据信息
    _PR = [PlistReader sharePlistReader];
    NSString *radical = [_PR getRadicalThroughChar:fontChar];
    NSArray *rCharArr = [_PR getCategoryCharRadical:radical];

    for (int i=0; i<rCharArr.count; i++) {
        XWRadicalBtn *pbtn = [[XWRadicalBtn alloc] initWithFrame:CGRectMake((5+(i%5)*(40+28))*kFixed_rate,(6+i/5*(40+7))*kFixed_rate,40 * kFixed_rate, 40 * kFixed_rate)];
        NSString *title = [rCharArr objectAtIndex:i] ;
        [pbtn setTitle:title forState:UIControlStateNormal];

        [pbtn addTarget:self action:@selector(radicalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:pbtn];
        self.scrollView.contentSize = CGSizeMake(780/2 * kFixed_rate, (6+i/5*(40+7)+40)*kFixed_rate);
    }
}

- (void)radicalBtnClick:(XWRadicalBtn *)radicalBtn {
    if (_RBlock) {
        _RBlock(radicalBtn.titleLabel.text);
    }
}

- (void)radicalInfo:(RadicalBlock)thisBlock {
    _RBlock = thisBlock;
}

@end
