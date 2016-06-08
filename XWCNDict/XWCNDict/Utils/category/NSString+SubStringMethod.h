//
//  NSString+SubStringMethod.h
//  myFont1.7
//
//  Created by IMac_06 on 14-1-7.
//  Copyright (c) 2014年 IMac_06. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SubStringMethod)

+(NSArray *)getCharArrayFromNSString:(NSString *)charsString;

+(NSArray *)getSubStrArrayFromString:(NSString *)String withSubLength:(NSInteger)len;


-(unsigned int)getUnicodeCode;

-(NSString *)quanjiaoToBanjiao;


@end
