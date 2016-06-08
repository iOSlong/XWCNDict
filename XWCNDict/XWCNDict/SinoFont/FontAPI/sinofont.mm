//
//  sinofont.mm
//  dat_files2
//
//  Created by LXW on 13-12-2.
//  Copyright (c) 2013年 LXW. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
//#include "stdafx.h"
//#include <malloc.h>
#include <memory.h>
#include <math.h>
/*
 #include "sys_malc.h"
 
 #include "libstcf.h"
 #include "sinofont.h"
 */
//#include "WinDef.h"


/////////////////////////////////////////last head one

#ifndef Bool
#define Bool int
#endif

#ifndef Byte
#define Byte unsigned char
#endif

//#define ST_INT64 __int64
#define ST_INT64 int64_t  //

#ifndef ABS
#define ABS( a )     ( (a) < 0 ? -(a) : (a) )
#endif
#ifndef min
#define min( a, b )     ( (a) < (b) ? (a) : (b) )
#endif
#ifndef max
#define max( a, b )     ( (a) > (b) ? (a) : (b) )
#endif

#define precision_bits 6
#define precision 64
#define precision_jitter 2
#define precision_half 32

int g_base=128;

#define ST_CAN_MOVEBIT
#define St_Zoom_X(x) (((((x)<<precision_bits)+st_word_states.bjx)*st_zoomlevw)/g_base)
#define St_Zoom_Y(y) (((((y)<<precision_bits)+st_word_states.bjy)*st_zoomlevh)/g_base)
#ifdef ST_CAN_MOVEBIT
#define TRUNC( x )    ( (x) >> precision_bits )
#else
#define TRUNC( x )    ((x)>0 ? ( (x) >> precision_bits ):( -((-(x)+precision-1) >> precision_bits) ))
#endif

#define TRUNC_CEILING( x ) (((x) + precision - 1) >> precision_bits)
#define TRUNC_FLOOR( x ) ((x) >> precision_bits)
#define FRAC( x )     ( (x) & (precision - 1) )
#define FMulDiv( a, b, c )  ( (a) * (b) / (c) )
#define FLOOR( x )    ( (x) & -precision )
#define CEILING( x )  ( ((x) + precision - 1) & -precision )

#define GET_INT(val,ptr) val = (*ptr) | (ptr[1]<<8) | (ptr[2]<<16) | (ptr[3]<<24); ptr += 4
#define GET_INT16(val,ptr) val = (*ptr) | (ptr[1]<<8); ptr += 2


/****  字库解释程序相关设置  开始  ****/

#define ST_MAX_BUFSIZE 2500
#define ST_MAX_FONT_SIZE 500
#define ST_MIN_FONT_SIZE 5
#define START_AT_TOP 1

/****  字库解释程序相关设置  结束  ****/


/****  字库解释程序相关结构体定义  开始  ****/
Byte bmp1[ST_MAX_BUFSIZE];

struct St_Glyph_States_
{
	int				lastX;
	int				lastY;
	int				minX;
	int				minY;
	int				maxX;
	int				maxY;
	int				top;
	int				bottom;
};
typedef struct St_Glyph_States_ St_Glyph_States;

struct St_Word_States_
{
	int				bjno;
	int				bjx;
    //	int				bjxzoom;
	int				bjy;
    //	int				bjyzoom;
	int				antilev;
	int				fontw;
	int				fonth;
	int				fontlevw;
	int				fontlevh;
	Byte*			usecolortab;
	Byte*			antibuf;
	Byte*			lpaibuf;
	int				antibufsize;
	int				fontn;
	int				bufferx;
	int				buffery;
	int				buffersize;
	Bool			usefd;
    //	Bool			bSharp;
	int				hlevzoom;
	int				wlevzoom;
	int				zoomdot;
	int				backcol;
	Bool			usegoubian;
	Bool			startattop;
};
typedef struct St_Word_States_ St_Word_States;

struct ST_BUFWORD_
{
	int wordid;
	int wordidmode;
	int halffhid;
	int antilev;
	int count;
	int fontw;
	int fonth;
	int isgoubian;
#if ST_WORD_BUF_SIZE
	Byte wordbuf[ST_WORD_BUF_SIZE];
#endif
};
typedef struct ST_BUFWORD_ ST_BUFWORD;
/****  字库解释程序相关结构体定义  结束  ****/

