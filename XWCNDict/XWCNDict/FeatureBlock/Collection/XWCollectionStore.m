//
//  XWCollectionStore.m
//  XWCNDict
//
//  Created by xw.long on 16/6/25.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWCollectionStore.h"

@implementation XWCollectionStore

+ (XWCollectionStore *)shareCollectionStore
{
    static XWCollectionStore *anyObj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        anyObj = [[XWCollectionStore alloc] init];
    });
    return anyObj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrayCanvas = [NSMutableArray array];
    }
    return self;
}




@end
