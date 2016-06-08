//
//  StrokeFontIO.cpp
//  dat_files2
//
//  Created by LXW on 13-12-2.
//  Copyright (c) 2013年 LXW. All rights reserved.
//

#include "StrokeFontIO.h"
//#include "stdafx.h"
#include "STStrokeFontApi.h"
//#import "debug.c"

//#define max(a,b) (((a) > (b)) ? (a) : (b))
//
//#define min(a,b) (((a) < (b)) ? (a) : (b))
///////////////////////////////////

int GetSectDataSize(BYTE *pdata)
{
	int theCommand;
	int j;
	int numCommands=0;
	int nSize=0;
	BYTE *ptCommands=NULL;
	BYTE *lpdata=pdata;
	lpdata+=2; //后移2字节 起点坐标x,y
	nSize+=2; //更新数据长度
    
	numCommands = *lpdata; //取命令的数量
	lpdata++; //后移1字节
	nSize++; //更新数据长度
	if (numCommands==0)
	{
		numCommands=((unsigned char)*lpdata)|(((unsigned char)*(lpdata+1))<<8);
		lpdata+=2;
		nSize+=2;
	}
	ptCommands = lpdata; //保存命令指针
	lpdata += (numCommands+1)>>1; //跳过命令区
	nSize += (numCommands+1)>>1; //更新数据长度
    
	for(j=0;j<numCommands;j++)
	{
		//如果是奇数
		if((j&1)==1)
		{
			//取命令
			theCommand = (*ptCommands) & 0x0F;
			ptCommands++; //后移一字节
		}
		else
		{
			//取命令
			theCommand = ((*ptCommands)>>4) & 0x0F;
		}
		switch(theCommand)
		{
            case 1:
            case 2:
            case 4:
            case 5:
            case 6:
            case 7:
                lpdata++; //后移一字节
                nSize++; //更新数据长度
                break;
            case 3:
                lpdata+=2; //后移两字节
                nSize+=2; //更新数据长度
                break;
            case 0:
                lpdata+=6; //后移6字节
                nSize+=6; //更新数据长度
                break;
            case 8:
                lpdata+=3; //后移3字节
                nSize+=3; //更新数据长度
                break;
            case 9:
                lpdata+=10; //后移10字节
                nSize+=10; //更新数据长度
                break;
            case 10:
                lpdata+=6; //后移10字节
                nSize+=6; //更新数据长度
                break;
            case 11:
            case 12:
                lpdata+=2; //后移10字节
                nSize+=2; //更新数据长度
                break;
            case 13:
                lpdata+=4; //后移10字节
                nSize+=4; //更新数据长度
                break;
            case 14:
                lpdata+=12; //后移10字节
                nSize+=12; //更新数据长度
                break;
            case 15:
                lpdata+=4; //后移10字节
                nSize+=4; //更新数据长度
                break;
            default:
                break;
		}
	}
	return nSize;
}

