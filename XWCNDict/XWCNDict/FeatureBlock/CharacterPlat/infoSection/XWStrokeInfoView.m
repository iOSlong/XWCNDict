//
//  XWStrokeInfoView.m
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWStrokeInfoView.h"
#import "XWStrokeBtn.h"

@implementation XWStrokeInfoView
{
    NSInteger _strokebtnCount;

    //strokeBtn ImageArray;
    NSMutableArray *_normalImgArr;
    NSMutableArray *_selectedImgArr;
}

- (instancetype)initWithFrame:(CGRect)frame andStrokeBtnCount:(NSInteger)count {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.strokeBtnArr = [[NSMutableArray alloc] init];
        self.strokesImgArr = [[NSMutableArray alloc] init];
        _strokebtnCount = count;
        self.userInteractionEnabled = YES;

        self.backgroundColor = [UIColor yellowColor];

        [self addSubview:self.scrollView];
    }
    return self;

}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.alpha = 1;
    }
    return _scrollView;
}

//得到一组图片用于选中效果图
- (void)getSelectedImgArray:(NSArray *)array;
{
    _selectedImgArr = [NSMutableArray arrayWithArray:array];
}

//得到一组图片用于常态效果图
- (void)getNormalImgArray:(NSArray *)array;
{
    _normalImgArr = [NSMutableArray arrayWithArray:array];
}


#define kSideSpan   (5 * kFixed_rate)
//为成员strokeBtn添加两种状态的图片
- (void)getStrokesBtnReload;
{
    _strokebtnCount = _normalImgArr.count;
    int columns =  6;
    NSInteger rows = _strokebtnCount/columns+1;
    //    printf("sbtn.count = %d\n",_strokebtnCount);

    if (!_normalImgArr.count) {
        return;
    }
    //clear all old subviews(all are strokeBtns)
    for (XWStrokeBtn *sb in self.scrollView.subviews)
    {
        [sb removeFromSuperview];
    }

    [self.strokeBtnArr removeAllObjects];
    CGFloat sbtnWidth = (self.frame.size.width-2*kSideSpan)/columns;
    //count how mach rows need to show strokebtns
    rows = _strokebtnCount%columns==0 ? _strokebtnCount/columns : _strokebtnCount/columns+1;
    CGFloat scrollContent_h = rows*sbtnWidth + 2*kSideSpan;
    //if need ,reset self.scrollview.contentSize;
    if (scrollContent_h>=_scrollView.frame.size.height)
    {
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, scrollContent_h)];
    }


    for (int i=0;i<_normalImgArr.count; i++)
    {
        CGFloat location_x = (i%columns)*sbtnWidth;
        CGFloat loaction_y = (i/columns)*sbtnWidth;
        XWStrokeBtn *sbtn = [[XWStrokeBtn alloc] initWithFrame:CGRectMake(kSideSpan+location_x, kSideSpan * 1.5 + loaction_y, sbtnWidth-3, sbtnWidth-3)];
        sbtn.tag = kGetTagFromIndex(i);
        sbtn.labelTitle = [NSString stringWithFormat:@"%d",i+1];
        [sbtn makeSureIndexLabelShow];
        [sbtn addTarget:self action:@selector(sbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [sbtn setSelectedImg:[_selectedImgArr objectAtIndex:i]];
        [sbtn setNormalImg:[_normalImgArr objectAtIndex:i]];
        sbtn.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:sbtn];
        [self.strokeBtnArr addObject:sbtn];
    }
}

- (void)sbtnClick:(XWStrokeBtn *)sbtn
{
    for (XWStrokeBtn *sb in _strokeBtnArr) {
        sb.selected = NO;
    }
    NSInteger index = kGetIndexFromTag(sbtn.tag);
    sbtn.selected = !sbtn.selected;
    printf("sbtn.index = %ld,indexTitile = %s\n",(long)index,[sbtn.labelTitle UTF8String]);
}

@end
