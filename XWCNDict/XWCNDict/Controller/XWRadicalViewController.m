//
//  XWRadicalViewController.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/4.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWRadicalViewController.h"
#import "RadicalPinyinDict.h"
#import "XWBounceBox.h"
#import "PlistReader.h"

@interface XWRadicalViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) XWBounceBox *bounceBox;
@property (nonatomic, strong) NSArray *rootKeys;
@property (nonatomic, strong) NSDictionary *rootDict;
@property (nonatomic, strong) NSMutableArray *arrRadical;
@property (nonatomic, strong) NSMutableArray *arrDictBtn;
@property (nonatomic, strong) NSMutableArray *arrTitle;


@end

@implementation XWRadicalViewController{
    XWDictBtn *_tempDictBtn;
    CGFloat span_l,span_r,span_up,span_down;
    CGFloat box_span;

    int direction;//{1.右侧弹出，2左侧弹出，3上方弹出，4下方弹出}
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [_tempDictBtn setSelected: NO];
    [_bounceBox setHidden:YES];
    _tempDictBtn = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.textfield resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];

    [self configureSectionPlatView];

    self.textfield.delegate = self;
}

- (void)configureSectionPlatView {
    self.platViewModel = XWPlatViewModelRadical;
    
    self.scrollView.frame = CGRectMake(0, kupSpan, kPlat_W, kPlat_H-112*kFixed_rate);
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionPlatScrollTap:)]];
    self.scrollView.delegate = self;
    [self.sectionPlatView addSubview:self.scrollView];


    UILabel *infolabel  = [[UILabel alloc] initWithFrame:CGRectMake(78 * kFixed_rate, 198 * kFixed_rate, 300 *kFixed_rate, 30 *kFixed_rate)];
    [infolabel setTextColor:[UIColor lightGrayColor]];
    infolabel.text = @"Please select radical to start";

    //    UIFont *font = [UIFont fontWithName:@"STZhuankai" size:25];
    //    infolabel.font = font;
    [infolabel setFont:[UIFont fontWithName:@"Arail" size:25*kFixed_rate]];



    [self.view addSubview:infolabel];



    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn setFrame:CGRectMake(905 * kFixed_rate, 680*kFixed_rate, 30*kFixed_rate, 30*kFixed_rate)];
    [infoBtn setBackgroundImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [self.view addSubview:infoBtn];


    self.bounceBox = [[XWBounceBox alloc] initWithFrame:CGRectMake(50, 50, 200, 100)];
    [self.sectionPlatView addSubview:self.bounceBox];
    [self.bounceBox setHidden:YES];


    [self getDataDisplay];


}

- (void)getDataDisplay {
    RadicalPinyinDict *_RPD = [RadicalPinyinDict shareRadicalPinyinDict];
    _rootDict = _RPD.radicalRootDict;
    _rootKeys = _RPD.radicalRootKeys;

    _arrTitle = [[NSMutableArray alloc] initWithCapacity:0];
    _arrRadical = [[NSMutableArray alloc] init];

//    for (NSString *alpha in _rootKeys)
//    {
//        NSDictionary *blankDict = [_rootDict objectForKey:alpha];
//        NSArray *pinyinArr = [blankDict allKeys];
//        [_arrPinyin addObject:pinyinArr];
//    }

    [self displayDictBtn];
}

