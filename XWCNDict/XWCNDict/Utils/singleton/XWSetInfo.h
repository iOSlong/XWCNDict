//
//  XWSetInfo.h
//  XWCNDict
//
//  Created by xw.long on 16/6/22.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XWSetInfo : NSObject

+ (XWSetInfo *)shareSetInfo;

@property (nonatomic, strong, readonly) NSMutableArray  *arrInfoImgName;
@property (nonatomic, strong, readonly) NSMutableArray  *arrUnicodeFont;
@property (nonatomic, strong, readonly) NSString        *imgNameCharacterPlat;
@property (nonatomic, strong, readonly) NSString        *imgNameCharSave;
@property (nonatomic, strong, readonly) NSString        *imgNameSetGear;
@property (nonatomic, strong, readonly) NSString        *imgNameTabbarMask;
@property (nonatomic, strong, readonly) NSString        *imgNameCharPlatMask;
@property (nonatomic, strong, readonly) NSString        *imgNamePoemPlatMask;
@property (nonatomic, strong, readonly) NSString        *imgNamePoemTabMask;
@property (nonatomic, strong, readonly) NSString        *imgNameEqTabMask;



@property (nonatomic, strong) NSString  *imgNameField;
@property (nonatomic, strong) NSString  *fontCharShow;
@property (nonatomic, strong) UIColor   *color_char;
@property (nonatomic, strong) UIColor   *color_radical;
@property (nonatomic, strong) UIColor   *themeColorCharacter;
@property (nonatomic, strong) UIColor   *themeColorRadical;
@property (nonatomic, strong) UIColor   *themeColorPhonetic;
@property (nonatomic, strong) UIColor   *themeColorCollection;
@property (nonatomic, strong) UIColor   *themeColorPoems;
@property (nonatomic, strong) UIColor   *themeColorBackground;


@property (nonatomic, assign) float     speed;
@property (nonatomic, assign) float     volume;
@property (nonatomic, assign) BOOL      isVoice;
@property (nonatomic, assign) BOOL      sound_stroke;
@property (nonatomic, assign) BOOL      sound_char;


///数组将需要设置property的sinoFont传进来，进行统一的属性设置。
@property (nonatomic, strong) NSMutableArray *arrSinoFont;

///当sinofontArray添加的时候，可以通过调用下面这个方法让新添加的SinoFont获得全局属性。
-(void)freshAllPropertyState;

@end
