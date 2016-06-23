//
//  XWPinyinInfoView.h
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PinyinBlock)(NSString *fontChar, NSString *pinyin);

@interface XWPinyinInfoView : UIView

@property (nonatomic, copy) PinyinBlock PYBlock;

- (void)reloadPinyinWith:(NSString *)fontChar pinyin:(NSString *)pinyin;

- (void)pinyinInfo:(PinyinBlock) thisBlock;

@end
