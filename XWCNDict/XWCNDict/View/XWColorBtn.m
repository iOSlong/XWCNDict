//
//  XWColorBtn.m
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWColorBtn.h"

@implementation XWColorBtn
{
    UIColor *_newBackgroundColor;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code


        self.adjustsImageWhenHighlighted  = YES;

        //        self.layer.shadowColor = [UIColor colorWithRed:194.0/255 green:196.0/255 blue:156.0/255 alpha:1].CGColor;
        self.layer.shadowColor = [UIColor whiteColor].CGColor;
        self.layer.shadowRadius = self.frame.size.height*0.25;
        self.layer.shadowOpacity = 0;
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.layer.cornerRadius = self.frame.size.height*0.5;
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    //在这里设置的东西每次改变self的各种属性的时候都会被调用一下。其实这个不太好。
}
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _newBackgroundColor = backgroundColor;
    self.layer.backgroundColor = _newBackgroundColor.CGColor;

}
- (UIColor *)backgroundColor
{
    return _newBackgroundColor;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected: selected];
    if (selected) {
        self.layer.shadowOpacity = 1;
    }else{
        self.layer.shadowOpacity = 0;
    }
}

@end
