//
//  XWPoemViewController.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/4.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWPoemViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XWPoemArena.h"
#import "XWPoemSetView.h"
//#import "PoemSet.h"

@interface XWPoemViewController ()<UIScrollViewDelegate,XWPoemArenaDelegate>
@property (nonatomic, strong) NSMutableArray *arrSceneImg1;
@property (nonatomic, strong) NSMutableArray *arrSceneImg2;
@property (nonatomic, strong) NSMutableArray *arrPlats;


@property (nonatomic, strong) NSMutableArray *arrPoemArena;
@property (nonatomic, strong) NSMutableArray *arrPoem;
@property (nonatomic, strong) NSMutableArray *arrPoemVoice;

@property (nonatomic, strong) XWPoemSetView *poemSetView;
@property (nonatomic, strong) XWPoemArena   *poemArena;
@property (nonatomic, strong) UIButton      *controlBtn;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation XWPoemViewController{
    NSInteger _pageIndex;
    NSInteger _launchIndex;
    XWPoemArena *_launchPoemArena;

}


- (XWPoemSetView *)poemSetView
{
    if (!_poemSetView) {
        _poemSetView = [[XWPoemSetView alloc] initWithFrame:CGRectMake(-538 * kFixed_rate, 635 * kFixed_rate/2, 538 * kFixed_rate, 295 * kFixed_rate)];
        __weak __typeof(self)weakSelf = self;

        [_poemSetView poemSetVolumeCallBackFunc:^(XWPoemSetView *poemset) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.player.volume = poemset.volume;
        }];
        [_poemSetView poemSetVoiceCallBackFunc:^(XWPoemSetView *poemset) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (_poemSetView.voiceOpen) {
                [strongSelf readPoemVoiceAtIndex:_pageIndex];
                [strongSelf.player play];
            }else{
                [strongSelf.player stop];
            }
        }];
    }
    return _poemSetView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.platViewModel = XWPlatViewModelPeom;

    UIImage *image1 = [UIImage imageNamed:@"shijin1.png"];
    UIImage *image2 = [UIImage imageNamed:@"shijin2.png"];
    UIImage *image3 = [UIImage imageNamed:@"shijin3.png"];
    UIImage *image4 = [UIImage imageNamed:@"shijin4.png"];
    UIImage *image5 = [UIImage imageNamed:@"shijin5.png"];
    self.arrSceneImg1 = [NSMutableArray arrayWithObjects:image1,image2,image3,image4,image5, nil];

    UIImage *image11 = [UIImage imageNamed:@"shijin11.png"];
    UIImage *image22 = [UIImage imageNamed:@"shijin22.png"];
    UIImage *image33 = [UIImage imageNamed:@"shijin33.png"];
    UIImage *image44 = [UIImage imageNamed:@"shijin44.png"];
    UIImage *image55 = [UIImage imageNamed:@"shijin55.png"];
    self.arrSceneImg2 = [NSMutableArray  arrayWithObjects:image11,image22,image33,image44,image55, nil];

    UIImageView *plat1 = [[UIImageView alloc] initWithImage:image11];
    UIImageView *plat2 = [[UIImageView alloc] initWithImage:image22];
    UIImageView *plat3 = [[UIImageView alloc] initWithImage:image33];
    UIImageView *plat4 = [[UIImageView alloc] initWithImage:image44];
    UIImageView *plat5 = [[UIImageView alloc] initWithImage:image55];

    self.arrPlats = [NSMutableArray arrayWithObjects:plat1,plat2,plat3,plat4,plat5, nil];
    for (UIImageView *imgv in self.arrPlats) {
        imgv.userInteractionEnabled = YES;
    }




    XWPoem *poem1 = [[XWPoem alloc] init];
    poem1.pAuthor = @"李白";
    poem1.pContent = @"床前明月光疑似地上霜举头望明月低头思故乡";
    poem1.pName = @"静夜思";
    poem1.pLineLenght =5;

    XWPoem *poem2 = [[XWPoem alloc] init];
    poem2.pAuthor = @"杜甫";
    poem2.pName = @"绝句";
    poem2.pContent = @"两个黄鹂鸣翠柳一行白鹭上青天窗寒西岭千秋雪门泊东吴万里船";
    poem2.pLineLenght = 7;

    XWPoem *poem3 = [[XWPoem alloc] init];
    poem3.pAuthor = @"柳宗元";
    poem3.pName = @"江雪";
    poem3.pContent = @"千山鸟飞绝万径人踪灭孤舟蓑笠翁独钓寒江雪";
    poem3.pLineLenght = 5;

    XWPoem *poem4 = [[XWPoem alloc] init];
    poem4.pAuthor = @"王之涣";
    poem4.pName = @"登鹳雀楼";
    poem4.pContent = @"白日依山尽黄河入海流欲穷千里目更上一层楼";
    poem4.pLineLenght = 5;

    XWPoem *poem5 = [[XWPoem alloc] init];
    poem5.pAuthor = @"贺知章";
    poem5.pName = @"回乡偶书";
    poem5.pContent = @"少小离家老大回乡音无改鬓毛衰儿童相见不相识笑问客从何处来";
    poem5.pLineLenght = 7;


    _arrPoem = [NSMutableArray arrayWithObjects:poem1,poem2,poem3,poem4,poem5, nil];






    XWPoemArena *pstage1 = [[XWPoemArena alloc] initWithFrame:CGRectMake(530 * kFixed_rate, 60 * kFixed_rate, 300 * kFixed_rate, 190 * kFixed_rate)];
