//
//  BmpDataManager.m
//  SinoPoem
//
//  Created by IMac_06 on 14-1-18.
//  Copyright (c) 2014年 IMac_06. All rights reserved.
//

#import "BmpDataManager.h"

struct colorDate
{
    float red;
    float green;
    float blue;
    float alpha;
};


@interface BmpDataManager ()

-(NSArray *)countRadicalArrayWithStroke:(STCharStrokes *)pStrokes;

-(void)reloadBottomColor:(UIColor *)bottomColor andFrontColor:(UIColor *)frontColor;

@end

@implementation BmpDataManager
{
    colorDate bColor;
    colorDate fColor;
}




+(BmpDataManager *)shareBmpDataManager{
    static BmpDataManager *thisBMP;
    if (!thisBMP) {
        thisBMP = [[BmpDataManager alloc] init];
    }
    return thisBMP;
}

-(void)reloadBottomColor:(UIColor *)bottomColor andFrontColor:(UIColor *)frontColor
{
    //设置颜色的默认值 黑色
    if (bottomColor == nil) {
        bColor.red = bColor.blue = bColor.green = 133;
    }else{
        
        CGColorRef cgColor = bottomColor.CGColor;
        NSUInteger num = CGColorGetNumberOfComponents(cgColor);
        const CGFloat *colorComponents = CGColorGetComponents(cgColor);
        
        if (num ==2) {
            
            bColor.green= bColor.blue = bColor.red =colorComponents[0]*255;
            
        }else{
            bColor.red = colorComponents[0]*255;
            bColor.green = colorComponents[1]*255;
            bColor.blue = colorComponents[2]*255;
        }
    }
    
    if (frontColor == nil)
    {
        fColor.blue= fColor.red = fColor.green = 0;
        
    }else{
        CGColorRef cgColor1 = frontColor.CGColor;
        NSUInteger num1 = CGColorGetNumberOfComponents(cgColor1);
        const CGFloat *colorComponents1 = CGColorGetComponents(cgColor1);
        
        if (num1 ==2) {
            
            fColor.blue= fColor.red = fColor.green = colorComponents1[0]*255;
            
        }else{
            fColor.red = colorComponents1[0]*255;
            fColor.green = colorComponents1[1]*255;
            fColor.blue = colorComponents1[2]*255;
        }
    }
}
#pragma mark - I add thoese method in applicaiton Stroke_Game -
/*
 获取一个字符包含的笔画数目-->数组中元素个数，数组元素对应笔画的起始笔画段
 部首起始笔画段标记数组，个数为部首数目。第一笔部首，对应第数组0号元素。
 */
-(NSArray *)countRadicalArrayWithStroke:(STCharStrokes *)pStrokes
{
    NSMutableArray *radicalArray = [[NSMutableArray alloc] init];
    
    for (int j=0; j<pStrokes->num; j++)
    {
        STStrokeSect SSect = pStrokes->pStrokeSects[j];
        if (SSect.strokeType1)
        {
            [radicalArray addObject:[NSNumber numberWithInt:j]];
        }
    }
    return radicalArray;
}

