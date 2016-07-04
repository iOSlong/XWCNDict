//
//  XWPrintPageRender.m
//  XWCNDict
//
//  Created by xw.long on 16/7/4.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWPrintPageRender.h"

@implementation XWPrintPageRender
{
    BOOL _generatingPdf;
}

- (CGRect) paperRect
{
    if (!_generatingPdf)
        return [super paperRect];

    return UIGraphicsGetPDFContextBounds();
}

- (CGRect) printableRect
{
    if (!_generatingPdf)
        return [super printableRect];

    return CGRectInset( self.paperRect, 20, 20 );
}

- (NSData *)convertUIWevViewToPDFsaveWidth:(float)pdfW height:(float)pdfH andData:(NSMutableData *)muData
{
    _generatingPdf = YES;

    NSMutableData *pdfData = [NSMutableData data];

    UIGraphicsBeginPDFContextToData( pdfData, CGRectMake(0, 0, pdfW, pdfH), nil );

    [self prepareForDrawingPages: NSMakeRange(0, 1)];

    CGRect bounds = UIGraphicsGetPDFContextBounds();

    for ( int i = 0 ; i < self.numberOfPages ; i++ )
    {
        UIGraphicsBeginPDFPage();

        [self drawPageAtIndex: i inRect: bounds];
    }

    UIGraphicsEndPDFContext();

    _generatingPdf = NO;

    return pdfData;
}


@end
