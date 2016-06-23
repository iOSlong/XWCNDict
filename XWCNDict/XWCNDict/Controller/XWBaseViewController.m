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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBasicView];

    self.platViewModel = XWPlatViewModelCharacters;
    
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


@end