//    pstage1.backgroundColor = [UIColor yellowColor];
    pstage1.delegate = self;
    pstage1.tag = 0;
    [plat1 addSubview:pstage1];

    XWPoemArena *pstage2 = [[XWPoemArena alloc] initWithFrame:CGRectMake(966.0/2 * kFixed_rate, 176.0/2 * kFixed_rate, 620/2 * kFixed_rate, 524/2 * kFixed_rate)];
    pstage2.delegate = self;
    pstage2.tag = 1;
    [plat2 addSubview:pstage2];

    XWPoemArena *pstage3 = [[XWPoemArena alloc] initWithFrame:CGRectMake(1080/2 * kFixed_rate, 418/2 * kFixed_rate, 300 * kFixed_rate, 190 * kFixed_rate)];
    pstage3.delegate = self;
    pstage3.tag = 2;
    [plat3 addSubview:pstage3];

    XWPoemArena *pstage4 = [[XWPoemArena alloc] initWithFrame:CGRectMake(126/2 * kFixed_rate, 214/2 * kFixed_rate, 570/2 * kFixed_rate, 390/2 * kFixed_rate)];
    pstage4.delegate = self;
    pstage4.tag = 3;
    [plat4 addSubview:pstage4];


    XWPoemArena *pstage5 = [[XWPoemArena alloc] initWithFrame:CGRectMake(986/2 * kFixed_rate, 174/2 * kFixed_rate, 570/2 * kFixed_rate, 530/2 * kFixed_rate)];
    pstage5.delegate = self;
    pstage5.tag = 4;
    [plat5 addSubview:pstage5];

    self.poemArena = pstage1;


    _arrPoemArena = [NSMutableArray array];
    [_arrPoemArena addObject:pstage1];
    [_arrPoemArena addObject:pstage2];
    [_arrPoemArena addObject:pstage3];
    [_arrPoemArena addObject:pstage4];
    [_arrPoemArena addObject:pstage5];



    for (int i = 0; i<self.arrPlats.count; i++) {
        CGRect rect = CGRectMake(kPlat_X + i * kScreenSize.width, 0, kPlat_W, kPlat_H);
        UIImageView *imgvpp = self.arrPlats[i];
        imgvpp.frame = rect;
        [self.scrollView addSubview:imgvpp];
    }
    [self.scrollView setContentSize:CGSizeMake(kScreenSize.width * self.arrPlats.count, kPlat_H)];



    [self performSelectorInBackground:@selector(addPoem) withObject:nil];

    
    self.controlBtn = [[UIButton alloc] initWithFrame:CGRectMake(260/2 *kFixed_rate , self.btnSetGear.y, 55/2 * kFixed_rate, 55/2 * kFixed_rate)];
    [self.controlBtn setImage:[UIImage imageNamed:@"bofang2"] forState:UIControlStateNormal];
    [self.view addSubview:self.controlBtn];
    [self.controlBtn addTarget:self action:@selector(btnPlayClick:) forControlEvents:UIControlEventTouchUpInside];


    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 500, 30)];
    [self.pageControl setNumberOfPages:5];
    self.pageControl.center = CGPointMake(768/2 * kFixed_rate, 1440/2 * kFixed_rate);
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.currentPage = _pageIndex;
    [self.view addSubview:self.pageControl];
    /// 音频文件
    _arrPoemVoice = [[NSMutableArray alloc] initWithObjects:@"jingyesi",@"jueju",@"jiangxue",@"dengguanquelou",@"huixiangoushu", nil];


    self.scrollView.delegate = self;

