//
//  XWPoemWordBtn.h
//  XWCNDict
//
//  Created by xw.long on 16/7/4.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STSinoFont.h"


@protocol XWPoemwordBtnDelegate;

@interface XWPoemWordBtn : UIButton<STSinoFontDelegate>

@property (nonatomic, strong) STSinoFont    *sinofont;
@property (nonatomic, strong) UIImageView   *imgvCanvas;
@property (nonatomic, strong) NSString      *fontChar;
@property (nonatomic, strong) UIColor       *colorChar;
@property (nonatomic, assign) CGFloat       drawSpeed;
@property (nonatomic, assign) BOOL          notDelegate;
@property (nonatomic, copy) void(^PoemWordBlock)(XWPoemWordBtn *pwb);
@property(nonatomic,assign) id<XWPoemwordBtnDelegate>delegate;


- (void)getImgOfPunctuation;

- (void)getStaticImg:(UIColor *)color;

@end


@protocol XWPoemwordBtnDelegate <NSObject>

@optional

-(void)poemWordDrawOver:(XWPoemWordBtn *)pBtn;


@end