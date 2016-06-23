//
//  STSinoFont.m
//  STSinoFont_0527
//
//  Created by imac_06 on 14-5-27.
//  Copyright (c) 2014年 xuewu. All rights reserved.
//

#import "STSinoFont.h"
#import "BmpDataManager.h"
#import "FontBitmapDraw.h"
#import <AVFoundation/AVFoundation.h>


@interface STSinoFont ()

-(unsigned int)getUnicodeCodeFromFont:(NSString *)font;

-(BOOL)getInitProperties;



//those methods are all about Animation Drawing
-(void)timerEventRunloop;

-(void)timerMakeDelaybyStroke;

-(void)call_backCharFontAnimation:(STAnimationInfo *)ConInfo;

-(void) STInitAnimationInfo:(UINT) code  andWithWidth:(int)w  andWithHeight:(int) h andWithFontFile:(NSString*) fontfile andWithMapFile:(NSString*) mappingfile andWithInfo:(STAnimationInfo *)animationInfo;

- (NSRange )getStrokeRangeByIndex:(NSInteger )index;

- (void)resetBitmap:(STAnimationInfo *)pInfo withIndex:(int)sectIndex;

- (void) STUpdateDrawBufwithInfo:(STAnimationInfo*) pInfo isDrawing:( bool) bDraw withOriginX:(int) x withOringinY:(int) y withWidth:(int) w withHeight:(int) h;

- (void) STUpdateDrawBufOneIndexWithInfo:(STAnimationInfo*) pInfo isDrawing:( bool) bDraw withOriginX:(int) x withOringinY:(int) y withWidth:(int) w withHeight:(int) h;

-(UIImage *) STAnimationDraw:(STAnimationInfo* )pInfo;

void STFreeAnimationInfo(STAnimationInfo* animationInfo);

@end

@implementation STSinoFont
{
    FontBitmapDraw *_FBD;
    BmpDataManager *_BDM;
    
    NSTimer *_timer;
    STAnimationInfo _tempInfo;
    double _defultSpeed;            //取得动画笔画对应绘制速度默认值。
    BOOL newStroke;                 // 发音时  用于判断是否是新的笔画
    AVAudioPlayer *_player;

    NSRange strokeRange;        //绘制笔画的笔画段索引及数量
    BOOL drawStrokeOne;
    
    
}

-(unsigned int)getUnicodeCodeFromFont:(NSString *)font{
    const char *character = [font cStringUsingEncoding:NSUnicodeStringEncoding];
    
    unsigned int *unicode = (unsigned int *)character;
    return *unicode;
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@" \\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString * returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListMutableContainers format:NULL error:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}


#pragma mark - init method part

-(id)initWithChar:(NSString *)fontChar andSize:(CGSize)fontSize thousandeBase:(BOOL)thousandBase
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *stroke_font = [mainBundle pathForResource:@"stroke_font" ofType:@"dat"];
    NSString *codeMapping = [mainBundle pathForResource:@"CodeMapping" ofType:@"dat"];

//    stroke_font = @"/Users/longxuewu/Desktop/myGitHub/XWCNDict/XWCNDict/XWCNDict/SinoFont/stroke_font.dat";
//    codeMapping = @"/Users/longxuewu/Desktop/myGitHub/XWCNDict/XWCNDict/XWCNDict/SinoFont/CodeMapping.dat";

    const char *fontfile = [stroke_font UTF8String];
    const char *mapfile = [codeMapping UTF8String];

    self = [self initWithChar:fontChar andSize:fontSize strokeWithCodePath:fontfile :mapfile :thousandBase];
    
    return self;
}



