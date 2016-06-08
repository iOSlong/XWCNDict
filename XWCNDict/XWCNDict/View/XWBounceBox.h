//
//  XWBounceBox.h
//  XWProDict
//
//  Created by 龙学武 on 16/6/6.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWDictBtn.h"

@interface Arrow : UIView

@end





@interface XWBounceBox : UIView

-(void)moveArrowCenterAtPoint:(CGPoint )point;

-(void)reloadInfoWithRadicalArr:(NSArray *)r_c_pArr;

-(void)reloadInfoWithpinyinArr:(NSArray *)char_pinArr;

float getBigestFromArray(float *a);


@end
