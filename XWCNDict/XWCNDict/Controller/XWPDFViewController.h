//
//  XWPDFViewController.h
//  XWCNDict
//
//  Created by xw.long on 16/7/4.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWBaseViewController.h"
#import "XWCollectionPlat.h"
#import "XWPrintPageRender.h"


@interface XWPDFViewController : XWBaseViewController<UIPrintInteractionControllerDelegate>

@property (nonatomic, strong) XWCollectionPlat  *collectionPlat;
@property (nonatomic, strong) UIImageView       *imgvShow;

@end
