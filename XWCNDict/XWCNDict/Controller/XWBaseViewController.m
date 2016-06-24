//
//  XWBaseViewController.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/4.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWBaseViewController.h"

@interface XWBaseViewController ()

@end

@implementation XWBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%s",__FUNCTION__);
        _setInfo = [XWSetInfo shareSetInfo];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBasicView];

    self.platViewModel = XWPlatViewModelCharacters;

    
}

#pragma mark - 添加收索条 -
-(void)addSearchBar
{
    UIImage *searchImg = [UIImage imageNamed:@"search.png"];
    CGFloat sw = CGImageGetWidth(searchImg.CGImage)/2 * kFixed_rate;
    CGFloat sh = CGImageGetHeight(searchImg.CGImage)/2 * kFixed_rate;

    self.textfield = [[UITextField alloc] init];
    self.textfield.frame = CGRectMake(744 * kFixed_rate, (235-52)*kFixed_rate, sw, sh);
    self.textfield.placeholder = @"Search";
    self.textfield.keyboardType = UIKeyboardTypeWebSearch;
//    self.textfield.delegate = self;
    self.textfield.returnKeyType = UIReturnKeyGo;
    [self.textfield setBackground:searchImg];

    [self.view addSubview:_textfield];
    UIButton *shv  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sh, sh)];
    [shv addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.textfield.leftView = shv;

    self.textfield.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)searchBtn:(UIButton *)btn;
{
    
}


#pragma  mark - 设置按钮
- (void)addSetGear {
    self.btnSetGear = [[UIButton alloc] initWithFrame:CGRectMake(170/2 * kFixed_rate, 1359/2 * kFixed_rate, 52/2 * kFixed_rate, 52/2 * kFixed_rate)];
    //    _setGearView.center = CGPointMake(1800/2, 1370/2);
    self.btnSetGear.alpha = 0.8;
    [self.btnSetGear setBackgroundImage:[UIImage imageNamed:_setInfo.imgNameSetGear] forState:UIControlStateNormal];
    [self.btnSetGear addTarget:self action:@selector(setGearBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSetGear];
    //    [self.view bringSubviewToFront:_setGearView];

//    _charSet = [[CharacterSet alloc] initWithFrame:CGRectMake(-615.0/2-300, 554/2, 0, 0)];
    //    [_cSetView setHidden:YES];
    //    _charSet.backgroundColor = [UIColor redColor];
//    [self.view addSubview:_charSet];

}

- (void)setGearBtn:(UIButton *)btn {

}



#pragma mark - Configure XWSectionPlatView
- (XWSectionPlatView *)sectionPlatView {
    if (!_sectionPlatView) {
        _sectionPlatView= [[XWSectionPlatView alloc] initWithFrame:CGRectMake(kPlat_X, kPlat_Y, kPlat_W, kPlat_H )];
        [self.view addSubview:_sectionPlatView];
        [_sectionPlatView setHidden:YES];
    }
    return _sectionPlatView;
}

- (void)setPlatViewModel:(XWPlatViewModel)platViewModel {
    _platViewModel = platViewModel;

    [self.sectionPlatView setHidden:NO];

    switch (platViewModel) {
        case XWPlatViewModelCharacters:
            self.sectionPlatView.backgroundColor = [UIColor clearColor];
            break;
        case XWPlatViewModelRadical:{
            self.sectionPlatView.leftColor  = [UIColor colorWithRed:204.0/225 green:166.0/255 blue:31.0/255 alpha:1];
            self.sectionPlatView.rightColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
            self.sectionPlatView.leftSpan   = 350/2 * kFixed_rate;
        }
            break;
        case XWPlatViewModelPhonetic:{
            self.sectionPlatView.leftColor = [UIColor colorWithRed:204.0/225 green:166.0/255 blue:31.0/255 alpha:1];
            self.sectionPlatView.rightColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
            self.sectionPlatView.leftSpan = 350/2 * kFixed_rate;
        }
            break;
        case XWPlatViewModelCollection:{
            self.sectionPlatView.backgroundColor = [UIColor whiteColor];
        }
            break;

        default:{
            self.sectionPlatView.backgroundColor = [UIColor whiteColor];
        }
            break;
    }

    [self addSearchBar];
    [self addSetGear];
}



#pragma mark - Configure imgvBackground
- (void)setBasicView {
    self.imgvBackground = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imgvBackground.backgroundColor = [UIColor colorWithRed:48.0/255 green:52.0/255 blue:55.0/255 alpha:1];
    [self.view addSubview:_imgvBackground];
}



#pragma mark - Configure StatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (BOOL)shouldAutorotate {
    return YES;
}


#pragma mark - Category for MBProgressHUD
// 默认不允许操作背景下面的view.
- (void)showHint:(NSString *)hint hide:(CGFloat)delay
{
    BOOL enableBackgroundUserAction = NO;
    // 需要改的地方有点多先在这里拦截.
    if ([hint hasPrefix:@"canTouchMoveBackView"]) {
        enableBackgroundUserAction = YES;
    }
    [self showHint:hint hide:delay enableBackgroundUserAction:enableBackgroundUserAction];
}

- (void)showHint:(NSString *)hint hide:(CGFloat)delay enableBackgroundUserAction:(BOOL)enable
{
    if (!hint || !hint.length) {
        return;
    }
    __block NSString *hintBlock = hint;
    __block BOOL blockEnableBackgroundInteraction = enable;
    dispatch_async(dispatch_get_main_queue(), ^{
        //TBLog(@"show hint loading");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // 如果允许操作下面的view, 需要禁用 mb 本身的userInteraction.
        hud.userInteractionEnabled = !blockEnableBackgroundInteraction;
        [hud setDetailsLabelFont:[UIFont fontWithName:@"STZhuankai" size:15 * kFixed_rate]];
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud setDetailsLabelText:hintBlock];
        [hud hide:YES afterDelay:delay];
    });
}

- (void)showLoading:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //TBLog(@"show loading.");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:animated];
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud setMode:MBProgressHUDModeIndeterminate];
    });
}

- (void)showLoading:(BOOL)animated enableUserAction:(BOOL)enable {
    dispatch_async(dispatch_get_main_queue(), ^{
        //TBLog(@"show loading.");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:animated];
        hud.userInteractionEnabled = !enable; // 如果允许操作下面的view, 需要禁用 mb 本身的userInteraction.
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud setMode:MBProgressHUDModeIndeterminate];
    });
}

- (void)hideLoading:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
}

//

- (void)showLoadingSuccess:(BOOL)animated hintString:(NSString *)hintString hide:(CGFloat)delay
{
    __block NSString *hintStringBlock = hintString;
    dispatch_async(dispatch_get_main_queue(), ^{
        //TBLog(@"show success loading.");
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setRemoveFromSuperViewOnHide:YES];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.customView = imageView;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.minShowTime = 1;
        HUD.labelText = hintStringBlock;
        HUD.labelFont = [UIFont fontWithName:@"STZhuankai" size:15 * kFixed_rate];
        [HUD hide:YES afterDelay:delay];
    });
}

- (void)showLoadingFailure:(BOOL)animated
{

}



@end