#pragma mark - 1.0  绘制指定颜色的字符的位图
-(unsigned char *)getBitmapDataThrough:(STCharStrokes *)pStrokes WithColor:(UIColor *)fontColor
{

    [self reloadBottomColor:fontColor andFrontColor:nil];
    
    float width = pStrokes->w;
    float height = pStrokes->h;
    
    unsigned char *a = (unsigned char*)malloc(4*width*height);
    memset(a, 0, 4*width*height );
    
    BYTE *nation = (BYTE*)malloc(width *height);
    memset(nation, 0, width *height);
    
    for (int sn=0; sn<pStrokes->num; sn++)
    {
        BYTE *sour = pStrokes->pStrokeSectBmp[sn];
        
        for (int i=0; i<width*height; i++)
        {
            nation[i] = sour[i]>nation[i]? sour[i]:nation[i];
        }
    }
    
    for (int i=0; i<width *height; i++)
    {
        nation[i]=MIN((16-nation[i])*16, 255);
        {
            a[4*i+1] = 0;
            a[4*i+2] = 0;
            a[4*i+0] = 0;
            a[4*i+3] = 255-nation[i];
            if (a[4*i+3])
            {
                //决定字体的颜色，区域
                a[4*i+0]=bColor.red;
                a[4*i+1]=bColor.green;
                a[4*i+2]=bColor.blue;
            }
        }
    }
    free(nation);
    return a;
}
#pragma mark - 2.0  取得部首，或者整个字符的位图数据
-(void *)getBitmapDataFrom:(STCharStrokes *)pStrokes onlyRadical:(BOOL)onlyRadical withColor:(UIColor *)color;
{
    void *bitmapData;
    if (!onlyRadical) {
        bitmapData = [self getBitmapDataThrough:pStrokes WithColor:color];
        return bitmapData;
    }
    
    [self reloadBottomColor:color andFrontColor:nil];
    
    //字符的高宽
    int charW=pStrokes->w;
    int charH=pStrokes->h;
    
    //笔画段数量 像素高*宽
    int value = charH *charW;
    
    BYTE *ss2 = (BYTE*)malloc(value*sizeof(BYTE));
    memset(ss2, 0, value*sizeof(BYTE));
    int num = pStrokes->num;
    
    for (int i = 0; i<num; i++) {
        
        BYTE *ss = (BYTE*)malloc(value*sizeof(BYTE));
        memset(ss, 0, value*sizeof(BYTE));
        memcpy(ss, pStrokes->pStrokeSectBmp[i], value*sizeof(BYTE));
        
        for (int t = 0; t<value; t++) {
            
            //如果是部首的话
            if (pStrokes->pStrokeSects[i].isRadical){
                
                if (ss[t]!=0) {
                    ss[t]+=20;
                }
            }
            ss2[t] = MAX(ss[t], ss2[t]);
        }
        free(ss);
    }
    
    BYTE *aaa = (BYTE *)malloc(charW*charH*4);
    memset(aaa, 0, charH*charW*4);
    
    for (int i=0; i<charW*charH; i++)
    {
        if (ss2[i]>=20) {
            ss2[i]-=20;
            ss2[i] = MIN((16-ss2[i])*16, 255);
            
            aaa[4*i+0]=bColor.red;
            aaa[4*i+1]=bColor.green;
            aaa[4*i+2]=bColor.blue;

            aaa[4*i+3]=255-ss2[i];
            
        }else{
            
            ss2[i] = MIN((16-ss2[i])*16, 255);
            aaa[4*i+3] = 0;
        }
        
    }
    free(ss2);
    
    return aaa;
    
}

-(unsigned char *)getBitmapDataThrough:(STCharStrokes *)pStrokes bottomColor:(UIColor *)bottomColor radicalColor:(UIColor*)radicalColor;
{

    
    [self reloadBottomColor:bottomColor andFrontColor:radicalColor];
    
    //字符的高宽
    int charW=pStrokes->w;
    int charH=pStrokes->h;
    
    //笔画段数量 像素高*宽
    int value = charH *charW;
    
    BYTE *ss2 = (BYTE*)malloc(value*sizeof(BYTE));
    memset(ss2, 0, value*sizeof(BYTE));
    int num = pStrokes->num;
    
    for (int i = 0; i<num; i++) {
        
        BYTE *ss = (BYTE*)malloc(value*sizeof(BYTE));
        memset(ss, 0, value*sizeof(BYTE));
        memcpy(ss, pStrokes->pStrokeSectBmp[i], value*sizeof(BYTE));
        
        for (int t = 0; t<value; t++) {
            
            //如果是部首的话
            if (pStrokes->pStrokeSects[i].isRadical){
                
                if (ss[t]!=0) {
                    ss[t]+=20;
                }
            }
            ss2[t] = MAX(ss[t], ss2[t]);
        }
        free(ss);
    }
    
    BYTE *aaa = (BYTE *)malloc(charW*charH*4);
    memset(aaa, 0, charH*charW*4);
    
    for (int i=0; i<charW*charH; i++)
    {
        if (ss2[i]>=20) {
            ss2[i]-=20;
            ss2[i] = MIN((16-ss2[i])*16, 255);
            
            aaa[4*i+0]=fColor.red;
            aaa[4*i+1]=fColor.green;
            aaa[4*i+2]=fColor.blue;
            
        }else{
            
            ss2[i] = MIN((16-ss2[i])*16, 255);
            
            aaa[4*i+0]= bColor.red;
            aaa[4*i+1]=bColor.green;
            aaa[4*i+2]=bColor.blue;
        }
        
        aaa[4*i+3]=255-ss2[i];
        //        if (aaa[4*i+3]) {
        //            aaa[4*i+3] = 100;
        //        }
    }
    free(ss2);
    
    return aaa;

}




