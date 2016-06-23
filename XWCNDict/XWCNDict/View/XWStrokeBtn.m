//
//  XWStrokeBtn.m
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWStrokeBtn.h"

@implementation XWStrokeBtn{
    UIImageView *_selectedImgView;
    UIImageView *_normalImgView;
    UIColor *activeColor;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        //        NSLog(@"strokebtn.labeltitle = %@",self.labelTitle);
        activeColor = [UIColor colorWithRed:121.0/255 green:199.0/255 blue:56.0/255 alpha:1];

        CGFloat span = 5;
        CGRect subRect = CGRectMake(span, span, self.frame.size.width-2*span, self.frame.size.width-2*span);
        _selectedImgView = [[UIImageView alloc] initWithFrame:subRect];
        [_selectedImgView setHidden:YES];

        _normalImgView = [[UIImageView alloc] initWithFrame:subRect];

        [self addSubview:_selectedImgView];
        [self addSubview:_normalImgView];


        //        [self getInit];//这个地方初始化，属性传值将失败。

    }
    return self;
}

- (void)makeSureIndexLabelShow
{
    [self getInit];
}
-(void)getInit
{
    CGFloat indexWidth = self.frame.size.width/2.5;
    CGFloat indexOffset = self.frame.size.width/9;
    self.labelIndex = [[UILabel alloc] initWithFrame:CGRectMake(-indexOffset, -indexOffset, indexWidth, indexWidth)];
    self.labelIndex.layer.backgroundColor = [UIColor colorWithRed:25.0/255 green:141.0/255 blue:200.0/255 alpha:1].CGColor;
    self.labelIndex.layer.cornerRadius = indexWidth * 0.5;
    self.labelIndex.textAlignment = NSTextAlignmentCenter;
    self.labelIndex.textColor = [UIColor whiteColor];
    self.labelIndex.font = [UIFont systemFontOfSize:indexWidth-7];
    if (!self.labelTitle)
    {
        self.labelIndex.text = @"标";
    }
    else
    {
        self.labelIndex.text = _labelTitle;
    }
    [self addSubview:_labelIndex];

    [self.labelIndex setHidden:YES];
}


- (void)setSelectedImg:(UIImage *)image {
    _selectedImgView.image  = image;
}

- (void)setNormalImg:(UIImage *)image {
    _normalImgView.image    = image;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if(selected)
    {
        [self showActiveState];
        [_selectedImgView setHidden:NO];
        [_normalImgView setHidden:YES];
    }
    else
    {
        [self showOriginalState];
        [_selectedImgView setHidden:YES];
        [_normalImgView setHidden:NO];
    }
}
//选中状态的效果设置
- (void)showActiveState
{

    self.layer.cornerRadius = self.frame.size.width*0.5;
    self.layer.backgroundColor = activeColor.CGColor;
    self.layer.borderWidth = 0;
    self.layer.borderColor = 0;

    self.clipsToBounds = NO;


    [self.labelIndex setHidden:NO];

}
//正常状态的效果设置
- (void)showOriginalState
{
    [self.labelIndex setHidden:YES];
    self.layer.cornerRadius = 0;
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    //    self.layer.borderColor= [[UIColor  grayColor] CGColor];
    //    self.layer.borderWidth = 1.0f;
}


@end
