//
//  XWBaseViewController.h
//  XWProDict
//
//  Created by 龙学武 on 16/6/4.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWSectionPlatView.h"
#import "XWSetInfo.h"

typedef NS_ENUM(NSUInteger, XWPlatViewModel) {
    XWPlatViewModelCharacters,
    XWPlatViewModelRadical,
    XWPlatViewModelPhonetic,
    XWPlatViewModelCollection,
    XWPlatViewModelPeom,
    XWPlatViewModelYizijing,
    XWPlatViewModelNotebook,
    XWPlatViewModelGame
};

@interface XWBaseViewController : UIViewController

@property (nonatomic, strong) UIImageView       *imgvBackground;

///默认隐藏
@property (nonatomic, strong) XWSectionPlatView *sectionPlatView;
@property (nonatomic, assign) XWPlatViewModel   platViewModel;

@property (nonatomic, strong) UITextField       *textfield;
@property (nonatomic, strong) UIButton          *btnSetGear;
@property (nonatomic, strong) XWSetInfo         *setInfo;

- (void)searchBtn:(UIButton *)btn;
- (void)setGearBtn:(UIButton *)btn;

@end
