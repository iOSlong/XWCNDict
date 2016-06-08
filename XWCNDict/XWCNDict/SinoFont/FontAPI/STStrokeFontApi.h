//
//  STStrokeFontApi.h
//  STSinoFont_0527
//
//  Created by imac_06 on 14-5-27.
//  Copyright (c) 2014年 xuewu. All rights reserved.
//

#ifndef STSinoFont_0527_STStrokeFontApi_h
#define STSinoFont_0527_STStrokeFontApi_h



#pragma once
#include "WinDef.h"

struct STStrokeSect
{
	int direction; // 笔画段方向，共分为1-8八个方向：
    // 1: 从左到右
    // 2: 从左上到右下
    // 3: 从上到下
    // 4: 从右上到左下
    // 5: 从右到左
    // 6: 从右上到左下
    // 7: 从下到上
    // 8: 从左下到右上
    
	int startX; // 笔画段的外框起点X坐标
	int startY; // 笔画段的外框起点Y坐标
    // 外框起点根据笔画段方向确定，字符左上角为原点(0,0)
	int endX; // 笔画段的外框终点X坐标
	int endY; // 笔画段的外框终点Y坐标
    // 外框终点根据笔画段方向确定，字符左上角为原点(0,0)
	int animationTime; // 笔画段的绘制速度信息
	int animationStep; // 笔画段的绘制步长信息，一般为1
	int stopTime; // 该笔画段与下一笔画段之间的间隔时间
	int isRadical; // 0表示不是部首笔画段，1表示是部首笔画段
	int strokeType1; // 0表示与上一笔画段为同一笔画，1表示横，2表示竖，3表示撇，4表示捺，5表示折
	int strokeType2; // 与strokeType1组合为strokeType1_strokeType2的形式表示详细笔画类型，具体见附表。
};



struct STCharStrokes
{
    int num; // 笔画段的数量
    UINT charCode; // 字符的Unicode编码
    UINT radicalCode; // 字符的部首的Unicode编码
    int strokeNum; // 字符的笔画数
    int w; // 字符的宽度
    int h; // 字符的高度
    STStrokeSect *pStrokeSects; // 字符所包含的笔画段信息，共num个
	BYTE** pStrokeSectBmp; // 字符笔画段对应的灰度位图Buf，共num个，每个大小为w*h字节，灰度级别为16级，即每个字节对应一个像素，其值为0-16，0表示全透明，16表示不透明
    // 此位图Buf仅包含当前笔画段的点阵信息
	BYTE** pAnimationBmp; // 字符笔画段对应的动态绘制所需的灰度位图Buf，共num个，每个大小为w*h字节，灰度级别为16级，即每个字节对应一个像素，其值为0-16，0表示全透明，16表示不透明
    // 此位图Buf包含了当前笔画段以及笔顺在当前笔画段之前的所有笔画段的点阵信息
};

/*
 函数说明：
 获取指定字符指定大小的所有笔画段信息
 参数：
 code 字符的Unicode编码
 w 字符的宽度
 h 字符的高度
 fontfile 属性字库数据文件的路径
 mappingfile 属性字库码表文件的路径
 返回值：
 STCharStrokes结构体的指针，包含字符所对应的相关信息，使用完成后需调用STDestoryCharStrokes函数进行销毁
 */
extern struct STCharStrokes* STGetCharStrokes(UINT code, int w, int h, const TCHAR* fontfile, const TCHAR* mappingfile,BOOL thousandBase);
/*
 函数说明：
 释放STCharStrokes结构体所占用的内存空间
 参数：
 pStrokes 指向要释放的STCharStrokes结构体指针的指针
 */
extern void STDestoryCharStrokes(struct STCharStrokes** pStrokes);

//=====================

const int nSpeedBase=100;

struct STAnimationInfo
{
	STCharStrokes* pStrokes; // 要绘制的字符对应的笔画段信息
	int* pCurPosX; // 储存动态绘制过程中使用的每个笔画段对应的当前位置X坐标，大小为pStrokes->num个
	int* pCurPosY; // 储存动态绘制过程中使用的每个笔画段对应的当前位置Y坐标，大小为pStrokes->num个
	int nCurState; // 当前绘制状态，0表示停止，1表示正在绘制，2表示暂停
	int nCurSectIndex; // 当前正在绘制的笔画段index
    //	DWORD nTimerID; // 字符动态绘制的定时器
    NSTimer *timer;
	int nSpeed; // 动态绘制速度参数，范围1到200，数值越大速度越慢，标准速度为100
	bool bPauseByStroke; // 是否按笔画暂停
	BYTE* pDrawBuf; // 动态绘制时使用的显示输出灰度Buf，动态绘制的原理就是每次定时器执行时更新该Buf内容，并输出至屏幕显示，大小为pStrokes->w*pStrokes->h字节
    //	HDC hDC; // 绘制的DC
	int x; // 在DC上绘制的X坐标，字符左上角位置
	int y; // 在DC上绘制的Y坐标，字符左上角位置
    
};


#endif
