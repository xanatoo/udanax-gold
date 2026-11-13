#include <owl.h>
#include <stdio.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop
#include "fakebtns.h"

/*  Just some useful leftover code.
	Editor->Attr.Style |= ES_NOHIDESEL;
	Editor->Attr.Style &= ~WS_HSCROLL;
	Editor->Attr.Style &= ~ES_AUTOHSCROLL;
*/

// methods for the text edit button
FEButtonEdit::
FEButtonEdit(PTWindowsObject parent, int AnId, LPSTR ATitle,
				int X, int Y, int W, int H, WORD ATextLen, BOOL Multiline,
				PTModule AModule)
		: TEdit(parent, AnId, ATitle, X, Y, W, H, ATextLen, Multiline, AModule)
{}

FEButtonEdit::
FEButtonEdit(PTWindowsObject parent, int resourceID, WORD ATextLen, PTModule AModule)
		: TEdit(parent, resourceID, ATextLen, AModule)
{}

static HFONT textFont = CreateFont(18, 0,0,0,0,0,0,0,0,0,0,0,0,"Times New Roman");
void FEButtonEdit::
SetupWindow() {
	TEdit::SetupWindow();
	SendMessage(HWindow, WM_SETFONT, (UINT)textFont, FALSE);
}

void FEButtonEdit::
WMLButtonDown(RTMessage /* Msg */) {
	SendMessage(Parent->HWindow, WM_COMMAND, Attr.Id,
							MAKELONG(HWindow, BN_CLICKED));
}

// methods for the checkbox button
FEButtonCheckBox::
FEButtonCheckBox(PTWindowsObject parent, int AnId, LPSTR ATitle,
				int X, int Y, int W, int H, PTGroupBox AGroup, PTModule AModule)
		: TCheckBox(parent, AnId, ATitle, X, Y, W, H, AGroup, AModule)
{}

FEButtonCheckBox::
FEButtonCheckBox(PTWindowsObject parent, int resourceID, PTGroupBox AGroup, PTModule AModule)
		: TCheckBox(parent, resourceID, AGroup, AModule)
{}

void FEButtonCheckBox::
BNClicked(RTMessage /* Msg */) {
	SendMessage(Parent->HWindow, WM_COMMAND, Attr.Id,
							MAKELONG(HWindow, BN_CLICKED));
}

