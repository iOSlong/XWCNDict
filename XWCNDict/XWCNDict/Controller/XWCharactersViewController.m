//
//  XWCharactersViewController.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/4.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWCharactersViewController.h"
#import "XWTabBarViewController.h"
#import "XWCharacterPlat.h"



typedef struct pageIndex{
    int currentCharIndex;   /// 当前的子在字库中的位置0<currentLocation<_fontLibraryArr.count
    int offsetLocation;     /// 标记scrollView所显示的页面
    int maxCharIndex;       /// 当前最后一个字符（即表示已经初始化了的字符数目）
    int minCharIndex;       /// 当前的最前面一个有效的characterPlat字符索引。
}PageStruct;


@interface XWCharactersViewController ()<UIScrollViewDelegate,UITextFieldDelegate,XWCharacterPlatDelegate>

@property (nonatomic) UIScrollView      *scrollView;
@property (nonatomic) UIPageControl     *pageControl;
@property (nonatomic) XWCharacterPlat   *currentCharPlat;
@property (nonatomic) NSMutableArray    *arrCharPlat;

@end

@implementation XWCharactersViewController {
    NSUInteger _pageLocation;
    PageStruct _pageStruct;

    UIImageView *_imgvTabBarMask;
    UIImageView *_imgvPageMask;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        _imgvTabBarMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20*kFixed_rate, kScreenSize.width, 133 * kFixed_rate)];
        _imgvTabBarMask.image = [UIImage imageNamed:self.setInfo.imgNameTabbarMask];
        _imgvTabBarMask.alpha = 0.8;
        _imgvTabBarMask.userInteractionEnabled = YES;
        [_imgvTabBarMask setHidden:NO];
        [self.tabBarVC.view addSubview:_imgvTabBarMask];

        _imgvPageMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
        _imgvPageMask.image = [UIImage imageNamed:self.setInfo.imgNameTabbarMask];
        _imgvPageMask.alpha = 0.8;
        _imgvPageMask.userInteractionEnabled = YES;
        [_imgvPageMask setHidden:YES];
        [self.view addSubview:_imgvPageMask];

        [_imgvPageMask setHidden:YES];
        [_imgvTabBarMask setHidden:YES];
        _imgvTabBarMask.alpha   = 0;
        _imgvPageMask.alpha     = 0;


        UITapGestureRecognizer *tapGOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTap:)];
        UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTap:)];
        [_imgvTabBarMask addGestureRecognizer:tapGOne];
        [_imgvPageMask addGestureRecognizer:tapTwo];

    }
    return self;
}

- (void)maskTap:(UIGestureRecognizer *)gestureR {
    [_imgvPageMask setHidden:YES];
    [_imgvTabBarMask setHidden:YES];
    _imgvTabBarMask.alpha   = 0;
    _imgvPageMask.alpha     = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];

    [self configureScrollView];

    [self.view addSubview:self.pageControl];

    self.textfield.delegate = self;
    
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 500 * kFixed_rate, 30 * kFixed_rate)];
        [self.pageControl setNumberOfPages:[self.arrCharPlat count]];
        self.pageControl.center = CGPointMake(768/2 * kFixed_rate, 1440/2 * kFixed_rate);
        self.pageControl.userInteractionEnabled = NO;
        [self.pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (void)pageControlClick:(UIPageControl *)pageC {

}

- (NSMutableArray *)arrCharPlat{
    if (!_arrCharPlat) {
        _arrCharPlat = [NSMutableArray array];
    }
    return _arrCharPlat;
}

- (void)configureScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kPlat_Y, kScreenSize.width, kPlat_H)];
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width*3 * kFixed_rate, kPlat_H);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    XWCharacterPlat *charPlat1 = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(kPlat_X, 0, kPlat_W, kPlat_H)];
    XWCharacterPlat *charPlat2 = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(kPlat_X + kScreenSize.width, 0,  kPlat_W, kPlat_H)];
    XWCharacterPlat *charPlat3 = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(kPlat_X + 2*(kScreenSize.width), 0,  kPlat_W, kPlat_H)];

    [self.scrollView addSubview:charPlat1];
    [self.scrollView addSubview:charPlat2];
    [self.scrollView addSubview:charPlat3];

    [self.arrCharPlat addObject:charPlat1];
    [self.arrCharPlat addObject:charPlat2];
    [self.arrCharPlat addObject:charPlat3];


    self.currentCharPlat = charPlat1;

    _pageStruct.maxCharIndex        = 2;
    _pageStruct.minCharIndex        = 0;
    _pageStruct.currentCharIndex    = 0;
    _pageStruct.offsetLocation      = 0;

}


#pragma mark - SetGear Events
- (void)setGearBtn:(UIButton *)btn {

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
//    _charSet.frame = CGRectMake(0, 552/2, _charSet.frame.size.width, _charSet.frame.size.height);

    //    _charSet.backgroundColor = [UIColor yellowColor];

    [self displayMask];

    [UIView commitAnimations];
}

