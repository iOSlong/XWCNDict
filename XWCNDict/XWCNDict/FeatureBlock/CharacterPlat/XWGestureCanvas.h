//
//  XWGestureCanvas.h
//  XWCNDict
//
//  Created by xw.long on 16/6/22.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWSetInfo.h"

@class XWGestureCanvas;

typedef NS_ENUM(NSUInteger, XWCanvasEvent) {
    XWCanvasEventSingleTap,
    XWCanvasEventDoubleTap,
    XWCanvasEventNone,
};

@protocol XWGestureCanvasDelegate <NSObject>
@optional
/// 点击了文字画布事件代理
- (void)gestureCanvas:(XWGestureCanvas *)canvas withEvent:(XWCanvasEvent)event;

@end


@interface XWGestureCanvas : UIView

- (instancetype)initWithFrame:(CGRect)frame fontChar:(NSString *)fontChar;

@property (nonatomic, strong)   NSString *fontChar;
@property (nonatomic, weak)     id<XWGestureCanvasDelegate>delegate;


@end
