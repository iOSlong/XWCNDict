//
//  WinDef.h
//  dat_files2
//
//  Created by LXW on 13-12-2.
//  Copyright (c) 2013年 LXW. All rights reserved.
//

//#ifndef dat_files2_WinDef_h
#define dat_files2_WinDef_h
#import <Foundation/Foundation.h>


/****************************************************************************
 *                                                                           *
 * windef.h -- Basic Windows Type Definitions                                *
 *                                                                           *
 * Copyright (c) Microsoft Corporation. All rights reserved.                 *
 *                                                                           *
 ****************************************************************************/


/*
 这里常用到文件预定义，可以放到所有头文件引用文件中，
 简单方法：/Users/imac_06/Desktop/Font_Demo/font_move1.4+audio2/font_move1.2/font_move1.2-Prefix.pch
 在上面的文件中添加头文件引用：#import“WinDef.h”。
 */





#ifndef BASETYPES
#define BASETYPES
    typedef unsigned long ULONG;
    typedef ULONG *PULONG;
    typedef unsigned short USHORT;
    typedef USHORT *PUSHORT;
    typedef unsigned char UCHAR;
    typedef UCHAR *PUCHAR;
    typedef char *PSZ;
#endif  /* !BASETYPES */
    
#define MAX_PATH          260
    
#ifndef NULL
#ifdef __cplusplus
#define NULL    0
#else
#define NULL    ((void *)0)
#endif
#endif
    
#ifndef FALSE
#define FALSE               0
#endif
    
#ifndef TRUE
#define TRUE                1
#endif
    
#ifndef IN
#define IN
#endif
    
#ifndef OUT
#define OUT
#endif
    
#ifndef OPTIONAL
#define OPTIONAL
#endif
    
#undef far
#undef near
#undef pascal
    
#define far
#define near
#if (!defined(_MAC)) && ((_MSC_VER >= 800) || defined(_STDCALL_SUPPORTED))
#define pascal __stdcall
#else
#define pascal
#endif
    

#undef FAR
#undef  NEAR
#define FAR                 far
#define NEAR                near
#ifndef CONST
#define CONST               const
#endif
    
    typedef unsigned long       DWORD;
//    typedef int                 BOOL;
    typedef unsigned char       BYTE;
    typedef unsigned short      WORD;
    typedef float               FLOAT;
    typedef FLOAT               *PFLOAT;
    typedef BOOL near           *PBOOL;
    typedef BOOL far            *LPBOOL;
    typedef BYTE near           *PBYTE;
    typedef BYTE far            *LPBYTE;
    typedef int near            *PINT;
    typedef int far             *LPINT;
    typedef WORD near           *PWORD;
    typedef WORD far            *LPWORD;
    typedef long far            *LPLONG;
    typedef DWORD near          *PDWORD;
    typedef DWORD far           *LPDWORD;
    typedef void far            *LPVOID;
    typedef CONST void far      *LPCVOID;
    
    typedef int                 INT;
    typedef unsigned int        UINT;
    typedef unsigned int        *PUINT;
    


#ifndef NOMINMAX
    
#ifndef max
#define max(a,b)            (((a) > (b)) ? (a) : (b))
#endif
    
#ifndef min
#define min(a,b)            (((a) < (b)) ? (a) : (b))
#endif
    
#endif  /* NOMINMAX */

#define kGetBarButtonItem(Title,Selector) [[UIBarButtonItem alloc] initWithTitle:Title style:UIBarButtonItemStyleBordered target:self action:Selector]




    typedef DWORD   COLORREF;
    typedef DWORD   *LPCOLORREF;


typedef wchar_t  WCHAR;
typedef char TCHAR;

#define _T(x)  x
#define _tfopen  fopen