/****  字库解释程序相关公共变量定义  开始  ****/
#if ST_MAX_BUFWORD_NUM
ST_BUFWORD st_bufword[ST_MAX_BUFWORD_NUM];
#endif
int St_Fill_Dot[ST_MAX_FONT_SIZE*4+2][50];
int St_Line_Dotnum[ST_MAX_FONT_SIZE*4+2];
Byte *st_pfillbmp;

int st_zoomlevh,st_zoomlevw;

St_Word_States st_word_states;
St_Glyph_States glyph_states;

unsigned char	*st_datadat;
unsigned char	*st_headdat;
unsigned char	*st_bjpot;
signed char		*st_datc;
/****  字库解释程序相关公共变量定义  结束  ****/

/****  字库解释程序相关计算用数组定义  开始  ****/
/* Left fill bitmask */
static const Byte  LMask[8] =
{ 0xFF, 0x7F, 0x3F, 0x1F, 0x0F, 0x07, 0x03, 0x01 };

/* Right fill bitmask */
static const Byte  RMask[8] =
{ 0x80, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC, 0xFE, 0xFF };

static const Byte antilevbuf_low[256]=
{0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4};
static const Byte antilevbuf_up[256]=
{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4};
/****  字库解释程序相关计算用数组定义  结束  ****/


Bool St_FillBuf()
{
	int		i,j,k;
	int		*tmptr;
    int		e1, e2;
	int		c1,c2,f1,f2;
	Byte*	pLine;
	int		bufferx=st_word_states.bufferx;
	int		fontlevw=st_word_states.fontlevw;
	int		top;
	int		ii,jj,tmpk;
	int		fontlevw_1=fontlevw-1;
    
	k=glyph_states.top-st_word_states.buffery+1;
	if (k>0)
		memset(St_Line_Dotnum+(st_word_states.buffery<<2),0,(k<<2));
    
	glyph_states.bottom=max(glyph_states.bottom,0);
	glyph_states.top=min(glyph_states.top,st_word_states.buffery-1);
	if (st_word_states.startattop)
	{
		pLine=st_pfillbmp+(st_word_states.buffery-1-glyph_states.bottom)*bufferx;
		bufferx=-bufferx;
	}
	else
		pLine=st_pfillbmp+glyph_states.bottom*bufferx;
    
	top=glyph_states.top;
	for (i=glyph_states.bottom;i<=top;i++,pLine+=bufferx)
	{
		k=St_Line_Dotnum[i];
		if (k==2)
		{
			tmptr=St_Fill_Dot[i];
			if (tmptr[1]>tmptr[0])
			{
				e1 = TRUNC_CEILING( tmptr[0] );
				e2 = TRUNC_FLOOR( tmptr[1] );
			}
			else
			{
				e1 = TRUNC_CEILING( tmptr[1] );
				e2 = TRUNC_FLOOR( tmptr[0] );
			}
			if (e2<e1)
				e2=e1;
			if ( e2 > fontlevw_1 )
				e2 = fontlevw_1;
			if ( e2 >e1 )
			{
				c1 = (e1 >> 3);
				c2 = (e2 >> 3);
                
				f1 = e1 & 7;
				f2 = e2 & 7;
                
				if ( c1 != c2 )
				{
					pLine[c1++] |= LMask[f1];
					if ( c2 > c1 )
						memset( pLine + c1, 0xFF, c2 - c1 );
                    
					pLine[c2] |= RMask[f2];
				}
				else
					pLine[c1] |= ( LMask[f1] & RMask[f2] );
			}
			else if (e2 ==e1)
			{
				c1 = (e1 >> 3);
				f1 = e1 & 7;
				pLine[c1] |= ( 0x80>>f1 );
			}
		}
		else if (k>1)
		{
			tmptr=St_Fill_Dot[i];
			for (ii=1;ii<k;ii++)
			{
				tmpk=tmptr[ii];
				jj=ii;
				while (jj!=0 && tmptr[jj-1]>tmpk)
				{
					tmptr[jj]=tmptr[jj-1];
					jj--;
				}
				tmptr[jj]=tmpk;
			}
			for (j=1;j<k;j+=2)
			{
				e1 = TRUNC_CEILING( tmptr[j-1] );
				e2 = TRUNC_FLOOR( tmptr[j] );
				if (e2<e1)
					e2=e1;
				if ( e2 > fontlevw_1 )
					e2 = fontlevw_1;
				if ( e2 >e1 )
				{
					c1 = (e1 >> 3);
					c2 = (e2 >> 3);
                    
					f1 = e1 & 7;
					f2 = e2 & 7;
                    
					if ( c1 != c2 )
					{
						pLine[c1++] |= LMask[f1];
						if ( c2 > c1 )
							memset( pLine + c1, 0xFF, c2 - c1 );
                        
						pLine[c2] |= RMask[f2];
					}
					else
						pLine[c1] |= ( LMask[f1] & RMask[f2] );
				}
				else if (e2 ==e1)
				{
					c1 = (e1 >> 3);
					f1 = e1 & 7;
					pLine[c1] |= ( 0x80>>f1 );
				}
			}
		}
		St_Line_Dotnum[i]=0;
	}
	return 1;
}

