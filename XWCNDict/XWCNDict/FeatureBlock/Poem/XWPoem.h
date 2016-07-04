//
//  XWPoem.h
//  XWCNDict
//
//  Created by xw.long on 16/7/4.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWPoem : NSObject

//注意这里只能是等言的律诗，每个句子长度= pLineLenght！

@property(nonatomic,retain)NSString *pName;

@property(nonatomic,retain)NSString *pAuthor;

@property(nonatomic,retain)NSString *pContent;

@property(nonatomic,assign)int pLineLenght;


@end