-(id)initWithChar:(NSString *)fontChar andSize:(CGSize)fontSize strokeWithCodePath:(const char *)strokefont :(const char *)codemapping :(BOOL)thousandBase
{
    self = [super init];
    if (self) {
        _FBD = [FontBitmapDraw shareFontBitmapDraw];
        _BDM = [BmpDataManager shareBmpDataManager];
        
        _fontChar = fontChar;
        _charCode = [self getUnicodeCodeFromFont:fontChar];
        self.size = CGSizeMake(fontSize.width, fontSize.height);
        _stroke_font_dat = [NSString stringWithUTF8String:strokefont];
        _codemapping_dat = [NSString stringWithUTF8String:codemapping];
        _thousandBase = thousandBase;
        self.volume = 0.5;
        self.voice = NO;
        _drawOver = YES;
        _drawing = NO;
        if (!_drawingSpeed) {
            self.drawingSpeed = 0.5;
        }
        
        self.imageCanvas = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fontSize.width, fontSize.height)];
        
        if (![self getInitProperties]) {
            return 0;
        }//注意初始化之后，判断一下是否成功的初始化了，比如字符不成再，初始化失败得到返回对象为nil
//        NSAssert([self getInitProperties], @"init method Struct STCharStrokes get faild");

    }
    return self;
}

//通过读取字库信息，得到字符的笔画信息，
-(BOOL)getInitProperties;
{
    STCharStrokes *cStrokes;
    
    cStrokes = STGetCharStrokes(_charCode, _size.width, _size.height, [_stroke_font_dat UTF8String], [_codemapping_dat UTF8String],_thousandBase);
    /*获取字符失败——DoNothing*/
    if (cStrokes->num==0)
        return NO;
    
    
    _Num = cStrokes->num;
    _strokeNum = cStrokes->strokeNum;
    
    STDestoryCharStrokes(&(cStrokes));
    
    return YES;
}

#pragma mark - reWrite Set method part
//改变对象的初始化字符信息，
-(void)setFontChar:(NSString *)fontChar
{
    if (![_fontChar isEqualToString:fontChar]) {
        _fontChar = fontChar;
        _charCode = [self getUnicodeCodeFromFont:fontChar];
        
        [self getInitProperties];
    }
}
//改变笔画绘制数度
-(void)setDrawingSpeed:(float)drawingSpeed
{
    _drawingSpeed = drawingSpeed;
    
    [self drawSpeed:drawingSpeed addSteplength:self.addSteplength];
    
}
//改变字符的大小
-(void)setSize:(CGSize)size
{
    _size = CGSizeMake(size.width, size.height);
    self.imageCanvas.frame = CGRectMake(0, 0, _size.width, _size.height);
}



#pragma mark - Get Image Part -
//获取指定颜色 完整的字符图片对象，完整字符图片
-(UIImage *)getBaseImageWithColor:(UIColor *)color
{
    UIImage *image;
    if (!color) {
        color = [UIColor blackColor];
    }
    if (self.charColor==nil)
    {
        self.charColor = color;
    }
    
    STCharStrokes *pStrokes = STGetCharStrokes(self.charCode, _size.width, _size.height, [_stroke_font_dat UTF8String], [_codemapping_dat UTF8String], _thousandBase);
    

    
    void *data = [_BDM getBitmapDataThrough:pStrokes WithColor:color];
//
    image = [_FBD fontBitmapDrawWithData:data Width:self.size.width Height:self.size.height];
    
    STDestoryCharStrokes(&pStrokes);
    
    return image;
}