StrokeSect* ReadCharData(BYTE* pFontBuf, int nIndex, int &nSectNum)
{
	StrokeSect* pStrokeSect=NULL;
	if (!pFontBuf)
		return NULL;
	UINT* lpFontBuf=(UINT*)pFontBuf;
	UINT num=lpFontBuf[0];
	UINT* offset_data=(UINT*)(pFontBuf+sizeof(UINT));
	UINT* offset_info=(UINT*)(pFontBuf+sizeof(UINT)*(num+2));
    
	if (nIndex<0 || nIndex>num-1)
		return NULL;
	int closepathnum=0;
	BYTE *pinfo=pFontBuf+offset_info[nIndex];
	BYTE *data=pFontBuf+offset_data[nIndex];
	closepathnum=*data;
	if (closepathnum<=0)
		return NULL;
    
	pStrokeSect=new StrokeSect[closepathnum];
    
	data++;
	for (int i=0;i<closepathnum;i++)
	{
		int datasize=0;
		pStrokeSect[i].lpdata=data;
		pStrokeSect[i].datasize=datasize=GetSectDataSize(data);
		data+=datasize;
	}
    
	
	for (int x=0;x<closepathnum;x++)
	{
		pStrokeSect[x].direction=pinfo[0];
		pStrokeSect[x].stopline=pinfo[1];
		pStrokeSect[x].stroke_time=pinfo[2];
		pStrokeSect[x].stroke_step=pinfo[3];
		pStrokeSect[x].stop_time=pinfo[4];
		pStrokeSect[x].stroke_type=pinfo[5];
		switch (pinfo[5])
		{
            case 9:
                pStrokeSect[x].stroke_type=10;
                break;
            case 10:
                pStrokeSect[x].stroke_type=11;
                break;
            case 11:
                pStrokeSect[x].stroke_type=26;
                break;
            case 22:
                pStrokeSect[x].stroke_type=23;
                break;
            case 23:
                pStrokeSect[x].stroke_type=22;
                break;
		}
        //		if (pStrokeSect[x].direction==6)
        //			pStrokeSect[x].stroke_step*=5;
        //		if (pStrokeSect[x].direction==8)
        //			pStrokeSect[x].stroke_step*=2;
		pStrokeSect[x].charPartCode=pinfo[6]|(pinfo[7]<<8);
		pinfo+=STROKEINFO_SIZE;
	}
    //	for (int x=0;x<closepathnum-1;x++)
    //	{
    //		if (pStrokeSect[x+1].stopline)
    //			pStrokeSect[x].stop_time=200;
    //		else
    //			pStrokeSect[x].stop_time=0;
    //	}
    //	pStrokeSect[closepathnum-1].stop_time=200;
	nSectNum=closepathnum;
    
	return pStrokeSect;
}

//GB 转换成 Unicode：
int GB2Unicode(int code)
{
	UINT nCodePage = 936; //GB2312
	char pStr[3]={0,0,0};
	pStr[0]=(code>>8)&0xFF;
	pStr[1]=(code)&0xFF;
	WCHAR pStrW[2]={0,0};
//	MultiByteToWideChar(nCodePage,0,pStr,-1,pStrW,1);
	return pStrW[0];
}

//Unicode 转换成GB ：
int Unicode2GB(int code)
{
	UINT nCodePage = 936; //GB2312
	WCHAR pStrW[2]={0,0};
	pStrW[0]=code;
	char pStr[3]={0,0,0};
//	WideCharToMultiByte(nCodePage,0,pStrW,-1,pStr,2,NULL,NULL);
	return *((USHORT*)pStr);
}

int Unicode2Index(int code)
{
	int nIndex=-2;
	int gbCode=Unicode2GB(code);
	if (gbCode<0x80)
		return nIndex;
	BYTE c1=gbCode&0xFF;
	BYTE c2=(gbCode>>8)&0xFF;
    
	if (c1>=0xB0 && c1<=0xF7 &&
		c2>=0xA1 && c2<=0xFE)
	{
		nIndex=(c1-0xB0)*94+(c2-0xA1);
	}
	else if (c1==0x86 && c2==0xAA)
	{
		nIndex=(0xD7-0xB0)*94+(0xFA-0xA1);
	}
	return nIndex;
}

int STUnicode2Index(BYTE* pCodeMapping, UINT code)
{
	int index=-1;
	USHORT* pCodes=(USHORT*)(pCodeMapping+2);
	int codeNum=*((USHORT*)pCodeMapping);
	for (int j=0;j<codeNum;j++)
	{
		if (code==pCodes[j])
		{
			index=j;
			break;
		}
	}
	return index;
}

int GetCharRadical(BYTE* pFontBuf, int nIndex)
{
	if (!pFontBuf)
		return -1;
	UINT* lpFontBuf=(UINT*)pFontBuf;
	UINT num=lpFontBuf[0];
	UINT* offset_data=(UINT*)(pFontBuf+sizeof(UINT));
	UINT* offset_info=(UINT*)(pFontBuf+sizeof(UINT)*(num+2));
    
	if (nIndex<0 || nIndex>num-1)
		return -1;
	int closepathnum=0;
	BYTE *pinfo=pFontBuf+offset_info[nIndex];
	BYTE *data=pFontBuf+offset_data[nIndex];
	closepathnum=*data;
	if (closepathnum<=0)
		return -1;
	
	int charPartCode=-1;
	for (int x=0;x<closepathnum;x++)
	{
		charPartCode=pinfo[6]|(pinfo[7]<<8);
		pinfo+=STROKEINFO_SIZE;
		if (charPartCode>0)
			break;
	}
    
	if (charPartCode>0)
		charPartCode=GB2Unicode(charPartCode);
    
	return charPartCode;
}

