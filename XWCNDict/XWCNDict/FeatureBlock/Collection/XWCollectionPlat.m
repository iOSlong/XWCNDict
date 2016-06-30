//
//  XWCollectionPlat.m
//  XWCNDict
//
//  Created by xw.long on 16/6/25.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWCollectionPlat.h"
#import "XWMyDataController.h"

#define kbox_w      (170.5 * kFixed_rate)
#define ksideSpan   (10 * kFixed_rate)

@implementation XWCollectionPlat{
    XWMyDataController  *_DC;
    XWSetInfo           *_setInfo;
    NSMutableArray      *_muArrCanvas;
    BOOL                _haveDelete;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:42.0/255 green:178.0/255 blue:192.0/255 alpha:1];
        self.userInteractionEnabled = YES;

        _DC             = [XWMyDataController shareDataController];
        _setInfo        = [XWSetInfo shareSetInfo];
        _muArrCanvas    = [NSMutableArray array];
        _haveDelete     = NO;
    }
    return self;
}

- (void)setArrCanvas:(NSArray<XWCanvasControl *> *)arrCanvas
{
    _arrCanvas = arrCanvas;
    if (arrCanvas) {
        SizeContraints sizeCon = [XWCanvasControl innerSizeContraints];
        for (NSInteger i = 0; i < arrCanvas.count; i ++)
        {
            CGRect rectCanvas = CGRectMake(sizeCon.spanLeft + (i%4)*(sizeCon.canvasWidth + sizeCon.spanColumn), (i/4)*(sizeCon.spanRow + sizeCon.canvasWidth) + sizeCon.spanUp, sizeCon.canvasWidth, sizeCon.canvasWidth);
            XWCanvasControl *canvas = [arrCanvas objectAtIndex:i];
            canvas.frame       = rectCanvas;
            canvas.delegate    = self;

            [self addSubview:canvas];
            [_muArrCanvas addObject:canvas];

            __weak __typeof(self)weakSelf = self;
            [canvas setCanvasBlock:^(XWCanvasControl *canvas, XWCanvasControlEvent event) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (event == XWCanvasControlEventDeleteChar) {
                    [strongSelf showAllCanvasDelState];
                }
            }];
        }
    }
}

- (void)canvasControl:(XWCanvasControl *)canvas event:(XWCanvasControlEvent)event
{
    if (event == XWCanvasControlEventDeleteChar)
    {
        [canvas removeFromSuperview];
        [_muArrCanvas removeObjectAtIndex:canvas.index];

        NSInteger i = 0;
        for (XWCanvasControl *canvas in _muArrCanvas) {
            canvas.index = i;
            i++;
        }

        NSInteger location = [_DC.synchronousArrCanvas indexOfObject:canvas];
        [_DC.synchronousArrCanvas removeObjectAtIndex:location];
        /// 同时删除CoreData 存储的字符类容
        NSArray *arrCharacter = [_DC arrObjectModel];
        for (XWCharacter *character in arrCharacter)
        {
            if ([character.fontChar isEqualToString:canvas.fontChar])
            {
                [_DC.managedObjectContext deleteObject:character];
                break;
            }
        }
        NSError *error = nil;
        [_DC.managedObjectContext save:&error];
        if (error) {
            NSLog(@"fail storn charModel  :%@",error);
        }
        
        [self reloadCollectCasesFromCollectCaseArr];
        
        _DC.delCanvasCount ++;
        _haveDelete = YES;
    }
}

#pragma mark 每一次进行删除动作后都调用一下这个函数，进行动画效果解决。
-(void)reloadCollectCasesFromCollectCaseArr
{
    SizeContraints sizeCon = [XWCanvasControl innerSizeContraints];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.2f];

    for (int i=0; i<_muArrCanvas.count; i++)
    {
        CGRect rectCanvas = CGRectMake(sizeCon.spanLeft + (i%4)*(sizeCon.canvasWidth + sizeCon.spanColumn), (i/4)*(sizeCon.spanRow + sizeCon.canvasWidth) + sizeCon.spanUp, sizeCon.canvasWidth, sizeCon.canvasWidth);

        XWCanvasControl *canvas = [_muArrCanvas objectAtIndex:i];
        canvas.frame = rectCanvas;
    }

    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancelAllCanvasDelState];
    if (_haveDelete) {
        if (self.pageIndex == [_DC.synchronousArrCanvas count]/8 + 1) {
            _DC.delCanvasCount = 0;
            return;
        }else if (self.pageIndex <= [_DC.synchronousArrCanvas count]/8){

            if (self.CollectionPlatBlock) {
                self.CollectionPlatBlock(self);
            }

            NSInteger remainCount = 8 - _DC.delCanvasCount;
            [self effectMovingCanvasFromLocation:remainCount];
            _DC.delCanvasCount = 0;
        }
    }
}

- (void)effectMovingCanvasFromLocation:(NSInteger)remainCount
{
    NSRange range = NSMakeRange(8*(self.pageIndex-1), 8);
    NSArray *subArr = [_DC.synchronousArrCanvas subarrayWithRange:range];

    SizeContraints sizeCon = [XWCanvasControl innerSizeContraints];


    for (NSInteger i = remainCount; i<subArr.count; i++)
    {
        CGRect rectCanvas = CGRectMake(sizeCon.spanLeft+(4+(i-remainCount)%4)*(sizeCon.canvasWidth + sizeCon.spanColumn), sizeCon.spanUp+(sizeCon.spanRow + sizeCon.canvasWidth)-15, sizeCon.canvasWidth+sizeCon.spanColumn, sizeCon.canvasWidth);

        XWCanvasControl *canvas = [subArr objectAtIndex:i];
        canvas.frame = rectCanvas;
    }


    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.2f];
    for (NSInteger i = remainCount; i<subArr.count; i++)
    {
        CGRect rectCanvas = CGRectMake(sizeCon.spanLeft + (i%4)*(sizeCon.canvasWidth + sizeCon.spanColumn), (i/4)*(sizeCon.spanRow + sizeCon.canvasWidth) + sizeCon.spanUp, sizeCon.canvasWidth, sizeCon.canvasWidth);

        XWCanvasControl *canvas = [subArr objectAtIndex:i];
        canvas.frame = rectCanvas;

    }
    [UIView commitAnimations];
}

- (void)cancelAllCanvasDelState
{
    for (XWCanvasControl *canvas in _DC.synchronousArrCanvas) {
        canvas.delState = NO;
    }
    _haveDelete = NO;
}

- (void)showAllCanvasDelState
{
    for (XWCanvasControl *canvas in _DC.synchronousArrCanvas) {
        canvas.delState = YES;
    }
    _haveDelete = NO;
}

- (void)setCollectionPlatBlock:(void (^)(XWCollectionPlat *))CollectionPlatBlock
{
    _CollectionPlatBlock = CollectionPlatBlock;
}

@end
