//
//  XWCharPlatSegment.h
//  XWCNDict
//
//  Created by xw.long on 16/6/10.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XWCharPlatSegmentDelegate <NSObject>

@optional
//设置选中元素项时候的代理函数。
-(void)selectSegmentWithIndex:(NSUInteger )index;


@end

@interface XWCharPlatSegment : UIView

//保存segmentController元素对象
@property(nonatomic,retain)NSMutableArray *segmentItems;

//标记选中元素项的索引。
@property(nonatomic,assign)NSInteger selectedIndex;

@property(nonatomic,retain)UIImageView *backImageView;

@property(nonatomic,assign)id<XWCharPlatSegmentDelegate>delegate;


//选中指定的元素项
-(void)setSelectedSegmentWithIndex:(NSUInteger )index;

//为指定元素项设定标题
-(void)setTitle:(NSString *)title withIndex:(NSUInteger )index;


@end
