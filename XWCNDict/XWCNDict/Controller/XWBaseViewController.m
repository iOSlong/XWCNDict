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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBasicView];
}


- (void)setBasicView {
    self.imgvBackground = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imgvBackground.backgroundColor = [UIColor colorWithRed:48.0/255 green:52.0/255 blue:55.0/255 alpha:1];
    [self.view addSubview:_imgvBackground];

}

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
