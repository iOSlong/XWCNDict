//
//  StrokeFontIO.h
//  dat_files2
//
//  Created by LXW on 13-12-2.
//  Copyright (c) 2013年 LXW. All rights reserved.
//

#ifndef __dat_files2__StrokeFontIO__
#define __dat_files2__StrokeFontIO__

//#include <iostream>

#endif /* defined(__dat_files2__StrokeFontIO__) */
#pragma once

#define STROKEINFO_SIZE 8
#include "WinDef.h"

enum
{
	RedShift565    = 11,
	GreenShift565  = 5,
	BlueShift565   = 0
};

enum
{
	RedMask565     = 0xF800,
	GreenMask565   = 0x07E0,
	BlueMask565    = 0x001F
};
#define GetRValue565(rgb)      (LOBYTE(((rgb)&RedMask565) >> RedShift565))
#define GetGValue565(rgb)      (LOBYTE(((rgb)&GreenMask565) >> GreenShift565))
#define GetBValue565(rgb)      (LOBYTE((rgb)&BlueMask565))
#define RGB565(r,g,b)          ((WORD)(((BYTE)(b)|((WORD)((BYTE)(g))<<GreenShift565))|(((WORD)(BYTE)(r))<<RedShift565)))

struct StrokeSect
{
	int direction;
	int start;
	int startX;
	int startY;
	int end;
	int endX;
	int endY;
	int curpos;
	int curposX;
	int curposY;
	int stopline;
	BYTE *lpdata;
	int datasize;
	int stroke_time;
	int stroke_step;
	int stop_time;
	unsigned short charPartCode;
	int stroke_type;
};

extern struct StrokeSect* ReadCharData (BYTE* pFontBuf, int nIndex, int *nSectNum);
extern int GetCharRadical(BYTE* pFontBuf, int nIndex);
extern int GetCharStrokeNum(BYTE* pFontBuf, int nIndex);

extern int Unicode2Index(int code);