//获取指定颜色 字符对应的部首图片对象，单独部首图片
-(UIImage *)getRadicalImageWithSize:(CGSize )size andColor:(UIColor *)color;
{
    UIImage *image;
    if (size.height==0||size.width==0) {
        size = self.size;
    }
    
    STCharStrokes *_rStrokes = STGetCharStrokes(self.charCode, size.width, size.height, [self.stroke_font_dat UTF8String], [self.codemapping_dat UTF8String], _thousandBase);
    
    NSAssert(_rStrokes->num, @"Struct STCharStrokes get faild");
    
    void *data = [_BDM getBitmapDataFrom:_rStrokes onlyRadical:YES withColor:color];
    
    
    image = [_FBD fontBitmapDrawWithData:data Width:size.width Height:size.height];
    
    STDestoryCharStrokes(&(_rStrokes));
    
    return image;
    
}
//获取部首上色，并且包括除去部首笔画部分，可以颜色区分，完整字符图片
-(UIImage *)getRadicalImageWithSize:(CGSize)size bottomColor:(UIColor *)bColor radicalColor:(UIColor *)rColor;
{
    UIImage *image;
    if (size.height==0||size.width==0) {
        size = self.size;
    }
    
    STCharStrokes *_rStrokes = STGetCharStrokes(self.charCode, size.width, size.height, [self.stroke_font_dat UTF8String], [self.codemapping_dat UTF8String], _thousandBase);
    
    NSAssert(_rStrokes->num, @"Struct STCharStrokes get faild");
    
    void *data = [_BDM getBitmapDataThrough:_rStrokes bottomColor:bColor radicalColor:rColor];
    
    
    image = [_FBD fontBitmapDrawWithData:data Width:size.width Height:size.height];
    
    STDestoryCharStrokes(&(_rStrokes));
    
    return image;
//
}
//获取指定的笔画图片对象，单独的一个笔画。
-(UIImage *)getStrokeImageWithSize:(CGSize )size andColor:(UIColor *)color atIndex:(NSInteger )index;
{
    UIImage *image;
    if (size.height==0||size.width==0) {
        size = self.size;
    }
    
    STCharStrokes *iStrokes = STGetCharStrokes(self.charCode, size.width, size.height, [self.stroke_font_dat UTF8String], [self.codemapping_dat UTF8String], _thousandBase);
    
    NSAssert(iStrokes->num, @"Struct STCharStrokes get faild");
    
    if (index >iStrokes->strokeNum) {
        return 0;
    }
    
    void *data = [_BDM getBitmapDataThrough:iStrokes withContinue:NO andIndex:index withColor:color];
    
    
    image = [_FBD fontBitmapDrawWithData:data Width:size.width Height:size.height];
    
    STDestoryCharStrokes(&(iStrokes));
    
    return image;
}
//获取指定颜色 字符所有笔画的图片对象的数组,[image1,image2,image3,~]，所有单独笔画图片的数组。
-(NSArray *)getStrokesImageArrayWithSize:(CGSize)size andColor:(UIColor *)color strokeTogether:(BOOL )together;
{
    if (size.height==0||size.width==0) {
        size = self.size;
    }
    
    NSMutableArray *strokesImgArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    STCharStrokes *tempStrokes = STGetCharStrokes(self.charCode, size.width, size.height, [self.stroke_font_dat UTF8String], [self.codemapping_dat UTF8String],_thousandBase);
    NSAssert(tempStrokes->num, @"Struct STCharStrokes get faild");
    
    UIImage *image = nil;
    for (int i=1; i<=tempStrokes->strokeNum; i++)
    {
        void *data = [_BDM getBitmapDataThrough:tempStrokes withContinue:together andIndex:i withColor:color];
        
        image = [_FBD fontBitmapDrawWithData:data Width:size.width Height:size.height];
        
        [strokesImgArr addObject:image];
    }
    STDestoryCharStrokes(&tempStrokes);
    return strokesImgArr;
}


/*获取指定基础颜色，连续部首颜色的图片对象的数组(默认frontColor--black，bottomColor--lightGray)
 得到绘制到每一个笔画阶段的字符图片数组。最后一张为完整的字符图片。
 */
-(NSArray *)getStrokesContinueImageArrayWithSize:(CGSize)size bottomColor:(UIColor *)bColor frontColor:(UIColor *)fColor;
{
    if (size.height==0||size.width==0) {
        size = self.size;
    }
    
    if (!fColor)
        fColor = [UIColor blackColor];
    if (!bColor)
        bColor = [UIColor lightGrayColor];
    
    NSMutableArray *strokesImgArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    STCharStrokes *tempStrokes = STGetCharStrokes(self.charCode, size.width, size.height, [self.stroke_font_dat UTF8String], [self.codemapping_dat UTF8String],_thousandBase);
    
    strokesImgArr = (NSMutableArray *)[_BDM fontStaticShowWithData:tempStrokes bottomColor:bColor frontColor:fColor];

    STDestoryCharStrokes(&tempStrokes);
    return strokesImgArr;

}

