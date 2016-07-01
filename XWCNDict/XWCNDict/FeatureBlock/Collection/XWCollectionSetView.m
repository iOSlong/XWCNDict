//
//  XWCollectionSetView.m
//  XWCNDict
//
//  Created by xw.long on 16/7/2.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWCollectionSetView.h"
#import "XWCNDict-Swift.h"      /// 默认生成 工程中隐藏，可点进去看到
#import "XWMyDataController.h"
#import "XWCanvasControl.h"

@implementation XWCollectionSetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:52.0/255 green:168.0/255 blue:162.0/255 alpha:1];
        [self addSomeSetItems];

    }
    return self;
}

- (void)addSomeSetItems
{

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 250, 60)];
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"调节开关进行字符长按模式转换";
    [self addSubview:label];

    XWSevenSwitch *sswitch = [[XWSevenSwitch alloc] initWithFrame:CGRectMake(100,70, 80, 20)];
    [sswitch addTarget:self action:@selector(sSwitchChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:sswitch];


    UILabel *speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 250, 20)];
    speedLabel.font = [UIFont systemFontOfSize:15];
    speedLabel.text = @"调节绘制速度";
    [self addSubview:speedLabel];

    UISlider *speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 180, self.frame.size.width, 30)];
    speedSlider.value = 0.5;
    [speedSlider addTarget:self action:@selector(speedChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:speedSlider];



}
- (void)speedChange:(UISlider *)slider
{

    int stepLengh = (int)(slider.value/0.3);
    printf("stepLenght = %d\n",stepLengh);

    XWMyDataController *_DC = [XWMyDataController shareDataController];
    for (XWCanvasControl *canvas in _DC.synchronousArrCanvas) {
        [canvas.sinoFont drawSpeed:slider.value addSteplength:stepLengh];
    }
    _DC.speed       = slider.value;
    _DC.stepLength  = stepLengh;
}

- (void)sSwitchChangedValue:(XWSevenSwitch *)ssw
{
    if (ssw.isOn) {
        printf("ssw.isOn = Yes!\n");

//        [CollectAccount shareCollectAcount].isManageMode = YES;

    }else{
        printf("ssw.isOn = No!\n");
//        [CollectAccount shareCollectAcount].isManageMode = NO;
    }
}



@end
