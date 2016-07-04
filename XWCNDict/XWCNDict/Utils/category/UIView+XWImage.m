//
//  UIView+XWImage.m
//  XWCNDict
//
//  Created by xw.long on 16/7/4.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "UIView+XWImage.h"

@implementation UIView (XWImage)

- (UIImage *)convertToImage
{
    UIGraphicsBeginImageContext(self.size);

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

@end
