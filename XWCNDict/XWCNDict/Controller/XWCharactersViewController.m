//
//  XWCharactersViewController.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/4.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWCharactersViewController.h"
#import "XWCharacterPlat.h"

@interface XWCharactersViewController ()<UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) XWCharacterPlat *currentCharPlat;
@property (nonatomic) NSMutableArray *arrCharPlat;

@end

@implementation XWCharactersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];

    [self configureScrollView];

    
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

//    UIImage *backGroundImg = [UIImage imageNamed:@"font_plat.png"];
//    CGFloat width = CGImageGetWidth(backGroundImg.CGImage)/2.0 ;//* kFixed_rate;
//    CGFloat height = CGImageGetHeight(backGroundImg.CGImage)/2.0; //* kFixed_rate;
    XWCharacterPlat *charPlat1 = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(kPlat_X, 0, kPlat_W, kPlat_H)];
    XWCharacterPlat *charPlat2 = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(kPlat_X + kScreenSize.width, 0,  kPlat_W, kPlat_H)];
    XWCharacterPlat *charPlat3 = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(kPlat_X + 2*(kScreenSize.width * kFixed_rate), 0,  kPlat_W, kPlat_H)];
    charPlat1.backgroundColor = [UIColor whiteColor];
    charPlat2.backgroundColor = [UIColor whiteColor];
    charPlat3.backgroundColor = [UIColor whiteColor];

    [self.scrollView addSubview:charPlat1];
    [self.scrollView addSubview:charPlat2];
    [self.scrollView addSubview:charPlat3];
}



@end











