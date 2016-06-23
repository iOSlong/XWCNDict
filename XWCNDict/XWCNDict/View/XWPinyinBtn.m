//
//  XWPinyinBtn.m
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWPinyinBtn.h"

@implementation XWPinyinBtn

{

    UIImageView *_normalImgView;
    UIImageView *_selectedImgView;
    UILabel *_fontCharLabel;

    UILabel *_greenBackView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        CGRect superRect = self.bounds;

        //        self.backgroundColor = [UIColor redColor];

        _normalImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, superRect.size.height, superRect.size.height)];
        _normalImgView.backgroundColor = [UIColor yellowColor];

        _selectedImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, superRect.size.height, superRect.size.height)];

        _fontCharLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, superRect.size.height, superRect.size.height)];
        _fontCharLabel.textColor = [UIColor whiteColor];
        _fontCharLabel.textAlignment = NSTextAlignmentCenter;
        //        _fontCharLabel.font = [UIFont systemFontOfSize:superRect.size.height/1.5];
        _fontCharLabel.font = [UIFont fontWithName:@"STZhuankai" size:superRect.size.height/1.5];


        _greenBackView = [[UILabel alloc] initWithFrame:CGRectMake(0, 3.0/37.0*superRect.size.height, superRect.size.width, superRect.size.height*31.0/37.0)];



        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(superRect.size.height*0.8, 0, superRect.size.width-superRect.size.height*0.8, superRect.size.height*31.0/37.0)];
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.font = [UIFont fontWithName:@"STZhuankai" size:superRect.size.height/2];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.adjustsFontSizeToFitWidth = YES;


        [self addSubview:_greenBackView];
        [_greenBackView addSubview:_rightLabel];
        [self addSubview:_selectedImgView];
        [self addSubview:_normalImgView];

        [self addSubview:_fontCharLabel];





        [self controlShapeOfImageView];

    }
    return self;
}
-(void)controlShapeOfImageView
{

    _normalImgView.layer.cornerRadius = self.bounds.size.height*0.5;
    _selectedImgView.layer.cornerRadius = self.bounds.size.height*0.5;
    _greenBackView.layer.cornerRadius = _rightLabel.frame.size.height*0.5;
    _normalImgView.layer.backgroundColor = _selectedImgView.layer.backgroundColor = [UIColor colorWithRed:25.0/255 green:141.0/255 blue:200.0/255 alpha:1].CGColor;
    _greenBackView.layer.backgroundColor = [UIColor colorWithRed:121.0/255 green:199.0/255 blue:56.0/255 alpha:1].CGColor;


    self.layer.cornerRadius = self.bounds.size.height*0.5;
}
-(void)setSelectedImg:(UIImage *)selectedImg
{
    _selectedImg = selectedImg;
    _selectedImgView.image = selectedImg;
}

-(void)setNormalImg:(UIImage *)normalImg
{
    _normalImg = normalImg;
    _normalImgView.image = normalImg;
}

-(void)setLabelTitle:(NSString *)labelTitle
{
    _labelTitle = labelTitle;
    self.rightLabel.text = _labelTitle;
}

-(void)setFontChar:(NSString *)fontChar
{
    _fontChar = fontChar;
    _fontCharLabel.text = fontChar;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {

        //        [self showSomePressedStateFor_A_While];

    }else{

        //        [self showSomePressedStateFor_A_While];

    }
}
-(void)selectedState
{
    _normalImgView.layer.backgroundColor = _selectedImgView.layer.backgroundColor = [UIColor colorWithRed:125.0/255 green:121.0/255 blue:100.0/255 alpha:1].CGColor;
    _greenBackView.layer.backgroundColor = [UIColor colorWithRed:151.0/255 green:119.0/255 blue:56.0/255 alpha:1].CGColor;



}
-(void)normalState
{
    _normalImgView.layer.backgroundColor = _selectedImgView.layer.backgroundColor = [UIColor colorWithRed:25.0/255 green:141.0/255 blue:200.0/255 alpha:1].CGColor;
    _greenBackView.layer.backgroundColor = [UIColor colorWithRed:121.0/255 green:199.0/255 blue:56.0/255 alpha:1].CGColor;
}
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    //show some state different to original state。

    [self selectedState];

    [self performSelector:@selector(normalState) withObject:nil afterDelay:2];


    return YES;
}



-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{

    //back to the original state
    [self normalState];

    [self sendActionsForControlEvents:UIControlEventValueChanged];

}



//
//-(void)showSomePressedStateFor_A_While
//{
//   [UIView animateWithDuration:0.5f animations:^{
//       _normalImgView.layer.backgroundColor = _selectedImgView.layer.backgroundColor = [UIColor colorWithRed:125.0/255 green:121.0/255 blue:100.0/255 alpha:1].CGColor;
//       _greenBackView.layer.backgroundColor = [UIColor colorWithRed:151.0/255 green:119.0/255 blue:56.0/255 alpha:1].CGColor;
//   } completion:^(BOOL finished) {
//       _normalImgView.layer.backgroundColor = _selectedImgView.layer.backgroundColor = [UIColor colorWithRed:25.0/255 green:141.0/255 blue:200.0/255 alpha:1].CGColor;
//       _greenBackView.layer.backgroundColor = [UIColor colorWithRed:121.0/255 green:199.0/255 blue:56.0/255 alpha:1].CGColor;
//   }];
//}


@end
