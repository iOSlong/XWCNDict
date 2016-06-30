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
    XWCanvasControlEventDeleteChar,
    XWCanvasControlEventTouchUpInside
};

@protocol XWCanvasControlDelegate <NSObject>

@optional

- (void)canvasControl:(XWCanvasControl *)canvas event:(XWCanvasControlEvent)event;

@end

@interface XWCanvasControl : UIView

@property (nonatomic, strong) STSinoFont    *sinoFont;
@property (nonatomic, strong) UIImageView   *imgvBackground;
@property (nonatomic, strong) UIImageView   *imgvDynamicView;
@property (nonatomic, strong) UIButton      *delBtn;
@property (nonatomic, strong) NSString      *fontChar;
@property (nonatomic, assign) NSInteger     index;
@property (nonatomic, assign) BOOL          delState;
@property (nonatomic, weak) id<XWCanvasControlDelegate>delegate;
@property (nonatomic, copy)void(^CanvasBlock)(XWCanvasControl *canvas, XWCanvasControlEvent event);

+ ( SizeContraints )innerSizeContraints;
- (void)setCanvasBlock:(void (^)(XWCanvasControl *, XWCanvasControlEvent))CanvasBlock;

@end
