//
//  XWTabBarViewController.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/3.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWTabBarViewController.h"



static XWTabBarViewController *selfxwTabBarViewController;
@implementation UIViewController (XWTabBarViewControllerSupport)

- (XWTabBarViewController *)tabBarVC {
    return selfxwTabBarViewController;
}

@end




@implementation XWTabBarViewController


- (instancetype)init
{
    self = [super init];
    if (self) {

        self.tabBar.hidden = YES;

        _imgvBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0,20 * kFixed_rate,1024 * kFixed_rate,133 *kFixed_rate)];
        _imgvBackground.exclusiveTouch  = YES;
        _imgvBackground.backgroundColor = [UIColor orangeColor];
        _imgvBackground.userInteractionEnabled = YES;
        [self.view addSubview:_imgvBackground];

        UIColor *color1 = [UIColor colorWithRed:120.0/255 green:184.0/255 blue:52.0/255 alpha:1];
        UIColor *color2 = [UIColor colorWithRed:215.0/255 green:121.0/255 blue:21.0/255 alpha:1];
        UIColor *color3 = [UIColor colorWithRed:204.0/255 green:166.0/255 blue:31.0/255 alpha:1];
        UIColor *color4 = [UIColor colorWithRed:42.0/255 green:178.0/255 blue:192.0/255 alpha:1];
        UIColor *color5 = [UIColor colorWithRed:184.0/255 green:57.0/255 blue:52.0/255 alpha:1];


        _arrBarLineColor = [NSArray arrayWithObjects:color1,color2,color3,color4,color5, nil];

        _imgvBarBottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 147* kFixed_rate, 1024 * kFixed_rate, 6 *kFixed_rate)];
        _imgvBarBottomLine.backgroundColor = color1;
        [self.view addSubview:_imgvBarBottomLine];


        [self congigureNavSegmentView];

        selfxwTabBarViewController = self;

    }
    return self;
}


- (void)setImgBackground:(UIImage *)imgBackground{
    if (imgBackground) {
        self.imgvBackground.image = imgBackground;
    }
}

- (void)setItem:(XWSegmentItem *)itemInfo atIndex:(NSInteger)index{
    if (self.arrsegmentItem.count > index) {
        [self.arrsegmentItem replaceObjectAtIndex:index withObject:itemInfo];
    }
}

- (void)congigureNavSegmentView{

    XWSegmentItem *characterItem    = [[XWSegmentItem alloc] init];
    XWSegmentItem *radicalItem      = [[XWSegmentItem alloc] init];
    XWSegmentItem *phoneticItem     = [[XWSegmentItem alloc] init];
    XWSegmentItem *collectionItem   = [[XWSegmentItem alloc] init];
    XWSegmentItem *poemItem         = [[XWSegmentItem alloc] init];
    XWSegmentItem *yizijingItem     = [[XWSegmentItem alloc] init];
    XWSegmentItem *notebookItem     = [[XWSegmentItem alloc] init];
    XWSegmentItem *gameItem         = [[XWSegmentItem alloc] init];

    characterItem.title     = @"character";
    radicalItem.title       = @"radical";
    phoneticItem.title      = @"phonetic";
    collectionItem.title    = @"collection";
    poemItem.title          = @"poem";
    yizijingItem.title      = @"yizijing";
    notebookItem.title      = @"notebook";
    gameItem.title          = @"game";

    NSArray *arrayItem = @[characterItem,radicalItem,phoneticItem,collectionItem,poemItem,yizijingItem,notebookItem,gameItem];
    for (int i=0; i<arrayItem.count; i++) {
        XWSegmentItem *segItem = arrayItem[i];
        NSString *imgNormal     = [NSString stringWithFormat:@"bar_d%d",i+1];
        NSString *imgSelected   = [NSString stringWithFormat:@"1-%d",i+1];
        NSString *imgHighlight  = [NSString stringWithFormat:@"bar_d%d",i+1];
        segItem.imgNormal       = imgNormal;
        segItem.imgSelected     = imgSelected;
        segItem.imgHighlight    = imgHighlight;
    }

    self.navSegMentView = [[XWNavSegmentView alloc] initWithFrame:CGRectMake(0,40 * kFixed_rate,[UIScreen mainScreen].bounds.size.width, 80) segmentItemArr:arrayItem];
    self.navSegMentView.delegate = self;
    [_imgvBackground addSubview:_navSegMentView];

}
- (void)xwNavSegment:(XWNavSegmentView *)navSegmentView didSelectedIndex:(NSInteger)selectedIndex{
    [self setSelectedIndex:selectedIndex];
    if (selectedIndex<5)
        _imgvBarBottomLine.backgroundColor = [_arrBarLineColor objectAtIndex:selectedIndex];
    else
        _imgvBarBottomLine.backgroundColor = [UIColor clearColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
