//
//  RadicalPinyinDict.h
//  huawenDict5.0
//
//  Created by imac_06 on 14-6-24.
//  Copyright (c) 2014年 学武. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadicalPinyinDict : NSObject


+(RadicalPinyinDict *)shareRadicalPinyinDict;



@property(nonatomic,retain)NSArray *pinyinRootKeys;
@property(nonatomic,retain)NSArray *radicalRootKeys;

@property(nonatomic,retain)NSDictionary *pinyinRootDict;
@property(nonatomic,retain)NSDictionary *radicalRootDict;


@end
