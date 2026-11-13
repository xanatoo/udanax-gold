#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "felist.h"
#include "draft.h"
#include "content.h"
#include "femanage.h"
#include "bucket.h"
#include "color.h"

FEListWindow* FEListWindow::
make (PTWindowsObject aParent, LPSTR aTitle, FEBucketManager* bucketMgr, FEWinType type) {
	return new FEListWindow(aParent, aTitle, bucketMgr, type);
}

FEListWindow::
FEListWindow(PTWindowsObject aParent, LPSTR aTitle, FEBucketManager* bucketMgr, FEWinType type) :
	TWindow(aParent, aTitle)
{
	ListBox = new TListBox(this, ID_LISTBOX, 0, 0, 0, 0);
	ListBox->Attr.Style |= LBS_NOINTEGRALHEIGHT;
	ListBox->Attr.Style &= ~LBS_SORT;
	ListBox->Attr.Style &= ~WS_BORDER;
	myBucketMgr = bucketMgr;
	myType = type;
	if (type == LinkWin) {
		Attr.X = 450;
		Attr.Y = 10;
		Attr.W = 150;
		Attr.H = 250;
		ListBox->Attr.W = Attr.W+2;
		ListBox->Attr.H = Attr.H+2;
	} else if (type == VariantWin) {
		Attr.X = 300;
		Attr.Y = 20;
		Attr.W = 200;
		Attr.H = 150;
		ListBox->Attr.W = Attr.W+2;
		ListBox->Attr.H = Attr.H+2;
	} else if (type == HistoryWin) {
		Attr.X = 250;
		Attr.Y = 30;
		Attr.W = 200;
		Attr.H = 150;
		ListBox->Attr.W = Attr.W+2;
		ListBox->Attr.H = Attr.H+2;
  }
}

void FEListWindow::
SetupWindow () {
	TWindow::SetupWindow();
	if (myType == LinkWin) {
		SendMessage(ListBox->HWindow, WM_SETFONT, TheLinkFont, FALSE);
	} else if (myType == VariantWin) {
		SendMessage(ListBox->HWindow, WM_SETFONT, TheVariantFont, FALSE);
	} else if (myType == HistoryWin) {
		SendMessage(ListBox->HWindow, WM_SETFONT, TheHistoryFont, FALSE);
	}
}

void FEListWindow::WMClose (RTMessage) {
	myBucketMgr->closeWindow();
}

int FEListWindow::
addString (LPSTR string) {
	return ListBox->AddString(string);
}

void FEListWindow::
replaceString (int index, char* newString) {
	ListBox->DeleteString(index);
	ListBox->InsertString(newString, index);
}

void FEListWindow::
deleteString (int index) {
	ListBox->DeleteString(index);
}

void FEListWindow::
CMInfo (RTMessage) {
	myBucketMgr->info(ListBox->GetSelIndex());
}

void FEListWindow::
CMDelete (RTMessage) {
	int index = ListBox->GetSelIndex();
	if (index != -1 && myBucketMgr->deleteItem(index)) {
		this->deleteString(index);
  }
}

void FEListWindow::
WMMDIActivate (RTMessage Msg) {
	if ( Msg.WParam ) {
		ListBox->SetSelIndex(-1);
	}
}

void FEListWindow::
HandleListBoxMsg (RTMessage Msg) {
	int Idx = ListBox->GetSelIndex();
	if (Msg.LP.Hi == LBN_SELCHANGE && Idx != -1) {
		myBucketMgr->show(Idx);
	} else if (Msg.LP.Hi == LBN_DBLCLK && Idx != -1) {
		myBucketMgr->follow(Idx);
	}
}

/* Responds to an incoming WM_SIZE message by resizing the child edit
  control according to the size of the Window's client area. */
void FEListWindow::
WMSize(RTMessage Msg) {
  TWindow::WMSize(Msg);
  SetWindowPos(ListBox->HWindow, 0, -1, -1, LOWORD(Msg.LParam)+2,
    HIWORD(Msg.LParam)+2, SWP_NOZORDER);
}

/* Use SetFocus rather than EnableKBHandler because we'll
   need to change menus and such anyway. */
void FEListWindow::
WMSetFocus(RTMessage) {
  SetFocus(ListBox->HWindow);
}

static COLORREF linkColor = RGB(0,128,128);
static HBRUSH linkBrush = CreateSolidBrush(linkColor);

static COLORREF variantColor = RGB(128,128,0);
static HBRUSH variantBrush = CreateSolidBrush(variantColor);

static COLORREF historyColor = RGB(192,192,192);
static HBRUSH historyBrush = CreateSolidBrush(historyColor);

// TODO: make this use the correct color, somehow
void FEListWindow::
WMCtlColor(RTMessage msg) {
	HDC hdc = (HDC)msg.WParam;
	if (myType == LinkWin) {
		SetBkColor(hdc, linkColor);
		msg.Result = (long)linkBrush;
	} else if (myType == VariantWin) {
		SetBkColor(hdc, variantColor);
		msg.Result = (long)variantBrush;
	} else if (myType == HistoryWin) {
		SetBkColor(hdc, historyColor);
		msg.Result = (long)historyBrush;
	}
}

