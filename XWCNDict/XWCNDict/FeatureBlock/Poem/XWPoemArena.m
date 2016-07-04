//
//  XWPoemArena.m
//  XWCNDict
//
//  Created by xw.long on 16/7/4.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWPoemArena.h"

@interface XWPoemArena ()<XWPoemwordBtnDelegate>
@property(nonatomic,retain)NSMutableArray *pwbMuArray;//存储初始化的PoemWordBtn对象，
@property(nonatomic,retain)NSMutableArray *pNameArr;
@property(nonatomic,retain)NSMutableArray *pAuthorArr;
@property(nonatomic,retain)NSMutableArray *pContentArr;

@property(nonatomic,retain)XWPoemWordBtn *pwb;

@end

#define kPWB_SpanX 15
#define kPWB_spanY 5
#define kAuthor_span 15 //作者名字里诗歌类容的位置

@implementation XWPoemArena
{
    NSArray *_pwbArray;//存储初始化的PoemWordBtn对象，

    CGFloat _pwb_w;//诗歌字的大小
    CGFloat _poet_w;//作者的字大小
    NSInteger _poemColumn;//诗的列数（诗的名字和作者个占一列）
    NSInteger _poemRow;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.pwbMuArray = [[NSMutableArray alloc] init];
        self.pNameArr = [[NSMutableArray alloc] init];
        self.pContentArr = [[NSMutableArray alloc] init];
        self.pAuthorArr = [[NSMutableArray alloc] init];
        self.playingOver = YES;
        self.playingPause = NO;
        self.canDelegate = YES;

    }
    return self;
}

- (void)setPoem:(XWPoem *)poem
{
    _poem = poem;

    //计算布局
    [self mathmaticPlayItemsWith:poem];

    [self displayPoemWordBtns];

}

- (void)mathmaticPlayItemsWith:(XWPoem *)poem
{
    self.pContentArr = (NSMutableArray *)[poem.pContent getCharArray];
    self.pNameArr = (NSMutableArray *)[poem.pName getCharArray];
    self.pAuthorArr = (NSMutableArray *)[poem.pAuthor getCharArray];

    _poemRow    = poem.pLineLenght;
    _poemColumn = [self.pContentArr count]/poem.pLineLenght + 2;
    if (self.pContentArr.count % poem.pLineLenght) {
        _poemColumn += 1;
    }
    _pwb_w      =(self.width-(_poemColumn+1)*kPWB_SpanX-kAuthor_span)/_poemColumn;

    self.frame = CGRectMake(self.x, self.y, self.width, _poemRow*(kPWB_spanY+_pwb_w));

}

