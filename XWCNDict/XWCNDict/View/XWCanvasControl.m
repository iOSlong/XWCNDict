//
//  XWCanvasControl.m
//  XWCNDict
//
//  Created by xw.long on 16/6/25.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWCanvasControl.h"

@implementation XWCanvasControl


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


        [self addSubview:self.imgvBackground];

        [self configureGestures];

        [self.layer setContents:(id)[UIImage imageNamed:[XWSetInfo shareSetInfo].imgNameField].CGImage];
        
        
    }
    return self;
}

- (UIImageView *)imgvBackground
{
    if (!_imgvBackground)
    {
        _imgvBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width * 0.75, self.height * 0.75)];
        _imgvBackground.center = CGPointMake(self.width * 0.5, self.height * 0.5);
        _imgvBackground.userInteractionEnabled = YES;

    }
    return _imgvBackground;
}

- (STSinoFont *)sinoFont
{
    if (!_sinoFont)
    {
        _sinoFont = [[STSinoFont alloc] initWithChar:_fontChar andSize:self.imgvBackground.size thousandeBase:NO];
    }
    return _sinoFont;
}

- (void)setFontChar:(NSString *)fontChar
{
    if (fontChar)
    {
        _fontChar = fontChar;
        if (!_sinoFont) {
            [self.imgvBackground addSubview:self.sinoFont.imageCanvas];
        }
        self.sinoFont.fontChar = fontChar;
    }
}


- (void)configureGestures {
    UITapGestureRecognizer *tapSingleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    tapSingleGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapSingleGesture];

    UITapGestureRecognizer *tapDoubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    tapDoubleGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapDoubleGesture];

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
        
    }
}

- (void)gestureTap:(UITapGestureRecognizer *)tapG
{
    switch (tapG.numberOfTapsRequired) {
        case 1:
        {
            NSLog(@"tap One");
            _imgvBackground.image = nil;
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

-(void)showDeleteState
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.50f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //    [_delBtn setHidden:NO];

    //这个状态下，取消点击事件响应能力，停止正在绘制的效果。
    [_sinoFont drawPause];
    self.imgvBackground.userInteractionEnabled = NO;

    self.alpha = 0.5f;
    [UIView commitAnimations];

}

-(void)cancelDeleteState
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.50f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    //    [_delBtn setHidden:YES];
    self.imgvBackground.alpha = 1.0f;

    //回复可响应事件。
    self.imgvBackground.userInteractionEnabled = YES;

    [UIView commitAnimations];
}


+ (SizeContraints)innerSizeContraints
{
    SizeContraints sizeCon;

    sizeCon.canvasWidth = 341.0/2 * kFixed_rate;
    sizeCon.spanRow     = 32.0/2 * kFixed_rate;
    sizeCon.spanColumn  = 40.0/2 * kFixed_rate;
    sizeCon.spanLeft    = (kPlat_W - 3 * sizeCon.spanColumn - 4 * sizeCon.canvasWidth)/2;
    sizeCon.spanUp      = (kPlat_H - sizeCon.spanRow - 2 * sizeCon.canvasWidth)/2;

    return sizeCon;
}

@end
