//
//  XWPinyinBtn.h
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWPinyinBtn : UIButton

//右侧显示拼音的label
@property (nonatomic, strong) UILabel   *rightLabel;


//rightlabe显示字符
@property (nonatomic, strong) NSString  *labelTitle;

//显示leftLabel汉字字符
@property (nonatomic, strong) NSString  *fontChar;



@property (nonatomic, strong) UIImage   *normalImg;

@property (nonatomic, strong) UIImage   *selectedImg;


-(void)normalState;

-(void)selectedState;

@end