/*获取指定基础颜色，不连续笔画的图片对象的数组：(默认frontColor--black，bottomColor--lightGray)
 得到每一个笔画与除去笔画部分，以颜色区分，为完整字符图片。
 */
-(NSArray *)getStrokeOnlyImageArrayWithSize:(CGSize)size bottomColor:(UIColor *)bColor frontColor:(UIColor *)fColor;
{
    if (size.height==0||size.width==0) {
        size = self.size;
    }
    
    if (!bColor)
        bColor = [UIColor blackColor];
    if (!fColor)
        fColor = [UIColor lightGrayColor];
    
    STCharStrokes *tempStrokes = STGetCharStrokes(self.charCode, size.width, size.height, [self.stroke_font_dat UTF8String], [self.codemapping_dat UTF8String],_thousandBase);
    
    NSMutableArray *strokesImgArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    UIImage *image = nil;
    for (int i=1; i<=tempStrokes->strokeNum; i++)
    {
        void *data = [_BDM getBitmapDataThrough:tempStrokes bottomColor:bColor frontColor:fColor inIndex:i];
        
        image = [_FBD fontBitmapDrawWithData:data Width:size.width Height:size.height];
        
        [strokesImgArr addObject:image];
    }
    
    STDestoryCharStrokes(&tempStrokes);
    
    return strokesImgArr;

}

#pragma mark - Animation Part

#pragma mark 《启动绘制》
-(void)drawStar{
    
    //有时候，一个字符还没有完成绘制，如果要从头绘制，直接调用这个方法，需要将原有的_tempInfo释放掉，
    STFreeAnimationInfo(&(_tempInfo));
//    self.imageCanvas.image = nil;
    [_timer invalidate];
    _timer = nil;
    
    [self STInitAnimationInfo:self.charCode andWithWidth:_size.width andWithHeight:_size.height andWithFontFile:self.stroke_font_dat andWithMapFile:self.codemapping_dat andWithInfo:&_tempInfo];
    
    drawStrokeOne = NO;//设置这个不是单独绘制一个笔画。
    
    if (!_drawingSpeed) {
//        self.drawingSpeed = 0.5;
    }
    
    //如果计时器为空 启动一新的计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.drawingSpeed target:self selector:@selector(timerEventRunloop) userInfo:nil repeats:YES];

    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    

    _tempInfo.nCurState = 1;
    
    [_timer fire];
    _drawing = YES;
    _drawOver = NO;
}

#pragma mark 《暂停绘制》
-(void)drawPause
{
    if (_timer)
        [_timer setFireDate:[NSDate distantFuture]];
    _drawing = NO;
}
#pragma mark 《绘制 暂停+继续 》
-(void)drawContinue
{
    if (_timer)
        [_timer setFireDate:[NSDate distantPast]];
    _drawing = YES;
}

-(void)drawFinished{
    STFreeAnimationInfo(&(_tempInfo));
    [_timer invalidate];
    _timer = nil;
    self.imageCanvas.image = nil;
    _drawing = NO;
    _drawOver = YES;
}

