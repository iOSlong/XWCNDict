//
//  BmpDataManager.h
//  SinoPoem
//
//  Created by IMac_06 on 14-1-18.
//  Copyright (c) 2014年 IMac_06. All rights reserved.
/********************************************************************
    本类用于组织位图数据，
 ******************************************************************/

#import <Foundation/Foundation.h>
#import "STStrokeFontApi.h"
#import <UIKit/UIKit.h>

@interface BmpDataManager : NSObject

+(BmpDataManager *)shareBmpDataManager;

/*1.0处理字符字形内存存储方式,如果无RGB值，得到透明*/
-(unsigned char *)getBitmapDataThrough:(STCharStrokes *)pStrokes WithColor:(UIColor *)fontColor;



//构建位图数据 同时返回一组静态展示的图片
- (NSArray *)fontStaticShowWithData:(STCharStrokes*)pStrokes bottomColor:(UIColor*)bottomColor frontColor:(UIColor*)frontColor;//13



-(unsigned char *)getBitmapDataThrough:(STCharStrokes *)pStrokes bottomColor:(UIColor *)bottomColor radicalColor:(UIColor*)radicalColor;



-(void *)getBitmapDataThrough:(STCharStrokes *)pStrokes withContinue:(BOOL)isContinue andIndex:(int)index withColor:(UIColor *)color;//12



-(void *)getBitmapDataFrom:(STCharStrokes *)pStrokes onlyRadical:(BOOL)onlyRadical withColor:(UIColor *)color;//11


//构建位图数据 同时返回一组静态展示的图片,图片笔画单独
-(void *)getBitmapDataThrough:(STCharStrokes *)pStrokes bottomColor:(UIColor *)bottomColor frontColor:(UIColor *)frontColor inIndex:(int)index;//15



-(void *)getBitmapDataFrom:(STAnimationInfo *)pInfo withColor:(UIColor *)charColor;



@end






