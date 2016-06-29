//
//  XWCollectionStore.h
//  XWCNDict
//
//  Created by xw.long on 16/6/25.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWCollectionStore : NSObject

+ (XWCollectionStore *)shareCollectionStore;

@property (nonatomic, strong) NSMutableArray *arrayCanvas;


@end
