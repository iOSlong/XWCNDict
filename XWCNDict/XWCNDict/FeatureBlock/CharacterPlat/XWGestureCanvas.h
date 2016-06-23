//
//  XWGestureCanvas.h
//  XWCNDict
//
//  Created by xw.long on 16/6/22.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWSetInfo.h"
#import "STSinoFont.h"

@class XWGestureCanvas;

typedef NS_ENUM(NSUInteger, XWCanvasEvent) {
    XWCanvasEventSingleTap,
    XWCanvasEventDoubleTap,
    XWCanvasEventReload
};

@protocol XWGestureCanvasDelegate <NSObject>
@optional
/// 点击了文字画布事件代理
- (void)gestureCanvas:(XWGestureCanvas *)canvas withEvent:(XWCanvasEvent)event;
- (void)gestureCanvas:(XWGestureCanvas *)canvas withEvent:(XWCanvasEvent)event saveImg:(UIImage *)saveImg;

@end


@interface XWGestureCanvas : UIView

@property (nonatomic, strong) STSinoFont    *sinoFont;
@property (nonatomic, strong) XWSetInfo     *setInfo;
@property (nonatomic, strong) UIImage       *imgStatic;
@property (nonatomic, strong) UIImageView   *imgvBackground;


@property (nonatomic, strong)   NSString *fontChar;
@property (nonatomic, weak)     id<XWGestureCanvasDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame fontChar:(NSString *)fontChar;
- (void)releaseSinoFont;
- (void)reloadWithFontChar:(NSString *)fontChar;

@end
