//
//  XWCollectionPlat.h
//  XWCNDict
//
//  Created by xw.long on 16/6/25.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCanvasControl.h"




@interface XWCollectionPlat : UIImageView<XWCanvasControlDelegate>

@property (nonatomic, strong) NSArray <XWCanvasControl *>* arrCanvas;
@property (nonatomic, assign) NSInteger pageIndex;


@end
