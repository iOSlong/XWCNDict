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

#define kFixed_rate                 (([UIScreen mainScreen].bounds.size.width)/1024.0)
#define kScreenSize                 [UIScreen mainScreen].bounds.size
#define kLeftSpan                   (175.0 * kFixed_rate)
#define kPlat_W                     (876 * kFixed_rate)
#define kPlat_H                     (428 * kFixed_rate)
#define kPlat_X                     (74 * kFixed_rate)
#define kPlat_Y                     (235.0 * kFixed_rate)

#define kupSpan                     (56.0 * kFixed_rate)


#define kMiField_W                  (235.0 * kFixed_rate)           // 米字格大小
#define kMiField_X                  (264/2 * kFixed_rate)
#define kMiField_Y                  (192/2 * kFixed_rate)
#define kChar_W                     (kMiField_W - 40 * kFixed_rate) // 文字大小

#define kInfoBanner_X               (896.0/2 * kFixed_rate)
#define kInfoBanner_Y               (85.0/2 * kFixed_rate)
#define kInfoBanner_W               (627.0/2 * kFixed_rate)
#define kInfoBanner_H               (163.0/2 * kFixed_rate)





#endif /* constantUI_h */
