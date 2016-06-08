//
//  XWNavSegmentView.h
//  XWProDict
//
//  Created by 龙学武 on 16/6/4.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWSegmentItem : NSObject
@property (nonatomic, strong) NSString *imgSelected;
@property (nonatomic, strong) NSString *imgHighlight;
@property (nonatomic, strong) NSString *imgNormal;
@property (nonatomic, strong) NSString *title;
@end



@protocol XWNavSegmentViewDelegate;

@interface XWNavSegmentView : UIView

@property (nonatomic, strong) UIImageView *imgvBackground;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) id <XWNavSegmentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame segmentItemArr:(NSArray *)segmentItemArr;
- (void)insertItemWith:(XWSegmentItem *)segmentItem atIndex:(NSInteger )index;
- (void)setItem:(XWSegmentItem *)item atIndex:(NSInteger)index;




@end



@protocol XWNavSegmentViewDelegate <NSObject>
@optional
- (void)xwNavSegment:(XWNavSegmentView *)navSegmentView didSelectedIndex:(NSInteger)selectedIndex;

@end
