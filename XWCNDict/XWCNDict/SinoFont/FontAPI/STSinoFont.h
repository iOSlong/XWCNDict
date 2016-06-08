//
//  STSinoFont.h
//  STSinoFont_0527
//
//  Created by imac_06 on 14-5-27.
//  Copyright (c) 2014年 xuewu. All rights reserved.
/********************************************************************
 
 1.资源源于属性字库、两个.dat 文件
                属性字段thousandBase 决定是否使用1000基数数据，或则默认使用128基数数据。
    本类提供了两种初始化字符的方式，其中一种是默认使用的7971个汉字数据文件的初始化方法，
 
 2.可得到常见字符属性{
                    字符笔画数，
                    动态组成笔画段数，
                    部首，
                    unicode编码，
                    字符大小，
                    }
    基本属性，是初始化本类即可从字符信息中判断得到的信息，是不可变更的信息。如Num，charCode，strokeNum都是只读的字段。
 
 
 
 
 3.可设置引擎绘制属性：{
                    字符颜色，
                    笔画读音，启动，音量大小，
                    绘制速度调节，（绘制步长，绘制帧率）
                    绘制按笔画暂停，及暂停时间，
                    }
    绘制属性字段是在进行初始化完毕后，对动态绘制进行操作调整的字段，直接使用点方法更改字段类容即可达到效果。
 
 
 
 
 4.动态绘制的控制操作：{
                    绘制开启，绘制暂停，绘制继续，
                    绘制单独笔画。
                    }
    绘制控制，这里是使用函数方法，实现动态绘制的控制，直接调用对应的方法即可实现控制功能。
 
 
 5.绘制过程中如果没有绘制完毕就暂停，并且确定不再需要绘制，注意调用方法
            -(void)releaseSinoFont_AnimationInfo;将内存资源释放。
 6.获取静态图片，这里提供了七个方法获取其中不同组合样式的图片。具体间方法注释。
 
********************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol STSinoFontDelegate ;//声明一个代理，有的时候可能用得着（多字连续绘制）。


@interface STSinoFont : NSObject


#pragma mark - Properties About

@property(nonatomic,assign)id<STSinoFontDelegate>delegate;


//给一个tag值，标记STSinoFont类。
@property(nonatomic,assign)NSInteger tag;
/*每一个字，可以单独初始化为一个STSinoFont对象，初始化多个的时候，为了区分不同的STSinoFont对象，可以使用tag值来标记*/


//1.字符笔画段数量，只读，初始化本对象完成即可得到值
@property(nonatomic,assign,readonly)int Num;

//2.字符的Unicode编码
@property(nonatomic,assign,readonly)unsigned int charCode;

//初始化的时候得到一个值，后期可以直接使用STSinoFont * .fontChar 犯法改变对象的字符
@property(nonatomic,retain)NSString *fontChar;

//3.字符部首的Unicode编码
@property(nonatomic,assign,readonly)unsigned int radicalCode;

//4.字符的笔画数目，如啊字，笔画数10.
@property(nonatomic,assign,readonly)int strokeNum;

//5.字符大小，初始化的时候给定了一个值，一般请情况下不需要做改变。
@property(nonatomic,assign)CGSize size;

//7.字库文件路径（2），初始化方法中有一个是默认的给定了7971的两个.dat 文件，如有改动可以做调整以方便调用，或者使用另外一个初始化方法。
@property(nonatomic,retain,readonly)NSString *stroke_font_dat;
@property(nonatomic,retain,readonly)NSString *codemapping_dat;

//8.字符的颜色,当部首颜色不一样时，这个颜色是除了部首外，其他笔画的颜色。
@property(nonatomic,retain)UIColor *charColor;

//9.字符部首的颜色
@property(nonatomic,retain)UIColor *radicalColor;

// 默认NO是128基数数据，为YES 则表示1000基数数据，这个值在初始化过程中给定，
@property(nonatomic,assign,readonly)BOOL thousandBase;

// 按笔画暂停功能，默认是NO,如果是YES，则暂停时间由属性strokePauseTime决定
@property(nonatomic,assign)BOOL strokePause;

//按笔画暂停的时间,默认为0，与strokePause属性配合使用
@property(nonatomic,assign)float strokePauseTime;

//是否读音，默认是NO，YES 表示开启读音功能
@property(nonatomic,assign)BOOL voice;

//读音的音量（0~1），默认是0.5，在voice为YES 时候生效。
@property(nonatomic,assign)float volume;