#pragma mark - 3.0  绘制指定颜色连续、或不连续笔画的图像对象位图数组
-(void *)getBitmapDataThrough:(STCharStrokes *)pStrokes withContinue:(BOOL)isContinue andIndex:(int)index  withColor:(UIColor *)color
{
    
    [self reloadBottomColor:color andFrontColor:nil];
    
    float width = pStrokes->w;
    float height = pStrokes->h;
    
    
    
    NSArray *radicalArray = [self countRadicalArrayWithStroke:pStrokes];
    
    int start,end;
    if (!isContinue) {
        start= [[radicalArray objectAtIndex:index-1] intValue];
    }else{
        start = 0;
    }
    
    if ([[radicalArray objectAtIndex:index-1] intValue]==[[radicalArray lastObject] intValue]){
        end = pStrokes->num;
    }else{
        end = [[radicalArray objectAtIndex:index] intValue];
    }
    
    
    unsigned char *a = (unsigned char*)malloc(4*width*height);
    memset(a, 0, 4*width*height );
    
    BYTE *nation = (BYTE*)malloc(width *height);
    memset(nation, 0, width *height);
    
    
    for (int sn=start; sn<end; sn++)
    {
        BYTE *sour = pStrokes->pStrokeSectBmp[sn];
        
        for (int i=0; i<width*height; i++)
        {
            nation[i] = sour[i]>nation[i]? sour[i]:nation[i];
        }
    }
    
    for (int i=0; i<width *height; i++)
    {
        nation[i]=MIN((16-nation[i])*16, 255);
        {
            a[4*i+0] = 0;
            a[4*i+1] = 0;
            a[4*i+2] = 255;
            a[4*i+3] = 255-nation[i];
        }
        if (a[4*i+3])
        {
            //决定字体的颜色，区域
            a[4*i+0]=bColor.red;
            a[4*i+1]=bColor.green;
            a[4*i+2]=bColor.blue;

        }
    }
    free(nation);
    return a;
    
}

