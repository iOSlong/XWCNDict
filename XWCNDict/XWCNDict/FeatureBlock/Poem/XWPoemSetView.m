//
//  XWPoemSetView.m
//  XWCNDict
//
//  Created by xw.long on 16/7/4.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWPoemSetView.h"
#import "XWCNDict-Swift.h"      /// 默认生成 工程中隐藏，可点进去看到


@implementation XWPoemSetView
{
    NSMutableArray *_switchArr;     //保存开关选项设置；


    UISlider *_speedSlider;
    UISlider *_voiceSlider;


    UIImageView *_imageView;

    XWColorKeyBoard *_poemwordcolor_keyboard;
}

#define kStrokeSoundTag 100
#define kCharacterSoundTag 200
#define kCharacterColorTag 300

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 305 * kFixed_rate, 251 * kFixed_rate)];
        _imageView.image = [UIImage imageNamed:@"poemSetBackImg"];
        [self addSubview:_imageView];


        [self addOtherControlItems];

    }
    return self;
}
-(void)addOtherControlItems{



    UIImage *stetchLeftTrack= [UIImage imageNamed:@"22.png"];
    UIImage *stetchRightTrack = [UIImage imageNamed:@"11.png"];
    UIImage *thumbImage = [UIImage imageNamed:@"anniu.png"];



    _speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 140 * kFixed_rate, 40/2 * kFixed_rate)];
    _speedSlider.value = 0.5;
    _speedSlider.selected = YES;
    _speedSlider.center = CGPointMake(430/2 * kFixed_rate, 86/2 * kFixed_rate);

    [_speedSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [_speedSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    [_speedSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [_speedSlider setThumbImage:thumbImage forState:UIControlStateNormal];



    _voiceSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 140 * kFixed_rate, 40/2 * kFixed_rate)];
    _voiceSlider.value = 0.5;
    _voiceSlider.selected = YES;
    _voiceSlider.center = CGPointMake(430/2 * kFixed_rate, 172/2 * kFixed_rate);

    [_voiceSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [_voiceSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    [_voiceSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [_voiceSlider setThumbImage:thumbImage forState:UIControlStateNormal];

    //    [_voiceSlider setThumbTintColor:[UIColor colorWithRed:25.0/255 green:141.0/255 blue:200.0/255 alpha:1]];



    [_speedSlider addTarget:self action:@selector(poemSpeedChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_speedSlider];



    [_voiceSlider addTarget:self action:@selector(poemVoiceChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_voiceSlider];


    int a[3] = {100,200,300};
    for (int j=0; j<3; j++)
    {
        XWSevenSwitch *sw = [[XWSevenSwitch alloc] initWithFrame:CGRectMake(0, 0, 140/2 * kFixed_rate, 20 * kFixed_rate)];
        sw.center = CGPointMake(500/2 * kFixed_rate, (260/2+(43)*j) * kFixed_rate);
        sw.tag = a[j];
        //        sw.thumbTintColor = [UIColor colorWithRed:25.0/255 green:141.0/255 blue:200.0/255 alpha:1];
        //        sw.tintColor = [UIColor grayColor];
        sw.inactiveColor = [UIColor colorWithRed:168.0/255 green:168.0/255 blue:168.0/255 alpha:1.00f];
        sw.thumbTintColor = [UIColor colorWithRed:25.0/255.0 green:141.0/255.0 blue:200.0/255.0 alpha:1];
        sw.onThumbTintColor  = [UIColor colorWithRed:121.0/255 green:199.0/255 blue:56.0/255 alpha:1];
        [sw addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        [_switchArr addObject:sw];
        [self addSubview:sw];
    }
    _poemwordcolor_keyboard = [[XWColorKeyBoard alloc] initWithFrame:CGRectMake(630/2 * kFixed_rate, (225-30) * kFixed_rate, 222 * kFixed_rate, 100 * kFixed_rate)];
    __weak __typeof(self)weakSelf = self;
    [_poemwordcolor_keyboard colorKeyBoard:^(UIColor *colorSelected) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        for (XWPoemArena *ps in strongSelf.poemStageArray) {
            ps.charColor = colorSelected;
        }
    }];
    _poemwordcolor_keyboard.tag = 100;
    [_poemwordcolor_keyboard setHidden:YES];
    [self addSubview:_poemwordcolor_keyboard];
    //    [_poemwordcolor_keyboard setHidden:YES];

}


-(void)poemSpeedChange:(UISlider *)slider
{
    for (XWPoemArena *ps in self.poemStageArray) {
        ps.drawSpeed = slider.value;
    }
}
-(void)poemVoiceChange:(UISlider *)slider
{
    //    for (PoemStage *ps in self.poemStageArray) {
    //        ps.volume = slider.value;
    //    }
    self.volume = slider.value;
    PoemSetVolumeCallback(self);
}



-(void)switchChange:(XWSevenSwitch *)sw
{
    switch (sw.tag) {
        case kStrokeSoundTag:
        {
            //            if (sw.isOn) {
            //                for (PoemStage *ps in self.poemStageArray)
            //                {
            //                    ps.strokeSound = YES;
            //                }
            //            }else{
            //                for (PoemStage *ps in self.poemStageArray)
            //                {
            //                    ps.strokeSound = NO;
            //                }
            //            }

        }
            break;
        case kCharacterSoundTag:
        {
            self.voiceOpen = sw.isOn;
            PoemSetVoiceCallback(self);
        }
            break;
        case kCharacterColorTag:
        {
            if (sw.isOn) {
                [_poemwordcolor_keyboard setHidden:NO];
            }else{
                [_poemwordcolor_keyboard setHidden:YES];
            }
        }
            break;
        default:
            break;
    }
}


-(void)poemSetVolumeCallBackFunc:(void (^)(XWPoemSetView *))thiscallback
{
    PoemSetVolumeCallback = thiscallback;
}
-(void)poemSetVoiceCallBackFunc:(void (^)(XWPoemSetView *))thiscallback
{
    PoemSetVoiceCallback = thiscallback;
}


@end
