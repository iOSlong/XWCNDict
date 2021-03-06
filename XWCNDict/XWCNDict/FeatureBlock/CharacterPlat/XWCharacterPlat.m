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
#import "XWPinyinInfoView.h"
#import "XWRadicalInfoView.h"


@interface XWCharacterPlat ()<XWCharPlatSegmentDelegate,XWGestureCanvasDelegate>
@property (nonatomic, strong) XWCharPlatSegment     *infoSegment;
@property (nonatomic, strong) XWCharacterInfoView   *characterInfoView;
@property (nonatomic, strong) XWStrokeInfoView      *strokeInfoView;
@property (nonatomic, strong) XWPinyinInfoView      *pinyinInfoView;
@property (nonatomic, strong) XWRadicalInfoView     *radicalInfoView;
@end

@implementation XWCharacterPlat{
    XWSetInfo *_setInfo;
    __block BOOL needFreshRadical;
    __block BOOL needFreshPinyin;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.userInteractionEnabled = YES;
        
        _setInfo = [XWSetInfo shareSetInfo];
        needFreshPinyin     = YES;
        needFreshRadical    = YES;


        self.image = [UIImage imageNamed:_setInfo.imgNameCharacterPlat];


        [self configureInfoBannerView];

        [self configureCharPlatInfoSegment];

        [self configureCharSaveControlView];

        [self addSubview:self.characterInfoView];
        [self addSubview:self.strokeInfoView];
        [self addSubview:self.pinyinInfoView];
        [self addSubview:self.radicalInfoView];
        /// UI布局的部分都搁置到最前面最好。
        [self configureMigeImageView];


        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBoxStyle) name:kNotiNameCharacter_CanvasBox_StyleChange object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(charColorChange) name:kNotiNameCharacter_Radical_ColorChange object:nil];


    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andChar:(NSString *)fontChar {
    _fontChar = fontChar;
    return [self initWithFrame:frame];
}


#pragma mark - NotificationCenter notiEvent
- (void)changeBoxStyle {
    UIImage *image = [UIImage imageNamed:_setInfo.imgNameField];
    self.migeImgView.image = image;

}
- (void)charColorChange {
    self.imgvSaveControl.image = [self.fontCanvas.sinoFont getRadicalImageWithSize:CGSizeMake(50, 50) bottomColor:[UIColor colorWithRed:141.0/255 green:198.0/255 blue:228.0/255 alpha:1] radicalColor:_setInfo.color_radical];

    if (_setInfo.color_radical&&!_setInfo.color_char) {
        _setInfo.color_char = [UIColor blackColor];
    }
    self.staticImg = [self.fontCanvas.sinoFont getBaseImageWithColor:_setInfo.color_char];

    [self stopOtherThreads];
}



