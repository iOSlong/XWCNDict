//
//  PReader.m
//  exel
//
//  Created by 龙学武 on 14-4-26.
//  Copyright (c) 2014年 IMac_06. All rights reserved.
//

#import "PlistReader.h"

#pragma mark - NSString_Catogary -
@interface NSString  (NSStringSupport)

-(NSString *)getNoNumAndSpecialCharString;

@end

@implementation NSString (NSStringSupport)

-(NSString *)getNoNumAndSpecialCharString
{
    NSString *specialStr = @"0123456789#!%";
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:self];
    int len = self.length;
    while (len--) {
        NSString *one = [mStr substringWithRange:NSMakeRange(len, 1)];
        if ([specialStr rangeOfString:one].length) {
            [mStr deleteCharactersInRange:NSMakeRange(len, 1)];
        }
    }
    return mStr;
}

@end
#pragma mark - NSArray_Catogary -

@interface NSArray (NSArraySupport)

-(NSArray *)getSortedArray_byNumMark;

@end

@implementation NSArray (NSArraySupport)
//取得字符串中的数字。
-(int)getNumFromString:(NSString *)string
{
    NSString *numStr = @"";
    NSString *helpStr = @"0987654321";
    int len = string.length;
    int i = 0;
    while (i<len) {
        NSString *oneChar = [string substringWithRange:NSMakeRange(i, 1)];
        if ([helpStr rangeOfString:oneChar].length) {
            numStr = [numStr stringByAppendingString:oneChar];
        }
        i++;
    }
    return [numStr intValue];
}
//根据标记数字大小，将无序的键值按升序排列。
-(NSArray *)getSortedArray_byNumMark
{
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:self];
    for (int i=0; i<mArr.count; i++)
    {
        for (int j=i; j<mArr.count; j++)
        {
            NSString *item = [mArr objectAtIndex:i];
            NSString *item2 = [mArr objectAtIndex:j];

            int mark1 = [self getNumFromString:item];
            int mark2 = [self getNumFromString:item2];

            if (mark1>mark2)
            {
                [mArr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return mArr;
}

@end


#pragma mark - PlistReader Implemantation Part -

@interface PlistReader()
{
    NSDictionary *_bushouDict;
    NSDictionary *_pinyinDict;
    NSDictionary *_radicalpinyinDict;
    NSArray *_pinyinArr;
    NSArray *_orderRkeys;
    NSArray *_orderPkeys;
}
@end

@implementation PlistReader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getOriginalDataReady];
    }
    return self;
}
-(void)getOriginalDataReady
{

    _orderPkeys = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"w",@"x",@"y",@"z", nil];//作为根字典的键值
    _orderRkeys = [NSArray arrayWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十七", nil];

    NSString *pinyinDictPlist = [[NSBundle mainBundle] pathForResource:@"pinyin" ofType:@"plist"];
    NSString *bushouDictPlist = [[NSBundle mainBundle] pathForResource:@"radical" ofType:@"plist"];
    NSString *pinyinArrPlist = [[NSBundle mainBundle] pathForResource:@"pinyinArr" ofType:@"plist"];
    NSString *radicalpinyinPlist = [[NSBundle mainBundle] pathForResource:@"radicalPinyin" ofType:@"plist"];
    

    _bushouDict = [NSDictionary dictionaryWithContentsOfFile:bushouDictPlist];

    _pinyinDict = [NSDictionary dictionaryWithContentsOfFile:pinyinDictPlist];
    _pinyinArr = [NSArray arrayWithContentsOfFile:pinyinArrPlist];
    
    _radicalpinyinDict = [NSDictionary dictionaryWithContentsOfFile:radicalpinyinPlist];
}

+(PlistReader *)sharePlistReader
{
    static PlistReader *thisPR;
    if (!thisPR) {
        thisPR = [[PlistReader alloc] init];
    }
    return thisPR;
}


#pragma mark - Instance methods


-(NSDictionary *)getRootDictOfPinyin
{
    return _pinyinDict;
}
-(NSArray *)getRootkeysOfPinyin
{
    return _orderPkeys;
}
-(NSDictionary *)getRootDictOfRadical;
{
    return _bushouDict;
}
-(NSArray *)getRootkeysOfRadical;
{
    return _orderRkeys;
}

//根据无韵拼音(lu,yu,jia,……)得到所有近似发音的字符和拼音｛｛char，pinyin｝，｛｝，……｝
-(NSArray *)getCharAndPinyinArrByBlankPinyin:(NSString *)pinyin;
{
    NSString *key = [pinyin substringToIndex:1];

    NSDictionary *alphaDict = [_pinyinDict objectForKey:key];

    NSArray *char_pinArr = [alphaDict objectForKey:pinyin];

    return char_pinArr;
}

