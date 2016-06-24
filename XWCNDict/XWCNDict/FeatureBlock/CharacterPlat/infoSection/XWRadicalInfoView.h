//
//  XWRadicalInfoView.h
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RadicalBlock)(NSString *fontChar);

@interface XWRadicalInfoView : UIView

@property (nonatomic, copy) RadicalBlock RBlock;

- (void)radicalInfo:(RadicalBlock)thisBlock;

- (void)reloadRadicalWith:(NSString *)fontChar;

@end