Bool St_Line_Up(int x1,int y1,int x2,int y2,int miny,int maxy,Bool bUp)
{
	int Dx, Dy;
	int e1, e2, f1, size;
	int Ix, Rx, Ax;
    
	Dx = x2 - x1;
	Dy = y2 - y1;
	if ( Dy <= 0 || y2 < miny || y1 > maxy )
	{
		return 1;
	}
    
    if ( y1 < miny )
    {
		x1 += FMulDiv( Dx, miny - y1, Dy );
        e1  = TRUNC( miny );
        f1  = FRAC( miny );
    }
    else
    {
        e1 = TRUNC( y1 );
        f1 = FRAC( y1 );
    }
    
    if ( y2 > maxy )
    {
        e2  = TRUNC( maxy );
    }
    else
    {
        e2 = TRUNC( y2 );
    }
    
	if ( e1 == e2 ) /* 直线竖直方向小于一个像素 */
	{
		return 1;
	}
	else
	{
		x1 += FMulDiv( Dx, precision - f1, Dy );
		e1 += 1;
	}
	size = e2 - e1 + 1;
    
    if ( Dx > 0 )
    {
        Ix = (Dx<<precision_bits) / Dy;
        Rx = (Dx<<precision_bits) % Dy;
        Dx = 1;
    }
    else
    {
        Ix = -( ((-Dx)<<precision_bits) / Dy );
        Rx =    ((-Dx)<<precision_bits) % Dy;
        Dx = -1;
    }
    
    Ax  = -Dy;
    
	if (bUp)
	{
		while ( size > 0 )
		{
			if (e1>=0)
			{
				St_Fill_Dot[e1][St_Line_Dotnum[e1]]=max(x1,0);
                /*				St_Fill_Dot[e1][St_Line_Dotnum[e1]]=x1;*/
				St_Line_Dotnum[e1]++;
			}
			e1++;
            
			x1 += Ix;
			Ax += Rx;
			if ( Ax >= 0 )
			{
				Ax -= Dy;
				x1 += Dx;
			}
			size--;
		}
		glyph_states.top=max(glyph_states.top,e1-1);
	}
	else
	{
		while ( size > 0 )
		{
			if (e1<=0)
			{
				St_Fill_Dot[-e1][St_Line_Dotnum[-e1]]=max(x1,0);
                /*				St_Fill_Dot[-e1][St_Line_Dotnum[-e1]]=x1;*/
				St_Line_Dotnum[-e1]++;
			}
			e1++;
            
			x1 += Ix;
			Ax += Rx;
			if ( Ax >= 0 )
			{
				Ax -= Dy;
				x1 += Dx;
			}
			size--;
		}
		glyph_states.bottom=min(glyph_states.bottom,1-e1);
	}
	return 1;
}
Bool St_Line_To(int x,int y)
{
	if (FRAC(y)==0)
	{
		y++;
	}
	if (y>glyph_states.lastY)
	{
		St_Line_Up(glyph_states.lastX,glyph_states.lastY,x,y,
                   glyph_states.minY,glyph_states.maxY,1);
	}
	else
	{
		St_Line_Up(glyph_states.lastX,-(glyph_states.lastY),x,-y,
                   -(glyph_states.maxY),-(glyph_states.minY),0);
	}
	glyph_states.lastX=x;
	glyph_states.lastY=y;
    
	return 1;
}

