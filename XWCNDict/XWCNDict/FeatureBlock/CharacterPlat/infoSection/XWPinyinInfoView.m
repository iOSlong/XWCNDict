//
//  XWPinyinInfoView.m
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWPinyinInfoView.h"
#import "XWPinyinInfoView.h"
#import "XWPinyinBtn.h"

@interface XWPinyinInfoView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation XWPinyinInfoView
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

- (void)reloadPinyinWith:(NSString *)fontChar pinyin:(NSString *)pinyin {
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    NSArray *charPinArr = [_PR getPinyinArrByBlankChar:fontChar];
    NSArray *pArr;
    if (!pinyin) {
        pArr = [_PR getCharAndPinyinArrByRhythmPinyin:[charPinArr objectAtIndex:0]];
    }else
    {
        pArr = [_PR getCharAndPinyinArrByRhythmPinyin:pinyin];
    }

    for (int i=0; i<pArr.count; i++) {
        XWPinyinBtn *pbtn = [[XWPinyinBtn alloc] initWithFrame:CGRectMake((i%3)*(108+30) * kFixed_rate, (8+i/3*(37+5))*kFixed_rate ,108 * kFixed_rate, 37 * kFixed_rate)];
        [pbtn addTarget:self action:@selector(PinyinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //        NSString *title = [NSString stringWithFormat:@"%@()"]
        pbtn.rightLabel.text = [[pArr objectAtIndex:i] objectAtIndex:1];
        pbtn.fontChar = [[pArr objectAtIndex:i] objectAtIndex:0];
        [self.scrollView addSubview:pbtn];
        //        pbtn.backgroundColor = [UIColor yellowColor];
        self.scrollView.contentSize = CGSizeMake(768/2 * kFixed_rate, (i/3*(37+5)+37+30)*kFixed_rate);
    }
}
- (void)PinyinBtnClick:(XWPinyinBtn *)pyBtn {
    if (_PYBlock) {
        _PYBlock (pyBtn.fontChar, pyBtn.rightLabel.text);
    }
}

- (void)pinyinInfo:(PinyinBlock)thisBlock {
    _PYBlock = thisBlock;
}

@end
