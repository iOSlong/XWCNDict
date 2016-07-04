//
//  XWNavSegmentView.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/4.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWNavSegmentView.h"
#import "XWSetInfo.h"


@implementation XWSegmentItem


@end



@interface XWNavSegmentView ()
@property (nonatomic, strong) NSMutableArray *arrSegmentItem;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UIImageView *imgvAngle;
@property (nonatomic, strong) NSMutableArray *arrBtnItems;
\
@end


@implementation XWNavSegmentView{
    CGFloat _item_w;
    CGFloat _item_h;
    CGFloat _item_span;
    XWSetInfo *_setInfo;
}

- (instancetype)initWithFrame:(CGRect)frame segmentItemArr:(NSArray *)segmentItemArr{
    if (self = [super initWithFrame:frame]) {
        _setInfo = [XWSetInfo shareSetInfo];
        UIImage *imgBack = [UIImage imageNamed:@"111"];
        self.imgvBackground = [[UIImageView alloc] init];
        self.imgvBackground.image = imgBack;
        self.imgvBackground.frame = CGRectMake(0, 0, CGImageGetWidth(imgBack.CGImage)/2 * kFixed_rate, CGImageGetHeight(imgBack.CGImage)/2 * kFixed_rate);
        [self addSubview:_imgvBackground];

        if (segmentItemArr && segmentItemArr.count) {
            self.exclusiveTouch     = YES;
            self.arrSegmentItem     = [NSMutableArray arrayWithArray:segmentItemArr];
            _item_span = [UIScreen mainScreen].scale;
            _item_span = 2;
            if (self.arrSegmentItem.count == 1) {
                _item_w = self.frame.size.width;
            }else{
                _item_w = self.frame.size.width/((self.arrSegmentItem.count -1) * _item_span);
            }

            //按照设计效果，还是第二种的segment效果感觉好一些。
            [self configureSegmentItemsWithArr:segmentItemArr];
//            [self configurePartViewWith:segmentItemArr];

        }
    }
    return self;
}

- (void)configurePartViewWith:(NSArray *)segmentItemArr{
    CGFloat view_w = 0;
    CGFloat view_h = 0;
    float upSpan = 7;
    int a[8] = {0,286.0/2,534.0/2,782.0/2,1031.0/2,1279.0/2,1527.0/2,1776.0/2};

    _imgvAngle = [[UIImageView alloc] initWithFrame:CGRectMake(42, 0, 14, 9)];
    _imgvAngle.image = [UIImage imageNamed:@"jiantou2.png"];
    [_imgvAngle setHidden:YES];
    [self addSubview:_imgvAngle];

    if (!_arrBtnItems) {
        _arrBtnItems = [NSMutableArray array];
    }

    for (int i=0; i<segmentItemArr.count; i++) {
        XWSegmentItem *item = segmentItemArr[i];
        UIImage *imgSelected = [UIImage imageNamed:item.imgSelected];
        CGFloat img_W = CGImageGetWidth(imgSelected.CGImage)/2 * kFixed_rate;
        CGFloat img_H = CGImageGetHeight(imgSelected.CGImage)/2 * kFixed_rate;

        UIButton *btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
        btnItem.tag = kGetTagFromIndex(i);

        if (i==0) {
            upSpan = 0;
        }else{
            upSpan = 7;
        }
        btnItem.frame = CGRectMake(a[i] * kFixed_rate, upSpan * kFixed_rate, img_W, img_H);
//        [btnItem setImage:[UIImage imageNamed:item.imgNormal] forState:UIControlStateNormal];
        [btnItem setImage:[UIImage imageNamed:item.imgSelected] forState:UIControlStateSelected];
//        [btnItem setImage:[UIImage imageNamed:item.imgHighlight] forState:UIControlStateHighlighted];
        [btnItem addTarget:segmentItemArr action:@selector(btnItemClick:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:btnItem];
        [_arrBtnItems addObject:btnItem];

        view_w += img_W;
        view_h = img_H;
//        a[i+1] = view_w;
    }

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, view_w, view_h);
    UIButton *btn = [self.arrBtnItems objectAtIndex:0];
    btn.selected = YES;
    self.selectedIndex =kGetIndexFromTag(btn.tag);
}

