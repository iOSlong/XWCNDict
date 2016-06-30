//
//  XWCollectionViewController.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/4.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWCollectionViewController.h"
#import "XWMyDataController.h"
#import "XWCollectionPlat.h"

@interface XWCollectionViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UILabel       *labelPageIndex;
@end

@implementation XWCollectionViewController{
    XWMyDataController  *_DC;

    NSMutableArray      *_arrSectionCanvas; //[ [8],[8],[<8] ]
    NSMutableArray      *_arrPlat;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kPlat_Y, kScreenSize.width, kPlat_H)];
        _scrollView.contentSize = CGSizeMake(kScreenSize.width, kPlat_H);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UILabel *)labelPageIndex
{
    if (!_labelPageIndex) {
        _labelPageIndex = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width-170*kFixed_rate, (1394/2-20)*kFixed_rate, 100 * kFixed_rate, 25 * kFixed_rate)];
        _labelPageIndex.textColor = [UIColor lightGrayColor];
        _labelPageIndex.textAlignment = NSTextAlignmentCenter;
        _labelPageIndex.font = [UIFont fontWithName:@"Arial-ItalicMT" size:20];
    }
    return _labelPageIndex;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (_DC.needReloadCollectionCanvas) {
        [self getCollectionCanvasReady];
    }
    _DC.needReloadCollectionCanvas = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _DC = [XWMyDataController shareDataController];
    _arrSectionCanvas   = [NSMutableArray array];
    _arrPlat            = [NSMutableArray array];



    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.labelPageIndex];


}

- (void)getCollectionCanvasReady
{
    NSArray *arrCharacter = [_DC arrObjectModel];
    SizeContraints sizeCon = [XWCanvasControl innerSizeContraints];
    for (NSInteger i = 0; i < arrCharacter.count; i ++) {
        XWCharacter *character = arrCharacter[i];
        CGRect rectCanvas = CGRectMake(sizeCon.spanLeft + (i%4)*(sizeCon.canvasWidth + sizeCon.spanColumn), (i/4)*(sizeCon.spanRow + sizeCon.canvasWidth) + sizeCon.spanUp, sizeCon.canvasWidth, sizeCon.canvasWidth);

        XWCanvasControl *canvas     = [[XWCanvasControl alloc] initWithFrame:rectCanvas];
        canvas.imgvDynamicView.image = [UIImage imageWithData:character.dataImg];
        canvas.fontChar             = character.fontChar;
        canvas.tag                  = i;
        canvas.index                = i;

        [_DC.synchronousArrCanvas addObject:canvas];
    }

    [self reloadCollectionPlats];
}

- (void)reloadCollectionPlats
{
    [_arrSectionCanvas removeAllObjects];
    [_arrPlat removeAllObjects];

    NSInteger i = 0;
    /// 分割 Canvas 的方法
    while ( i < _DC.synchronousArrCanvas.count) {
        NSInteger len = (_DC.synchronousArrCanvas.count - i) > 8 ? 8 : _DC.synchronousArrCanvas.count - i;
        NSArray *platSection = [NSArray arrayWithArray:[_DC.synchronousArrCanvas subarrayWithRange:NSMakeRange(i, len)]];

        NSInteger j = 0;
        for (XWCanvasControl *canvas in platSection) {
            canvas.index = j++;
        }
        [_arrSectionCanvas addObject:platSection];
        i += 8;
    }

    /// 重新排版 收藏界面的问题
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[XWCanvasControl class]]) {
            [subView removeFromSuperview];
        }
    }

    for (NSInteger i = 0; i < _arrSectionCanvas.count; i ++ ) {
        XWCollectionPlat *collectionPlat = [[XWCollectionPlat alloc] initWithFrame:self.rectPlat];
        collectionPlat.left      = kScreenSize.width * i + self.rectPlat.origin.x;
        collectionPlat.arrCanvas = [_arrSectionCanvas objectAtIndex:i];
        collectionPlat.pageIndex = i + 1;

        [self.scrollView addSubview:collectionPlat];
        [_arrPlat addObject:collectionPlat];


        __weak __typeof(self)weakSelf = self;
        [collectionPlat setCollectionPlatBlock:^(XWCollectionPlat *colPlat) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf reloadCollectionPlats];

        }];
    }

    [self.scrollView setContentSize:CGSizeMake( kScreenSize.width * _arrSectionCanvas.count, self.scrollView.height)];

    NSString *indexTitle = [NSString stringWithFormat:@"%d / %d",1,_arrSectionCanvas.count ? (int)[_arrSectionCanvas count]:1];
    _labelPageIndex.text = indexTitle;
}

- (void)loadCollectionPlat
{
    XWCollectionPlat *collectionPlat = [[XWCollectionPlat alloc] initWithFrame:self.rectPlat];
    [self.scrollView addSubview:collectionPlat];
}

#pragma mark - _scrollViewDelegate -
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    printf("point.x = %f\n",point.x);
    NSString *indexTitle = [NSString stringWithFormat:@"%d / %ld",(int)point.x/(int)kScreenSize.width+1,_arrSectionCanvas.count];
    //    NSString *indexTitle = @"12/21";//[NSString stringWithFormat:@"%d/%d",(int)point.x/1024+1,_caseRowArr.count];

    _labelPageIndex.text = indexTitle;

    [self.view bringSubviewToFront:_scrollView];
}

@end
