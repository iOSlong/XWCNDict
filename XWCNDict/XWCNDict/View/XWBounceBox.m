//
//  XWBounceBox.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/6.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWBounceBox.h"
#import "AppDelegate.h"
#import "XWSetInfo.h"

@implementation Arrow

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *path = [UIBezierPath bezierPath];

    [path moveToPoint:CGPointMake(rect.size.width/2, 0)];

    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];

    [path addCurveToPoint:CGPointMake(0, rect.size.height) controlPoint1:CGPointMake(rect.size.width/2, rect.size.height) controlPoint2:CGPointMake(rect.size.width/2, rect.size.height)];

    [path closePath];

    [[UIColor colorWithRed:25.0/255 green:141.0/225 blue:200.0/255 alpha:1] setStroke];
    [[UIColor colorWithRed:25.0/255 green:141.0/225 blue:200.0/255 alpha:1] setFill];
    [path stroke];
    [path fill];

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.4;

    //    self.layer.shadowPath = [];
    
}

@end




@interface XWBounceBox ()
@property (nonatomic, strong) Arrow *arrow;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger row,column;
@property (nonatomic, assign) CGFloat btnW,btnH;
@end


#define kArrowW (20.0 * kFixed_rate)
#define kArrowH (18.0 * kFixed_rate)    //箭头

//默认情况下按钮的边长
#define kbtnW   100.0f
#define kbtnH   30.0f

#define kspanH  5
#define kspanW  3//按钮大小和间距

#define kMaxHeight (kbtnH+kspanH)*6
#define kMinHeight (kbtnH+2*kspanH)*2  //弹框高度

@implementation XWBounceBox

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 7;
        self.layer.borderColor = [UIColor colorWithRed:25.0/255 green:141.0/225 blue:200.0/255 alpha:1].CGColor;
        self.layer.cornerRadius = self.frame.size.height*0.1;

        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity: 0.5];
        [self.layer setShadowOffset:CGSizeMake(-2,8)];
        [self.layer setShadowRadius:5];

        _arrow = [[Arrow alloc] initWithFrame:CGRectMake(0, 0, kArrowW, kArrowH)];
        _arrow.backgroundColor = [UIColor clearColor];
        _arrow.center = CGPointMake(30, -5);

        [self addSubview:_arrow];


        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 2, self.frame.size.width, self.frame.size.height-5)];
        _scrollView.layer.cornerRadius = self.layer.cornerRadius;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.backgroundColor = [UIColor colorWithRed:48.0/255 green:52.0/255 blue:55.0/255 alpha:1];
        [self addSubview:_scrollView];

    }
    return self;
}


-(void)moveArrowCenterAtPoint:(CGPoint)point
{
    _arrow.center = point;
    CGFloat rotateAngle = 0;

    if (point.x==self.frame.size.width+5) {
        rotateAngle = M_PI/2;
    }//左侧
    if (point.x==-5) {
        rotateAngle = -M_PI/2;
    }//右侧
    if (point.y==self.frame.size.height+5) {
        rotateAngle = M_PI;
    }//上侧
    if (point.y==-5) {
        rotateAngle = 0;
    }//下侧

    CGAffineTransform transform = CGAffineTransformIdentity;
    CGAffineTransform rotationTransform = CGAffineTransformRotate(transform, rotateAngle);
    _arrow.transform = rotationTransform;

}


#define kBounceBoxUpSpan 15.0f
#define kleftSpan 20.0f
#pragma mark - 部首数组查找
-(void)reloadInfoWithRadicalArr:(NSArray *)r_c_pArr;
{
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    _column = 3;
    if (r_c_pArr.count<=2) {
        [self adjustFrameWithNewHeight:150];

    }else if(r_c_pArr.count<=4)
    {
        [self adjustToBigestheight];
    }else
    {
        [self adjustToWidest];
    }

    CGFloat lastPosition_y = 0;


    for ( int i=0; i<r_c_pArr.count; i++) {
        NSString *title = [[[r_c_pArr objectAtIndex:i] allKeys] lastObject];
        //        NSLog(@"%@",title);
        NSArray *detail = [[r_c_pArr objectAtIndex:i] objectForKey:title];


        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kleftSpan,kBounceBoxUpSpan+lastPosition_y, 120, 30)];
        [label setFont:[UIFont systemFontOfSize:20]];
        [label setTextColor:[UIColor colorWithRed:215.0/255 green:121.0/255 blue:21.0/255 alpha:1]];
        label.text = title;

        [_scrollView addSubview:label];

        CGFloat relative_y = 0;
        for (int j=0; j<detail.count; j++)
        {
            CGRect rect = CGRectMake(kleftSpan+j%_column*(kbtnW+5),kBounceBoxUpSpan+lastPosition_y+j/_column*(kbtnH+5)+30, kbtnW+3, kbtnH);

            XWDictBtn *dbtn = [[XWDictBtn alloc] initWithFrame:rect];
            dbtn.key = [[detail objectAtIndex:j] substringToIndex:1];

//            dbtn.titleLabel.font = [UIFont fontWithName:@"STZhuankai" size:18];
//            [dbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            NSString *content = [detail objectAtIndex:j];

            [dbtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [dbtn setTitle:content forState:UIControlStateNormal];
            [dbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [dbtn setBackgroundColor:[UIColor clearColor]];
            dbtn.frame = rect;
            //            dbtn.selected = NO;

            [dbtn addTarget:self action:@selector(dbtnClick:) forControlEvents:UIControlEventTouchUpInside];

            dbtn.superKey = [detail objectAtIndex:j];

            relative_y = (kbtnH+5)*(j/_column)+2*label.frame.size.height;
            //            NSLog(@"%@",[detail objectAtIndex:j]);

            [_scrollView addSubview:dbtn];
            [_scrollView setContentSize:CGSizeMake(self.frame.size.width, relative_y+lastPosition_y+30)];

        }

        lastPosition_y += relative_y;
        if (detail.count==0) {
            lastPosition_y +=label.frame.size.height;
        }
    }

    self.frame = CGRectMake(100, 20, self.frame.size.width, self.frame.size.height);
    [_scrollView setContentOffset:CGPointMake(0, 0)];
}
-(void)dbtnClick:(XWDictBtn *)db
{
    [XWSetInfo shareSetInfo].fontCharShow = db.key;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiNameCollection_JumpTo_CharacterVC object:nil];
}