#define kDictBtnH   (30 * kFixed_rate)
#define kDictBtnW   (70 * kFixed_rate)
-(void)displayDictBtn
{
    CGFloat lastPosition = 0;
    _arrDictBtn = [NSMutableArray array];
    _arrTitle   = [NSMutableArray array];

    for (int i=0; i<_rootKeys.count; i++)
    {
        NSString *key = [_rootKeys objectAtIndex:i];
        NSDictionary *rDict = [_rootDict objectForKey:key];
        NSArray *rArr = [rDict allKeys];

        CGFloat relativePosition = 0;

        for (int j=0; j<rArr.count; j++)
        {
            NSString *radical = [rArr objectAtIndex:j];
            if (radical.length>1) {
                radical = [radical quanjiaoToBanjiao];
            }
            NSMutableString *title = [NSMutableString stringWithString:radical];
            [title appendString:@"部"];

            CGRect rect = CGRectMake(350/2*kFixed_rate +35+j%8*(kDictBtnW+5), j/8*(kDictBtnH+4)+lastPosition+1, kDictBtnW, kDictBtnH);
            XWDictBtn *btn = [[XWDictBtn alloc] initWithFrame:rect];

            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"STZhuanhei" size:19 * kFixed_rate];

            btn.superKey = [_rootKeys objectAtIndex:i];
            btn.key = [rArr objectAtIndex:j];
            btn.selected = NO;

            [btn addTarget:self action:@selector(rbtnClick:) forControlEvents:UIControlEventTouchUpInside];


            [self.scrollView addSubview:btn];

            [_arrDictBtn  addObject:btn];;


            relativePosition = (j/6+1)*(kDictBtnH+2)+40;
        }

        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, lastPosition+relativePosition)];


        UILabel *Numlabel  = [[UILabel alloc] initWithFrame:CGRectMake(50, lastPosition, 100, 30)];
        [self.scrollView addSubview:Numlabel];
        [_arrTitle addObject:Numlabel];

        [Numlabel setFont:[UIFont fontWithName:@"STZhuanhei" size:20]];
        Numlabel.textAlignment = NSTextAlignmentRight;
        Numlabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        Numlabel.text = [NSString stringWithFormat:@"%@画",[_rootKeys objectAtIndex:i]];
        lastPosition += relativePosition;

    }

}

- (void)rbtnClick:(XWDictBtn *)btn {
    NSLog(@"%@",btn.superKey);

    CGFloat Animationweitiao = 0;
    if (btn.center.y-self.scrollView.contentOffset.y >= (kPlat_H-110)-btn.frame.size.height/2) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y+20) animated:YES];
        Animationweitiao = 20;
    }
    if (btn.center.y-self.scrollView.contentOffset.y <= btn.frame.size.height/2) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y-20) animated:YES];
        Animationweitiao  = -20;
    }





    if (_tempDictBtn == btn) {

    }else{
        [_tempDictBtn setSelected:NO];
        [btn setSelected:YES];
        _tempDictBtn = btn;
    }


    [self.sectionPlatView bringSubviewToFront:self.bounceBox];
    [self.bounceBox setHidden:NO];

    _bounceBox.frame = CGRectMake(0, 0, 100*(arc4random()%3+1), 50*(arc4random()%6+1));

#pragma mark - giveSome dict infoArr
    PlistReader *_PR = [PlistReader sharePlistReader];
    NSArray *charpinArr = [_PR getCategoryCharPinyinByRadical:btn.key];
    [self.bounceBox reloadInfoWithRadicalArr:charpinArr];




    CGFloat alert_h = _bounceBox.frame.size.height;
    CGFloat alert_w = _bounceBox.frame.size.width;


    CGFloat db_w = btn.frame.size.width;
    CGFloat db_h = btn.frame.size.height;
    CGFloat bbspan = 20;  //bouncedBox 与按钮边框的距离
    CGPoint relativeCenter = CGPointMake(btn.center.x, btn.center.y-self.scrollView.contentOffset.y+kupSpan-Animationweitiao);



    span_l = btn.center.x - kLeftSpan;
    span_r = kPlat_W - relativeCenter.x;
    span_up = relativeCenter.y;
    span_down = kPlat_H - relativeCenter.y;

    //    printf("%3.1f,\t%3.2f,\t%3.2f,\t%3.2f\n",span_l,span_r,span_up,span_down);

    float a[4] = {span_l/(kPlat_W-kLeftSpan),span_r/(kPlat_W-kLeftSpan),span_up/kPlat_H,span_down/kPlat_H};

    direction = getBigestFromArray(a);

    if (direction==1) {
        CGPoint origin = CGPointMake(relativeCenter.x-db_w/2-bbspan, relativeCenter.y);
        //调整参数计算
        CGFloat upweitiao = alert_h*((span_up/span_down)/(span_up/span_down+1));

        _bounceBox.center = CGPointMake(origin.x-alert_w/2, origin.y+(alert_h/2-upweitiao));
        [_bounceBox moveArrowCenterAtPoint:CGPointMake(alert_w+5, alert_h/2-(_bounceBox.center.y-relativeCenter.y))];


    }else if (direction==2){
        CGPoint origin = CGPointMake(relativeCenter.x+db_w/2+bbspan, relativeCenter.y);
        CGFloat upweitiao = alert_h*((span_up/span_down)/(span_up/span_down+1));
        _bounceBox.center = CGPointMake(origin.x+alert_w/2, origin.y+(alert_h/2-upweitiao));
        [_bounceBox moveArrowCenterAtPoint:CGPointMake(-5, alert_h/2-(_bounceBox.center.y-relativeCenter.y))];


    }
    else if(direction==3)
    {
        CGPoint origin = CGPointMake(relativeCenter.x, relativeCenter.y-db_h/2-bbspan);
        CGFloat leftweitiao = alert_w*((span_l/span_r)/(span_l/span_r+1));
        _bounceBox.center = CGPointMake(origin.x+(alert_w/2-leftweitiao), origin.y-alert_h/2);
        [_bounceBox moveArrowCenterAtPoint:CGPointMake(alert_w/2-(_bounceBox.center.x-btn.center.x), alert_h+5)];


    }else if (direction==4){
        CGPoint origin = CGPointMake(relativeCenter.x, relativeCenter.y+db_h/2+bbspan);
        CGFloat leftweitiao = alert_w*((span_l/span_r)/(span_l/span_r+1));

        _bounceBox.center = CGPointMake(origin.x+(alert_w/2-leftweitiao), origin.y+alert_h/2);
        [_bounceBox moveArrowCenterAtPoint:CGPointMake(alert_w/2-(_bounceBox.center.x-btn.center.x), -5)];

    }

}


