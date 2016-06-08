//
//  FontBitmapDraw.m
//  SinoPoem
//
//  Created by IMac_06 on 14-1-18.
//  Copyright (c) 2014年 IMac_06. All rights reserved.
//

#import "FontBitmapDraw.h"

@implementation FontBitmapDraw

static FontBitmapDraw *thisFBD;
+(FontBitmapDraw *)shareFontBitmapDraw{
    if (!thisFBD) {
        thisFBD = [[FontBitmapDraw alloc] init];
    }
    return thisFBD;
}

-(UIImage *)fontBitmapDrawWithData:(void *)data Width:(float)w Height:(float)h
{
    size_t width = w;
    size_t height = h;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow=width*4;
    CGColorSpaceRef colorspace;
    CGBitmapInfo bitmapInfo;
    colorspace = CGColorSpaceCreateDeviceRGB();
    bitmapInfo = kCGImageAlphaLast|kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big;
    
#if 1
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, data, width * height * 4, NULL);
    
    CGImageRef ref = CGImageCreate(width, height, bitsPerComponent, 32, bytesPerRow, colorspace, bitmapInfo, dataProvider, NULL, NO, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    float scale = [[UIScreen mainScreen]scale];
    
    /*   CGDataProviderRef方法应用的数据和最终的位图数据都使指在data，有大量的浪费，所以下面重新使用CGContextDrawImage
     重新绘制一个相同的位图，释放掉原有的data数据    */
    CGSize sz = CGSizeMake(CGImageGetWidth(ref), CGImageGetHeight(ref));
    UIGraphicsBeginImageContextWithOptions(sz, NO, scale);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, sz.width, sz.height), flip(ref));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(ref);
    
    free(data);
    
#endif
    return image;

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
///////////////////////add this method in 3.12 2014
-(UIImage *)mergeImage:(UIImage *)belowImg withImage:(UIImage *)aboveImg
{
    UIImage *newImage;
    CGSize newSize = [belowImg size];
    UIGraphicsBeginImageContext(newSize);
    [belowImg drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    [aboveImg  drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
///////////////add this method in 3.20 2014
-(UIImage *)getImageFromCopy:(UIImage *)image{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    newImage = [UIImage imageWithCGImage:[self flip:[newImage CGImage]]];
    
    UIGraphicsEndImageContext();
    return newImage;
}

-(CGImageRef )flip:(CGImageRef )im
{
    UIGraphicsBeginImageContext(CGSizeMake(CGImageGetWidth(im), CGImageGetHeight(im)));
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, CGImageGetWidth(im), CGImageGetHeight(im)), im);
    CGImageRef result  = [UIGraphicsGetImageFromCurrentImageContext() CGImage];
    UIGraphicsEndImageContext();
    return result;
}
#pragma mark - textDraw Method -
//文本绘制方法
-(UIImage *)getImageFromString:(NSString *)str withFont:(UIFont *)font backgroundColor:(UIColor *)bcolor foregroundColor:(UIColor *)fcolor;
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,fcolor,NSForegroundColorAttributeName,bcolor,NSBackgroundColorAttributeName, nil];
    
    CGSize size  = [str sizeWithAttributes:attributes];
    
    UIGraphicsBeginImageContext(size);
        
    [str drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
}

@end
