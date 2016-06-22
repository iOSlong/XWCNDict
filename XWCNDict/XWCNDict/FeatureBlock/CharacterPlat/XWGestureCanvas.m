//
//  XWGestureCanvas.m
//  XWCNDict
//
//  Created by xw.long on 16/6/22.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWGestureCanvas.h"
#import "STSinoFont.h"

@interface XWGestureCanvas ()
@property (nonatomic, strong) STSinoFont    *sinoFont;
@property (nonatomic, strong) UIImage       *imgStatic;
@property (nonatomic, strong) UIImageView   *imgvBackground;
@end

@implementation XWGestureCanvas

- (instancetype)initWithFrame:(CGRect)frame fontChar:(NSString *)fontChar {
    if (self = [super initWithFrame:frame]) {
        if (fontChar) {
            _fontChar = fontChar;
        }else{
            _fontChar = @"啊";
        }

        [self configureGestures];


        self.sinoFont = [[STSinoFont alloc] initWithChar:self.fontChar andSize:CGSizeMake(frame.size.width, frame.size.width) thousandeBase:NO];
        [self addSubview:self.sinoFont.imageCanvas];


        self.imgStatic =[self.sinoFont getBaseImageWithColor:[UIColor blackColor]];


        self.imgvBackground = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imgvBackground];

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

@end