Bool St_Bezier_To(int x2,int y2,int x3,int y3, int x4,int y4)
{
	int		i,n1,n2,n3;
	int		fax, fbx, fcx,	fay, fby, fcy;
	int		tmpx, tmpy;
	int		tmpn;
	int		x1,y1;
	int		lineW;
    
	x1=glyph_states.lastX;
	y1=glyph_states.lastY;
	tmpn=st_word_states.fontn;
	lineW=max(ABS(x4-x1),ABS(y4-y1));
	lineW=(lineW+1279)/1280;
	tmpn=max(tmpn,lineW);
	
	if (tmpn==2)
	{
		if (ABS(x4-x1)>640 || ABS(y4-y1)>640)
			tmpn=3;
	}
	switch (tmpn)
	{
        case 2:
#ifdef ST_CAN_MOVEBIT
            tmpx=(x1+(x2+x3)*3+x4)>>3;
            tmpy=(y1+(y2+y3)*3+y4)>>3;
#else
            tmpx=(x1+(x2+x3)*3+x4)/8;
            tmpy=(y1+(y2+y3)*3+y4)/8;
#endif
            St_Line_To(tmpx,tmpy);
            break;
        case 3:
            tmpx=((x1<<3)+6*((x2<<1)+x3)+x4)/27;
            tmpy=((y1<<3)+6*((y2<<1)+y3)+y4)/27;
            St_Line_To(tmpx,tmpy);
            
            tmpx=(x1+6*(x2+(x3<<1))+(x4<<3))/27;
            tmpy=(y1+6*(y2+(y3<<1))+(y4<<3))/27;
            St_Line_To(tmpx,tmpy);
            break;
        default:
            fcx = (x2 - x1) * 3;
            fbx = (x3 - x2) * 3 - fcx;
            fax = (x4 - x1) - fcx - fbx;
            
            fcy = (y2 - y1) * 3;
            fby = (y3 - y2) * 3 - fcy;
            fay = (y4 - y1) - fcy - fby;
            n1=tmpn;
            n2=n1*n1;
            n3=n2*n1;
            
            for (i=1;i<tmpn;i++)
            {
                tmpx=(ST_INT64)fax*i*i*i/n3+fbx*i*i/n2+fcx*i/n1+x1;
                tmpy=(ST_INT64)fay*i*i*i/n3+fby*i*i/n2+fcy*i/n1+y1;
                St_Line_To(tmpx,tmpy);
            }
            
            break;
	}
	St_Line_To(x4,y4);
	return 1;
}
void St_Draw_BJ()
{
	int				x1,x2,x3,x4,y1,y2,y3,y4;
	int				x11,x22,x33,x44,y11,y22,y33,y44;
	int				i,xh1;
	signed char*	datpt;
	int				closenum;
	int				closecommandnum,commandbyte;
	int				halfdata;
	Byte			thecommand=0;
	int				startx,starty;
	Byte*			commandbuf;
    
    
	st_word_states.bjx<<=(precision_bits);
	st_word_states.bjy<<=(precision_bits);
    
	datpt=st_datc+st_word_states.bjno;
	closenum=*((Byte*)datpt);
	datpt++;
    
	glyph_states.maxX=(st_word_states.fontlevw<<precision_bits)-precision_half-1;
	glyph_states.maxY=(st_word_states.fontlevh<<precision_bits)-precision_half-1;
	glyph_states.minX=-precision_half-1;
	glyph_states.minY=-precision_half-1;
	glyph_states.bottom=glyph_states.maxY;
	glyph_states.top=0;
    
	for(i=0;i<closenum;i++)
	{
		x1=*datpt;
		datpt++;
		y1=*datpt;
		datpt++;
        
		glyph_states.lastX=startx=St_Zoom_X(x1);
		glyph_states.lastY=starty=St_Zoom_Y(y1);
		if (FRAC(starty)==0)
		{
			starty++;
			glyph_states.lastY++;
		}
        
        
		closecommandnum=*datpt;
		datpt++;
        
		commandbyte=(closecommandnum+1)>>1;
		commandbuf=(Byte*)datpt;
		datpt+=commandbyte;
        
		thecommand=(((Byte)*commandbuf)>>4) & 0x0F;
		// updated start point
		if (thecommand==15)
		{
			x1=*((short*)datpt);
			//datpt+=2;
			y1=*((short*)(datpt+2));
			//datpt+=2;
            
			glyph_states.lastX=startx=St_Zoom_X(x1);
			glyph_states.lastY=starty=St_Zoom_Y(y1);
			if (FRAC(starty)==0)
			{
				starty++;
				glyph_states.lastY++;
			}
		}
        
		for(xh1=0;xh1<closecommandnum;xh1++)
		{
			if((xh1&1)==1)
			{
				thecommand=((Byte)(*commandbuf)) & 0x0F;
				commandbuf++;
			}
			else
			{
				thecommand=(((Byte)*commandbuf)>>4) & 0x0F;
			}
			switch (thecommand)
			{
                case 2:
                    x1=*datpt;
                    datpt++;
                    x22=St_Zoom_X(x1);
                    glyph_states.lastX=x22;
                    break;
                case 1:
                    y1=*datpt;
                    datpt++;
                    x22=glyph_states.lastX;
                    y22=St_Zoom_Y(y1);
                    St_Line_To(x22,y22);
                    break;
                case 8:
                    halfdata = (((Byte)*datpt)>>4) & 0x0F;
                    if(halfdata>8)
                    {
                        halfdata=8-halfdata;
                    }
                    else if(halfdata==8)
                    {
                        halfdata=-halfdata;
                    }
                    x2=x1+halfdata;
					
                    halfdata = ((Byte)*datpt) & 0x0F;
                    if(halfdata>8)
                    {
                        halfdata=8-halfdata;
                    }
                    else if(halfdata==8)
                    {
                        halfdata=-halfdata;
                    }
                    y2=y1+halfdata;
                    datpt++;
                    
                    halfdata = (((Byte)*datpt)>>4) & 0x0F;
                    if(halfdata>8)
                    {
                        halfdata=8-halfdata;
                    }
                    else if(halfdata==8)
                    {
                        halfdata=-halfdata;
                    }
                    x3=x2+halfdata;
                    halfdata=((Byte)*datpt) & 0x0F;
                    if(halfdata>8)
                    {
                        halfdata=8-halfdata;
                    }
                    else if(halfdata==8)
                    {
                        halfdata=-halfdata;
                    }
                    y3=y2+halfdata;
                    datpt++;
                    
                    halfdata = (((Byte)*datpt)>>4) & 0x0F;
                    if(halfdata>8)
                    {
                        halfdata=8-halfdata;
                    }
                    else if(halfdata==8)
                    {
                        halfdata=-halfdata;
                    }
                    x4=x3+halfdata;
                    halfdata=((Byte)*datpt) & 0x0F;
                    if(halfdata>8)
                    {
                        halfdata=8-halfdata;
                    }
                    else if(halfdata==8)
                    {
                        halfdata=-halfdata;
                    }
                    y4=y3+halfdata;
                    datpt++;
                    x22=St_Zoom_X(x2);
                    x33=St_Zoom_X(x3);
                    x44=St_Zoom_X(x4);
                    y22=St_Zoom_Y(y2);
                    y33=St_Zoom_Y(y3);
                    y44=St_Zoom_Y(y4);
                    
                    St_Bezier_To(x22,y22,x33,y33,x44,y44);
                    x1=x4;
                    y1=y4;
                    break;
                case 0:
                    x22=St_Zoom_X(*datpt);
                    datpt++;
                    y22=St_Zoom_Y(*datpt);
                    datpt++;
                    x33=St_Zoom_X(*datpt);
                    datpt++;
                    y33=St_Zoom_Y(*datpt);
                    datpt++;
                    
                    x1=*datpt;
                    datpt++;
                    y1=*datpt;
                    datpt++;
                    
                    x44=St_Zoom_X(x1);
                    y44=St_Zoom_Y(y1);
                    
                    St_Bezier_To(x22,y22,x33,y33,x44,y44);
                    break;
                case 3:
                    x1=*datpt;
                    datpt++;
                    y1=*datpt;
                    datpt++;
                    x22=St_Zoom_X(x1);
                    y22=St_Zoom_Y(y1);
                    St_Line_To(x22,y22);
                    break;
                case 4:
                    x4=*datpt;
                    datpt++;
                    x44=St_Zoom_X(x4);
                    y44=glyph_states.lastY;
                    x22=glyph_states.lastX;
                    
                    y2=y1+ABS((x4-x1)*2/3);
                    y22=St_Zoom_Y(y2);
                    x33=x44;
                    y33=y22;
                    
                    St_Bezier_To(x22,y22,x33,y33,x44,y44);
                    x1=x4;
                    break;
                case 5:
                    x4=*datpt;
                    datpt++;
                    x44=St_Zoom_X(x4);
                    y44=glyph_states.lastY;
                    
                    x22=glyph_states.lastX;
                    y2=y1-ABS((x4-x1)*2/3);
                    y22=St_Zoom_Y(y2);
                    x33=x44;
                    y33=y22;
                    
                    St_Bezier_To(x22,y22,x33,y33,x44,y44);
                    x1=x4;
                    break;
                case 6:
                    y4=*datpt;
                    datpt++;
                    x44=glyph_states.lastX;
                    y44=St_Zoom_Y(y4);
                    
                    y22=glyph_states.lastY;
                    y33=y44;
                    x2=x1-ABS((y4-y1)*2/3);
                    x22=St_Zoom_X(x2);
                    x33=x22;
                    St_Bezier_To(x22,y22,x33,y33,x44,y44);
                    y1=y4;
                    break;
                case 7:
                    y4=*datpt;
                    datpt++;
                    x44=glyph_states.lastX;
                    y44=St_Zoom_Y(y4);
                    
                    y22=glyph_states.lastY;
                    y33=y44;
                    x2=x1+ABS((y4-y1)*2/3);
                    x22=St_Zoom_X(x2);
                    x33=x22;
                    St_Bezier_To(x22,y22,x33,y33,x44,y44);
                    y1=y4;
                    break;
                case 9:
                    x22=glyph_states.lastX;
                    y22=St_Zoom_Y(*datpt);
                    datpt++;
                    St_Line_To(x22,y22);
					
                    x44=St_Zoom_X(*datpt);
                    datpt++;
                    y44=St_Zoom_Y(*datpt);
                    datpt++;
                    x11=glyph_states.lastX;
                    y11=glyph_states.lastY;
                    x22=x11;
                    y22=y11+(y44-y11)*2/3;
                    x33=x44+(x11-x44)*2/3;
                    y33=y44;
                    St_Bezier_To(x22,y22,x33,y33,x44,y44);
                    
                    x22=St_Zoom_X(*datpt);
                    y22=glyph_states.lastY;
                    datpt++;
                    St_Line_To(x22,y22);
                    
                    x44=St_Zoom_X(*datpt);
                    datpt++;
                    y44=St_Zoom_Y(*datpt);
                    datpt++;
                    x11=glyph_states.lastX;
                    y11=glyph_states.lastY;
                    x22=x11-(x11-x44)*2/3;
                    y22=y11;
                    x33=x44;
                    y33=y44+(y11-y44)*2/3;
                    St_Bezier_To(x22,y22,x33,y33,x44,y44);
                    
                    y22=St_Zoom_Y(*datpt);
                    datpt++;
                    x22=glyph_states.lastX;
                    St_Line_To(x22,y22);
                    
                    x44=St_Zoom_X(*datpt);
                    datpt++;
                    y44=St_Zoom_Y(*datpt);
                    datpt++;
                    x11=glyph_states.lastX;
                    y11=glyph_states.lastY;
                    x22=x11;
                    y22=y11-(y11-y44)*2/3;
                    x33=x44-(x44-x11)*2/3;
                    y33=y44;
                    St_Bezier_To(x22,y22,x33,y33,x44,y44);
                    
                    x22=St_Zoom_X(*datpt);
                    y22=glyph_states.lastY;
                    datpt++;
                    St_Line_To(x22,y22);
                    
                    x44=startx;
                    y44=starty;
                    x11=glyph_states.lastX;
                    y11=glyph_states.lastY;
                    x22=x11+(x44-x11)*2/3;
                    y22=y11;
                    x33=x44;
                    y33=y44-(y44-y11)*2/3;
                    St_Bezier_To(x22,y22,x33,y33,x44,y44);
                    break;
                case 10: // 小曲线 1字节 增量坐标
                    x2=x1+*datpt;
                    datpt++;
                    y2=y1+*datpt;
                    datpt++;
                    x3=x2+*datpt;
                    datpt++;
                    y3=y2+*datpt;
                    datpt++;
                    x4=x3+*datpt;
                    datpt++;
                    y4=y3+*datpt;
                    datpt++;
                    x22=St_Zoom_X(x2);
                    x33=St_Zoom_X(x3);
                    x44=St_Zoom_X(x4);
                    y22=St_Zoom_Y(y2);
                    y33=St_Zoom_Y(y3);
                    y44=St_Zoom_Y(y4);
                    
                    St_Bezier_To(x22,y22,x33,y33,x44,y44);
                    x1=x4;
                    y1=y4;
                    break;
                case 11:
                    y1=y1+*((short*)datpt);
                    datpt+=2;
                    x22=glyph_states.lastX;
                    y22=St_Zoom_Y(y1);
                    St_Line_To(x22,y22);
                    break;
                case 12:
                    x1=x1+*((short*)datpt);
                    datpt+=2;
                    x22=St_Zoom_X(x1);
                    glyph_states.lastX=x22;
                    break;
                case 13:
                    x1=x1+*((short*)datpt);
                    datpt+=2;
                    y1=y1+*((short*)datpt);
                    datpt+=2;
                    x22=St_Zoom_X(x1);
                    y22=St_Zoom_Y(y1);
                    St_Line_To(x22,y22);
                    break;
                case 14: // 大曲线 2字节 增量坐标
                    x2=x1+*((short*)datpt);
                    datpt+=2;
                    y2=y1+*((short*)datpt);
                    datpt+=2;
                    x3=x2+*((short*)datpt);
                    datpt+=2;
                    y3=y2+*((short*)datpt);
                    datpt+=2;
                    x4=x3+*((short*)datpt);
                    datpt+=2;
                    y4=y3+*((short*)datpt);
                    datpt+=2;
                    x22=St_Zoom_X(x2);
                    x33=St_Zoom_X(x3);
                    x44=St_Zoom_X(x4);
                    y22=St_Zoom_Y(y2);
                    y33=St_Zoom_Y(y3);
                    y44=St_Zoom_Y(y4);
                    
                    St_Bezier_To(x22,y22,x33,y33,x44,y44);
                    x1=x4;
                    y1=y4;
                    break;
                case 15:
                    datpt+=4;
                    break;
			}
		}
		if (glyph_states.lastY!=starty)
		{
			St_Line_To(startx,starty);
		}
	}
	St_FillBuf();
}

