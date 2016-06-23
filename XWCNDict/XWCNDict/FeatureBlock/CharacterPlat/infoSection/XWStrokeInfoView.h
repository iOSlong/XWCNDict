//
//  XWStrokeInfoView.h
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWStrokeInfoView : UIView

@property(nonatomic, strong) NSMutableArray     *strokeBtnArr;

@property(nonatomic, strong) NSMutableArray     *strokesImgArr;

@property(nonatomic, strong) UIScrollView       *scrollView;

- (instancetype)initWithFrame:(CGRect)frame andStrokeBtnCount:(NSInteger)count;

//得到一组图片用于选中效果图
- (void)getSelectedImgArray:(NSArray *)array;

//得到一组图片用于常态效果图
- (void)getNormalImgArray:(NSArray *)array;

//为成员strokeBtn添加两种状态的图片
- (void)getStrokesBtnReload;

@end
