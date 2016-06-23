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

@interface XWCharacterPlat ()<XWCharPlatSegmentDelegate,XWGestureCanvasDelegate>
@property (nonatomic, strong) XWCharPlatSegment     *infoSegment;
@property (nonatomic, strong) XWCharacterInfoView   *characterInfoView;
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

        /// UI布局的部分都搁置到最前面最好。
        [self configureMigeImageView];

        [self addSubview:self.characterInfoView];

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

    self.fontChar = @"腻";
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
//        [_character_infoView setHidden:NO];
//        [_stroke_infoView setHidden:YES];
//        [_pinyin_infoView setHidden:YES];
//        [_radical_infoView setHidden:YES];
    }
    if (index==1) {
//        [_stroke_infoView setHidden:NO];
//        [_character_infoView setHidden:YES];
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
}

@end
