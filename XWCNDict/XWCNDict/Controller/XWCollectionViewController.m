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
#import "XWCollectionSetView.h"
#import "XWPDFViewController.h"

@interface XWCollectionViewController ()<UIScrollViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UILabel               *labelPageIndex;
@property (nonatomic, strong) XWCollectionSetView   *collectionSetView;
@property (nonatomic, strong) UIButton              *btnPrint;

@end

@implementation XWCollectionViewController{
    XWMyDataController  *_DC;

    NSMutableArray                          *_arrSectionCanvas; //[ [8],[8],[<8] ]
    NSMutableArray<XWCollectionPlat *>      *_arrPlat;
    XWCollectionPlat                        *_currentPlat;
}

- (XWCollectionSetView *)collectionSetView
{
    if (!_collectionSetView) {
        _collectionSetView = [[XWCollectionSetView alloc] initWithFrame:CGRectMake((-615.0/2-300)*kFixed_rate, 554/2 * kFixed_rate, 250*kFixed_rate, 300*kFixed_rate)];
    }
    return _collectionSetView;
}

- (UIButton *)btnPrint
{
    if (!_btnPrint) {
        _btnPrint = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnPrint setFrame:CGRectMake(self.labelPageIndex.x-50 * kFixed_rate, 668 * kFixed_rate, 26 * kFixed_rate, 26 * kFixed_rate)];
        _btnPrint.centerY = self.btnSetGear.centerY;
        [_btnPrint setBackgroundImage:[UIImage imageNamed:@"printbtn.png"] forState:UIControlStateNormal];
        [_btnPrint addTarget:self action:@selector(printBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnPrint];
    }
    return _btnPrint;
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
    if (_DC.synchronousArrCanvas.count == 0) {
        [self showHint:@"您没有收藏的文字！" hide:1.5];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _DC = [XWMyDataController shareDataController];
    _arrSectionCanvas   = [NSMutableArray array];
    _arrPlat            = [NSMutableArray array];


    self.scrollView.delegate    = self;
    self.textfield.delegate     = self;
    
    self.platViewModel          = XWPlatViewModelCollection;

    [self.view addSubview:self.labelPageIndex];

    [self.view addSubview:self.btnPrint];

    [self.view addSubview:self.collectionSetView];


    __weak __typeof(self)weakSelf = self;
    self.MaskHiddenBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.collectionSetView.frame = CGRectMake((-607.0/2-300)*kFixed_rate, 554/2 * kFixed_rate, strongSelf.collectionSetView.width, strongSelf.collectionSetView.height);
    };
    self.MaskShowBlock  = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.view bringSubviewToFront:strongSelf.collectionSetView];
        strongSelf.collectionSetView.frame = CGRectMake(0, 552/2 * kFixed_rate, strongSelf.collectionSetView.width, strongSelf.collectionSetView.height);
    };

}

- (void)getCollectionCanvasReady
{
    NSArray *arrCharacter = [_DC arrObjectModel];
    [_DC.synchronousArrCanvas removeAllObjects];
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

    /// 没有收藏文字的情况
    if (_DC.synchronousArrCanvas.count == 0) {
        XWCollectionPlat *collectionPlat = [[XWCollectionPlat alloc] initWithFrame:self.rectPlat];
        collectionPlat.left      = kScreenSize.width * i + self.rectPlat.origin.x;
        [self.scrollView addSubview:collectionPlat];
        [_arrPlat addObject:collectionPlat];
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

    NSString *indexTitle    = [NSString stringWithFormat:@"%d / %d",1,_arrSectionCanvas.count ? (int)[_arrSectionCanvas count]:1];
    _labelPageIndex.text    = indexTitle;
    _currentPlat            = _arrPlat[0];

}

- (void)loadCollectionPlat
{
    XWCollectionPlat *collectionPlat = [[XWCollectionPlat alloc] initWithFrame:self.rectPlat];
    [self.scrollView addSubview:collectionPlat];
}

#pragma mark - _scrollViewDelegate -
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point           = scrollView.contentOffset;
    NSInteger index         = (int)point.x/(int)kScreenSize.width+1;
    NSString *indexTitle    = [NSString stringWithFormat:@"%ld / %ld",(long)index,_arrSectionCanvas.count];
    //    NSString *indexTitle = @"12/21";//[NSString stringWithFormat:@"%d/%d",(int)point.x/1024+1,_caseRowArr.count];

    _labelPageIndex.text    = indexTitle;
    _currentPlat            = _arrPlat[index -1];

    [self.view bringSubviewToFront:self.scrollView];
}

#pragma mark - TestFieldDelegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSInteger i = 0;
    for (XWCanvasControl *canvas in _DC.synchronousArrCanvas) {
        if ([canvas.fontChar isEqualToString:textField.text]) {
            [self.scrollView setContentOffset:CGPointMake(kScreenSize.width*(i/8), 0) animated:YES];
            return YES;
            break;
        }
        i++;
    }
    [self showHint:@"没有搜索到该字符" hide:1.5];
    return YES;
}

#pragma mark 重写 searchBtn
- (void)searchBtn:(UIButton *)btn
{
    [self.textfield resignFirstResponder];
    NSInteger i = 0;
    for (XWCanvasControl *canvas in _DC.synchronousArrCanvas) {
        if ([canvas.fontChar isEqualToString:self.textfield.text]) {
            [self.scrollView setContentOffset:CGPointMake(kScreenSize.width*(i/8), 0) animated:YES];
            return ;
            break;
        }
        i++;
    }
    [self showHint:@"没有搜索到该字符" hide:1.5];
}

#pragma mark 打印文字
- (void)printBtnClick:(UIButton *)btn
{
    if (_arrSectionCanvas.count == 0) {
        [self showHint:@"没有收藏的字符!" hide:1.5];
        return;
    }
    XWPDFViewController *pdfVC = [[XWPDFViewController alloc] init];
    pdfVC.collectionPlat    = _currentPlat;


    [self.navigationController pushViewController:pdfVC animated:YES];
}

@end
