//
//  XWCollectionPlat.h
//  XWCNDict
//
//  Created by xw.long on 16/6/25.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCanvasControl.h"
#import <CoreData/CoreData.h>



@interface XWCollectionPlat : UIImageView<XWCanvasControlDelegate>

@property (nonatomic, strong) NSArray <XWCanvasControl *>* arrCanvas;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, copy) void (^CollectionPlatBlock)(XWCollectionPlat *plat);

@end
