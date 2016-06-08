//
//  RadicalPinyinDict.m
//  huawenDict5.0
//
//  Created by imac_06 on 14-6-24.
//  Copyright (c) 2014年 学武. All rights reserved.
//

#import "RadicalPinyinDict.h"

@implementation RadicalPinyinDict

static RadicalPinyinDict *shareSinoDict;
+ (RadicalPinyinDict *)shareRadicalPinyinDict
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareSinoDict = [[RadicalPinyinDict alloc] init];
    });
    return shareSinoDict;
}


@end