#define directionCase  \
if (pStrokeSect[nCurSectIndex].direction==1)\
{\
if (pInfo->pCurPosX[nCurSectIndex]<pStrokeSect[nCurSectIndex].endX)\
{\
pInfo->pCurPosX[nCurSectIndex]+=step;\
x=pStrokeSect[nCurSectIndex].startX;\
y=pStrokeSect[nCurSectIndex].startY;\
w=pInfo->pCurPosX[nCurSectIndex]-x;\
h=strokeH;\
bDraw=true;\
}\
}\
else if (pStrokeSect[nCurSectIndex].direction==2)\
{\
if (strokeH<strokeW)\
{\
if (pInfo->pCurPosY[nCurSectIndex]<pStrokeSect[nCurSectIndex].endY)\
{\
pInfo->pCurPosY[nCurSectIndex]+=step;\
x=pStrokeSect[nCurSectIndex].startX;\
y=pStrokeSect[nCurSectIndex].startY;\
h=pInfo->pCurPosY[nCurSectIndex]-y;\
w=h*strokeW/strokeH;\
bDraw=true;\
}\
}\
else\
{\
if (pInfo->pCurPosX[nCurSectIndex]<pStrokeSect[nCurSectIndex].endX)\
{\
pInfo->pCurPosX[nCurSectIndex]+=step;\
x=pStrokeSect[nCurSectIndex].startX;\
y=pStrokeSect[nCurSectIndex].startY;\
w=pInfo->pCurPosX[nCurSectIndex]-x;\
h=w*strokeH/strokeW;\
bDraw=true;\
}\
}\
}\
else if (pStrokeSect[nCurSectIndex].direction==3)\
{\
if (pInfo->pCurPosY[nCurSectIndex]<pStrokeSect[nCurSectIndex].endY)\
{\
pInfo->pCurPosY[nCurSectIndex]+=step;\
x=pStrokeSect[nCurSectIndex].startX;\
y=pStrokeSect[nCurSectIndex].startY;\
w=strokeW;\
h=pInfo->pCurPosY[nCurSectIndex]-y;\
bDraw=true;\
}\
}\
else if (pStrokeSect[nCurSectIndex].direction==4)\
{\
if (strokeH<strokeW)\
{\
if (pInfo->pCurPosY[nCurSectIndex]<pStrokeSect[nCurSectIndex].endY)\
{\
pInfo->pCurPosY[nCurSectIndex]+=step;\
x=pStrokeSect[nCurSectIndex].startX;\
y=pStrokeSect[nCurSectIndex].startY;\
h=pInfo->pCurPosY[nCurSectIndex]-y;\
w=h*strokeW/strokeH;\
x=pStrokeSect[nCurSectIndex].startX-w+1;\
bDraw=true;\
}\
}\
else\
{\
if (pInfo->pCurPosX[nCurSectIndex]>pStrokeSect[nCurSectIndex].endX)\
{\
pInfo->pCurPosX[nCurSectIndex]-=step;\
x=pInfo->pCurPosX[nCurSectIndex]+1;\
w=pStrokeSect[nCurSectIndex].startX-x+1;\
y=pStrokeSect[nCurSectIndex].startY;\
h=w*strokeH/strokeW;\
bDraw=true;\
}\
}\
}\
else if (pStrokeSect[nCurSectIndex].direction==5)\
{\
if (pInfo->pCurPosX[nCurSectIndex]>pStrokeSect[nCurSectIndex].endX)\
{\
pInfo->pCurPosX[nCurSectIndex]-=step;\
x=pInfo->pCurPosX[nCurSectIndex]+1;\
y=pStrokeSect[nCurSectIndex].startY;\
w=pStrokeSect[nCurSectIndex].startX-x+1;\
h=strokeH;\
bDraw=true;\
}\
}\
else if (pStrokeSect[nCurSectIndex].direction==6)\
{\
if (strokeH<strokeW)\
{\
if (pInfo->pCurPosY[nCurSectIndex]>pStrokeSect[nCurSectIndex].endY)\
{\
pInfo->pCurPosY[nCurSectIndex]-=step;\
y=pInfo->pCurPosY[nCurSectIndex]+1;\
h=pStrokeSect[nCurSectIndex].startY-y+1;\
w=h*strokeW/strokeH;\
x=pStrokeSect[nCurSectIndex].startX-w+1;\
bDraw=true;\
}\
}\
else\
{\
if (pInfo->pCurPosX[nCurSectIndex]>pStrokeSect[nCurSectIndex].endX)\
{\
pInfo->pCurPosX[nCurSectIndex]-=step;\
x=pInfo->pCurPosX[nCurSectIndex]+1;\
w=pStrokeSect[nCurSectIndex].startX-x+1;\
h=w*strokeH/strokeW;\
y=pStrokeSect[nCurSectIndex].startY-h+1;\
bDraw=true;\
}\
}\
}\
else if (pStrokeSect[nCurSectIndex].direction==7)\
{\
if (pInfo->pCurPosY[nCurSectIndex]>pStrokeSect[nCurSectIndex].endY)\
{\
pInfo->pCurPosY[nCurSectIndex]-=step;\
x=pStrokeSect[nCurSectIndex].endX;\
y=pInfo->pCurPosY[nCurSectIndex]+1;\
w=strokeW;\
h=pStrokeSect[nCurSectIndex].startY-y+1;\
bDraw=true;\
}\
}\
else if (pStrokeSect[nCurSectIndex].direction==8)\
{\
if (strokeH<strokeW)\
{\
if (pInfo->pCurPosY[nCurSectIndex]>pStrokeSect[nCurSectIndex].endY)\
{\
pInfo->pCurPosY[nCurSectIndex]-=step;\
x=pStrokeSect[nCurSectIndex].startX;\
y=pInfo->pCurPosY[nCurSectIndex]+1;\
h=pStrokeSect[nCurSectIndex].startY-y+1;\
w=h*strokeW/strokeH;\
bDraw=true;\
}\
}\
else\
{\
if (pInfo->pCurPosX[nCurSectIndex]<pStrokeSect[nCurSectIndex].endX)\
{\
pInfo->pCurPosX[nCurSectIndex]+=step;\
x=pStrokeSect[nCurSectIndex].startX;\
w=pInfo->pCurPosX[nCurSectIndex]-x;\
h=w*strokeH/strokeW;\
y=pStrokeSect[nCurSectIndex].startY-h+1;\
bDraw=true;\
}\
}\
}
