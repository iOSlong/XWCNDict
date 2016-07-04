//
//  XWTabBarViewController.h
//  XWProDict
//
//  Created by 龙学武 on 16/6/3.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWNavSegmentView.h"

@interface XWTabBarViewController : UITabBarController<XWNavSegmentViewDelegate>
@property (nonatomic, strong) XWNavSegmentView  *navSegMentView;
@property (nonatomic, strong) NSMutableArray    *arrsegmentItem;
@property (nonatomic, strong, readonly) UIImageView       *imgvBackground;
@property (nonatomic, strong, readonly) UIImageView       *imgvBarBottomLine;
@property (nonatomic, strong, readonly) NSArray *arrBarLineColor;
@property (nonatomic, strong) UIImage           *imgBackground;


- (void)setItem:(XWSegmentItem *)itemInfo atIndex:(NSInteger)index;

- (void)setBarHidden:(BOOL )hidden;


@end


/// 利用类别添加成员变量。
@interface UIViewController (XWTabBarViewControllerSupport)

@property (nonatomic, strong, readonly)XWTabBarViewController * tabBarVC;

@end
