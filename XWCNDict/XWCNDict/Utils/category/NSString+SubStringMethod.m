//
//  NSString+SubStringMethod.m
//  myFont1.7
//
//  Created by IMac_06 on 14-1-7.
//  Copyright (c) 2014年 IMac_06. All rights reserved.
//

#import "NSString+SubStringMethod.h"

@implementation NSString (SubStringMethod)

-(NSArray *)getSubStrings_FromStr:(NSString *)response withStartMark:(NSString *)startMark andEndMark:(NSString *)endMark{
    
    NSMutableArray *subStringArray = [[NSMutableArray alloc] initWithCapacity:0];
    if ([startMark isEqualToString:endMark]||[response rangeOfString:startMark].location >[response rangeOfString:endMark].location) {
        return nil;
    }
    while (1) {
        NSRange rangehead = [response rangeOfString:startMark];
        NSRange rangetail = [response rangeOfString:endMark];
        
        if (rangehead.length) {
            NSString *subone = [response substringWithRange:NSMakeRange(rangehead.location+rangehead.length, rangetail.location-rangehead.length-rangehead.location)];
            
            [subStringArray addObject:subone];
            
            response = [response substringFromIndex:rangetail.location+rangetail.length];
        }else{
            break;
        }
    }
    return subStringArray;
}
+(NSArray *)getCharArrayFromNSString:(NSString *)charsString
{
    NSMutableArray *charArray = [[NSMutableArray alloc] initWithCapacity:0];
    int index = 0;
    while (1) {
        NSString *charOne = [charsString substringWithRange:NSMakeRange(index, 1)];
        [charArray addObject:charOne];
        index++;
        if (index>=[charsString rangeOfString:charsString].length) {
            break;
        }
    }
    return charArray;
}

-(unsigned int)getUnicodeCode{
    const char *character = [self cStringUsingEncoding:NSUnicodeStringEncoding];
    unsigned int *unicode = (unsigned int *)character;
    return *unicode;
}

+(NSArray *)getSubStrArrayFromString:(NSString *)String withSubLength:(NSInteger)len{
    NSMutableArray *subStrArray = [[NSMutableArray alloc] init];
    for (int i=0; i<String.length; i+=((50 > String.length-i)?String.length-i:len)) {
        NSString *newStr;
        if (String.length-i>len) {
            newStr = [String substringWithRange:NSMakeRange(i, len)];
        }else{
            newStr = [String substringWithRange:NSMakeRange(i, String.length-i)];
        }
        [subStrArray addObject:newStr];
    }
    return subStrArray;
}


-(NSString *)quanjiaoToBanjiao;
{
    NSMutableString *str = [NSMutableString stringWithString:self];
    int len  = str.length;
    while (len--) {
        NSRange range = NSMakeRange(len, 1);
        if ([[str substringWithRange:range]isEqualToString:@"）"]) {
            [str replaceCharactersInRange:range withString:@")"];
        }
        if ([[str substringWithRange:range]isEqualToString:@"（"]) {
            [str replaceCharactersInRange:range withString:@"("];
        }
    }    
    return str;
}


#if 0
-(NSArray *)getCityNameArray_FromStr:(NSString *)response withStartMark:(NSString *)startMark andEndMark:(NSString *)endMark
{
    
    NSMutableArray *CitysArray = (NSMutableArray *)[self getSubStrings_FromStr:response withStartMark:startMark andEndMark:endMark];
    
    NSMutableArray *citysNameArray= [[NSMutableArray alloc] initWithCapacity:0];
    
    //从城市数组中将名字必须时格式:[石家庄 (53698)]提取出来存入数组返回.
    for (NSString *cityName in CitysArray) {
        NSRange range = [cityName rangeOfString:@" "];
        
        cityName = [cityName substringWithRange:NSMakeRange(0, range.location)];
        
        [citysNameArray addObject:cityName];
    }
    return citysNameArray;
}
#endif



@end