#pragma mark - 4.0  返回按笔画续增的图片(数组)
- (NSArray *)fontStaticShowWithData:(STCharStrokes*)pStrokes bottomColor:(UIColor*)bottomColor frontColor:(UIColor*)frontColor;
{

    [self reloadBottomColor:bottomColor andFrontColor:frontColor];
    
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    
    //字符的高宽
    int charW=pStrokes->w;
    int charH=pStrokes->h;
    
    //笔画段数量 像素高*宽
    int index = pStrokes->num;
    int value = charH *charW;
    
    
    BYTE *ss0 = (BYTE*)malloc(value*sizeof(BYTE));          //整个字符的的位图数据
    memcpy(ss0, pStrokes->pAnimationBmp[index-1], value*sizeof(BYTE));
//    memcpy(ss0, pStrokes->pStrokeSectBmp[index-1], value*sizeof(BYTE));
    
    for (int i=0; i<charW*charH; i++)
    {
        ss0[i]=MIN((16-ss0[i])*16, 255);
    }
    
    STStrokeSect *pStrokeSect = pStrokes->pStrokeSects;
    
    for (int p =0; p< pStrokes->num; p++)
    {
        if (pStrokeSect[p].strokeType1){                    //如果遇到新的笔画
            
            BYTE *ss22 = (BYTE*)malloc(value*sizeof(BYTE)); //  存储某一笔画的位图数据
            memset(ss22, 0, value*sizeof(BYTE));
            
            for (int p1 = p+1; ; p1++) {
                
                if ((p1 >= pStrokes->num)|pStrokeSect[p1].strokeType1) {
                    
                    memcpy(ss22, pStrokes->pAnimationBmp[p1-1], value*sizeof(BYTE));
                    
                    for (int i = 0; i<value; i++) {
                        ss22[i]=MIN((16-ss22[i])*16, 255);
                    }
                    p = p1-1;
                    break;
                }else{
                    continue;
                }
            }
            
            BYTE *aaa = (BYTE *)malloc(charW*charH*4);
            memset(aaa, 0, charH*charW*4);
            
            for (int i=0; i<charW*charH; i++)
            {
                aaa[4*i+0]=bColor.red;
                aaa[4*i+1]=bColor.green;
                aaa[4*i+2]=bColor.blue;
                aaa[4*i+3]=255-ss0[i];
//                aaa[4*i+3]=125;/*for test _Long*/

                
                if (ss22[i]==ss0[i]) {  //若当前笔画与整个字符有重复的地方 置为红色  既是将当前笔画置为R+B
                    
                    aaa[4*i+0]=fColor.red;
                    aaa[4*i+1]=fColor.green;
                    aaa[4*i+2]=fColor.blue;
                }
                if (p == pStrokes->num-1) {
                    aaa[4*i+0]=fColor.red;
                    aaa[4*i+1]=fColor.green;
                    aaa[4*i+2]=fColor.blue;
                }
            }
            free(ss22);
            
            
            CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, aaa, charH * charW * 4, NULL);
            
            CGImageRef ref = CGImageCreate(charW, charH, 8, 32, charW * 4, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrder32Big|kCGImageAlphaLast, dataProvider, NULL, NO, kCGRenderingIntentDefault);
            
            CGDataProviderRelease(dataProvider);
            
#pragma mark  提炼内存块中的位图，释放该数据区域
            CGSize sz = CGSizeMake(CGImageGetWidth(ref), CGImageGetHeight(ref));
            
            UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
            CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, sz.width, sz.height), flip(ref));
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            
            [mutArr addObject:newImage];
            
            UIGraphicsEndImageContext();
            
            CGImageRelease(ref);
            
            //记得释放掉
            /*记得释放内存*/
            free(aaa);
        }
    }
    
    free(ss0);
    
    return [mutArr copy];
}