//imageCanvas 这是一个承载动态绘制位图的对象，在使用中不能直接使用点方法(UIImageView *) otherPlace.image = (STSinoFont *)imageCanvas.image,这样无法渲染位图到otherPlace中，而是需要直接使用这里的imageCanvase。使用addSubview：imageCanvas 方法将他叠放到需要使用到的视图上。
@property(nonatomic,retain)UIImageView *imageCanvas;

//在具体应用中，绘制发声后常常需要判断STSinoFont中的动态绘制是否在进行中，drawing为YES表示定时器运行着，正在绘制；为NO表示定时器可能销毁，可能停止运行，暂停绘制或绘制结束。
@property(nonatomic,assign,readonly)BOOL drawing;

//下面这个属性只有在一个完成的字符结束绘制，定时器销毁的时候才是YES，其他情况下为NO
@property(nonatomic,assign,readonly)BOOL drawOver;


//这个是决定绘制速度的（0~1），值越大，绘制越快，
@property(nonatomic,assign)float drawingSpeed;
//这个是绘制步长的增量（>=0），绘制步长是1，这里默认是0，这个值在传真
@property(nonatomic,assign)unsigned int addSteplength;




#pragma mark - Init Method
//着重fontSize 中的打下取整，得到就是初始化字符的字符大小，thousandBase参数是判断是否使用的是1000基数的数据，默认是NO。表hi使用的是128基数的数据。
-(id)initWithChar:(NSString *)fontChar andSize:(CGSize )fontSize strokeWithCodePath:(const char *)strokefont :(const char*)codemapping :(BOOL)thousandBase;

//下面方法初始化时候使用了128基数数据的字库文件，以为默认文件如果连个.dat文件没有变化，直接使用这个初始化方法就可以了。
-(id)initWithChar:(NSString *)fontChar andSize:(CGSize)fontSize thousandeBase:(BOOL)thousandBase;




#pragma mark - Static image get method  part

//获取指定颜色 完整的字符图片对象，完整字符图片
-(UIImage *)getBaseImageWithColor:(UIColor *)color;

//获取指定颜色 字符对应的部首图片对象，单独部首图片
-(UIImage *)getRadicalImageWithSize:(CGSize )size andColor:(UIColor *)color;

//获取部首上色，并且包括除去部首笔画部分，可以颜色区分，完整字符图片
-(UIImage *)getRadicalImageWithSize:(CGSize)size bottomColor:(UIColor *)bColor radicalColor:(UIColor *)rColor;

//获取指定的笔画图片对象，单独的一个笔画。
-(UIImage *)getStrokeImageWithSize:(CGSize )size andColor:(UIColor *)color atIndex:(NSInteger )index;


//获取指定颜色 字符所有笔画的图片对象的数组,[image1,image2,image3,~]，所有单独笔画图片的数组。
-(NSArray *)getStrokesImageArrayWithSize:(CGSize)size andColor:(UIColor *)color strokeTogether:(BOOL )together;


/*获取指定基础颜色，连续部首颜色的图片对象的数组(默认frontColor--black，bottomColor--lightGray)
 得到绘制到每一个笔画阶段的字符图片数组。最后一张为完整的字符图片。
 */
-(NSArray *)getStrokesContinueImageArrayWithSize:(CGSize)size bottomColor:(UIColor *)bColor frontColor:(UIColor *)fColor;


/*获取指定基础颜色，不连续笔画的图片对象的数组：(默认frontColor--black，bottomColor--lightGray)
 得到每一个笔画与除去笔画部分，以颜色区分，为完整字符图片。
*/
-(NSArray *)getStrokeOnlyImageArrayWithSize:(CGSize)size bottomColor:(UIColor *)bColor frontColor:(UIColor *)fColor;



//==========

#pragma mark - Drawing About ~




//开始绘制
-(void)drawStar;

//暂停绘制
-(void)drawPause;

//继续绘制
-(void)drawContinue;


//绘制速度（绘制帧率 绘制步长 两个参数决定）len取值>=0,当取0的时候使用默认步长1.
-(void)drawSpeed:(float)speed addSteplength:(int)leng;


//绘制指定索引的笔画（index >= 1）
-(void)drawStar_StrokeIndex:(NSInteger )index;

//手动调用这个函数可以再任何时候释放内存空间（主要是STAnimationInfo结构体占用的内存），并且摧毁定时器，
-(void)releaseSinoFont_AnimationInfo;




@end


@protocol STSinoFontDelegate <NSObject>

@required


//@optional
//动画绘制结束的时候，会触发这个代理函数。可选方法。
-(void)sinoFontDrawingFinished:(STSinoFont *)sinofont;



@end













