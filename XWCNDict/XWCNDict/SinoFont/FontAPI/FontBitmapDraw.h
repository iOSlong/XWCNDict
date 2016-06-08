//
//  FontBitmapDraw.h
//  SinoPoem
//
//  Created by IMac_06 on 14-1-18.
//  Copyright (c) 2014年 IMac_06. All rights reserved.

/********************************************************************
    位图绘制操作类，辅助绘制相应的位图图片。
 ******************************************************************/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FontBitmapDraw : NSObject

+(FontBitmapDraw *)shareFontBitmapDraw;

-(UIImage *)fontBitmapDrawWithData:(void *)data Width:(float )w Height:(float)h;

/*绘制两张图片成一张图片*/
-(UIImage *)mergeImage:(UIImage *)belowImg withImage:(UIImage *)aboveImg;

/*复制一张图片*/
-(UIImage *)getImageFromCopy:(UIImage *)image;


//文本绘制方法
-(UIImage *)getImageFromString:(NSString *)str withFont:(UIFont *)font backgroundColor:(UIColor *)bcolor foregroundColor:(UIColor *)fcolor;


@end
