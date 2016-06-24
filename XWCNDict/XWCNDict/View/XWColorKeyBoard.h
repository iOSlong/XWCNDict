//
//  XWColorKeyBoard.h
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ColorKeyBoardBlock)(UIColor *colorSelected);

@interface XWColorKeyBoard : UIImageView

@property (nonatomic, copy) ColorKeyBoardBlock ColorKBBlock;
@property (nonatomic, strong) UIColor *charColor;

- (instancetype)initInPoemSetWithFrame:(CGRect)frame;

- (void)colorKeyBoard:(ColorKeyBoardBlock)thisBlock;

@end
