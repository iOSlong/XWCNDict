//
//  XWCharacterPlat.h
//  XWProDict
//
//  Created by 龙学武 on 16/6/6.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWGestureCanvas.h"

@class XWCharacterPlat;

@protocol XWCharacterPlatDelegate <NSObject>

@optional

-(void)saveBtnSelected:(XWCharacterPlat *)characterPlat;

-(void)characterInfoShowFinished:(XWCharacterPlat *)characterPlat;

@end




@interface XWCharacterPlat : UIImageView
//保存按钮图片
@property(nonatomic,retain) UIImageView *saveImgView;

//米字格字体框
@property(nonatomic,retain) UIImageView *migeImgView;

//字体书写的画布
@property(nonatomic,retain) XWGestureCanvas *fontCanvas;

//一个静态图片标记
@property(nonatomic,retain) UIImage *staticImg;


//本字符平台对应字符
@property(nonatomic,retain)NSString *fontChar;

//字符平台对应字符的当前拼音
@property(nonatomic,retain)NSString *fontCharPinyin;


//声明协议代理属性
@property(nonatomic,assign)id<XWCharacterPlatDelegate>delegate;



//设置一个新的初始方法
-(id)initWithFrame:(CGRect)frame andChar:(NSString *)fontChar;


//呈现字符信息调用函数
-(void)characterInfoShow;


//从新设置当前characterPlat 的所有信息。
//-(void)reloadAllState;

//终止当前线程的一些不必要的操作和一些别的线程操作
-(void)stopOtherThreads;

-(void)readyForRelease;


@end