#pragma mark 《绘制速度调节》
-(void)drawSpeed:(float)speed addSteplength:(int)leng;
{
    /*  drawSpeed（0~1）《==》multiple（0~100）*/
    int multiple = speed/0.01;//test~分成100个速度
    double bigsideStep;//速度变化的梯度
    
    if (leng>0)//绘制步长不能是小于0的数，这里需要判断一下。
    _addSteplength = leng;//这个是绘制步长的增量，默认步长是1，迷人步长增量leng是0。
    
    if (_timer)//绘制过程中设置生效
    {
        //这里处理速度的方法是,将下面的_defaultSpeed(代表了默认的定时器调用时间间隔)将它分成50份，
        _defultSpeed =0.001*_tempInfo.pStrokes->pStrokeSects[_tempInfo.nCurSectIndex].animationTime*_tempInfo.nSpeed/nSpeedBase;
        //        printf("defultSpeed:%2.5f\n",_defultSpeed);
        
        bigsideStep = _defultSpeed/50;
        //_defultSpeed是默认的速度，让它以自己的五十分之一的梯度增加或减小得到速度变化的效果。梯度变化的倍数由给定speed决定。
        if (speed>=0.5) {
            _drawingSpeed = _defultSpeed-(multiple-50)*bigsideStep;
        }else{
            _drawingSpeed = _defultSpeed+(50-multiple)*bigsideStep;
        }
        
    }else//绘制结束后设置生效。0.003s是字符第一笔的绘制速度
    {
        bigsideStep = 0.03/50;
        if (speed>=0.5) {
            _drawingSpeed = 0.03-(multiple-50)*bigsideStep;
        }else{
            _drawingSpeed = 0.03+(50-multiple)*bigsideStep;
        }
    }
    
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
        _timer = [NSTimer scheduledTimerWithTimeInterval:_drawingSpeed target:self selector:@selector(timerEventRunloop) userInfo:nil repeats:YES];
        
        if (self.drawing) {
            [_timer setFireDate:[NSDate distantPast]];
        }else{
            [_timer setFireDate:[NSDate distantFuture]];
        }
    }
}


#pragma mark  开启avaudio 读部首发音 的函数
- (void)readStroke:(STStrokeSect *)strokeSect withCurrentStroke:(int)currenStroke
{
    
    NSString *read = [NSString stringWithFormat:@"%d_%d",strokeSect[currenStroke].strokeType1,strokeSect[currenStroke].strokeType2];
//    NSLog(@"%@",read);
    
    NSString *path = [[NSBundle mainBundle]pathForResource:read ofType:@"wav"];
    if (!path) {
        return;
    }
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _player.volume = self.volume;
    [_player prepareToPlay];
    
    [_player play];
    newStroke = NO;
}