- (void)displayMask {
    [self.view bringSubviewToFront:_imgvPageMask];
    [self.tabBarVC.view bringSubviewToFront:_imgvTabBarMask];
    [_imgvTabBarMask setHidden:NO];
    [_imgvPageMask setHidden:NO];
    _imgvPageMask.alpha = 0.8;
    _imgvTabBarMask.alpha = 0.8;

//    [self.view bringSubviewToFront:_charSet];

//    for (UIView *view in self.view.subviews)
//    {
//
//        if ([view isKindOfClass:[XWCharacterPlat class]])
//        {
//            continue;
//        }
//        else
//        {
//            //            view.alpha = 0.3;
//            view.userInteractionEnabled = NO;
//            //            self.xueInferiteTabBarController.view.alpha = 0.3;
//            //if need all screen be mask，then can use method of the following。
//            //but you should make the _maskImgView.frame.size.height = tabbar.height.
//            //if need only ViewController uder the TabBarConroller,will be easy more!
//            //            [self.xueInferiteTabBarController.view addSubview:_tabbarmaskView];
//        }
////        _setGearView.userInteractionEnabled = YES;
////        _setGearView.alpha = 1;
//    }

//    [self.tabBarVC setInteruserble:NO];
//
    [self.tabBarVC.view addSubview:_imgvTabBarMask];

//    self.view.userInteractionEnabled = YES;

}


#pragma mark - SearchBar Events
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    [self loadTheFontChar:textField.text];

    return YES;
}

- (void)searchBtn:(UIButton *)btn
{
    [self.textfield resignFirstResponder];

    [self loadTheFontChar:self.textfield.text];
}

- (void)loadTheFontChar:(NSString *)fontChar {
    if (!self.textfield.text.length) {
        return;
    }

    if ([self.textfield.text intValue]) {
        NSInteger index = [self.setInfo.arrUnicodeFont count]>[self.textfield.text intValue]? [self.textfield.text intValue]:[self.setInfo.arrUnicodeFont count];

        self.textfield.text = [self.setInfo.arrUnicodeFont objectAtIndex:index-1];
    }


    self.currentCharPlat.fontCharPinyin = nil;
    self.currentCharPlat.fontChar = self.textfield.text;
    self.textfield.text = nil;

}


#pragma  mark - ScrollView Delegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageLocation = scrollView.contentOffset.x/scrollView.frame.size.width;

    if (_pageLocation == 0)
    {
        if (_pageStruct.minCharIndex == 0)
        {
            _pageStruct.currentCharIndex = 0;
            self.currentCharPlat = self.arrCharPlat[0];

        }
        else
        {
            _pageStruct.currentCharIndex -- ;
            _pageStruct.minCharIndex --     ;
            _pageStruct.maxCharIndex --     ;

            NSString *fontChar = self.setInfo.arrUnicodeFont[_pageStruct.minCharIndex];

            XWCharacterPlat *headCharPlat = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(kPlat_X + _pageLocation*(kScreenSize.width), 0,  kPlat_W, kPlat_H)];
            headCharPlat.fontChar = fontChar;
            headCharPlat.delegate = self;

            [self.scrollView addSubview:headCharPlat];
            [self.arrCharPlat insertObject:headCharPlat atIndex:0];

            XWCharacterPlat *delPlat = [self.arrCharPlat lastObject];
            [delPlat readyForRelease];
            [self.arrCharPlat removeLastObject];

            [self reloadCharacterPlats];

        }
    }
    else if (_pageLocation == 1)
    {
        _pageStruct.currentCharIndex = _pageStruct.maxCharIndex -1;
        self.currentCharPlat = self.arrCharPlat[1];
        self.pageControl.currentPage = _pageStruct.currentCharIndex;
    }
    else if (_pageLocation == 2)
    {
        if (_pageStruct.maxCharIndex + 1 >= self.setInfo.arrUnicodeFont.count) {
            self.pageControl.currentPage = _pageStruct.maxCharIndex;
            return;
        }
        else
        {
            _pageStruct.maxCharIndex ++     ;
            _pageStruct.minCharIndex ++     ;
            _pageStruct.currentCharIndex ++ ;

            if (self.pageControl.numberOfPages == _pageStruct.maxCharIndex) {
                self.pageControl.numberOfPages ++ ;
            }

            NSString *fontChar = self.setInfo.arrUnicodeFont[_pageStruct.maxCharIndex];
            XWCharacterPlat *tailCharPlat = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(kPlat_X + _pageLocation*(kScreenSize.width), 0,  kPlat_W, kPlat_H)];
            tailCharPlat.fontChar = fontChar;
            tailCharPlat.delegate = self;

            [self.scrollView addSubview:tailCharPlat];
            [self.arrCharPlat addObject:tailCharPlat];


            XWCharacterPlat *delPlat = [self.arrCharPlat firstObject];
            [delPlat readyForRelease];
            [self.arrCharPlat removeObjectAtIndex:0];

            [self reloadCharacterPlats];
        }
    }

    self.pageControl.currentPage = _pageStruct.currentCharIndex;
}

- (void)reloadCharacterPlats
{
    self.scrollView.userInteractionEnabled = NO;
    //如果主线程中还有其他任务，这里容易出现一个animation cann/t find selector 的错误，即使加上这个限制条件，拖动太快还是会出现问题。

    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }

    for (int i=0; i<self.arrCharPlat.count; i++) {
        XWCharacterPlat *fontp = [self.arrCharPlat objectAtIndex:i];
        fontp.frame = CGRectMake((i*1024+158/2)*kFixed_rate, 0, fontp.frame.size.width, fontp.frame.size.height);
        [_scrollView addSubview:fontp];
        [self.scrollView setContentSize:CGSizeMake((1024+1024*i)*kFixed_rate, fontp.frame.size.height)];
    }
    [self.scrollView setContentOffset:CGPointMake(1024 * kFixed_rate, 0) animated:NO];
    self.currentCharPlat  = [self.arrCharPlat objectAtIndex:1];

    self.scrollView.userInteractionEnabled = YES;
}

@end











