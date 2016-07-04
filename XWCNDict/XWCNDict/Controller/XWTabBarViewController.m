//
//  XWTabBarViewController.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/3.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWTabBarViewController.h"
#import "XWSetInfo.h"


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
        XWSetInfo *_setInfo = [XWSetInfo shareSetInfo];

        _imgvBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0,20 * kFixed_rate,1024 * kFixed_rate,133 *kFixed_rate)];
        _imgvBackground.exclusiveTouch  = YES;
        _imgvBackground.backgroundColor = [UIColor orangeColor];
        _imgvBackground.userInteractionEnabled = YES;
        [self.view addSubview:_imgvBackground];

        _arrBarLineColor = [NSArray arrayWithObjects:_setInfo.themeColorCharacter,
                            _setInfo.themeColorRadical,
                            _setInfo.themeColorPhonetic,
                            _setInfo.themeColorCollection,
                            _setInfo.themeColorPoems,nil];

        _imgvBarBottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 147* kFixed_rate, 1024 * kFixed_rate, 6 *kFixed_rate)];
        _imgvBarBottomLine.backgroundColor = _setInfo.themeColorCharacter;
        [self.view addSubview:_imgvBarBottomLine];


        [self congigureNavSegmentView];

        selfxwTabBarViewController = self;


        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToCharacterViewController) name:kNotiNameCollection_JumpTo_CharacterVC object:nil];

    }
    return self;
}

- (void)jumpToCharacterViewController
{
    [self setSelectedIndex:0];
    [self.navSegMentView setSelectedIndex:0];
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

    characterItem.title     = @"Character";
    radicalItem.title       = @"Radical Index";
    phoneticItem.title      = @"Phonetic Index";
    collectionItem.title    = @"My Collection";
    poemItem.title          = @"Poems";
    yizijingItem.title      = @"Yizijing";
    notebookItem.title      = @"Notebook";
    gameItem.title          = @"Game";

    NSArray *arrayItem = @[characterItem,radicalItem,phoneticItem,collectionItem,poemItem]; //,yizijingItem,notebookItem,gameItem];
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


- (void)setBarHidden:(BOOL)hidden
{
    if (hidden) {
        [self.imgvBackground setHidden:YES];
        [self.imgvBarBottomLine setHidden:YES];
    }else{
        [self.imgvBackground setHidden:NO];
        [self.imgvBarBottomLine setHidden:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