#pragma mark 《单独绘制一个指定索引的笔画》
-(void)drawStar_StrokeIndex:(NSInteger )index;
{
//    STFreeAnimationInfo(&(_tempInfo));
    [_timer invalidate];
    _timer = nil;
    
    [self STInitAnimationInfo:self.charCode andWithWidth:_size.width andWithHeight:_size.height andWithFontFile:self.stroke_font_dat andWithMapFile:self.codemapping_dat andWithInfo:&_tempInfo];
    
    strokeRange = [self getStrokeRangeByIndex:index];
    
    _tempInfo.nCurState = 1;
    _tempInfo.nCurSectIndex = strokeRange.location;
    drawStrokeOne = YES;//这个参数是判断选择的关键点，调用这个函数时候为yes，其他时候为NO。
    
//    if (!self.drawingSpeed) {
//        self.drawingSpeed = 0.5;
//    }
    
    //如果计时器为空 启动一新的计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.drawingSpeed target:self selector:@selector(timerEventRunloop) userInfo:nil repeats:YES];

    [_timer fire];
    _drawing = YES;
}
//根据笔画值 得到笔画段值(index最小为1)
- (NSRange )getStrokeRangeByIndex:(NSInteger )index{
    NSRange range;
    if (index==0) {
        range.location = 0;
    }
    int location_head = 0;
    int location_tail = 0;
    int strokeNum =0;
    int num;
    
    STStrokeSect *strokeSect = _tempInfo.pStrokes->pStrokeSects;
    for ( num=0; num<_tempInfo.pStrokes->num; num++)
    {
        if (strokeSect[num].strokeType1)
        {
            strokeNum ++;
            if (strokeNum==index+1)
            {
                range.location = location_head;
                range.length = location_tail - location_head;
                break;
            }
            location_head = location_tail;
        }
        location_tail ++;
    }
    if (num==_tempInfo.pStrokes->num) {
        range.location = location_head;
        range.length = location_tail - location_head;
    }
//    printf("location:%d,\tlength:%d\n",range.location,range.length);
    return range;
}
//定时器启动，每次调用这个函数触发绘制函数的调用。
-(void)timerEventRunloop
{
    [self call_backCharFontAnimation:&_tempInfo];
}
//动画绘制的函数。
-(void)call_backCharFontAnimation:(STAnimationInfo *)ConInfo{
    
    
    STAnimationInfo* pInfo = ConInfo;
    STCharStrokes* pStrokes=pInfo->pStrokes;
    
    
    if (pInfo->nCurSectIndex>=pStrokes->num || pInfo->nCurState==0||pInfo->nCurState==2)
    {
        [_timer invalidate];
        _timer = nil;
        _drawing = NO;
        _drawOver = YES;
        STFreeAnimationInfo(pInfo);
        
        if (drawStrokeOne==YES) {//如果是绘制单独的笔画，通产会在这个地方结束绘制。
            if ([self.delegate respondsToSelector:@selector(sinoFontDrawingFinished:)]) {
                [self.delegate sinoFontDrawingFinished:self];
            }
        }
        return;
    }
    
    int nCurSectIndex=pInfo->nCurSectIndex;
    bool bDraw=false;
    STStrokeSect *pStrokeSect=pStrokes->pStrokeSects;
    
    
#pragma mark 一段绘制判断的宏代码，
    
    int step=pStrokeSect[nCurSectIndex].animationStep+self.addSteplength;
    
    int x = 0,y = 0,w = 0,h = 0;
    int strokeW=abs(pStrokeSect[nCurSectIndex].endX-pStrokeSect[nCurSectIndex].startX)+1;
    int strokeH=abs(pStrokeSect[nCurSectIndex].endY-pStrokeSect[nCurSectIndex].startY)+1;

    directionCase

#pragma mark isDraw
    
    if (bDraw)
    {
      
        if (self.voice) {
            if (newStroke) {
                //调用发音方法
                [self readStroke:pStrokeSect withCurrentStroke:nCurSectIndex];
            }
        }
        if (drawStrokeOne) {
            [self STUpdateDrawBufOneIndexWithInfo:pInfo isDrawing:bDraw withOriginX:x withOringinY:y withWidth:w withHeight:h];
        }else
            [self STUpdateDrawBufwithInfo:pInfo isDrawing:bDraw withOriginX:x withOringinY:y withWidth:w withHeight:h];
        [self STAnimationDraw:pInfo];
        
    }
    else
    {
        if (drawStrokeOne) {
            [self STUpdateDrawBufOneIndexWithInfo:pInfo isDrawing:bDraw withOriginX:x withOringinY:y withWidth:w withHeight:h];
        }else
            [self STUpdateDrawBufwithInfo:pInfo isDrawing:bDraw withOriginX:0 withOringinY:0 withWidth:0 withHeight:0];
        [self STAnimationDraw:pInfo];
        
        if (pInfo->pStrokes->pStrokeSects[nCurSectIndex+1].strokeType1!=0)
        {
            CGFloat playingtime =_player.duration-_player.currentTime;  //音频所需要时间
            if (_player.isPlaying&&self.voice) {
                [_timer setFireDate:[NSDate distantFuture]];
                _drawing = NO;
                [self performSelector:@selector(timerMakeDelaybyStroke) withObject:self afterDelay:playingtime];
            }
            else if (self.strokePause)
            {
                if (self.strokePauseTime==0)
                    self.strokePauseTime = 0.001*_tempInfo.pStrokes->pStrokeSects[0].stopTime*10*_tempInfo.nSpeed/nSpeedBase;
                
                [_timer setFireDate:[NSDate distantFuture]];
                _drawing = NO;
                [self performSelector:@selector(timerMakeDelaybyStroke) withObject:self afterDelay:self.strokePauseTime];
            }
        }
        
        newStroke = YES;
        
        
        if (pInfo->nCurState!=0)
        {
            nCurSectIndex++;
            pInfo->nCurSectIndex=nCurSectIndex;
            if (nCurSectIndex<pStrokes->num)
            {
                
                if (pInfo->nCurSectIndex == strokeRange.location+strokeRange.length&&drawStrokeOne) {
                    pInfo->nCurState = 2;
                }
            }
            else
            {
                [_timer invalidate];
                _timer = nil;
                _drawing = NO;
                _drawOver = YES;
                
                /*绘制结束将无用资源释放*/
                STFreeAnimationInfo(pInfo);
                
                if ([self.delegate respondsToSelector:@selector(sinoFontDrawingFinished:)]) {
                    [_delegate sinoFontDrawingFinished:self];
                }//这个函数是一个可选的代理函数。如果在绘制结束的时候需要传递信息，可以使用这个函数。
            }
        }
    }
//    printf("timer");
}

