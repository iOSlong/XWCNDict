//
//  XWGestureCanvas.m
//  XWCNDict
//
//  Created by xw.long on 16/6/22.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWGestureCanvas.h"


@implementation XWGestureCanvas

- (instancetype)initWithFrame:(CGRect)frame fontChar:(NSString *)fontChar {
    if (self = [super initWithFrame:frame]) {
        if (fontChar) {
            _fontChar = fontChar;
        }else{
            _fontChar = @"啊";
        }
        _setInfo = [XWSetInfo shareSetInfo];

        [self configureGestures];


        self.sinoFont = [[STSinoFont alloc] initWithChar:self.fontChar andSize:CGSizeMake(frame.size.width, frame.size.width) thousandeBase:NO];
        [self addSubview:self.sinoFont.imageCanvas];


        self.imgStatic =[self.sinoFont getBaseImageWithColor:[UIColor blackColor]];


        self.imgvBackground = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imgvBackground];

        [_setInfo.arrSinoFont addObject:self.sinoFont];
        self.sinoFont.volume = 0.5;
        self.sinoFont.voice = _setInfo.isVoice;

    }
    
    return self;
}

- (void)configureGestures {
    UITapGestureRecognizer *tapSingleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    tapSingleGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapSingleGesture];

    UITapGestureRecognizer *tapDoubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap:)];
    tapDoubleGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapDoubleGesture];

    [tapSingleGesture requireGestureRecognizerToFail:tapDoubleGesture];
}

- (void)gestureTap:(UITapGestureRecognizer *)tapG {
    NSLog(@"tap canvas %lu",(unsigned long)tapG.numberOfTapsRequired);
    switch (tapG.numberOfTapsRequired) {
        case 1:{
            self.imgvBackground.image = nil;

            if (self.sinoFont.drawing) {
                [self.sinoFont drawPause];
            }else if(self.sinoFont.drawOver == NO){
                [self.sinoFont drawContinue];
            }
            if (self.sinoFont.drawOver) {
                [self.sinoFont drawStar];
            }

            if ([self.delegate respondsToSelector:@selector(gestureCanvas:withEvent:)]) {
                [self.delegate gestureCanvas:self withEvent:XWCanvasEventSingleTap];
            }
        }
            break;
        case 2:{
            [self.sinoFont drawFinished];
            self.imgvBackground.image = self.imgStatic;

            if ([self.delegate respondsToSelector:@selector(gestureCanvas:withEvent:)]) {
                [self.delegate gestureCanvas:self withEvent:XWCanvasEventDoubleTap];
            }

        }
        default:
            break;
    }
}

- (void)setFontChar:(NSString *)fontChar {
    _fontChar = fontChar;
    if (fontChar) {

    }
}

- (void)reloadWithFontChar:(NSString *)fontChar {
    self.fontChar = fontChar;
    if (fontChar) {
        self.sinoFont.fontChar = fontChar;
        if (_setInfo.color_char) {
            self.imgStatic = [_sinoFont getBaseImageWithColor:_setInfo.color_char];
        }else{
            self.imgStatic =[_sinoFont getBaseImageWithColor:[UIColor blackColor]];
        }
        self.imgvBackground.image = self.imgStatic;
        self.sinoFont.imageCanvas.image = nil;

        UIImage *saveImg;
        if (_setInfo.color_radical) {
            saveImg = [_sinoFont getRadicalImageWithSize:CGSizeMake(100, 100) bottomColor:[UIColor colorWithRed:141.0/255 green:198.0/255 blue:228.0/255 alpha:1] radicalColor:_setInfo.color_radical];
            self.sinoFont.charColor = _setInfo.color_char;
            self.sinoFont.radicalColor = _setInfo.color_radical;

        }else{
            saveImg = [_sinoFont getRadicalImageWithSize:CGSizeMake(100, 100) bottomColor:[UIColor colorWithRed:141.0/255 green:198.0/255 blue:228.0/255 alpha:1] radicalColor:[UIColor colorWithRed:165.0/255 green:229.0/255 blue:133.0/255 alpha:1]];
            _setInfo.color_radical =[UIColor colorWithRed:165.0/255 green:229.0/255 blue:133.0/255 alpha:1];
        }

        if ([self.delegate respondsToSelector:@selector(gestureCanvas:withEvent:saveImg:)]) {
            [self.delegate gestureCanvas:self withEvent:XWCanvasEventReload saveImg:saveImg];
        }
        
    }
}


- (void)releaseSinoFont {
    if (self.sinoFont) {
        self.imgvBackground.image = nil;
        [self.sinoFont releaseSinoFont_AnimationInfo];
    }
}

@end