void St_Anti16lev()
{
	int		i,j;
	int		point;
	int		bufferx=st_word_states.bufferx;
	int		tmpx=bufferx<<1;
	int		addpoint=bufferx<<2;
	int		tmpx1=tmpx+bufferx;
	int		tmppoint;
	int		x=st_word_states.fontw>>1;
	int		lebit=st_word_states.fontw & 1;
	int		bmp_1,bmp_2,bmp_3,bmp_4;
	int		fonth=st_word_states.fonth;
	Byte*	antibuf=st_word_states.antibuf;
	tmppoint=0;
    
	for (j=0;j<fonth;j++,tmppoint+=addpoint)
	{
		point=tmppoint;
		for (i=0;i<x;i++,point++)
		{
			bmp_1=st_pfillbmp[point];
			bmp_2=st_pfillbmp[point+bufferx];
			bmp_3=st_pfillbmp[point+tmpx];
			bmp_4=st_pfillbmp[point+tmpx1];
			*(antibuf++)=
            antilevbuf_up[bmp_1]+
            antilevbuf_up[bmp_2]+
            antilevbuf_up[bmp_3]+
            antilevbuf_up[bmp_4];
			*(antibuf++)=
            antilevbuf_low[bmp_1]+
            antilevbuf_low[bmp_2]+
            antilevbuf_low[bmp_3]+
            antilevbuf_low[bmp_4];
		}
		if (lebit)
		{
			*(antibuf++)=
            antilevbuf_up[st_pfillbmp[point]]+
            antilevbuf_up[st_pfillbmp[point+bufferx]]+
            antilevbuf_up[st_pfillbmp[point+tmpx]]+
            antilevbuf_up[st_pfillbmp[point+tmpx1]];
		}
	}
}