#pragma mark -  翻转位图
CGImageRef flip (CGImageRef im) {
    
    CGSize sz = CGSizeMake(CGImageGetWidth(im), CGImageGetHeight(im));
    
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, sz.width, sz.height), im);
    
    CGImageRef result = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    
    UIGraphicsEndImageContext();
    
    return result;
    
}
#pragma mark - 5.0  绘制指定颜笔画 并于字符底色的图像对象位图数组
-(void *)getBitmapDataThrough:(STCharStrokes *)pStrokes bottomColor:(UIColor *)bottomColor frontColor:(UIColor *)frontColor inIndex:(int)index;
{
    
    [self reloadBottomColor:bottomColor andFrontColor:frontColor];
    

    float width = pStrokes->w;
    float height = pStrokes->h;
    
    
    NSArray *radicalArray = [self countRadicalArrayWithStroke:pStrokes];
    
    int start,end;
    
    start= [[radicalArray objectAtIndex:index-1] intValue];
    
    if ([[radicalArray objectAtIndex:index-1] intValue]==[[radicalArray lastObject] intValue]){
        end = pStrokes->num;
    }else{
        end = [[radicalArray objectAtIndex:index] intValue];
    }
    
    
    unsigned char *a = (unsigned char*)malloc(4*width*height);
    memset(a, 0, 4*width*height );
    
    BYTE *nation = (BYTE*)malloc(width *height);
    memset(nation, 0, width *height);
    
    
    for (int sn=0; sn<pStrokes->num; sn++)
    {
        BYTE *mark = (BYTE *)malloc(width*height*sizeof(BYTE));
        memset(mark, 0, width*height*sizeof(BYTE));
        memcpy(mark, pStrokes->pStrokeSectBmp[sn], width*height*sizeof(BYTE));
        
        for (int i=0; i<width*height; i++)
        {
            if (sn>=start && sn<end)
            {
                if (mark[i]!=0)
                {
                    mark[i]+=20;
                }
            }
            nation[i] = MAX(mark[i], nation[i]);
        }
        free(mark);
    }
    
    for (int i=0; i<width*height; i++)
    {
        if (nation[i]>20)
        {
            nation[i]-=20;
            nation[i] = MIN((16-nation[i])*16, 255);
            
            a[4*i+0] = fColor.red;
            a[4*i+1] = fColor.green;
            a[4*i+2] = fColor.blue;
        }
        else
        {
            nation[i] = MIN((16-nation[i])*16, 255);
            a[4*i+0] = bColor.red;
            a[4*i+1] = bColor.green;
            a[4*i+2] = bColor.blue;

        }
        
        a[4*i+3] = 255 - nation[i];
    }
    free(nation);
    return a;
}


#pragma mark -
#pragma mark - STAnimationInfo part -


/*这一个位图方式，非字形区域的背景颜色不做改变，及为0*/
-(void *)getBitmapDataFrom:(STAnimationInfo *)pInfo withColor:(UIColor *)charColor
{
    CGFloat red ;
    CGFloat blue ;
    CGFloat green;
    if (charColor == nil) {
        red = blue = green = 0;
    }else{
        CGColorRef cgColor = charColor.CGColor;
        NSUInteger num = CGColorGetNumberOfComponents(cgColor);
        const CGFloat *colorComponents = CGColorGetComponents(cgColor);
        
        if (num ==2) {
            
            green= blue = red =colorComponents[0]*255;
            
        }else{
            red = colorComponents[0]*255;
            green = colorComponents[1]*255;
            blue = colorComponents[2]*255;
        }
    }
    
    size_t width = pInfo->pStrokes->w;
    size_t height = pInfo->pStrokes->h;
    
    BYTE *pstroke = (BYTE *)malloc(width*height*4);
    BYTE * PartStroke = (BYTE *)malloc(width*height);
    
    int index=0;
    for (int x=0;x<pInfo->pStrokes->w;x++)
    {
        for (int y=0;y<pInfo->pStrokes->h;y++)
        {
            int lev=pInfo->pDrawBuf[index];
            int r=min((16-lev)*16,255);
            PartStroke[x*pInfo->pStrokes->w + y] = r;
            index++;
            
        }
    }
    
    for (int i=0; i<width; i++)
    {
        for (int j=0; j<height; j++)
        {
            pstroke[(i*width+j)*4+0] = 0;
            pstroke[(i*width+j)*4+1] = 0;
            pstroke[(i*width+j)*4+2] = 0;
            pstroke[(i*width+j)*4+3] = 255-PartStroke[i*height+j];
            if (pstroke[(i*width+j)*4+3]) {
                pstroke[(i*width+j)*4+0] = red;
                pstroke[(i*width+j)*4+1] = green;
                pstroke[(i*width+j)*4+2] = blue;
            }/*设置颜色区域*/
        }
    }
    free(PartStroke);
    return pstroke;
}

@end




