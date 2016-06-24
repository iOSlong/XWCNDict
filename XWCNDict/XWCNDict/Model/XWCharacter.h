//
//  XWCharacter.h
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface XWCharacter : NSManagedObject

@property (nonatomic, strong) NSString  *fontChar;
@property (nonatomic, strong) NSDate    *dateModify;
@property (nonatomic, strong) NSData    *dataImg;


@end