#pragma mark - SearchBar Events
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];


    if (!self.textfield.text.length) {
        return YES;
    }
    [self doSearchLocation:self.textfield.text];


    self.textfield.text = nil;


    return YES;
}


#pragma mark - ReImplement SuperMethods

- (void)searchBtn:(UIButton *)btn
{

    [self.textfield resignFirstResponder];
    //    printf("char:%s\n",[tf.text UTF8String]);

    if (!self.textfield.text.length) {
        return;
    }

    [self doSearchLocation:self.textfield.text];


    self.textfield.text = nil;
}

//- (void)setGearBtn:(UIButton *)btn
//{
//
//}


-(void)doSearchLocation:(NSString *)title;
{
    [_bounceBox setHidden:YES];
    [_tempDictBtn setSelected:NO];
    _tempDictBtn = nil;


    if ([@"ABCDEFGHIJKLMNOPQRSTUVWXYZ" rangeOfString:title].length) {
        title = [title lowercaseString];
    }

    CGFloat location_y = -1;
    UILabel *titlelabel;
    //判断操作
    for (UILabel *label  in _arrTitle)
    {
        if ([label.text rangeOfString:title].length)
        {
            location_y = label.frame.origin.y;
            titlelabel = label;
            break;
        }
    }

    for (UILabel *label in _arrTitle) {
        [label setFont:[UIFont fontWithName:@"Arial" size:25]];

        label.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    }


    //进行跳转判断
    if (location_y>=0)
    {
        [self.scrollView setContentOffset:CGPointMake(0, location_y) animated:YES];

        [titlelabel setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];

        //        [titlelabel setFont:[UIFont fontWithName:@"Arial" size:30]];
        [titlelabel setFont:[UIFont boldSystemFontOfSize:35]];

    }

}


- (void)sectionPlatScrollTap:(UIGestureRecognizer *)tapG {
    //    CGPoint point = [tapG locationInView:tapG.view];
    //    printf("touch:{%3.2f,%3.2f}\n",point.x,point.y);

    [_bounceBox setHidden:YES];
    [_tempDictBtn setSelected:NO];
    _tempDictBtn = nil;

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_bounceBox setHidden:YES];
    [_tempDictBtn setSelected:NO];
    _tempDictBtn = nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_bounceBox setHidden:YES];
    [_tempDictBtn setSelected:NO];
    _tempDictBtn = nil;
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat location_y = scrollView.contentOffset.y;
    for (XWDictBtn *db in _arrDictBtn) {
        if (fabs(db.frame.origin.y-location_y)<=30) {
            location_y = db.frame.origin.y;
            break;
        }
    }
    [self.scrollView setContentOffset:CGPointMake(0, location_y) animated:YES];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat location_y = scrollView.contentOffset.y;
    
    
    for (XWDictBtn *db in _arrDictBtn) {
        if (fabs(db.frame.origin.y-location_y)<=30) {
            location_y = db.frame.origin.y;
            break;
        }
    }
    [self.scrollView setContentOffset:CGPointMake(0, location_y) animated:YES];
}


@end
