//
//  XWCharacterPlat.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/6.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWCharacterPlat.h"
#import "XWCharPlatSegment.h"
#import "XWCharacterInfoView.h"
#import "XWStrokeInfoView.h"

@interface XWCharacterPlat ()<XWCharPlatSegmentDelegate,XWGestureCanvasDelegate>
@property (nonatomic, strong) XWCharPlatSegment     *infoSegment;
@property (nonatomic, strong) XWCharacterInfoView   *characterInfoView;
@property (nonatomic, strong) XWStrokeInfoView      *strokeInfoView;
@end

@implementation XWCharacterPlat{
    XWSetInfo *_setInfo;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.userInteractionEnabled = YES;
        
        _setInfo = [XWSetInfo shareSetInfo];


        self.image = [UIImage imageNamed:_setInfo.imgNameCharacterPlat];


        [self configureInfoBannerView];

        [self configureCharPlatInfoSegment];

        [self configureCharSaveControlView];

        [self addSubview:self.characterInfoView];
        [self addSubview:self.strokeInfoView];

        /// UI布局的部分都搁置到最前面最好。
        [self configureMigeImageView];


    }
    return self;
}

- (XWCharacterInfoView *)characterInfoView {
    if (!_characterInfoView) {
        _characterInfoView = [[XWCharacterInfoView alloc] init];
        _characterInfoView.x = 896.0/2 * kFixed_rate;
        _characterInfoView.y = 314.0/2 * kFixed_rate;
        [_characterInfoView charInfo:^(NSString *charPinyin) {
            NSLog(@"%@",charPinyin);
        }];
    }
    return _characterInfoView;
}

- (XWStrokeInfoView *)strokeInfoView {
    if (!_strokeInfoView) {
        _strokeInfoView = [[XWStrokeInfoView alloc] initWithFrame:CGRectMake(896/2 * kFixed_rate, 300/2 * kFixed_rate, 624/2 * kFixed_rate, 280/2 * kFixed_rate) andStrokeBtnCount:30];
        _strokeInfoView.backgroundColor = [UIColor clearColor];

        [_strokeInfoView setHidden:YES];
    }
    return _strokeInfoView;
}


- (void)configureMigeImageView {
    
    UIImage *migeImg = [UIImage imageNamed:_setInfo.imgNameField];

    self.migeImgView = [[UIImageView alloc] initWithImage:migeImg];
    self.migeImgView.userInteractionEnabled = YES;
    self.migeImgView.frame = CGRectMake(kMiField_X, kMiField_Y, kMiField_W, kMiField_W);
    [self addSubview:_migeImgView];


    self.fontCanvas = [[XWGestureCanvas alloc] initWithFrame:CGRectMake(0, 0, kChar_W, kChar_W) fontChar:_fontChar];
    self.fontCanvas.delegate = self;
    self.fontCanvas.center = CGPointMake(kMiField_W/2, kMiField_W/2);
    [self.migeImgView addSubview:self.fontCanvas];

    self.fontChar = @"行";
}

- (void)configureInfoBannerView {
    self.imgvInfoBanner = [[UIImageView alloc] initWithFrame:CGRectMake(kInfoBanner_X , kInfoBanner_Y, kInfoBanner_W, kInfoBanner_H)];
    [self addSubview:self.imgvInfoBanner];
    self.imgvInfoBanner.image = [_setInfo.arrInfoImgName objectAtIndex:0];

}

- (void)configureCharPlatInfoSegment {
    self.infoSegment = [[XWCharPlatSegment alloc] initWithFrame:CGRectMake(896/2 * kFixed_rate, 646/2 * kFixed_rate, 0, 0)];
    self.infoSegment.left = self.width - self.infoSegment.width - kPlat_suffix + 1;
    self.infoSegment.delegate = self;
    [self addSubview:self.infoSegment];
}