- (XWCharacterInfoView *)characterInfoView {
    if (!_characterInfoView) {
        _characterInfoView = [[XWCharacterInfoView alloc] init];
        _characterInfoView.x = 896.0/2 * kFixed_rate;
        _characterInfoView.y = 314.0/2 * kFixed_rate;
        __weak __typeof(self)weakSelf = self;
        [_characterInfoView charInfo:^(NSString *charPinyin) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([strongSelf.fontCharPinyin isEqualToString:charPinyin]) {
                /// 没有必要更新pinyinInfoView
            }else{
                strongSelf.fontCharPinyin = charPinyin;
                NSLog(@"更新pinyinInfoView %@",charPinyin);
                [strongSelf.pinyinInfoView reloadPinyinWith:strongSelf.fontChar pinyin:charPinyin];
            }
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

- (XWPinyinInfoView *)pinyinInfoView {
    if (!_pinyinInfoView) {
        _pinyinInfoView = [[XWPinyinInfoView alloc] initWithFrame:CGRectMake(896/2 * kFixed_rate, 330/2 * kFixed_rate, 768/2 * kFixed_rate, 260/2 * kFixed_rate)];
        __weak typeof(self)weakSelf = self;
        [_pinyinInfoView pinyinInfo:^(NSString *fontChar, NSString *pinyin) {
            __strong typeof(weakSelf) strongSelf  = weakSelf;
            NSLog(@"fontchar:%@, pinyin:%@",fontChar, pinyin);
            if ([strongSelf.fontChar isEqualToString:fontChar]) {
                /// 没有必要刷新当前字符
            }else{
                needFreshPinyin     = NO;
                needFreshRadical    = YES;
                strongSelf.fontChar = fontChar;
            }
        }];
        [_pinyinInfoView setHidden:YES];
    }
    return _pinyinInfoView;
}

- (XWRadicalInfoView *)radicalInfoView {
    if (!_radicalInfoView) {
        _radicalInfoView = [[XWRadicalInfoView alloc] initWithFrame:CGRectMake(896/2 * kFixed_rate, 320/2 * kFixed_rate, 780/2 * kFixed_rate, 285/2 * kFixed_rate)];
        __weak __typeof(self)weakSelf = self;
        [_radicalInfoView radicalInfo:^(NSString *fontChar) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([strongSelf.fontChar isEqualToString:fontChar]) {
                /// 没有必要刷新当前字符
            }else{
                needFreshRadical    = NO;
                needFreshPinyin     = YES;
                strongSelf.fontCharPinyin = nil;
                strongSelf.fontChar = fontChar;
            }
            NSLog(@"radicalFont %@",fontChar);
        }];
        [_radicalInfoView setHidden:YES];
    }
    return _radicalInfoView;
}

- (void)configureMigeImageView {
    
    UIImage *migeImg = [UIImage imageNamed:_setInfo.imgNameField];

    self.migeImgView = [[UIImageView alloc] initWithImage:migeImg];
    self.migeImgView.userInteractionEnabled = YES;
    self.migeImgView.frame = CGRectMake(kMiField_X, kMiField_Y, kMiField_W, kMiField_W);
    [self addSubview:_migeImgView];


    self.fontCanvas = [[XWGestureCanvas alloc] initWithFrame:CGRectMake(0, 0, kChar_W, kChar_W) fontChar:self.fontChar];
    self.fontCanvas.delegate = self;
    self.fontCanvas.center = CGPointMake(kMiField_W/2, kMiField_W/2);
    [self.migeImgView addSubview:self.fontCanvas];

    if (self.fontChar) {
        [self characterInfoShow];
    }
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
        [_pinyinInfoView setHidden:YES];
        [_radicalInfoView setHidden:YES];
    }
    if (index==1) {
        [_strokeInfoView setHidden:NO];
        [_characterInfoView setHidden:YES];
        [_pinyinInfoView setHidden:YES];
        [_radicalInfoView setHidden:YES];

    }
    if (index==2) {
        [_pinyinInfoView setHidden:NO];
        [_characterInfoView setHidden:YES];
        [_strokeInfoView setHidden:YES];
        [_radicalInfoView setHidden:YES];

    }
    if (index==3) {
        [_radicalInfoView setHidden:NO];
        [_pinyinInfoView setHidden:YES];
        [_characterInfoView setHidden:YES];
        [_strokeInfoView setHidden:YES];

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

    if (needFreshPinyin) {
        [self.pinyinInfoView reloadPinyinWith:self.fontChar pinyin:self.fontCharPinyin];
    }

    if (needFreshRadical) {
        [self.radicalInfoView reloadRadicalWith:self.fontChar];
    }

    self.staticImg = [self.fontCanvas.sinoFont getBaseImageWithColor:_setInfo.color_char];
}

- (void)reloadStrokeInfoWith:(STSinoFont *)sinoFont{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        NSArray *normalArr = [sinoFont getStrokesContinueImageArrayWithSize:CGSizeMake(50, 50) bottomColor:[UIColor grayColor] frontColor:[UIColor blackColor]];
        NSArray *selectArr = [sinoFont getStrokesContinueImageArrayWithSize:CGSizeMake(50, 50) bottomColor:[UIColor colorWithRed:190.0/255 green:220.0/255 blue:156.0/255 alpha:1] frontColor:[UIColor whiteColor]];
        [_strokeInfoView getNormalImgArray:normalArr];
        [_strokeInfoView getSelectedImgArray:selectArr];

        dispatch_async(dispatch_get_main_queue(), ^{
            [_strokeInfoView getStrokesBtnReload];
        });
    });
    if (self.infoSegment.selectedIndex==1) {
        [_strokeInfoView setHidden:NO];
    }
}



- (void)stopOtherThreads {
    [self.fontCanvas.sinoFont drawPause];

    [UIView animateWithDuration:0.3 animations:^{
        self.fontCanvas.sinoFont.imageCanvas.image = nil;
        self.fontCanvas.imgvBackground.image = self.staticImg;
    }];

    [self.fontCanvas.sinoFont releaseSinoFont_AnimationInfo];

}

- (void)readyForRelease {
    [self stopOtherThreads];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
