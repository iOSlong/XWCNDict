//
//  XWCharacterPlat.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/6.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWCharacterPlat.h"
#import "XWCharPlatSegment.h"

@interface XWCharacterPlat ()<XWCharPlatSegmentDelegate>
@property (nonatomic, strong) XWCharPlatSegment *infoSegment;
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

        [self configureMigeImageView];

        [self configureInfoBannerView];

        [self configureCharPlatInfoSegment];


    }
    return self;
}

- (void)configureMigeImageView {
    
    UIImage *migeImg = [UIImage imageNamed:_setInfo.imgNameField];

    self.migeImgView = [[UIImageView alloc] initWithImage:migeImg];
    self.migeImgView.userInteractionEnabled = YES;
    self.migeImgView.frame = CGRectMake(kMiField_X, kMiField_Y, kMiField_W, kMiField_W);
    [self addSubview:_migeImgView];


    self.fontCanvas = [[XWGestureCanvas alloc] initWithFrame:CGRectMake(0, 0, kChar_W, kChar_W) fontChar:@"啊"];
    self.fontCanvas.center = CGPointMake(kMiField_W/2, kMiField_W/2);
    [self.migeImgView addSubview:self.fontCanvas];
}

- (void)configureInfoBannerView {
    self.imgvInfoBanner = [[UIImageView alloc] initWithFrame:CGRectMake(kInfoBanner_X , kInfoBanner_Y, kInfoBanner_W, kInfoBanner_H)];
    [self addSubview:self.imgvInfoBanner];
    self.imgvInfoBanner.image = [_setInfo.arrInfoImgName objectAtIndex:0];

}

- (void)configureCharPlatInfoSegment {
    self.infoSegment = [[XWCharPlatSegment alloc] initWithFrame:CGRectMake(896/2 * kFixed_rate-2, 646/2 * kFixed_rate, 0, 0)];
//    self.infoSegment.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
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


@end