- (void)btnItemClick:(UIButton *)btnItem
{
    NSInteger index = kGetIndexFromTag(btnItem.tag);
    btnItem.selected = YES;
    for (UIButton *btn in _arrBtnItems) {
        if (btn != btnItem) {
            btn.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(xwNavSegment:didSelectedIndex:)]) {
        [self.delegate xwNavSegment:self didSelectedIndex:index];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    for (UIButton *btn in _arrBtnItems) {
        NSInteger index = kGetIndexFromTag(btn.tag);
        if (index != selectedIndex) {
            btn.selected = NO;
        }else{
            btn.selected = YES;
        }
    }
    [self.segmentControl setSelectedSegmentIndex:selectedIndex];
}

- (void)configureSegmentItemsWithArr:(NSArray *)segmentItemArr{

    self.segmentControl = [[UISegmentedControl alloc] initWithFrame:self.bounds];
    self.segmentControl.tintColor = _setInfo.themeColorCharacter;
    for (XWSegmentItem *item in segmentItemArr) {
        [self.segmentControl insertSegmentWithTitle:item.title atIndex:self.segmentControl.numberOfSegments animated:YES];
    }

    [self.segmentControl addTarget:self action:@selector(segmentControlClick:) forControlEvents:UIControlEventValueChanged];
    [self.segmentControl setTitleTextAttributes:@{
                                                  NSFontAttributeName:[UIFont systemFontOfSize:24],
                                                  NSForegroundColorAttributeName:[UIColor whiteColor]
                                                  }forState:UIControlStateNormal];
    [self.segmentControl setTitleTextAttributes:@{
                                                  NSFontAttributeName:[UIFont systemFontOfSize:24],
                                                  NSForegroundColorAttributeName:[UIColor whiteColor]
                                                  }forState:UIControlStateSelected];
    [self.segmentControl setTitleTextAttributes:@{
                                                  NSFontAttributeName:[UIFont systemFontOfSize:24],
                                                  NSForegroundColorAttributeName:[UIColor blueColor]
                                                  }forState:UIControlStateHighlighted];

    [self addSubview:_segmentControl];
    self.segmentControl.selectedSegmentIndex = 0;
    [self updateSegmentControlBackgroundColor:self.segmentControl];

}

- (void)segmentControlClick:(UISegmentedControl *)segC{
    [self updateSegmentControlBackgroundColor:segC];

    NSInteger index = segC.selectedSegmentIndex;
    NSArray *arr = [NSArray arrayWithObjects:_setInfo.themeColorCharacter,
                    _setInfo.themeColorRadical,
                    _setInfo.themeColorPhonetic,
                    _setInfo.themeColorCollection,
                    _setInfo.themeColorPoems,nil];

    segC.tintColor = arr[index];

    if ([self.delegate respondsToSelector:@selector(xwNavSegment:didSelectedIndex:)]) {
        [self.delegate xwNavSegment:self didSelectedIndex:segC.selectedSegmentIndex];
    }
}

- (void)updateSegmentControlBackgroundColor:(UISegmentedControl*)sender
{
    for (int i=0; i<[sender.subviews count]; i++){
        if ([[sender.subviews objectAtIndex:i] respondsToSelector:@selector(isSelected)] && [[sender.subviews objectAtIndex:i]isSelected]){
            [[sender.subviews objectAtIndex:i] setBackgroundColor:[UIColor blackColor]];
        }
        if ([[sender.subviews objectAtIndex:i] respondsToSelector:@selector(isSelected)] && ![[sender.subviews objectAtIndex:i] isSelected]){
            [[sender.subviews objectAtIndex:i] setBackgroundColor:_setInfo.themeColorBackground];
        }
    }
}

- (void)setItem:(XWSegmentItem *)item atIndex:(NSInteger)index{
    if (self.segmentControl.numberOfSegments > index) {
        [self.segmentControl setTitle:item.title forSegmentAtIndex:index];
        [self updateSegmentControlBackgroundColor:self.segmentControl];
    }
}


- (void)insertItemWith:(XWSegmentItem *)segmentItem atIndex:(NSInteger )index{
    if (self.segmentControl.numberOfSegments >= index) {
        [self.segmentControl insertSegmentWithTitle:segmentItem.title atIndex:index animated:YES];
        [self updateSegmentControlBackgroundColor:self.segmentControl];
    }
}



@end