- (void)selectSegmentWithIndex:(NSUInteger)index {
    if (index==0)
    {
        [_characterInfoView setHidden:NO];
        [_strokeInfoView setHidden:YES];
//        [_pinyin_infoView setHidden:YES];
//        [_radical_infoView setHidden:YES];
    }
    if (index==1) {
        [_strokeInfoView setHidden:NO];
        [_characterInfoView setHidden:YES];
//        [_pinyin_infoView setHidden:YES];
//        [_radical_infoView setHidden:YES];

    }
    if (index==2) {
//        [_pinyin_infoView setHidden:NO];
//        [_character_infoView setHidden:YES];
//        [_stroke_infoView setHidden:YES];
//        [_radical_infoView setHidden:YES];

    }
    if (index==3) {
//        [_radical_infoView setHidden:NO];
//        [_pinyin_infoView setHidden:YES];
//        [_character_infoView setHidden:YES];
//        [_stroke_infoView setHidden:YES];

    }
    self.imgvInfoBanner.image = [_setInfo.arrInfoImgName objectAtIndex:index];
}

- (void)configureCharSaveControlView {
    UIImage *saveImg = [UIImage imageNamed:_setInfo.imgNameCharSave];
    CGFloat bw = 103 * kFixed_rate;
    CGFloat bh = 101 * kFixed_rate;
    UIButton *btnSaveControl = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSaveControl setImage:saveImg forState:UIControlStateNormal];
    [btnSaveControl addTarget:self action:@selector(btnSaveControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnSaveControl setFrame:CGRectMake(kPlat_W - bw - kPlat_suffix, 87/2 * kFixed_rate, bw, bh)];
    [self addSubview:btnSaveControl];

    self.imgvSaveControl = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btnSaveControl.width * 0.7, btnSaveControl.height * 0.7)];
    self.imgvSaveControl.center = CGPointMake(btnSaveControl.width * 0.5, btnSaveControl.height * 0.5);
    [btnSaveControl addSubview:self.imgvSaveControl];
}

- (void)btnSaveControlClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(saveBtnSelected:)]) {
        [self.delegate saveBtnSelected:self];
    }
}

- (void)setFontChar:(NSString *)fontChar {
    _fontChar = fontChar;
    if (fontChar) {
        [self characterInfoShow];
    }

    
}


- (void)characterInfoShow {
    NSLog(@"%@",self.fontChar);
    if (self.fontCanvas) {
        [self.fontCanvas releaseSinoFont];
        [self.fontCanvas reloadWithFontChar:self.fontChar];
    }
}

#pragma mark - CanvasDelegate
- (void)gestureCanvas:(XWGestureCanvas *)canvas withEvent:(XWCanvasEvent)event saveImg:(UIImage *)saveImg {

    self.imgvSaveControl.image = saveImg;

    [self.characterInfoView reloadCharacterWith:self.fontChar strokeNum:canvas.sinoFont.strokeNum];

    [self reloadStrokeInfoWith:canvas.sinoFont];
}

- (void)reloadStrokeInfoWith:(STSinoFont *)sinoFont{
    NSArray *normalArr = [sinoFont getStrokesContinueImageArrayWithSize:CGSizeMake(50, 50) bottomColor:[UIColor grayColor] frontColor:[UIColor blackColor]];
    NSArray *selectArr = [sinoFont getStrokesContinueImageArrayWithSize:CGSizeMake(50, 50) bottomColor:[UIColor colorWithRed:190.0/255 green:220.0/255 blue:156.0/255 alpha:1] frontColor:[UIColor whiteColor]];
    //    [_stroke_infoView setStrokesImgArr:normalArr withState:StrokeBtnNormalState];
    //    [_stroke_infoView setStrokesImgArr:selectArr withState:StrokeBtnSelectedState];


    [_strokeInfoView getNormalImgArray:normalArr];
    [_strokeInfoView getSelectedImgArray:selectArr];
    [_strokeInfoView getStrokesBtnReload];

    if (self.infoSegment.selectedIndex==1) {
        [_strokeInfoView setHidden:NO];
    }
}

@end
