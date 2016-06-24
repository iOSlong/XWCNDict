//
//  XWSetInfo.m
//  XWCNDict
//
//  Created by xw.long on 16/6/22.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWSetInfo.h"
#import "STSinoFont.h"

@implementation XWSetInfo

+ (XWSetInfo *)shareSetInfo {
    static XWSetInfo *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sinofontArray  = [NSMutableArray array];

        self.imgNameField       = @"mi";

        _imgNameCharacterPlat   = @"font_plat";
        _imgNameCharSave        = @"sabeBtn";
        _imgNameSetGear         = @"shezhi";
        _imgNameTabbarMask      = @"tabbarmask";
        _imgNameCharPlatMask    = @"shademask";
        

        _arrInfoImgName = [NSMutableArray array];
        for (int i=1;i<=4; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"info2-%d",i]];
            [_arrInfoImgName addObject:image];
        }

        //读取unicode字符文件
        NSString *unicodePath = [[NSBundle mainBundle] pathForResource:@"unicodeFont" ofType:@"plist"];
        NSArray *rootArr = [NSArray arrayWithContentsOfFile:unicodePath];
        _arrUnicodeFont = [[NSMutableArray alloc] init];
        for (int i=1; i<rootArr.count; i++) {
            [_arrUnicodeFont addObject:[[rootArr objectAtIndex:i] objectAtIndex:2]];
        }



    }
    return self;
}

- (void)setSpeed:(float)speed {
    _speed = speed;
    int _stepLenth = (int)(speed/0.3);
    for (STSinoFont *sino in self.sinofontArray) {
        [sino drawSpeed:speed addSteplength:_stepLenth];
    }
}

- (void)setVolume:(float)volume {
    _volume = volume;
    for (STSinoFont *sino in self.sinofontArray) {
        sino.volume = volume;
    }
}


- (void)setSound_stroke:(BOOL)sound_stroke {
    _sound_stroke = sound_stroke;
    for (STSinoFont *sino in self.sinofontArray) {
        sino.voice = sound_stroke;
    }
}

- (void)setColor_char:(UIColor *)color_char {
    _color_char = color_char;
    for (STSinoFont *sino in self.sinofontArray) {
        sino.charColor = color_char;
    }
}

- (void)setColor_radical:(UIColor *)color_radical {
    _color_radical = color_radical;
    for (STSinoFont *sino in self.sinofontArray) {
        sino.radicalColor = color_radical;
    }
}

- (void)freshAllPropertyState {
    for (STSinoFont *sino in self.sinofontArray) {
        sino.radicalColor = self.color_radical;
        sino.charColor = self.color_char;
        //        sino.character_Sound = self.character_sound;
        sino.voice = self.sound_stroke;
        sino.volume = self.volume;
        [sino drawSpeed:self.speed addSteplength:1];
    }
}

@end