- (void)displayPoemWordBtns
{
    for (XWPoemWordBtn *pwb in _pwbMuArray) {
        [pwb.sinofont releaseSinoFont_AnimationInfo];
        [pwb removeFromSuperview];
    }
    [self.pwbMuArray removeAllObjects];

    self.inReady = YES;

    //添加诗歌名字
    int tag_index = 0;
    self.drawSpeed = 0.5;
    for (int i=0; i<[self.pNameArr count]; i++) {
        XWPoemWordBtn *pwb = [[XWPoemWordBtn alloc] initWithFrame:CGRectMake(self.width-(kPWB_SpanX+_pwb_w), i*(_pwb_w-4+kPWB_spanY), _pwb_w-2, _pwb_w-2)];
        //        pwb.frame = CGRectMake(100, 100, 100, 100);
        pwb.delegate = self;
        pwb.drawSpeed = self.drawSpeed;
        pwb.fontChar = [self.pNameArr objectAtIndex:i];
        pwb.tag = tag_index;
        tag_index++;
        //        pwb.backgroundColor = [UIColor redColor];
        [pwb addTarget:self action:@selector(pwbBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        [self.pwbMuArray addObject:pwb];
        [self addSubview:pwb];
    }
    //添加诗歌作者名字
    for (int j=0; j<[self.pAuthorArr count]; j++) {
        _poet_w = _pwb_w*0.75;
        XWPoemWordBtn *pwb = [[XWPoemWordBtn alloc] initWithFrame:CGRectMake(self.width-2*(kPWB_SpanX+_pwb_w), j*(_pwb_w+kPWB_spanY), _poet_w, _poet_w)];
        pwb.center = CGPointMake(self.width-2*(kPWB_SpanX+_pwb_w)+_pwb_w*0.5, 3+_poet_w*0.5+j*(_poet_w+kPWB_spanY));
        pwb.delegate = self;
        pwb.drawSpeed = self.drawSpeed;
        pwb.fontChar = [self.pAuthorArr objectAtIndex:j];
        pwb.tag = tag_index;
        tag_index ++;
        //        pwb.backgroundColor = [UIColor redColor];
        [pwb addTarget:self action:@selector(pwbBtnClick:) forControlEvents:UIControlEventTouchUpInside];


        [self.pwbMuArray addObject:pwb];
        [self addSubview:pwb];
    }
    //添加诗歌类容
    for (int n=0; n<[self.pContentArr count]; n++) {
        XWPoemWordBtn *pwb = [[XWPoemWordBtn alloc] initWithFrame:CGRectMake(self.width-3*(kPWB_SpanX+_pwb_w)-n/_poemRow*(kPWB_SpanX+_pwb_w)-kAuthor_span, n%_poemRow*(_pwb_w+kPWB_spanY), _pwb_w, _pwb_w)];
        pwb.delegate = self;
        pwb.drawSpeed = self.drawSpeed;
        pwb.fontChar = [self.pContentArr objectAtIndex:n];
        pwb.tag = tag_index;
        tag_index ++;
        //        pwb.backgroundColor = [UIColor redColor];
        [pwb addTarget:self action:@selector(pwbBtnClick:) forControlEvents:UIControlEventTouchUpInside];


        [self.pwbMuArray addObject:pwb];
        [self addSubview:pwb];
    }

    self.pwb = [self.pwbMuArray objectAtIndex:0];
    self.haveReady = YES;
    if (self.delegate) {
        [self.delegate poemStageReadyPlaying:self];
    }
}

- (void)pwbBtnClick:(XWPoemWordBtn *)pwBtn
{
    pwBtn.notDelegate = YES;
    [pwBtn.sinofont drawStar];
}

#pragma mark - XWPoemwordBtnDelegate

- (void)poemWordDrawOver:(XWPoemWordBtn *)pBtn
{
    if (NO ==self.canDelegate) {
        return;
    }

    if (pBtn.tag >= [self.pwbMuArray count]-1) {
        self.playingOver = YES;
        [self.delegate poemStagePlayingOver:self];
        return;
    }
    self.playingOver = NO;
    self.playingPause = NO;
    XWPoemWordBtn *pWB =   [self.pwbMuArray objectAtIndex:pBtn.tag+1];
    self.pwb = pWB;
    [self performSelector:@selector(pwbGetDrawStar) withObject:nil afterDelay:0.1];
}

- (void)pwbGetDrawStar
{
    if (self.pwb.sinofont) {
        [self.pwb.sinofont drawStar];
    }else{
        [self.pwb getImgOfPunctuation];
        [self poemWordDrawOver:self.pwb];
    }
}



#pragma mark - SetDrawConfigure

-(void)setDrawSpeed:(float)drawSpeed
{
    _drawSpeed = drawSpeed;
    //    if (_drawSpeed>9.5) {
    //        _drawSpeed = 9.5;
    //    }
    for (XWPoemWordBtn *pwb in self.pwbMuArray) {
        [pwb.sinofont drawSpeed:drawSpeed addSteplength:0];
    }
}

-(void)setVolume:(float)volume
{
    _volume = volume;

    for (XWPoemWordBtn *pwb in self.pwbMuArray) {
        pwb.sinofont.volume = volume;
    }
}

-(void)setStrokeSound:(BOOL)strokeSound
{
    _strokeSound = strokeSound;

    for (XWPoemWordBtn *pwb in self.pwbMuArray) {
        pwb.sinofont.voice = strokeSound;
    }
}

-(void)setCharColor:(UIColor *)charColor
{
    _charColor = charColor;

    for (XWPoemWordBtn *pwb in self.pwbMuArray) {
        pwb.sinofont.charColor = charColor;
    }
}

#pragma mark interface method
-(void)poemStageGetStaticView:(UIColor *)color
{
    [self poemStagPause];
    for (XWPoemWordBtn *pwb in self.pwbMuArray) {
        [pwb getStaticImg:color];
    }
}

-(void)poemStageActive
{
    for (XWPoemWordBtn *pwb in self.pwbMuArray) {
        pwb.sinofont.imageCanvas.image = nil;
        [pwb.sinofont releaseSinoFont_AnimationInfo];
    }
    XWPoemWordBtn *pwb = [self.pwbMuArray objectAtIndex:0];
    [pwb.sinofont drawStar];
}
-(void)poemStagPause
{
    //    [self.pwb.sinofont drawPause];
    for (XWPoemWordBtn *pwb in self.pwbMuArray) {
        [pwb.sinofont drawPause];
    }
    self.playingPause = YES;
}

-(void)poemStagContinue
{
    [self.pwb.sinofont drawContinue];
    if (self.pwb.sinofont.drawOver) {
        self.pwb = [self.pwbMuArray objectAtIndex:([self.pwbMuArray count]>self.pwb.tag+1 ? self.pwb.tag+1 :self.pwb.tag)];
        [self.pwb.sinofont drawStar];
    }
    self.playingPause = NO;
}



@end