#pragma mark PoemSetView
    [self.view addSubview:self.poemSetView];
    self.poemSetView.poemStageArray = _arrPoemArena;

    __weak __typeof(self)weakSelf = self;
    self.MaskShowBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.view bringSubviewToFront:strongSelf.poemSetView];
        strongSelf.poemSetView.center = CGPointMake(fabs( strongSelf.poemSetView.center.x),  strongSelf.poemSetView.center.y);
    };
    self.MaskHiddenBlock = ^(){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.poemSetView.center = CGPointMake(-fabs(strongSelf.poemSetView.center.x),  strongSelf.poemSetView.center.y);
    };
}




-(void)btnPlayClick:(UIButton *)btn
{
    if (self.poemArena.playingOver) {
        self.poemArena.canDelegate = YES;
        if (!self.poemArena.haveReady) {
            return;
        }
        [self.poemArena poemStageActive];
        [self.controlBtn setImage:[UIImage imageNamed:@"zanting2.png"] forState:UIControlStateNormal];
    }
    if (!self.poemArena.playingOver) {
        if (self.poemArena.playingPause) {
            self.poemArena.canDelegate = YES;
            [self.poemArena poemStagContinue];
            [self.controlBtn setImage:[UIImage imageNamed:@"zanting2.png"] forState:UIControlStateNormal];

        }else{
            self.poemArena.canDelegate = NO;
            [self.poemArena poemStagPause];
            for (XWPoemArena *pa in _arrPoemArena) {
                pa.strokeSound = NO;
            }
            [self.controlBtn setImage:[UIImage imageNamed:@"bofang2.png"] forState:UIControlStateNormal];

        }
    }
}


#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / kScreenSize.width;
    _pageIndex = page;

    [self.poemArena poemStagPause];
    self.poemArena = [_arrPoemArena objectAtIndex:page];

    [self.controlBtn setImage:[UIImage imageNamed:@"bofang2.png"] forState:UIControlStateNormal];
    self.pageControl.currentPage = _pageIndex;

}


#pragma mark - 《开启avaudio 读部首发音》
- (void)readPoemVoiceAtIndex:(NSInteger )index
{

    NSString *poemVoice = [_arrPoemVoice objectAtIndex:index];
    //    NSLog(@"%@",read);
    NSString *path = [[NSBundle mainBundle]pathForResource:poemVoice ofType:@"wav"];
    if (!path) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];

        [_player prepareToPlay];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.player.volume =0.5;// _poemSet.volume;

            [_player play];
        });
    });
}


#pragma mark - XWPoemArenaDelegate
- (void)poemStagePlayingOver:(XWPoemArena *)poemArena
{
    [self.controlBtn setImage:[UIImage imageNamed:@"bofang2.png"] forState:UIControlStateNormal];
}

- (void)poemStageReadyPlaying:(XWPoemArena *)poemArena
{
    UIImageView *thisImgView = [_arrPlats objectAtIndex:poemArena.tag];
    thisImgView.image = [_arrSceneImg1 objectAtIndex:poemArena.tag];


    _launchIndex = poemArena.tag+1;
    if (_launchIndex<=4) {
        _launchPoemArena = [_arrPoemArena objectAtIndex:_launchIndex];
        [self performSelectorInBackground:@selector(launchPoem) withObject:nil];
        //        [self launchPoem];
        //        [self.scrollView setContentSize:CGSizeMake((_launchIndex+1)*1024, self.scrollView.frame.size.height)];
    }
    if (_launchIndex==5) {
        [_arrSceneImg2 removeAllObjects];
    }

}

- (void)launchPoem
{
    _launchPoemArena.poem = [_arrPoem objectAtIndex:_launchIndex];
}

- (void)addPoem
{
    self.poemArena.poem = [_arrPoem objectAtIndex:_pageIndex];
}


@end
