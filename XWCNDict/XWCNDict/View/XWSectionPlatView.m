//
//  XWSectionPlatView.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/6.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWSectionPlatView.h"

@implementation XWSectionPlatView
{
    CAShapeLayer *_layerLeft;
    CAShapeLayer *_layerRight;
    UIBezierPath *_pathLeft;
    UIBezierPath *_pathRight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _leftSpan = self.frame.size.width * 0.25;

        _layerLeft = [[CAShapeLayer alloc] init];
        _layerRight = [[CAShapeLayer alloc] init];
        _layerLeft.fillColor = nil;
        _layerRight.fillColor = nil;
        _layerLeft.frame = self.bounds;
        _layerRight.frame = self.bounds;
        self.backgroundColor = [UIColor blueColor];

        [self.layer addSublayer:_layerLeft];
        [self.layer addSublayer:_layerRight];
    }
    return self;
}
- (void)setLeftLayer{
    _pathLeft = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, _leftSpan, self.frame.size.height)];
    _layerLeft.path = _pathLeft.CGPath;
}

- (void)setRightLayer{
    _pathRight = [UIBezierPath bezierPathWithRect:CGRectMake(_leftSpan, 0, self.frame.size.width - _leftSpan, self.frame.size.height)];
    _layerRight.path = _pathRight.CGPath;
}

- (void)setLeftSpan:(CGFloat)leftSpan {
    _leftSpan = leftSpan;

    [self setRightLayer];
    [self setLeftLayer];
}
- (void)setRightColor:(UIColor *)rightColor {
    _layerRight.fillColor = rightColor.CGColor;
    [self setRightLayer];
}
- (void)setLeftColor:(UIColor *)leftColor {
    _layerLeft.fillColor = leftColor.CGColor;
    [self setLeftLayer];
}


@end