int GetCharStrokeNum(BYTE* pFontBuf, int nIndex)
{
	if (!pFontBuf)
		return -1;
	UINT* lpFontBuf=(UINT*)pFontBuf;
	UINT num=lpFontBuf[0];
	UINT* offset_data=(UINT*)(pFontBuf+sizeof(UINT));
	UINT* offset_info=(UINT*)(pFontBuf+sizeof(UINT)*(num+2));
    
	if (nIndex<0 || nIndex>num-1)
		return -1;
	int closepathnum=0;
	BYTE *pinfo=pFontBuf+offset_info[nIndex];
	BYTE *data=pFontBuf+offset_data[nIndex];
	closepathnum=*data;
	if (closepathnum<=0)
		return -1;
	
	int nStrokeNum=0;
	for (int x=0;x<closepathnum;x++)
	{
		if (pinfo[1])
			nStrokeNum++;
		pinfo+=STROKEINFO_SIZE;
	}
    
	return nStrokeNum;
}

BYTE* STReadFile(const TCHAR* filename)
{
	BYTE* pBuf=NULL;
	FILE *pfile=_tfopen(filename,_T("rb"));
	if (pfile)
	{
		fseek(pfile,0,SEEK_END);
		int filesize=ftell(pfile);
		if (filesize>0)
		{
			pBuf=new BYTE[filesize];
			fseek(pfile,0,SEEK_SET);
			fread(pBuf,1,filesize,pfile);
			//m_nCharNum=*((UINT*)m_pFontBuf);
		}
		fclose(pfile);
	}
	return pBuf;
}

extern void St_DrawComponent(int *fontw, int *fonth, int *x, int *y,
                             int *zoomx, int *zoomy, signed char* graphics, unsigned char *aibuf, int antilevel, int usefd, int base);

