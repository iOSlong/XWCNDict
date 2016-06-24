//
//  XWRadicalBtn.m
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWRadicalBtn.h"

@implementation XWRadicalBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel.font = [UIFont fontWithName:@"STZhuankai" size:frame.size.width/1.5];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.layer.cornerRadius = rect.size.width*0.5;
    self.layer.backgroundColor =[UIColor colorWithRed:121.0/255 green:199.0/255 blue:56.0/255 alpha:1].CGColor;
}

#pragma mark - reWrite some method of UIControl

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{

    self.layer.shadowRadius = self.frame.size.width*0.1;
    self.layer.shadowColor = [UIColor colorWithRed:25.0/255 green:141.0/255 blue:200.0/255 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 1;
    self.layer.backgroundColor = [UIColor colorWithRed:151.0/255 green:119.0/255 blue:56.0/255 alpha:1].CGColor;

    [self performSelector:@selector(showNormalState) withObject:self afterDelay:2.0f];

    return YES;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.layer.shadowRadius = 0;

    self.layer.backgroundColor = [UIColor colorWithRed:121.0/255 green:199.0/255 blue:56.0/255 alpha:1].CGColor;

    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)showNormalState
{
    self.layer.shadowRadius = 0;

    self.layer.backgroundColor = [UIColor colorWithRed:121.0/255 green:199.0/255 blue:56.0/255 alpha:1].CGColor;
    
}


@end
