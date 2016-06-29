//
//  XWCollectionPlat.m
//  XWCNDict
//
//  Created by xw.long on 16/6/25.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWCollectionPlat.h"

#define kbox_w      (170.5 * kFixed_rate)
#define ksideSpan   (10 * kFixed_rate)

@implementation XWCollectionPlat{
    XWSetInfo *_setInfo;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:42.0/255 green:178.0/255 blue:192.0/255 alpha:1];
        self.userInteractionEnabled = YES;

        _setInfo = [XWSetInfo shareSetInfo];

//        [self loadCollectionCaseFrom:nil];
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
        }
    }
}


//- (void)loadCollectionCaseFrom:(NSArray *)arrCase
//{
//    _arrCanvas = arrCase;
//
//    CGFloat leftspan = 130/2;
//    CGFloat upspan = 77/2;
//    CGFloat rowspan = 32/2;
//    CGFloat collumspan = 40/2;
//    CGFloat box_width = 341/2;
//    for (int i=0; i<arrCase.count; i++)
//    {
//        CGRect thisRect = CGRectMake(leftspan+(i%4)*(box_width+collumspan), upspan+(i/4)*(rowspan+box_width)-15, box_width+collumspan, box_width+15);
//
//        XWCanvasControl *canvas = [arrCase objectAtIndex:i];
//        canvas.frame = thisRect;
//        fontCase.delegate = self;
//
//
//        [self addSubview:fontCase];
//
//        [_collectCaseArr addObject:fontCase];
//
//
//        //4.触动回调函数，将调用这个事件。
//        [fontCase makeBackFun:^(CollectCase *thisCase) {
//            NSLog(@"fCase%d:Do LongPress",fontCase.index);
//            [self showAllCollectCaseDelState];
//        }];
//    }
//
//    
//    XWCanvasControl *canvas = [[XWCanvasControl alloc] initWithFrame:CGRectMake(10, 10, kbox_w, kbox_w)];
//    [canvas.layer setContents:(id)[UIImage imageNamed:_setInfo.imgNameField].CGImage];
//    canvas.fontChar = @"啊";
//    [self addSubview:canvas];
//}

@end
