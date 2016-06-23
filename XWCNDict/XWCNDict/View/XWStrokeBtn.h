//
//  XWStrokeBtn.h
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWStrokeBtn : UIButton

@property (nonatomic, strong) UILabel *labelIndex;

@property (nonatomic, strong) NSString *labelTitle;

- (void)setSelectedImg:(UIImage *)image;

- (void)setNormalImg:(UIImage *)image;

- (void)makeSureIndexLabelShow;


@end
