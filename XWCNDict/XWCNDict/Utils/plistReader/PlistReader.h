//
//  PReader.h
//  exel
//
//  Created by 龙学武 on 14-4-26.
//  Copyright (c) 2014年 IMac_06. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistReader : NSObject

+(PlistReader *)sharePlistReader;


-(NSDictionary *)getRootDictOfPinyin;
-(NSArray *)getRootkeysOfPinyin;
-(NSDictionary *)getRootDictOfRadical;
-(NSArray *)getRootkeysOfRadical;


//根据无韵拼音得到所有近似发音的字符和拼音｛｛char，pinyin｝，｛｝，……｝
//拼音字典中，点击无韵拼音键值，得到拼音信息。
-(NSArray *)getCharAndPinyinArrByBlankPinyin:(NSString *)pinyin;



//根据有节奏和韵律的拼音得到所有近似发音的字符和拼音｛｛char，pinyin｝，｛｝，……｝
//fontPlat中点击拼音，得到对应的pinyinIfo。
-(NSArray *)getCharAndPinyinArrByRhythmPinyin:(NSString *)pinyin;



//更具字符得到这个字符所有的拼音｛pinyin1，pinyin2，……｝
//fontPlat中，如果是多音字，得到它的所有的拼音。
-(NSArray *)getPinyinArrByBlankChar:(NSString *)fontChar;


//根据具体部首得到所有以它为部首的(按笔画分组)字符和拼音
/*
 {
    {革默认 = {｛char，pinyin｝，｛｝，……｝},
    {一到三画 = {｛char，pinyin｝，｛｝，……｝},
    {四画以上 = {｛char，pinyin｝，｛｝，……｝},
 }
 */
-(NSArray *)getCategoryCharAndPinyinArrByRadical:(NSString *)radical;




//根据具体的字符，得到所有与给定字符部首相同的所有(按笔画分组)字符和拼音
/*
 {
 {革默认 = {｛char，pinyin｝，｛｝，……｝},
 {一到三画 = {｛char，pinyin｝，｛｝，……｝},
 {四画以上 = {｛char，pinyin｝，｛｝，……｝},
 }
 */
-(NSArray *)getCategoryCharAndPinyinArrByRadicalChar:(NSString *)fontChar;

//{｛char，pinyin｝，｛char，pinyin｝,｛char，pinyin｝,｛char，pinyin｝,｛｝，……｝}
-(NSArray *)getArrayCharAndPinyinArrByRadicalChar:(NSString *)fontChar;


//根据给定的字符，得到它的对应的部首
-(NSString*)getRadicalThroughChar:(NSString *)fontChar;



//add this in 0504
//根据部首，得到部首对应的所有字符
//{char，char，char，char，char}
-(NSArray *)getCategoryCharRadical:(NSString *)radical;


/*
 {
 {革默认 = {char(pinyin), char(pinyin),……},
 {一到三画 = {char(pinyin), char(pinyin), ……},
 {四画以上 = { char(pinyin), char(pinyin), char(pinyin), char(pinyin), ……},
 }
 */
-(NSArray *)getCategoryCharPinyinByRadical:(NSString *)radical;




@end
