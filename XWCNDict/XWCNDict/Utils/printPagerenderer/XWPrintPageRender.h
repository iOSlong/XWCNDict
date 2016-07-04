//
//  XWPrintPageRender.h
//  XWCNDict
//
//  Created by xw.long on 16/7/4.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWPrintPageRender : UIPrintPageRenderer

@property (nonatomic, strong) NSMutableData *muData;

- (NSData *)convertUIWevViewToPDFsaveWidth:(float)pdfW height:(float)pdfH andData:(NSMutableData *)muData;

@end
