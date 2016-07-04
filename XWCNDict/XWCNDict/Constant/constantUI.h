//
//  constantUI.h
//  XWProDict
//
//  Created by 龙学武 on 16/6/4.
//  Copyright © 2016年 林夕. All rights reserved.
//

#ifndef constantUI_h
#define constantUI_h

#import "UIView+XWPosition.h"
#import "UIView+XWImage.h"


#define kFixed_rate                 (([UIScreen mainScreen].bounds.size.width)/1024.0)
#define kScreenSize                 [UIScreen mainScreen].bounds.size
#define kLeftSpan                   (175.0 * kFixed_rate)
#define kPlat_W                     (876 * kFixed_rate)
#define kPlat_H                     (428 * kFixed_rate)
#define kPlat_X                     (74 * kFixed_rate)
#define kPlat_Y                     (235.0 * kFixed_rate)
#define kPlat_suffix                 (9.0 * kFixed_rate)

#define kupSpan                     (56.0 * kFixed_rate)


#define kMiField_W                  (235.0 * kFixed_rate)           // 米字格大小
#define kMiField_X                  (264/2 * kFixed_rate)
#define kMiField_Y                  (192/2 * kFixed_rate)
#define kChar_W                     (kMiField_W - 40 * kFixed_rate) // 文字大小

#define kInfoBanner_X               (896.0/2 * kFixed_rate)
#define kInfoBanner_Y               (85.0/2 * kFixed_rate)
#define kInfoBanner_W               (627.0/2 * kFixed_rate)
#define kInfoBanner_H               (163.0/2 * kFixed_rate)


// Color helpers
#define RGBCOLOR(r,g,b)                                     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)                                  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define RGBCOLOR_HEX(h)                                     RGBCOLOR((((h)>>16)&0xFF), (((h)>>8)&0xFF), ((h)&0xFF))
#define RGBACOLOR_HEX(h,a)                                  RGBACOLOR((((h)>>16)&0xFF), (((h)>>8)&0xFF), ((h)&0xFF), (a))
#define RGBPureColor(h)                                     RGBCOLOR(h, h, h)
#define HSVCOLOR(h,s,v)                                     [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:1]
#define HSVACOLOR(h,s,v,a)                                  [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]
#define RGBA(r,g,b,a)                                       (r)/255.0f, (g)/255.0f, (b)/255.0f, (a)


#endif /* constantUI_h */