#pragma mark - 拼音查找
-(void)reloadInfoWithpinyinArr:(NSArray *)char_pinArr
{
    //    NSLog(@"%@",char_pinArr);
    _column = 3;
    NSInteger count = char_pinArr.count;
    if (count<=20) {
        _column = 3;
    }else{
        _column = 4;
        [self adjustToWidest];
    }
    CGFloat height = (count/_column)*(kbtnH+kspanH)+10;
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }

    if (height<=kMaxHeight) {
        [self adjustFrameWithNewHeight:(110>height?110:height)];
    }else{
        [self adjustToBigestheight];
    }


    for (int i=0; i<count; i++) {
        NSArray *item = [char_pinArr objectAtIndex:i];
        NSString *title = [NSString stringWithFormat:@"%@(%@)",[item objectAtIndex:0],[item objectAtIndex:1]];

        CGRect rect = CGRectMake(5+kspanW+i%_column*(kbtnW+kspanW), 15+kspanH+(kbtnH+kspanH)*(i/_column), kbtnW, kbtnH);

        XWDictBtn *btn = [[XWDictBtn alloc] initWithFrame:rect];

//        btn.titleLabel.font = [UIFont fontWithName:@"STZhuankai" size:18];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [btn addTarget:self action:@selector(dbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.key = [item objectAtIndex:0];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.frame = rect;
        [btn setBackgroundColor:[UIColor clearColor]];
        [_scrollView addSubview:btn];
    }
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width, (kspanH+kbtnH)*(1+(count/_column))+kspanH+25)];
    [_scrollView setContentOffset:CGPointMake(0, 0)];
}

-(void)adjustToBigestheight
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, (kbtnW+kspanW)*_column+5*2+kspanW, kMaxHeight);
    self.layer.cornerRadius = self.frame.size.height*0.1;


    [self.layer setShadowRadius:8];

    _scrollView.frame = CGRectMake(0, 2, self.frame.size.width, self.frame.size.height-5);
    _scrollView.layer.cornerRadius = self.layer.cornerRadius;

}
-(void)adjustToWidest
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,(kbtnW+kspanW)*3+5*2+kspanW+5+kbtnW, kMaxHeight);
    self.layer.cornerRadius = self.frame.size.height*0.1;


    [self.layer setShadowRadius:8];


    _scrollView.frame = CGRectMake(0, 2, self.frame.size.width, self.frame.size.height-5);
    _scrollView.layer.cornerRadius = self.layer.cornerRadius;

    _column = 4;
}
-(void)adjustFrameWithNewHeight:(CGFloat)height
{
    if (height<kMinHeight) {
        height = kMinHeight;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,(kbtnW+kspanW)*_column+5*2+kspanW, height);


    self.layer.cornerRadius = self.frame.size.height*0.1;



    [self.layer setShadowRadius:5];


    _scrollView.frame = CGRectMake(0, 2, self.frame.size.width, self.frame.size.height-5);
    _scrollView.layer.cornerRadius = self.layer.cornerRadius;
    
}

float getBigestFromArray(float *a)
{
    float temp = a[0];
    for (int i=1; i<4; i++)
    {
        if (temp<a[i]) {
            temp = a[i];
        }
    }

    for (int m=0; m<4; m++)
    {
        if (temp==a[m])
        {
            //            printf("temp = %3.2f,direction = %d\n",temp ,m+1);
            return m+1;
        }
    }
    return temp;
}

@end
