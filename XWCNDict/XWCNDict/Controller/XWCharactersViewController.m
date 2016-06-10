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
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 470.0/2 * kFixed_rate, 1024 * kFixed_rate, 428 * kFixed_rate)];
    self.scrollView.contentSize = CGSizeMake(1024*3 * kFixed_rate, 854/2 * kFixed_rate);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:_scrollView];

    UIImage *backGroundImg = [UIImage imageNamed:@"font_plat.png"];
    CGFloat width = CGImageGetWidth(backGroundImg.CGImage)/2.0 * kFixed_rate;
    CGFloat height = CGImageGetHeight(backGroundImg.CGImage)/2.0 * kFixed_rate;
    CGFloat leftSpan = 158/2 * kFixed_rate;
    XWCharacterPlat *charPlat1 = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(leftSpan, 0, width, height)];
    XWCharacterPlat *charPlat2 = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(leftSpan + 1024 * kFixed_rate, 0, width, height)];
    XWCharacterPlat *charPlat3 = [[XWCharacterPlat alloc] initWithFrame:CGRectMake(leftSpan + 2*(1024 * kFixed_rate), 0, width, height)];
    charPlat1.backgroundColor = [UIColor whiteColor];
    charPlat2.backgroundColor = [UIColor whiteColor];
    charPlat3.backgroundColor = [UIColor whiteColor];

    [self.scrollView addSubview:charPlat1];
    [self.scrollView addSubview:charPlat2];
    [self.scrollView addSubview:charPlat3];



}



@end