//重新启动定时器，这个函数在设置了需要按笔画暂停的绘制过程中得到调用。启动被暂停了的绘制定时器。
-(void)timerMakeDelaybyStroke
{
    [_timer setFireDate:[NSDate distantPast]];
    _drawing = YES;
}

//将_indexOfDrawingStroke 与 当前笔画 数据组合，这个组织绘制一个指定笔画的数据。
- (void)resetBitmap:(STAnimationInfo *)pInfo withIndex:(int)sectIndex{
    
    for (int index = strokeRange.location; index <=sectIndex; index++) {
        
        for (int i = 0; i<pInfo->pStrokes->h; i++) {
            for (int j =0 ; j<pInfo->pStrokes->w; j++) {
                
                int value = i*pInfo->pStrokes->h+j;
                
                pInfo->pDrawBuf[value] = MIN((pInfo->pStrokes->pStrokeSectBmp[index][value]+ pInfo->pDrawBuf[value]),16);
            }
        }
    }
}
////更新位图数据1 组织更新绘制完整的字符所有笔画的信息数据。
- (void) STUpdateDrawBufwithInfo:(STAnimationInfo*) pInfo isDrawing:( bool) bDraw withOriginX:(int) x withOringinY:(int) y withWidth:(int) w withHeight:(int) h
{
	int charW=pInfo->pStrokes->w;
	int charH=pInfo->pStrokes->h;
	if (bDraw)
	{
        if (pInfo->nCurSectIndex>0)
            memcpy(pInfo->pDrawBuf,pInfo->pStrokes->pAnimationBmp[pInfo->nCurSectIndex-1],charW*charH);
        else
            memset(pInfo->pDrawBuf,0,charW*charH);
        
		BYTE* pDst=pInfo->pDrawBuf;
		BYTE* pSrc=pInfo->pStrokes->pStrokeSectBmp[pInfo->nCurSectIndex];
        
		for (int i=y;i<=y+h;i++)
		{
			for (int j=x;j<x+w;j++)
			{
				int index=i*charW+j;
				pDst[index]=min(16,pDst[index]+pSrc[index]);
			}
		}
	}
	else
	{
        memcpy(pInfo->pDrawBuf,pInfo->pStrokes->pAnimationBmp[pInfo->nCurSectIndex],pInfo->pStrokes->w*pInfo->pStrokes->h);
	}
}

//更新位图数据2 主旨更新绘制指定的单独笔画的信息数据。
- (void) STUpdateDrawBufOneIndexWithInfo:(STAnimationInfo*) pInfo isDrawing:( bool) bDraw withOriginX:(int) x withOringinY:(int) y withWidth:(int) w withHeight:(int) h
{
	int charW=pInfo->pStrokes->w;
	int charH=pInfo->pStrokes->h;
	if (bDraw)
	{
        
        if (pInfo->nCurSectIndex < strokeRange.location||pInfo->nCurSectIndex>(strokeRange.location+strokeRange.length))
        {
            memset(pInfo->pDrawBuf,0,charW*charH);
        }
        else{
            //重新组织位图数据
            memset(pInfo->pDrawBuf,0,charW*charH);
            [self resetBitmap:pInfo withIndex:(pInfo->nCurSectIndex-1)];
            
        }
        
		BYTE* pDst=pInfo->pDrawBuf;
		BYTE* pSrc=pInfo->pStrokes->pStrokeSectBmp[pInfo->nCurSectIndex];
        
        if (pInfo->nCurSectIndex>=strokeRange.location&&pInfo->nCurSectIndex<(strokeRange.location+strokeRange.length)) {
            for (int i=y;i<=y+h;i++)
            {
                for (int j=x;j<x+w;j++)
                {
                    int index=i*charW+j;
                    pDst[index]=min(16,pDst[index]+pSrc[index]);
                }
            }
        }
	}
	else
	{
        memset(pInfo->pDrawBuf,0,charW*charH);
        [self resetBitmap:pInfo withIndex:(pInfo->nCurSectIndex)];
	}
}