int STDrawStrokeBmp(int w, int h, int nSectNum, StrokeSect *pStrokeSect, BYTE** pDrawBmp, BYTE** pSectBmp, BOOL thousandBase)
{
	int zoomx_y=1024;
	int x_x=0;
	int x_y=25;
	int base=128;
	// 128基数据
	//x_y=25;
	//base=128;
    
    //1000基数据
    if (thousandBase) {
        x_y = 200;
        base = 1000;
    }
	BYTE *pantibuf=new BYTE[w*h];
    
	for (int i=0;i<nSectNum;i++)
	{
		int fontw=w;
		int fonth=h;
		BYTE *databuf=new BYTE[pStrokeSect[i].datasize+1];
		databuf[0]=1;
		memcpy(databuf+1,pStrokeSect[i].lpdata,pStrokeSect[i].datasize);
		St_DrawComponent(&fontw,&fonth,&x_x,&x_y,&zoomx_y,&zoomx_y,(signed char*)databuf,pantibuf,16,0,base);
		memcpy(pSectBmp[i],pantibuf,w*h);
		delete [] databuf;
        
		int nIndex=i;
		int max_x=0;
		int max_y=0;
		int min_x=w;
		int min_y=h;
        
		if (i==0)
		{
			memset(pDrawBmp[i],0,w*h);
		}
		else
		{
			memcpy(pDrawBmp[i],pDrawBmp[i-1],w*h);
		}
        
		int pixelIndex=0;
		for (int y=0;y<h;y++)
		{
			for (int x=0;x<w;x++)
			{
				if (pantibuf[pixelIndex])
				{
					max_x=max(max_x,x);
					max_y=max(max_y,y);
					min_x=min(min_x,x);
					min_y=min(min_y,y);
					pDrawBmp[i][pixelIndex]=min(pDrawBmp[i][pixelIndex]+pantibuf[pixelIndex],16);
				}
				pixelIndex++;
			}
		}
        
        
		switch (pStrokeSect[i].direction)
		{
            case 1:
                pStrokeSect[i].start=min_x;
                pStrokeSect[i].end=max_x;
                pStrokeSect[i].startX=min_x;
                pStrokeSect[i].startY=min_y;
                pStrokeSect[i].endX=max_x;
                pStrokeSect[i].endY=max_y;
                pStrokeSect[i].curpos=pStrokeSect[i].start;
                pStrokeSect[i].curposX=pStrokeSect[i].startX;
                pStrokeSect[i].curposY=pStrokeSect[i].startY;
                break;
            case 2:
                pStrokeSect[i].start=min(min_x,min_y);
                pStrokeSect[i].end=max(max_x,max_y);
                pStrokeSect[i].startX=min_x;
                pStrokeSect[i].startY=min_y;
                pStrokeSect[i].endX=max_x;
                pStrokeSect[i].endY=max_y;
                pStrokeSect[i].curpos=pStrokeSect[i].start;
                pStrokeSect[i].curposX=pStrokeSect[i].startX;
                pStrokeSect[i].curposY=pStrokeSect[i].startY;
                break;
            case 3:
                pStrokeSect[i].start=min_y;
                pStrokeSect[i].end=max_y;
                pStrokeSect[i].startX=min_x;
                pStrokeSect[i].startY=min_y;
                pStrokeSect[i].endX=max_x;
                pStrokeSect[i].endY=max_y;
                pStrokeSect[i].curpos=pStrokeSect[i].start;
                pStrokeSect[i].curposX=pStrokeSect[i].startX;
                pStrokeSect[i].curposY=pStrokeSect[i].startY;
                break;
            case 4:
                pStrokeSect[i].start=min(min_y,w-max_x);
                pStrokeSect[i].end=max(max_y,w-min_x);
                pStrokeSect[i].startX=max_x;
                pStrokeSect[i].startY=min_y;
                pStrokeSect[i].endX=min_x;
                pStrokeSect[i].endY=max_y;
                pStrokeSect[i].curpos=pStrokeSect[i].start;
                pStrokeSect[i].curposX=pStrokeSect[i].startX;
                pStrokeSect[i].curposY=pStrokeSect[i].startY;
                break;
            case 5:
                pStrokeSect[i].start=max_x;
                pStrokeSect[i].end=min_x;
                pStrokeSect[i].startX=max_x;
                pStrokeSect[i].startY=min_y;
                pStrokeSect[i].endX=min_x;
                pStrokeSect[i].endY=max_y;
                pStrokeSect[i].curpos=pStrokeSect[i].start;
                pStrokeSect[i].curposX=pStrokeSect[i].startX;
                pStrokeSect[i].curposY=pStrokeSect[i].startY;
                break;
            case 6:
                pStrokeSect[i].start=max(max_x,max_y);
                pStrokeSect[i].end=min(min_x,min_y);
                pStrokeSect[i].startX=max_x;
                pStrokeSect[i].startY=max_y;
                pStrokeSect[i].endX=min_x;
                pStrokeSect[i].endY=min_y;
                pStrokeSect[i].curpos=pStrokeSect[i].start;
                pStrokeSect[i].curposX=pStrokeSect[i].startX;
                pStrokeSect[i].curposY=pStrokeSect[i].startY;
                //			pStrokeSect[i].stroke_time=1;
                break;
            case 7:
                pStrokeSect[i].start=max_y;
                pStrokeSect[i].end=min_y;
                pStrokeSect[i].startX=max_x;
                pStrokeSect[i].startY=max_y;
                pStrokeSect[i].endX=min_x;
                pStrokeSect[i].endY=min_y;
                pStrokeSect[i].curpos=pStrokeSect[i].start;
                pStrokeSect[i].curposX=pStrokeSect[i].startX;
                pStrokeSect[i].curposY=pStrokeSect[i].startY;
                break;
            case 8:
                pStrokeSect[i].start=max(max_y,w-min_x);
                pStrokeSect[i].end=min(min_y,w-max_x);
                pStrokeSect[i].startX=min_x;
                pStrokeSect[i].startY=max_y;
                pStrokeSect[i].endX=max_x;
                pStrokeSect[i].endY=min_y;
                pStrokeSect[i].curpos=pStrokeSect[i].start;
                pStrokeSect[i].curposX=pStrokeSect[i].startX;
                pStrokeSect[i].curposY=pStrokeSect[i].startY;
                //			pStrokeSect[i].stroke_time=5;
                break;
		}
        
	}
	delete [] pantibuf;
    
	return 0;
    
}

