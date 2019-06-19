//
//  XWCharacterSetView.m
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWCharacterSetView.h"
#import "XWColorKeyBoard.h"
#import "XWSetInfo.h"
#import "XWCNDict-Swift.h"      /// 默认生成 工程中隐藏，可点进去看到





@implementation XWCharacterSetView
{
    NSMutableArray *_boxBtnArr;     //只能选中其中一个btn


    NSMutableArray *_switchArr;     //保存开关选项设置；


    UISlider *_speedSlider;
    UISlider *_voiceSlider;


    UIImageView *_imageView;


    XWColorKeyBoard *_charatercolor_keyboard;
    XWColorKeyBoard *_radicalcolor_keyboard;
    XWColorKeyBoard *_tempkeyboard;
    NSArray *_colorKeyboardArr;


    __block XWSetInfo *_setInfo;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;

        _setInfo = [XWSetInfo shareSetInfo];

        _boxBtnArr = [[NSMutableArray alloc] init];
        _switchArr = [[NSMutableArray alloc] init];
        [self getAllUIItemsInit];
    }
    return self;
}

-(void)getAllUIItemsInit
{
    UIImage *setPlatImg = [UIImage imageNamed:@"shezhiditu.png"];
    CGFloat width = CGImageGetWidth(setPlatImg.CGImage)/2 * kFixed_rate;
    CGFloat height = (682/2+1)*kFixed_rate;//CGImageGetHeight(setPlatImg.CGImage)/2;

    // add this in 4.17 2014
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _imageView.image = setPlatImg;
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];


    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,width+220*kFixed_rate, height+30*kFixed_rate);
    //    self.backgroundColor = [UIColor lightGrayColor];
    //    self.image = setPlatImg;

    [self getThroughOtherItems];

}
-(void)getThroughOtherItems
{

    UIImage *stetchLeftTrack= [UIImage imageNamed:@"22.png"];
    UIImage *stetchRightTrack = [UIImage imageNamed:@"11.png"];
    UIImage *thumbImage = [UIImage imageNamed:@"anniu.png"];



    _speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 140*kFixed_rate, 40/2 *kFixed_rate)];
    _speedSlider.value = 0.5;
    _speedSlider.selected = YES;
    _speedSlider.center = CGPointMake(463/2 *kFixed_rate, 166/2 * kFixed_rate);

    [_speedSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [_speedSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    [_speedSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [_speedSlider setThumbImage:thumbImage forState:UIControlStateNormal];


    [_speedSlider addTarget:self action:@selector(speedChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_speedSlider];



    _voiceSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 140 *kFixed_rate, 40/2 *kFixed_rate)];
    _voiceSlider.value = 0.5;
    _voiceSlider.selected = YES;
    _voiceSlider.center = CGPointMake(463/2 * kFixed_rate, 252/2 *kFixed_rate);

    [_voiceSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [_voiceSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    [_voiceSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [_voiceSlider setThumbImage:thumbImage forState:UIControlStateNormal];

    //    [_voiceSlider setThumbTintColor:[UIColor colorWithRed:25.0/255 green:141.0/255 blue:200.0/255 alpha:1]];


    [_voiceSlider addTarget:self action:@selector(voiceChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_voiceSlider];


    for (int i=1; i<=3; i++)
    {
        UIImage *selectImg = [UIImage imageNamed:[NSString stringWithFormat:@"box_%dr.png",i]];
        UIImage *normalImg = [UIImage imageNamed:[NSString stringWithFormat:@"box_%d.png",i]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setImage:selectImg forState:UIControlStateSelected];
        [btn setImage:normalImg forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0,normalImg.size.width/2, normalImg.size.height/2);
        btn.center = CGPointMake((365/2+(i-1)*50) * kFixed_rate, 78/2 * kFixed_rate);
        [btn addTarget:self action:@selector(boxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_boxBtnArr addObject:btn];
        [self addSubview:btn];
    }
    UIButton *btn = [_boxBtnArr objectAtIndex:1];
    btn.selected = YES;

    for (int j=0; j<4; j++)
    {

        

        XWSevenSwitch *sw = [[XWSevenSwitch alloc] initWithFrame:CGRectMake(0, 0, 112/2 * kFixed_rate, 20 * kFixed_rate)];
        sw.center = CGPointMake(550/2 * kFixed_rate, (348/2+(45)*j)*kFixed_rate);
        sw.tag = j;
        sw.inactiveColor = [UIColor colorWithRed:168.0/255 green:168.0/255 blue:168.0/255 alpha:1.00f];
        sw.thumbTintColor = [UIColor colorWithRed:25.0/255.0 green:141.0/255.0 blue:200.0/255.0 alpha:1];
        sw.onThumbTintColor  = [UIColor colorWithRed:121.0/255 green:199.0/255 blue:56.0/255 alpha:1];
        [sw addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        [_switchArr addObject:sw];
        [self addSubview:sw];
    }


    _charatercolor_keyboard = [[XWColorKeyBoard alloc] initWithFrame:CGRectMake(330 * kFixed_rate, 238 *kFixed_rate, 222*kFixed_rate, 100*kFixed_rate)];
    [self addSubview:_charatercolor_keyboard];
    [_charatercolor_keyboard setHidden:YES];
    [_charatercolor_keyboard colorKeyBoard:^(UIColor *colorSelected) {
        _setInfo.color_char = colorSelected;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiNameCharacter_Radical_ColorChange object:nil];
    }];


    _radicalcolor_keyboard = [[XWColorKeyBoard alloc] initWithFrame:CGRectMake(330 * kFixed_rate, 283*kFixed_rate, 222*kFixed_rate, 100*kFixed_rate)];
    [self addSubview:_radicalcolor_keyboard];
    [_radicalcolor_keyboard setHidden:YES];
    [_radicalcolor_keyboard colorKeyBoard:^(UIColor *colorSelected) {
        _setInfo.color_radical = colorSelected;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiNameCharacter_Radical_ColorChange object:nil];

    }];

    _colorKeyboardArr = [NSArray arrayWithObjects:_charatercolor_keyboard,_radicalcolor_keyboard, nil];

}
#pragma mark - setMenuInfo Menthods! -



-(void)speedChange:(UISlider *)slider
{
    //    printf("speedSlider.value = %f\n",slider.value);
    _setInfo.speed = slider.value;
}
-(void)voiceChange:(UISlider *)slider
{
    //    printf("voiceSlider.value = %f\n",slider.value);
    _setInfo.volume = slider.value;
}
-(void)boxBtnClick:(UIButton *)btn
{
    for (UIButton *boxBtn in _boxBtnArr)
    {
        boxBtn.selected = NO;
    }
    btn.selected = YES;

    if (1==btn.tag)
    {
        //        printf("tian_zi_ge\n");
        _setInfo.imgNameField = @"jing.png";
    }
    else if (2==btn.tag)
    {
        //        printf("jin_zi_ge\n");
        _setInfo.imgNameField = @"mi.png";

    }
    else if (3==btn.tag)
    {
        //        printf("mi_zi_ge\n");
        _setInfo.imgNameField = @"tian.png";

    }

    //添加一个通知，让CharacterPlat重新设置一下_migeImageView的UIImage属性。
    //注意这个地方应为是新添加的通知，所以如果新建了一个CharacterPlat的话，这个通知是没有注册进去的，即是它不再MessageInfo中。
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiNameCharacter_CanvasBox_StyleChange object:nil];

}

- (void)switchChange:(XWSevenSwitch *)sw
{
    switch (sw.tag) {
        case 0:
        {
            //            printf("strokeSound!\n");
            _setInfo.sound_stroke = sw.on;
            _setInfo.isVoice = sw.on;
        }
            break;
        case 1:
        {

        }
            break;
        case 2:
        {
            [_radicalcolor_keyboard setHidden:YES];
            [(XWSevenSwitch *)[_switchArr objectAtIndex:3] setOn:NO];
//            [(XWSevenSwitch *)[_switchArr objectAtIndex:3] setOn:NO animated:YES];

            _tempkeyboard = [_colorKeyboardArr objectAtIndex:0];


            if (sw.on) {
                [_tempkeyboard setHidden:NO];
                [self bringSubviewToFront:_tempkeyboard];
            }
            else{
                [_tempkeyboard setHidden:YES];
            }
            //            printf("CharacterColour!\n");
//            _tempkeyboard.delegate = self;


        }
            break;
        case 3:
        {
            [_charatercolor_keyboard setHidden:YES];
            [(XWSevenSwitch *)[_switchArr objectAtIndex:2] setOn:NO];
//            [(XWSevenSwitch *)[_switchArr objectAtIndex:2] setOn:NO animated:YES];

            _tempkeyboard = [_colorKeyboardArr objectAtIndex:1];
            if (sw.on) {
                [_tempkeyboard setHidden:NO];
                [self bringSubviewToFront:_tempkeyboard];

            }else{
                [_tempkeyboard setHidden:YES];
            }
            //            printf("RadicalColour!\n");
//            _tempkeyboard.delegate = self;

        }
            break;
        default:
            break;
    }
}



@end
