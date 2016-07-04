//
//  XWPoemSetView.h
//  XWCNDict
//
//  Created by xw.long on 16/7/4.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWColorKeyBoard.h"
#import "XWPoemArena.h"

@interface XWPoemSetView : UIView
{
    void(^PoemSetVolumeCallback)(XWPoemSetView *poemset);
    void(^PoemSetVoiceCallback)(XWPoemSetView *poemset);
}

-(void)poemSetVolumeCallBackFunc:(void(^)(XWPoemSetView *poemset))thiscallback;

-(void)poemSetVoiceCallBackFunc:(void(^)(XWPoemSetView *poemset))thiscallback;

@property(nonatomic,retain)NSArray *poemStageArray;

@property(nonatomic,assign)float volume;
@property(nonatomic,assign)BOOL voiceOpen;

@end