void St_anti_fd_gb_out(int wordid, int wordidmode, int halffhid,int isbufword)
{
	switch (st_word_states.antilev)
	{
        case 16:
            St_Anti16lev();
            break;
	}
}

Bool St_SetAllValue()
{
	if (st_word_states.fontw>36 || st_word_states.fonth>36)
		st_word_states.fontn=6;
	else if (st_word_states.fontw>24 || st_word_states.fonth>24)
		st_word_states.fontn=4;
	else
		st_word_states.fontn=2;
    
	if (st_word_states.antilev==16)
	{
		st_word_states.fontlevw=st_word_states.fontw<<2;
		st_word_states.fontlevh=st_word_states.fonth<<2;
		st_word_states.buffery=st_word_states.fontlevh;
		st_word_states.bufferx=(st_word_states.fontlevw+7)>>3;
		st_word_states.buffersize=st_word_states.buffery*st_word_states.bufferx;
		st_word_states.hlevzoom=4*st_word_states.zoomdot;
		st_word_states.wlevzoom=4*st_word_states.zoomdot;
	}
	else
	{
		return 0;
	}
    
	st_zoomlevw=(st_word_states.fontlevw+st_word_states.wlevzoom);
	st_zoomlevh=(st_word_states.fontlevh+st_word_states.hlevzoom);
	return 1;
}


