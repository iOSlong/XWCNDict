//
//  XWCharacterPlat.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/6.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWCharacterPlat.h"


@implementation XWCharacterPlat{
    XWSetInfo *_setInfo;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.userInteractionEnabled = YES;
        
        _setInfo = [XWSetInfo shareSetInfo];

        [self configureMigeImageView];

    }
    return self;
}

- (void)configureMigeImageView {
    UIImage *migeImg = [UIImage imageNamed:_setInfo.boxImgName];
    CGFloat width=235.0 * kFixed_rate ,height = 235.0 * kFixed_rate;

    self.migeImgView = [[UIImageView alloc] initWithImage:migeImg];
    self.migeImgView.userInteractionEnabled = YES;
    self.migeImgView.frame = CGRectMake(264/2 * kFixed_rate, 192/2 * kFixed_rate, width, height);
    [self addSubview:_migeImgView];


    self.fontCanvas = [[XWGestureCanvas alloc] initWithFrame:CGRectMake(0, 0, width-40, height-40) fontChar:@"啊"];
    self.fontCanvas.backgroundColor = [UIColor yellowColor];
    self.fontCanvas.center = CGPointMake(width/2, height/2);
    [self.migeImgView addSubview:self.fontCanvas];
}

@end