//根据有节奏和韵律的拼音得到所有近似发音的字符和拼音｛｛char，pinyin｝，｛｝，……｝
-(NSArray *)getCharAndPinyinArrByRhythmPinyin:(NSString *)pinyin;
{
//    háng	hàng	héng	xíng
    NSString *blankPinyin;
    for (NSArray *row in _pinyinArr)
    {
        if ([pinyin isEqualToString:[row objectAtIndex:2]])
        {
            blankPinyin = [[row objectAtIndex:1] getNoNumAndSpecialCharString];

            break;
        }
    }
    return [self getCharAndPinyinArrByBlankPinyin:blankPinyin];
}


//更具字符得到这个字符所有的拼音｛pinyin1，pinyin2，……｝
-(NSArray *)getPinyinArrByBlankChar:(NSString *)fontChar;
{
    NSMutableArray  *pinyinArr = [[NSMutableArray alloc] init];

    for (NSArray *row in _pinyinArr) {
        if ([fontChar isEqualToString:[row objectAtIndex:0]]) {
            [pinyinArr addObject:[row objectAtIndex:2]];
        }
    }
    return pinyinArr;
}



//根据具体部首得到所有近似发音的(按笔画升序分组)字符和拼音
/*
 {
    {革默认 = {｛char，pinyin｝，｛｝，……｝},
    {一到三画 = {｛char，pinyin｝，｛｝，……｝},
    {四画以上 = {｛char，pinyin｝，｛｝，……｝},
 }
 它们的部首都相同。
 下面这个函数的运算效率有点低！
 */
-(NSArray *)getCategoryCharAndPinyinArrByRadical:(NSString *)radical;
{
    NSMutableArray *mArr = [[NSMutableArray alloc] init];

    NSDictionary *rDict;
    BOOL find = NO;
    for (NSString *key in _orderRkeys)
    {
        NSDictionary *numDict = [_bushouDict objectForKey:key];
        NSArray *key2Arr = [numDict allKeys];

        for (NSString *bushou in key2Arr)
        {
            if ([radical isEqualToString:bushou])
            {
                rDict = [numDict objectForKey:radical];
                find = YES;
                break;
            }
            if (find) {
                break;
            }
        }
        if (find) {
            break;
        }
    }

    NSArray *strokesArr = [[rDict allKeys] getSortedArray_byNumMark];

    //下面这个效率有点低
    for (NSString *strokeNum in strokesArr)
    {
        NSString *newkey = [strokeNum getNoNumAndSpecialCharString];

        NSArray *detailArr = [rDict objectForKey:strokeNum];
        NSMutableArray *newArr = [[NSMutableArray alloc] init];
        for (int i=0;i<detailArr.count;i++)
        {
            NSString *str = [detailArr objectAtIndex:i];
            NSString *pinyin  = [[self getPinyinArrByBlankChar:str] objectAtIndex:0];

            NSArray *char_pin = [NSArray arrayWithObjects:str,pinyin, nil];
            [newArr addObject:char_pin];
        }

        NSDictionary *newDetailDict = [[NSDictionary alloc] initWithObjectsAndKeys:newArr,newkey, nil];

        [mArr addObject:newDetailDict];

//        printf("%s = \n",[newkey UTF8String]);
//        for (NSArray *char_pin in newArr) {
//            printf("%s\t",[[char_pin componentsJoinedByString:@"("] UTF8String]);
//        }

    }

    return mArr;
}

//根据具体的字符，得到所有与给定字符部首相同的所有(按笔画分组)字符和拼音
/*
 {
    {革默认 = {｛char，pinyin｝，｛｝，……｝},
    {一到三画 = {｛char，pinyin｝，｛｝，……｝},
    {四画以上 = {｛char，pinyin｝，｛｝，……｝},
 }
 它们的部首都相同。
 */
-(NSArray *)getCategoryCharAndPinyinArrByRadicalChar:(NSString *)fontChar;
{

    NSString *radical = [self getRadicalThroughChar:fontChar];
//    NSLog(@"部首：%@",radical);
    return [self getCategoryCharAndPinyinArrByRadical:radical];
}

