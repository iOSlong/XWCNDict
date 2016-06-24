//
//  XWColorKeyBoard.m
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWColorKeyBoard.h"
#import "XWColorBtn.h"

@implementation XWColorKeyBoard
{
    NSMutableArray *_arrColorBtn;
    NSMutableArray *_arrColor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"colorKeyboardimg.png"];
        _arrColorBtn = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = YES;

        [self addColorBtns];

    }
    return self;
}

- (instancetype)initInPoemSetWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"poemColorBackImg.png"];
        _arrColorBtn = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = YES;
        [self addColorBtnsInPoem];
    }
    return self;

}

- (void)addColorBtnsInPoem {
    UIColor *color1 = [UIColor colorWithRed:255.0/255 green:157.0/255 blue:4.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:5.0/255 green:170.0/255 blue:250.0/255 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:168.0/255 green:168.0/255 blue:168.0/255 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:231.0/255 green:235.0/255 blue:16.0/255 alpha:1];
    UIColor *color5 = [UIColor colorWithRed:59.0/255 green:205.0/255 blue:94.0/255 alpha:1];

    _arrColor = [[NSMutableArray alloc] initWithObjects:color1,color2,color3,color4,color5, nil];

    for (int i=0; i<5; i++) {
        CGRect rect = CGRectMake(40+i%5*(17+18), 15+i/5*(17+8), 17, 17);
        XWColorBtn *cbtn = [[XWColorBtn alloc] initWithFrame:rect];
        cbtn.backgroundColor = [_arrColor objectAtIndex:i];
        [cbtn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_arrColorBtn addObject:cbtn];
        [self addSubview:cbtn];
    }
}
- (void)addColorBtns
{
    UIColor *color1 = [UIColor colorWithRed:255.0/255 green:157.0/255 blue:4.0/255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:5.0/255 green:170.0/255 blue:250.0/255 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:168.0/255 green:168.0/255 blue:168.0/255 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:231.0/255 green:235.0/255 blue:16.0/255 alpha:1];
    UIColor *color5 = [UIColor colorWithRed:59.0/255 green:205.0/255 blue:94.0/255 alpha:1];

    UIColor *color6 = [UIColor colorWithRed:180.0/255 green:132.0/255 blue:56.0/255 alpha:1];
    UIColor *color7 = [UIColor colorWithRed:33.0/255 green:130.0/255 blue:175.0/255 alpha:1];
    UIColor *color8 = [UIColor colorWithRed:97.0/255 green:97.0/255 blue:97.0/255 alpha:1];
    UIColor *color9 = [UIColor colorWithRed:162.0/255 green:163.0/255 blue:44.0/255 alpha:1];
    UIColor *color10 = [UIColor colorWithRed:39.0/255 green:149.0/255 blue:63.0/255 alpha:1];

    UIColor *color11 = [UIColor colorWithRed:84.0/255 green:62.0/255 blue:25.0/255 alpha:1];
    UIColor *color12 = [UIColor colorWithRed:15.0/255 green:60.0/255 blue:79.0/255 alpha:1];
    UIColor *color13 = [UIColor colorWithRed:35.0/255 green:40.0/255 blue:43.0/255 alpha:1];
    UIColor *color14 = [UIColor colorWithRed:77.0/255 green:77.0/255 blue:39.0/255 alpha:1];
    UIColor *color15 = [UIColor colorWithRed:19.0/255 green:65.0/255 blue:29.0/255 alpha:1];

    _arrColor = [[NSMutableArray alloc] initWithObjects:color1,color2,color3,color4,color5,color6,color7,color8,color9,color10,color11,color12,color13,color14,color15, nil];


    for (int i=0; i<15; i++) {
        CGRect rect = CGRectMake((40+i%5*(17+18))*kFixed_rate, (15+i/5*(17+8))*kFixed_rate, 17 * kFixed_rate, 17 * kFixed_rate);
        XWColorBtn *cbtn = [[XWColorBtn alloc] initWithFrame:rect];
        cbtn.backgroundColor = [_arrColor objectAtIndex:i];
        [cbtn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_arrColorBtn addObject:cbtn];
        [self addSubview:cbtn];
    }
}

- (void)colorBtnClick:(XWColorBtn *)cbtn
{
    for (XWColorBtn *cb in _arrColorBtn) {
        cb.selected = NO;
    }
    cbtn.selected = !cbtn.selected;
    NSLog(@"color:%@",cbtn.layer.backgroundColor);
    self.charColor = [UIColor colorWithCGColor:cbtn.layer.backgroundColor];

    if (_ColorKBBlock) {
        _ColorKBBlock (self.charColor);
    }
}

- (void)colorKeyBoard:(ColorKeyBoardBlock)thisBlock {
    _ColorKBBlock = thisBlock;
}

@end
