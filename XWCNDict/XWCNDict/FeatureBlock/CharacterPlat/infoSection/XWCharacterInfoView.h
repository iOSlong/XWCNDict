//
//  XWCharacterInfoView.h
//  XWCNDict
//
//  Created by xw.long on 16/6/23.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CharInfoBlock)(NSString *charPinyin);

@interface XWCharacterInfoView : UIView

- (void)reloadCharacterWith:(NSString *)fontChar strokeNum:(int )strokeNum;

@property (nonatomic, strong) NSString *fontCharPinyin;

@property (nonatomic, copy) CharInfoBlock CIBlock;

- (void)charInfo:(CharInfoBlock )thisBlock;


@end
