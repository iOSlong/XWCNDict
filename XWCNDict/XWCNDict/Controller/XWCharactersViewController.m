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
#import "XWCharacterSetView.h"
#import "XWMyDataController.h"
#import <MBProgressHUD/MBProgressHUD.h>




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
@property (nonatomic) XWCharacterSetView    *characterSetView;

@end

@implementation XWCharactersViewController {
    NSUInteger _pageLocation;
    PageStruct _pageStruct;

    UIImageView *_imgvTabBarMask;
    UIImageView *_imgvPageMask;

    XWMyDataController *_DC;
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

        _imgvPageMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
        _imgvPageMask.image = [UIImage imageNamed:self.setInfo.imgNameTabbarMask];
        _imgvPageMask.alpha = 0.8;
        _imgvPageMask.userInteractionEnabled = YES;
        [_imgvPageMask setHidden:YES];

        [_imgvPageMask setHidden:YES];
        [_imgvTabBarMask setHidden:YES];
        _imgvTabBarMask.alpha   = 0;
        _imgvPageMask.alpha     = 0;


        UITapGestureRecognizer *tapGOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTap:)];
        UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTap:)];
        [_imgvTabBarMask addGestureRecognizer:tapGOne];
        [_imgvPageMask addGestureRecognizer:tapTwo];

        _DC = [XWMyDataController shareDataController];

        /// 注意，在VC 里面的init方法中，不能执行 addSubview的UI绘制操作。
    }
    return self;
}

- (void)maskTap:(UIGestureRecognizer *)gestureR {
    [UIView animateWithDuration:0.5f animations:^{
        self.characterSetView.frame = CGRectMake((-607.0/2-300)*kFixed_rate, 554/2 * kFixed_rate, self.characterSetView.width, self.characterSetView.height);
        _imgvTabBarMask.alpha   = 0;
        _imgvPageMask.alpha     = 0;
    } completion:^(BOOL finished) {
        [_imgvPageMask setHidden:YES];
        [_imgvTabBarMask setHidden:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];

    [self configureScrollView];

    [self.view addSubview:self.pageControl];

    self.textfield.delegate = self;

    [self.view addSubview:_imgvPageMask];
    [self.tabBarVC.view addSubview:_imgvTabBarMask];
    [self.view addSubview:self.characterSetView];


}

- (XWCharacterSetView *)characterSetView {
    if (!_characterSetView) {
        _characterSetView = [[XWCharacterSetView alloc] initWithFrame:CGRectMake((-615.0/2-300)*kFixed_rate, 554/2 * kFixed_rate, 0, 0)];
    }
    return _characterSetView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 500 * kFixed_rate, 30)];
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

    XWCharacterPlat *charPlat1 = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(kPlat_X, 0, kPlat_W, kPlat_H) andChar:self.setInfo.arrUnicodeFont[0]];
    XWCharacterPlat *charPlat2 = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(kPlat_X + kScreenSize.width, 0,  kPlat_W, kPlat_H)andChar:self.setInfo.arrUnicodeFont[1]];
    XWCharacterPlat *charPlat3 = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(kPlat_X + 2*(kScreenSize.width), 0,  kPlat_W, kPlat_H)andChar:self.setInfo.arrUnicodeFont[2]];

    charPlat1.delegate = self;
    charPlat2.delegate = self;
    charPlat3.delegate = self;

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

    [self displayMask];

    [UIView commitAnimations];
}

- (void)displayMask {
    [self.view bringSubviewToFront:_imgvPageMask];
    [self.view bringSubviewToFront:self.characterSetView];
    [self.tabBarVC.view bringSubviewToFront:_imgvTabBarMask];
    [_imgvTabBarMask setHidden:NO];
    [_imgvPageMask setHidden:NO];
    _imgvPageMask.alpha = 0.8;
    _imgvTabBarMask.alpha = 0.8;
    self.characterSetView.frame = CGRectMake(0, 552/2 * kFixed_rate, self.characterSetView.width, self.characterSetView.height);
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


#pragma mark - CharacterPlat Delegate  save FontChar
- (void)saveBtnSelected:(XWCharacterPlat *)characterPlat {
    NSLog(@"save ………%@",characterPlat.fontChar);

    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"you sure save %@",characterPlat.fontChar] message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"YES");


        /// 判断是否有收藏
        NSArray *modelArr = [_DC arrObjectModel];
        BOOL needStorn = YES;
        for (XWCharacter *cModel in modelArr) {
            if ([characterPlat.fontChar isEqualToString:cModel.fontChar]) {
                [self showHint:[NSString stringWithFormat:@"%@  您已经收藏有该汉字啦 ！",cModel.fontChar] hide:2.0f];
                needStorn = NO;
                break;
            }
        }
        
        /// CoreData进行汉字本地存储
        if (needStorn) {
            /// 存储字符信息
            XWCharacter *charModel =  [NSEntityDescription insertNewObjectForEntityForName:@"XWCharacter" inManagedObjectContext:_DC.managedObjectContext];
            NSData *dataImg     = UIImagePNGRepresentation(characterPlat.staticImg);
            charModel.dataImg   = dataImg;
            charModel.fontChar  = characterPlat.fontChar;
            charModel.dateModify= [NSDate date];

            NSError *error = nil;
            [_DC.managedObjectContext save:&error];
            if (error) {
                NSLog(@"fail storn charModel  :%@",error);
            }else{
                [self showLoadingSuccess:YES hintString:@"已收藏到： My Collection" hide:2.0];
            }
        }
        [alertControl dismissViewControllerAnimated:YES completion:nil];

    }];

    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"NO");
        [alertControl dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertControl addAction:actionSure];
    [alertControl addAction:actionCancel];
    
    [self presentViewController:alertControl animated:YES completion:nil];

}






@end











