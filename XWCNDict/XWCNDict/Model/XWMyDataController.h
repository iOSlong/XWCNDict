//
//  XWMyDataController.h
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XWCharacter.h"
#import "XWCanvasControl.h"


@interface XWMyDataController : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (instancetype)shareDataController;

- (NSArray *)arrObjectModel;

@property (nonatomic, strong) NSMutableArray <XWCanvasControl *> *synchronousArrCanvas;
@property (nonatomic, assign) NSInteger delCanvasCount; ///记录当前CollectionPlat中删除掉的CanvasControl 的个数。


@end
