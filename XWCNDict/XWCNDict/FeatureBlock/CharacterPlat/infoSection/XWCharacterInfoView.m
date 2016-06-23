//
//  XWCharacterInfoView.m
//  XWCNDict
//
//  Created by xw.long on 16/6/23.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWCharacterInfoView.h"
#import "PlistReader.h"

@implementation XWCharacterInfoView{
    UIView *_pinyinPlat;
    UILabel *_strokeNumLabel;
    UILabel *_radicalLabel;
    PlistReader *_PR;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setCharacterInfoDefualt];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        [self setCharacterInfoDefualt];

    }
    return self;
}

- (void)setCharacterInfoDefualt {
    _PR = [PlistReader sharePlistReader];

    self.frame = CGRectMake(0, 0, 420 * kFixed_rate , 155 * kFixed_rate);
    UIImage *cirImg1  = [UIImage imageNamed:@"cir3.png"];
    UIImage *cirImg2  = [UIImage imageNamed:@"cir2.png"];
    UIImage *cirImg3  = [UIImage imageNamed:@"cir1.png"];
    NSArray *imgArr = [NSArray arrayWithObjects:cirImg1,cirImg2,cirImg3, nil];
    CGFloat cw = CGImageGetWidth(cirImg1.CGImage)/2 * kFixed_rate;
    CGFloat ch = CGImageGetHeight(cirImg1.CGImage)/2 * kFixed_rate;
    CGFloat lastH = 0.0f;

    for (int n =0; n<3; n++) {
        UIButton *cirBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cirBtn setFrame:CGRectMake(0, 0+lastH, cw, ch)];
        cirBtn.selected = YES;
        [cirBtn setImage:[imgArr objectAtIndex:n] forState:UIControlStateNormal];
        cirBtn.userInteractionEnabled = NO;
        [self addSubview:cirBtn];
        lastH +=(21 * kFixed_rate +ch);
    }
    CGFloat expand = 10 * kFixed_rate;
    CGFloat sideLength = expand+ch;

    _strokeNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0+cw+10*kFixed_rate , 0+1*(37/2 * kFixed_rate +ch)-expand/2, sideLength, sideLength)];
    _pinyinPlat = [[UIView alloc] initWithFrame:CGRectMake(0+cw+10*kFixed_rate, 0+0*(37/2 * kFixed_rate+ch)-expand/2, sideLength*2, sideLength)];
    _radicalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0+cw+10*kFixed_rate, 0+2*(37/2 * kFixed_rate+ch), sideLength, sideLength)];


    _strokeNumLabel.backgroundColor=  _radicalLabel.backgroundColor
    =_pinyinPlat.backgroundColor =[UIColor clearColor];

    _strokeNumLabel.textAlignment = _radicalLabel.textAlignment = NSTextAlignmentLeft;


    //    _strokeNumLabel.font = [UIFont fontWithName:@"STZhuankai" size:30];
//    _strokeNumLabel.font = [UIFont fontWithName:@"helvetica" size:23];
    _radicalLabel.font = [UIFont fontWithName:@"STZhuankai" size:30 * kFixed_rate];
    _strokeNumLabel.font    = [UIFont fontWithName:@"helvetica" size:23 * kFixed_rate];
//    _radicalLabel.font      = [UIFont systemFontOfSize:30 * kFixed_rate];
    [self addSubview:_strokeNumLabel ];
    [self addSubview: _pinyinPlat];
    [self addSubview:_radicalLabel];



//    [self.fontCharPinyin addObserver:self forKeyPath:@"fontCharPinyin" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    NSLog(@"%@",object);
//    
//}

- (void)reloadCharacterWith:(NSString *)fontChar strokeNum:(int )strokeNum{
    NSArray *pinArr = [_PR getPinyinArrByBlankChar:fontChar];



    for (UIView*vie in _pinyinPlat.subviews) {
        [vie removeFromSuperview];
    }
    _pinyinPlat.frame = CGRectMake(110 * kFixed_rate, (8+0*(37/2+30)-20/2), 290 * kFixed_rate, 40 * kFixed_rate);
    //    _pinyinPlat.backgroundColor = [UIColor whiteColor];
    _pinyinPlat.userInteractionEnabled = YES;
    CGFloat weitiaoSpan = 0;
    CGFloat lastLocation = 0;
    for (NSString *pinyin in pinArr) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];

        [btn.titleLabel setFont:[UIFont fontWithName:@"STZhuankai" size:30 * kFixed_rate]];
//        [btn.titleLabel setFont:[UIFont systemFontOfSize:30 * kFixed_rate]];

        [btn setTitle:pinyin forState:UIControlStateNormal];
        //        [btn setBackgroundColor:[UIColor yellowColor]];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [btn addTarget:self action:@selector(smimilarpinyinClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSDictionary *attritutes = [NSDictionary dictionaryWithObjectsAndKeys:btn.titleLabel.font,NSFontAttributeName, nil];
        CGSize size = [pinyin sizeWithAttributes:attritutes];

        [btn setFrame:CGRectMake(lastLocation+5, 0, size.width+10*kFixed_rate, 35*kFixed_rate)];
        if (size.width<25) {
            weitiaoSpan = 35*kFixed_rate;
        }else
        {
            weitiaoSpan = 15*kFixed_rate;
        }
        lastLocation += size.width+weitiaoSpan;

        //        btn.backgroundColor = [UIColor purpleColor];

        [_pinyinPlat addSubview:btn];

    }

    _strokeNumLabel.text = [NSString stringWithFormat:@"%d",strokeNum];



    NSString *radical = [[_PR getRadicalThroughChar:fontChar] quanjiaoToBanjiao];
    //    printf("radical.length = %d\n",radical.length);
    _radicalLabel.text = radical;


    CGSize size = [fontChar sizeWithAttributes:@{NSFontAttributeName:_radicalLabel.font}];

    _radicalLabel.frame = CGRectMake(_radicalLabel.frame.origin.x, _radicalLabel.frame.origin.y,radical.length*size.width, size.height);

}

//拼音北点击后，跟新到相应的拼音选项。
-(void)smimilarpinyinClick:(UIButton *)btn
{
    for (UIView *view in _pinyinPlat.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [((UIButton *)view) setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [btn setTitleColor:[UIColor colorWithRed:215.0/255 green:121.0/255 blue:21.0/255 alpha:1] forState:UIControlStateNormal];


    printf("pinyin:%s\n",[btn.titleLabel.text UTF8String]);
    if ([self.fontCharPinyin isEqualToString:btn.titleLabel.text]) {
        return;
    }
    self.fontCharPinyin = btn.titleLabel.text;

    if (_CIBlock) {
        _CIBlock(self.fontCharPinyin);
    }
}

- (void)charInfo:(CharInfoBlock )thisBlock {
    _CIBlock = thisBlock;
}

@end
