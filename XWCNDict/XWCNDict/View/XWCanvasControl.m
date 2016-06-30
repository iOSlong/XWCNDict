//
//  XWCanvasControl.m
//  XWCNDict
//
//  Created by xw.long on 16/6/25.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWCanvasControl.h"

@implementation XWCanvasControl

#define del_w   (40 * kFixed_rate)
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


        [self addSubview:self.imgvBackground];
        [self.imgvBackground.layer setContents:(id)[UIImage imageNamed:[XWSetInfo shareSetInfo].imgNameField].CGImage];

        [self.imgvBackground addSubview:self.imgvDynamicView];
        [self configureGestures];


        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 5;
        self.layer.shadowColor  = [UIColor redColor].CGColor;

        [self addDelImageView];
        
    }
    return self;
}


- (UIImageView *)imgvBackground
{
    if (!_imgvBackground)
    {
        _imgvBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, del_w * 0.5, self.width - del_w * 0.5, self.height - del_w * 0.5)];
        _imgvBackground.userInteractionEnabled = YES;

    }
    return _imgvBackground;
}

- (UIImageView *)imgvDynamicView
{
    if (!_imgvDynamicView) {
        _imgvDynamicView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width * 0.7, self.height * 0.7)];
        _imgvDynamicView.center = CGPointMake(_imgvBackground.width * 0.5, _imgvBackground.height *0.5);
        _imgvDynamicView.userInteractionEnabled = YES;
    }
    return _imgvDynamicView;
}

- (STSinoFont *)sinoFont
{
    if (!_sinoFont)
    {
        _sinoFont = [[STSinoFont alloc] initWithChar:_fontChar andSize:self.imgvDynamicView.size thousandeBase:NO];
    }
    return _sinoFont;
}

- (void)setFontChar:(NSString *)fontChar
{
    if (fontChar)
    {
        _fontChar = fontChar;
        if (!_sinoFont) {
            [self.imgvDynamicView addSubview:self.sinoFont.imageCanvas];
        }
        self.sinoFont.fontChar = fontChar;
    }
}

- (void)addDelImageView
{
    _delBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - del_w , 0, del_w, del_w)];
    [_delBtn setBackgroundImage:[UIImage imageNamed:@"collection_del.png"] forState:UIControlStateNormal];
    [_delBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    CGPathRef shadow = CGPathCreateWithRoundedRect(CGRectMake(0, 5, del_w, del_w), del_w*0.5, del_w*0.5, NULL);
    [_delBtn.layer setShadowPath:shadow];
    [_delBtn.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [_delBtn.layer setShadowOpacity:0.5f];
    CFRelease(shadow);
    [_delBtn setHidden:YES];
    [self addSubview:_delBtn];
}

- (void)deleteBtnClick:(UIButton *)btn
{
    [_sinoFont releaseSinoFont_AnimationInfo];

    [self.delegate canvasControl:self event:XWCanvasControlEventDeleteChar];
}


- (void)configureGestures {
    UITapGestureRecognizer *tapSingleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    tapSingleGesture.numberOfTapsRequired = 1;
    [self.imgvDynamicView addGestureRecognizer:tapSingleGesture];

    UITapGestureRecognizer *tapDoubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    tapDoubleGesture.numberOfTapsRequired = 2;
    [self.imgvDynamicView addGestureRecognizer:tapDoubleGesture];

    [tapSingleGesture requireGestureRecognizerToFail:tapDoubleGesture];


    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTap:)];
    [self addGestureRecognizer:longGesture];
}



- (void)longPressTap:(UILongPressGestureRecognizer *)longPG
{
    /// 添加状态枚举，确保长按手势将不会调用两次，
    if (longPG.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long Press");

        [self showDeleteState];
        if (self.CanvasBlock) {
            self.CanvasBlock (self, XWCanvasControlEventDeleteChar);
        }
    }
}

- (void)gestureTap:(UITapGestureRecognizer *)tapG
{
    switch (tapG.numberOfTapsRequired) {
        case 1:
        {
            NSLog(@"tap One");
            _imgvDynamicView.image = nil;
            if (_sinoFont.drawing) {
                [_sinoFont drawPause];
            }else{
                [_sinoFont drawContinue];
            }
            if (_sinoFont.drawOver) {
                [_sinoFont drawStar];
            }
        }
            break;
        case 2:
        {
            NSLog(@"tap Two: %@",self.fontChar);
            if (_sinoFont.drawing) {
                [_sinoFont drawPause];
            }

            [XWSetInfo shareSetInfo].fontCharShow = self.fontChar;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotiNameCollection_JumpTo_CharacterVC object:nil];

        }

        default:
            break;
    }
}

- (void)showDeleteState
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.30f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];

    [self.delBtn setHidden:NO];
    //这个状态下，取消点击事件响应能力，停止正在绘制的效果。
    [_sinoFont drawPause];
    self.imgvBackground.userInteractionEnabled = NO;
    self.imgvBackground.alpha = 0.5f;

    [UIView commitAnimations];

}

- (void)cancelDeleteState
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.30f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];

    [self.delBtn setHidden:YES];
    self.imgvBackground.alpha = 1.0f;

    //回复可响应事件。
    self.imgvBackground.userInteractionEnabled = YES;

    [UIView commitAnimations];
}

- (void)setDelState:(BOOL)delState
{
    _delState = delState;
    if (delState) {
        [self showDeleteState];
    }else{
        [self cancelDeleteState];
    }
}


+ (SizeContraints)innerSizeContraints
{
    SizeContraints sizeCon;

    sizeCon.canvasWidth = 341.0/2 * kFixed_rate;
    sizeCon.spanRow     = 28.0/2 * kFixed_rate;
    sizeCon.spanColumn  = 36.0/2 * kFixed_rate;
    sizeCon.spanLeft    = (kPlat_W - 3 * sizeCon.spanColumn - 4 * sizeCon.canvasWidth)/2;
    sizeCon.spanUp      = (kPlat_H - sizeCon.spanRow - 2 * sizeCon.canvasWidth)/2 - 10 * kFixed_rate;

    return sizeCon;
}

@end
