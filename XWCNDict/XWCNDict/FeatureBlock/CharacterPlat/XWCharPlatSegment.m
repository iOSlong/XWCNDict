//
//  XWCharPlatSegment.m
//  XWCNDict
//
//  Created by xw.long on 16/6/10.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWCharPlatSegment.h"


@interface MySegBtn : UIButton

@property(nonatomic,retain)UILabel *mytextLabel;

@end

@implementation MySegBtn

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.mytextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/1.8)];
        self.mytextLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2+10);
        self.mytextLabel.textAlignment = NSTextAlignmentCenter;
        self.mytextLabel.textColor = [UIColor whiteColor];
        self.mytextLabel.font = [UIFont fontWithName:[[UIFont familyNames] objectAtIndex:27] size:15];
        [self addSubview:_mytextLabel];
    }
    return self;
}

@end





@implementation XWCharPlatSegment

{
    NSMutableArray *_normalImgsArr;
    NSMutableArray *_selectedImgsArr;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.segmentItems = [[NSMutableArray alloc] init];
        self.userInteractionEnabled = YES;
        [self getImgsArr];



        [self initUIItems];
    }
    return self;
}
-(void)getImgsArr
{

    //    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 836/2, 121/2)];
    ////    self.backImageView.image = [UIImage imageNamed:@"111(2).png"];
    //    [self addSubview:_backImageView];
    //    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 836/2, 121/2);
    _normalImgsArr = [[NSMutableArray alloc] init];
    _selectedImgsArr = [[NSMutableArray alloc] init];
    for (int i=1; i<5; i++)
    {
        UIImage *normalImg = [UIImage imageNamed:[NSString stringWithFormat:@"seg%d%d.png",i,i]];
        UIImage *selectImg = [UIImage imageNamed:[NSString stringWithFormat:@"seg%d.png",i]];
        [_normalImgsArr addObject:normalImg];
        [_selectedImgsArr addObject:selectImg];
    }
}

-(void)initUIItems
{
    CGFloat lastLoction = 0.0f;
    CGFloat segmentWidth = 0.0f;
    //
    float a[4] = {208.0/2,210.0/2,210.0/2,207.0/2};
    for ( int i=0; i<_selectedImgsArr.count; i++) {
        UIImage *normalImg = [_normalImgsArr objectAtIndex:i];
        UIImage *selectImg = [_selectedImgsArr objectAtIndex:i];
        CGFloat img_w = normalImg.size.width/2 * kFixed_rate;
        CGFloat img_h = normalImg.size.height/2 * kFixed_rate;

        MySegBtn *sgmBtn = [[MySegBtn alloc] initWithFrame:CGRectMake(lastLoction, 10 * kFixed_rate, a[i] * kFixed_rate, img_h)];
        [sgmBtn setImage:normalImg forState:UIControlStateNormal];
        [sgmBtn setImage:selectImg forState:UIControlStateSelected];
        [sgmBtn setFrame:CGRectMake(lastLoction, 0, img_w, img_h)];
        sgmBtn.tag = kGetTagFromIndex(i);
        [sgmBtn addTarget:self action:@selector(sgmbtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        [self.segmentItems addObject:sgmBtn];
        [self addSubview:sgmBtn];
        lastLoction += a[i] * kFixed_rate;
        segmentWidth = img_h;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, lastLoction, segmentWidth);
    [self setSelectedSegmentWithIndex:0];
}

//点击按钮发生
-(void)sgmbtnClicked:(MySegBtn *)sender
{
    NSInteger index = kGetIndexFromTag(sender.tag);
    sender.selected = !sender.selected;
    [self setSelectedSegmentWithIndex:index];
    if ([self.delegate respondsToSelector:@selector(selectSegmentWithIndex:)]) {
        [self.delegate selectSegmentWithIndex:index];
    }
}

-(void)setSelectedSegmentWithIndex:(NSUInteger)index
{
    if (index>=self.segmentItems.count) {
        return;
    }
    for (MySegBtn *btn in self.segmentItems) {
        btn.selected = NO;
    }
    ((MySegBtn *)[self.segmentItems objectAtIndex:index]).selected = YES;
    self.selectedIndex = index;
}

-(void)setTitle:(NSString *)title withIndex:(NSUInteger)index
{
    MySegBtn *msb = [self.segmentItems objectAtIndex:index];
    [msb.mytextLabel setText:title];
}



@end
