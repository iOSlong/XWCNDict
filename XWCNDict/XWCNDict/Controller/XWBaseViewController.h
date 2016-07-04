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
#import <MBProgressHUD/MBProgressHUD.h>
#import "XWTabBarViewController.h"

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
@property (nonatomic, strong) UIImageView       *imgvTabBarMask; ///
@property (nonatomic, strong) UIImageView       *imgvPageMask;

@property (nonatomic, copy) void (^MaskShowBlock)();
@property (nonatomic, copy) void (^MaskHiddenBlock)();


///默认隐藏
@property (nonatomic, strong) XWSectionPlatView *sectionPlatView;
@property (nonatomic, assign) XWPlatViewModel   platViewModel;
@property (nonatomic, assign) CGRect            rectPlat;

@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) UITextField       *textfield;
@property (nonatomic, strong) UIButton          *btnSetGear;
@property (nonatomic, strong) XWSetInfo         *setInfo;

- (void)searchBtn:(UIButton *)btn;
- (void)setGearBtn:(UIButton *)btn;


- (void)showLoading:(BOOL)animated;
- (void)hideLoading:(BOOL)animated;
- (void)showLoading:(BOOL)animated enableUserAction:(BOOL)enable;

- (void)showLoadingSuccess:(BOOL)animated hintString:(NSString *)hintString hide:(CGFloat)delay;
//
- (void)showLoadingFailure:(BOOL)animated;
- (void)showHint:(NSString *)hint hide:(CGFloat)delay;
- (void)showHint:(NSString *)hint hide:(CGFloat)delay enableBackgroundUserAction:(BOOL)enable;


@end
