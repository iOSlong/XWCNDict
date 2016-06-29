//
//  XWGameViewController.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/4.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWGameViewController.h"
#import "STSinoFont.h"
#import "XWCanvasControl.h"


@interface XWGameViewController ()<STSinoFontDelegate>

@property (nonatomic, strong) STSinoFont *sinoFont;
@property (nonatomic, strong) STSinoFont *newsinoFont;

@property (nonatomic, strong) UIImageView *imgvFont;

@property (nonatomic, strong) UIButton *btnDraw;
@end

@implementation XWGameViewController

- (void)btnDrawClick:(UIButton *)btn {
//    [_sinoFont drawStar];//启动动画绘制（BaseDraw）

    if (_newsinoFont.drawing) {
        [_newsinoFont drawPause];
    }else{
        [_newsinoFont drawContinue];
    }
    if (_newsinoFont.drawOver) {
        [_newsinoFont drawStar];
    }
}
- (void)sinoFontDrawingFinished:(STSinoFont *)sinofont{
    NSLog(@"finish font drawing");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    _sinoFont = [[STSinoFont alloc] initWithChar:@"啊" andSize:CGSizeMake(140, 140) thousandeBase:NO];
//    _sinoFont.delegate = self;

    self.btnDraw = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btnDraw setBackgroundColor:[UIColor orangeColor]];
    self.btnDraw.frame = CGRectMake(100, 450, 100, 40);
    [self.btnDraw setTitle:@"draw font" forState:UIControlStateNormal];
    [self.view addSubview:_btnDraw];
    [self.btnDraw addTarget:self action:@selector(btnDrawClick:) forControlEvents:UIControlEventTouchUpInside];

    self.imgvFont = [[UIImageView alloc] initWithFrame:CGRectMake(100, 250, 140, 140)];
    [self.view addSubview:_imgvFont];
    self.imgvFont.backgroundColor = [UIColor yellowColor];


    [self.imgvFont addSubview:_sinoFont.imageCanvas];





    XWCanvasControl *canvas = [[XWCanvasControl alloc] initWithFrame:CGRectMake(300, 450, 150, 150)];
    canvas.backgroundColor = [UIColor lightGrayColor];
    canvas.fontChar = @"啊";
    [self.view addSubview:canvas];


   STSinoFont *newsinoFont = [[STSinoFont alloc] initWithChar:@"一" andSize:CGSizeMake(200, 200) thousandeBase:NO];
    newsinoFont.imageCanvas.center = self.view.center;
    _newsinoFont = newsinoFont;
    [self.view addSubview:newsinoFont.imageCanvas];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
