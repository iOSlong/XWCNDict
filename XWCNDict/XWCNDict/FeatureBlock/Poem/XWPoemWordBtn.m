//
//  XWPoemWordBtn.m
//  XWCNDict
//
//  Created by xw.long on 16/7/4.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWPoemWordBtn.h"
#import "XWSetInfo.h"
#import "FontBitmapDraw.h"


@implementation XWPoemWordBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imgvCanvas = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imgvCanvas];

        UITapGestureRecognizer *longGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
        longGR.numberOfTapsRequired = 2;
        [self addGestureRecognizer:longGR];
    }
    return self;
}

-(void)tapPress:(UITapGestureRecognizer *)lpr
{

    [XWSetInfo shareSetInfo].fontCharShow = self.fontChar;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiNameCollection_JumpTo_CharacterVC object:nil];

}



#pragma mark STSinoFontDelegate
-(void)sinoFontDrawingFinished:(STSinoFont *)sinofont
{
    //    NSLog(@"overDraw pwb.tag = %d",(int)self.tag);
    if (self.notDelegate) {//default is NO
        self.notDelegate = NO;
        return;
    }else
        [_delegate poemWordDrawOver:self];
}


-(void)getStaticImage:(UIColor *)color
{
    [self.sinofont releaseSinoFont_AnimationInfo];
    self.sinofont.imageCanvas.image = [self.sinofont getBaseImageWithColor:color];
}


- (void)setFontChar:(NSString *)fontChar
{
    _fontChar = fontChar;
    if (!self.sinofont) {
        self.sinofont = [[STSinoFont alloc] initWithChar:fontChar andSize:CGSizeMake(self.frame.size.width, self.frame.size.height) thousandeBase:NO];
        int step  = (int)(self.drawSpeed/0.5);

        [self.sinofont drawSpeed:self.drawSpeed addSteplength:step];
        self.sinofont.delegate = self;

        [self addSubview:self.sinofont.imageCanvas];
        self.sinofont.imageCanvas.image = [self.sinofont getBaseImageWithColor:[UIColor blackColor]];
        self.sinofont.imageCanvas.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }else{
        self.sinofont.fontChar = fontChar;
        int step  = (int)(self.drawSpeed/0.5);
        [self.sinofont drawSpeed:self.drawSpeed addSteplength:step];
    }
}

- (void)getStaticImg:(UIColor *)color
{
    [self.sinofont releaseSinoFont_AnimationInfo];
    self.sinofont.imageCanvas.image = [self.sinofont getBaseImageWithColor:color];
}

- (void)getImgOfPunctuation
{
    UIFont *font = [UIFont fontWithName:@"STZhuankai" size:self.width];
    UIImage *image = [[FontBitmapDraw shareFontBitmapDraw] getImageFromString:self.fontChar withFont:font backgroundColor:[UIColor clearColor] foregroundColor:[UIColor blackColor]];
    self.imgvCanvas.image = image;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
