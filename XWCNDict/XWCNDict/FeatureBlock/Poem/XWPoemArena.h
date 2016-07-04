//
//  XWPoemArena.h
//  XWCNDict
//
//  Created by xw.long on 16/7/4.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWPoem.h"
#import "XWPoemWordBtn.h"

@class XWPoemArena;

@protocol XWPoemArenaDelegate <NSObject>

@optional

-(void)poemStagePlayingOver:(XWPoemArena *)poemArena;

-(void)poemStageReadyPlaying:(XWPoemArena *)poemArena;

@end

@interface XWPoemArena : UIView

@property(nonatomic,retain)id<XWPoemArenaDelegate>delegate;

@property(nonatomic,retain)XWPoem *poem;


@property(nonatomic,assign)float drawSpeed;


@property(nonatomic,retain)UIColor *charColor;


@property(nonatomic,assign)BOOL strokeSound;

@property(nonatomic,assign)BOOL characterSound;

@property(nonatomic,assign)float volume;


@property(nonatomic,assign)BOOL playingOver;


@property(nonatomic,assign)BOOL playingPause;


@property(nonatomic,assign)BOOL inReady;    //表示开始了字符初始化
@property(nonatomic,assign)BOOL haveReady;  //表示字符初始化完成
@property(nonatomic,assign)BOOL canDelegate;//速度太快时候，代理执行印象暂停效果，特设此变量


-(void)poemStageActive;


-(void)poemStagPause;


-(void)poemStagContinue;


//得到诗歌静态字符。
-(void)poemStageGetStaticView:(UIColor *)color;



@end
