//
//  XWCharacter.m
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWCharacter.h"

@implementation XWCharacter

@dynamic fontChar;
@dynamic dateModify;
@dynamic dataImg;

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ | %@ | haveImg:%d", self.fontChar,self.dateModify,self.dataImg?1:0];
}

@end