STCharStrokes* STGetCharStrokes(UINT code, int w, int h, const TCHAR* fontfile, const TCHAR* mappingfile,BOOL thousandBase)
{
	STCharStrokes* pStrokes=new STCharStrokes[1];
    
	memset(pStrokes,0,sizeof(STCharStrokes));

    
	BYTE* pFont=STReadFile(fontfile);
	BYTE* pMapping=STReadFile(mappingfile);
	if (pFont && pMapping)
	{
		int index=STUnicode2Index(pMapping,code);
		if (index>=0)
		{
			//StrokeSect* ReadCharData
			int nSectNum=0;
			StrokeSect *pStrokeSect=ReadCharData(pFont,index,nSectNum);
			if (pStrokeSect)
			{
				BYTE** pDrawBmp=new BYTE* [nSectNum];
				BYTE** pSectBmp=new BYTE* [nSectNum];
				for (int i=0;i<nSectNum;i++)
				{
					pDrawBmp[i]=new BYTE[w*h];
					pSectBmp[i]=new BYTE[w*h];
				}
                
                /*用于设置笔画段的信息，*/
				STDrawStrokeBmp(w,h,nSectNum,pStrokeSect,pDrawBmp,pSectBmp,thousandBase);
                
				pStrokes->num=nSectNum;
				pStrokes->charCode=code;
				pStrokes->w=w;
				pStrokes->h=h;
				pStrokes->strokeNum=GetCharStrokeNum(pFont,index);
				pStrokes->radicalCode=GetCharRadical(pFont,index);
				pStrokes->pStrokeSects=new STStrokeSect[nSectNum];
                
                /*下面是设置字符的笔画段,分别设置每一个笔画段 的信息,
                 这里使用数据结构的点运算符来赋值*/
                
				for (int i=0;i<nSectNum;i++)
				{
					pStrokes->pStrokeSects[i].direction=pStrokeSect[i].direction;
					pStrokes->pStrokeSects[i].startX=pStrokeSect[i].startX;
					pStrokes->pStrokeSects[i].startY=pStrokeSect[i].startY;
					pStrokes->pStrokeSects[i].endX=pStrokeSect[i].endX;
					pStrokes->pStrokeSects[i].endY=pStrokeSect[i].endY;
					pStrokes->pStrokeSects[i].animationTime=pStrokeSect[i].stroke_time;
					pStrokes->pStrokeSects[i].animationStep=pStrokeSect[i].stroke_step;
					pStrokes->pStrokeSects[i].stopTime=pStrokeSect[i].stop_time;
					pStrokes->pStrokeSects[i].isRadical=(pStrokeSect[i].charPartCode!=0);
					pStrokes->pStrokeSects[i].strokeType1=pStrokeSect[i].stopline;
					pStrokes->pStrokeSects[i].strokeType2=pStrokeSect[i].stroke_type;
				}
				delete pStrokeSect;
                /*
                 因为是存在了二级指针中，相当于是二位数组，
                 每一个 字符段 之间的存储在内存中可能是不连续的，
                 如果需要得到完整的位图信息，则需要将他们重新读入一个连续的空间中
                 */

				pStrokes->pAnimationBmp=pDrawBmp;
				pStrokes->pStrokeSectBmp=pSectBmp;
			}
		}
		delete pFont;
		delete pMapping;
	}
    
	return pStrokes;
}

void STDestoryCharStrokes(STCharStrokes** pStrokes)
{
	if ((*pStrokes)->pAnimationBmp)
	{
		for (int i=0;i<(*pStrokes)->num;i++)
		{
			delete (*pStrokes)->pAnimationBmp[i];
		}
		delete (*pStrokes)->pAnimationBmp;
	}
	if ((*pStrokes)->pStrokeSectBmp)
	{
		for (int i=0;i<(*pStrokes)->num;i++)
		{
			delete (*pStrokes)->pStrokeSectBmp[i];
		}
		delete (*pStrokes)->pStrokeSectBmp;
	}
	if ((*pStrokes)->pStrokeSects)
	{
		delete (*pStrokes)->pStrokeSects;
	}
	delete *pStrokes;
	*pStrokes=NULL;
}