//{｛char，pinyin｝，｛char，pinyin｝,｛char，pinyin｝,｛char，pinyin｝,｛｝，……｝}
-(NSArray *)getArrayCharAndPinyinArrByRadicalChar:(NSString *)fontChar;
{
    NSArray *dictArr = [self getCategoryCharAndPinyinArrByRadicalChar:fontChar];
    NSMutableArray *char_pinArr = [[NSMutableArray alloc] init ];
    for (NSDictionary *dict in dictArr) {
        NSString *key = [[dict allKeys] lastObject];
        NSArray *catogary = [dict objectForKey:key];
        [char_pinArr addObjectsFromArray:catogary];
    }
    return char_pinArr;
}
//根据给定的字符，得到它的对应的部首
-(NSString*)getRadicalThroughChar:(NSString *)fontChar;
{
    NSArray *keys = [_bushouDict allKeys];
    BOOL find = NO;
    NSString *radical;
    for (NSString *key in keys)
    {
        NSDictionary *rDict = [_bushouDict objectForKey:key];
        NSArray *radicalArr  = [rDict allKeys];
        for (NSString *rkey in radicalArr)
        {
            NSDictionary *strokeNumDict = [rDict objectForKey:rkey];
            NSArray *strokeArr = [strokeNumDict allKeys];
            for (NSString *stroke in strokeArr)
            {
                NSArray *font_char = [strokeNumDict objectForKey:stroke];
                for (NSString *getChar in font_char)
                {
                    if ([getChar isEqualToString:fontChar])
                    {
                        radical = rkey; //取到字符的部首。
                        find = YES;
                        break;
                    }
                    if (find) break;

                }
                if (find) break;
            }
            if (find) break;
        }
    }
    return radical;
}


-(NSArray *)getCategoryCharRadical:(NSString *)radical
{
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    NSDictionary *rDict;
    BOOL find = NO;
    for (NSString *key in _orderRkeys)
    {
        NSDictionary *numDict = [_bushouDict objectForKey:key];
        NSArray *key2Arr = [numDict allKeys];
        
        for (NSString *bushou in key2Arr)
        {
            if ([radical isEqualToString:bushou])
            {
                rDict = [numDict objectForKey:radical];
                find = YES;
                break;
            }
            if (find) {
                break;
            }
        }
        if (find) {
            break;
        }
    }
    
    NSArray *strokesArr = [[rDict allKeys] getSortedArray_byNumMark];
    
    //下面这个效率有点低
    for (NSString *strokeNum in strokesArr)
    {
//        NSString *newkey = [strokeNum getNoNumAndSpecialCharString];
        
        NSArray *detailArr = [rDict objectForKey:strokeNum];
        
        
        [mArr addObjectsFromArray:detailArr];
        
    }
    
    return mArr;
}

/*
 {
 {革默认 = {char(pinyin), char(pinyin),……},
 {一到三画 = {char(pinyin), char(pinyin), ……},
 {四画以上 = { char(pinyin), char(pinyin), char(pinyin), char(pinyin), ……},
 }
 */
-(NSArray *)getCategoryCharPinyinByRadical:(NSString *)radical;
{
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    
    NSDictionary *rDict;
    BOOL find = NO;
    for (NSString *key in _orderRkeys)
    {
        NSDictionary *numDict = [_radicalpinyinDict objectForKey:key];
        NSArray *key2Arr = [numDict allKeys];
        
        for (NSString *bushou in key2Arr)
        {
            if ([radical isEqualToString:bushou])
            {
                rDict = [numDict objectForKey:radical];
                find = YES;
                break;
            }
            if (find) {
                break;
            }
        }
        if (find) {
            break;
        }
    }
    
    NSArray *strokesArr = [[rDict allKeys] getSortedArray_byNumMark];
    
    //下面这个效率有点低
    for (NSString *strokeNum in strokesArr)
    {
        NSString *newkey = [strokeNum getNoNumAndSpecialCharString];
        
        NSArray *detailArr = [rDict objectForKey:strokeNum];
        
//        NSMutableArray *newArr = [[NSMutableArray alloc] init];
//        for (int i=0;i<detailArr.count;i++)
//        {
//            NSString *str = [detailArr objectAtIndex:i];
//            NSString *pinyin  = [[self getPinyinArrByBlankChar:str] objectAtIndex:0];
//            
//            NSArray *char_pin = [NSArray arrayWithObjects:str,pinyin, nil];
//            [newArr addObject:char_pin];
//        }
//        
        NSDictionary *newDetailDict = [[NSDictionary alloc] initWithObjectsAndKeys:detailArr,newkey, nil];
        
        [mArr addObject:newDetailDict];
        
        //        printf("%s = \n",[newkey UTF8String]);
        //        for (NSArray *char_pin in newArr) {
        //            printf("%s\t",[[char_pin componentsJoinedByString:@"("] UTF8String]);
        //        }
        
    }
    
    return mArr;

}

@end