void St_DrawComponent(int *fontw, int *fonth, int *x, int *y,
                      int *zoomx, int *zoomy, signed char* graphics, unsigned char *aibuf, int antilevel, int usefd, int base)
{
	unsigned char tmpword[2];
	int bjnum=1;
	signed char *pOld;
	g_base=base;
	st_word_states.fontw=*fontw;
	st_word_states.fonth=*fonth;
    
	st_word_states.antilev=antilevel;
	st_word_states.antibufsize=st_word_states.fontw*st_word_states.fonth;
    
	st_word_states.usefd=usefd;
	st_word_states.zoomdot=0;
	st_word_states.buffersize=0;
	st_word_states.startattop=START_AT_TOP;
	st_word_states.usegoubian=0;
	st_pfillbmp=0;
	if (st_word_states.fontw>ST_MAX_FONT_SIZE || st_word_states.fonth>ST_MAX_FONT_SIZE || 
		st_word_states.fontw<9 || st_word_states.fonth<9)
	{
		goto fonterr;
	}
	st_word_states.antibuf=aibuf;
    
	memset(st_word_states.antibuf,0,st_word_states.antibufsize);
    
	if (!St_SetAllValue())
	{
		goto fonterr;
	}
	
	st_pfillbmp=(Byte*)calloc(st_word_states.buffersize,1);
	if (!st_pfillbmp)
	{
		st_word_states.buffersize=0;
		goto fonterr;
	}
	pOld=st_datc;
	st_datc=(signed char*)graphics;
    
	st_word_states.bjno=0;
    
	st_word_states.bjx=*x;
    
	st_word_states.bjy=*y;
    
	St_Draw_BJ();
	St_anti_fd_gb_out(0,1,1,0);
	st_datc=pOld;
	free(st_pfillbmp);
	return;
fonterr:
	if (st_pfillbmp)
		free(st_pfillbmp);
	return;
}
