//
//  XWDictBtn.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/6.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWDictBtn.h"

@implementation XWDictBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.backgroundColor =  [UIColor colorWithRed:0.2 green:0.3 blue:0.4 alpha:1];
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        //        [self setContentEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 0)];//左边距为1

    }
    return self;
}
-(void)showSelectedStateYes
{
    self.layer.cornerRadius = self.frame.size.height * 0.5;
    self.layer.backgroundColor = [UIColor colorWithRed:25.0/255 green:141.0/225 blue:200.0/255 alpha:1].CGColor;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}
-(void)showSelectedStateNo
{
    self.layer.cornerRadius = self.frame.size.height*0.3;
    //    self.layer.backgroundColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.4 alpha:1].CGColor;
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
}

-(void)setSelected:(BOOL)selected
{
    [super  setSelected:selected];
    if (selected) {
        [self showSelectedStateYes];
    }else
    {
        [self showSelectedStateNo];
    }

}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];

    NSDictionary *attritutes = [NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName, nil];

    CGFloat expand = 0;
    if ([title rangeOfString:@"("].length) {
        expand = 5;
    }

    CGSize size = [title sizeWithAttributes:attritutes];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, (expand+size.width+20 * kFixed_rate)>self.frame.size.height?(expand+size.width+20 * kFixed_rate):self.frame.size.height, self.frame.size.height);

    //    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
}


@end
