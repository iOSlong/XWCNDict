//
//  XWCanvasControl.h
//  XWCNDict
//
//  Created by xw.long on 16/6/25.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWSetInfo.h"
#import "STSinoFont.h"
#import "XWCollectionStore.h"


@class XWCanvasControl;

typedef  struct SizeContraints {
    CGFloat spanLeft;
    CGFloat spanUp;
    CGFloat spanRow;
    CGFloat spanColumn;
    CGFloat canvasWidth;
} SizeContraints;




typedef NS_ENUM(NSUInteger, XWCanvasControlEvent) {
    XWCanvasControlEventSingleTap,
    XWCanvasControlEventDoubleTap,
    XWCanvasControlEventLongPress,
    XWCanvasControlEventTouchUpInside
};

@protocol XWCanvasControlDelegate <NSObject>

@optional

- (void)canvasControl:(XWCanvasControl *)canvas event:(XWCanvasControlEvent)event;

@end

@interface XWCanvasControl : UIView

@property (nonatomic, strong) STSinoFont    *sinoFont;
@property (nonatomic, strong) UIImageView   *imgvBackground;
@property (nonatomic, strong) NSString      *fontChar;
@property (nonatomic, assign) NSInteger     index;
@property (nonatomic, weak) id<XWCanvasControlDelegate>delegate;

+ ( SizeContraints )innerSizeContraints;

@end
