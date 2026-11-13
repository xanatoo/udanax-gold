#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "content.h"
#include "textct.h"
#include "fe.h"
#include "feedit.h"
#include "bucket.h"
#include "links.h"

HFONT TheTextFont = CreateFont(16, 0,0,0,0,0,0,0,0,0,0,0,0,"Tms New Roman");
HFONT TheLinkFont = CreateFont(14, 0,0,0,0,0,0,0,0,0,0,0,0,"Arial");
HFONT TheVariantFont = TheLinkFont;
HFONT TheHistoryFont = TheLinkFont;

static COLORREF editColor = COLOR_WINDOWTEXT;
static HBRUSH editBrush = GetStockObject(WHITE_BRUSH);
// to have edit window specific attributes.
void FEEditWindow::
WMCtlColor (RTMessage msg) {
	HDC hdc = (HDC)msg.WParam;
/* TODO: fix this to not make the background color the same as the foreground. */
//	SetBkColor(hdc, editColor);
	msg.Result = (long)editBrush;
}
