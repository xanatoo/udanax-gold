#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "xstuff.hxx"
#include <static.h>
#include <edit.h>
#include "dlgtools.h"

class FEGetEditText : public XuExportHook {
		PTStatic myStatic;
	public:
		FEGetEditText(PTStatic control) : myStatic(control) {}
	protected:
		virtual void fulfilled(XuBufferVar buf, XuIntVar size) {
			myStatic->SetText ((char*)buf);
			delete buf;
		}
};

void DialogTools::
setEditText(XuEditionP edition, PTStatic edit) {
	FEStuff::getText(edition, new FEGetEditText(edit));
}

void DialogTools::
setEditText(XuSequenceP sequence, PTStatic edit) {
	FEStuff::getText(sequence, new FEGetEditText(edit));
}

class FESelectionHook : public XuReadyHook {
// Sets the selection on a text editor when the start and
// stop results come in from the server
// TODO: Move to dialog tools module

	XuIntValueP myStart; // the beginning of the selection
	XuIntValueP myStop; // the end of the selection
	TEdit * myEdit; // the editor to update

public:
	FESelectionHook (XuIntValueP start, XuIntValueP stop, TEdit * edit) 
		: myStart(start), myStop(stop), myEdit(edit) {}

	virtual void ready () {
		if (myStart->isFulfilled () && myStop->isFulfilled ()) {
			myEdit->SetSelection (myStart->asInt (), myStop->asInt ());
		}
	}
};

void DialogTools::
setSelection (XuIntValueP start, XuIntValueP stop, TEdit * edit) {
	XuPromise::waitForReady(new FESelectionHook(start, stop, edit));
}

void DialogTools::
align (HWND win, FEUI::Alignment horizontal, FEUI::Alignment vertical)
{
	RECT screen;
	GetWindowRect (GetDesktopWindow (), &screen);
	RECT window;
	GetWindowRect (win, &window);
	switch (horizontal) {
		case FEUI::Default:
			break;
		case FEUI::Min:
			window.right -= window.left - screen.left;
			window.left = screen.left;
			break;
		case FEUI::Center:
			int width = window.right - window.left;
			window.left = (screen.left + screen.right - width) / 2;
			window.right = window.left + width;
			break;
		case FEUI::Max:
			window.left += screen.right - window.right;
			window.right = screen.right;
			break;
	}
	switch (vertical) {
		case FEUI::Default:
			break;
		case FEUI::Min:
			window.bottom -= window.top - screen.top;
			window.top = screen.top;
			break;
		case FEUI::Center:
			int height = window.bottom - window.top;
			window.top = (screen.top + screen.bottom - height) / 2;
			window.bottom = window.top + height;
			break;
		case FEUI::Max:
			window.top += screen.bottom - window.bottom;
			window.bottom = screen.bottom;
			break;
	}
	MoveWindow (win, window.left, window.top,
		window.right - window.left, window.bottom - window.top,
		TRUE);
}