//返回动态绘制图片 位图绘制函数。
-(UIImage *) STAnimationDraw:(STAnimationInfo* )pInfo
{
    
    UIImage *drawImg =[_FBD fontBitmapDrawWithData:[_BDM getBitmapDataFrom:pInfo withColor:self.charColor] Width:pInfo->pStrokes->w Height:pInfo->pStrokes->h];
    
    self.imageCanvas.image = drawImg;
    
    return drawImg;
}


#pragma mark -   pInfo 初始化方法 得到STAnimationInfo原始数据。
#pragma mark -
-(void) STInitAnimationInfo:(UINT) code  andWithWidth:(int)w  andWithHeight:(int) h andWithFontFile:(NSString*) fontfile andWithMapFile:(NSString*) mappingfile andWithInfo:(STAnimationInfo *)animationInfo
{
    const char *fontFile = [fontfile UTF8String];
    const char *mappingFile = [mappingfile UTF8String];
    
	STCharStrokes* pStrokes=STGetCharStrokes(code,w,h,fontFile,mappingFile,_thousandBase);
    
	animationInfo->pStrokes=pStrokes;
    
	animationInfo->nCurState=0;
	animationInfo->nSpeed=100;
	animationInfo->bPauseByStroke=false;
    animationInfo->nCurSectIndex=0;
    //  animationInfo.x; animationInfo.y;
    
	if (pStrokes->num>0)
	{
		animationInfo->pCurPosX=new int[pStrokes->num];
		animationInfo->pCurPosY=new int[pStrokes->num];
		for (int i=0;i<pStrokes->num;i++)
		{
			animationInfo->pCurPosX[i]=pStrokes->pStrokeSects[i].startX;
			animationInfo->pCurPosY[i]=pStrokes->pStrokeSects[i].startY;
		}
		animationInfo->pDrawBuf=new BYTE[pStrokes->w*pStrokes->h];
		memset(animationInfo->pDrawBuf,0,pStrokes->w*pStrokes->h);
	}
    
    _drawing = NO;
    newStroke = YES;

}


//释放动态绘制信息内存占用。
void STFreeAnimationInfo(STAnimationInfo* animationInfo)
{
    //	if (animationInfo->nTimerID)
    //	{
    //		timeKillEvent(animationInfo->nTimerID);
    //		animationInfo->nTimerID=0;
    //		animationInfo->nCurState=0;
    //	}
	if (animationInfo->pCurPosX)
	{
		delete animationInfo->pCurPosX;
		animationInfo->pCurPosX=NULL;
	}
	if (animationInfo->pCurPosY)
	{
		delete animationInfo->pCurPosY;
		animationInfo->pCurPosY=NULL;
	}
	if (animationInfo->pDrawBuf)
	{
		delete animationInfo->pDrawBuf;
		animationInfo->pDrawBuf=NULL;
	}
	if (animationInfo->pStrokes)
	{
		STDestoryCharStrokes(&(animationInfo->pStrokes));
	}
    
}
//手动调用这个函数可以再任何时候释放内存空间（主要是STAnimationInfo结构体占用的内存），并且摧毁定时器，
-(void)releaseSinoFont_AnimationInfo;
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        _drawOver = YES;
    }
    if (_tempInfo.pStrokes) {
        STFreeAnimationInfo(&(_tempInfo));
    }

}


@end





