// form dialog boxes and controls

#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "xmdi.h"
#include "title.h"
#include "draft.h"
#include "content.h"
#include "formct.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "edit.h"
#include "dialog.h"
#include "checkbox.h"
#include "formui.h"
#include "promise.hxx"

// Set the selection to the last character
void FEFormEdit::WMSetFocus (RTMessage msg) {
	DefWndProc (msg);
  this->updateSelection ();
}

void FEFormEdit::updateSelection () {
  // to turn off highlighting of the entire field, and allow text entry at the end
	SetSelection (GetTextLen (), GetTextLen ());
}


// this edit field is losing the focus; send its contents to the backend
void FEFormEdit::WMKillFocus(RTMessage msg) {
	GetText(myBuf, GetTextLen()+1);
  // only flush if my contents actually have changed
	if (strcmp(myOldBuf, myBuf) != 0) {
		strcpy(myOldBuf, myBuf);
		myContent->fieldChanged
			(myNum, XuText::make(myBuf)->edition());
	}
	DefWndProc(msg);
}

// hook so we don't wait to fill in text fields
class FEFormEditHook : public XuExportHook {
	FEFormEdit* myEdit;
public:
	FEFormEditHook (FEFormEdit* edit) : myEdit(edit) {}

	virtual void fulfilled (XuBufferVar buf, XuIntVar size) {
		myEdit->SetText((char*)buf);
		strcpy(myEdit->myOldBuf, (char*)buf);
	}
	virtual void broken (XuVoidP) {
			cerr << "Couldn't get data.\n";
	}
};

// set this field from an Edition; do not wait
void FEFormEdit::setValue (XuRangeElementP newContents) {
	XuEditionP edn = XuEdition::cast(newContents);
	FEStuff::getText(edn,	new FEFormEditHook(this));
}

class FESelectionHook : public XuReadyHook {
// Sets the selection on a text editor when the start and
// stop results come in from the server
// TODO: Move to dialog tools module

private: // variables
	XuIntValueP myStart; // the beginning of the selection
	XuIntValueP myStop; // the end of the selection
	TEdit * myEdit; // the editor to update

	FESelectionHook () : XuReadyHook () {}

public: // create
	static XuReadyHookP make (XuIntValueP start, XuIntValueP stop, TEdit * edit) {
		FESelectionHook * result = new FESelectionHook ();
    XuReadyHookP gc = result;
		result->myStart = start;
		result->myStop = stop;
		result->myEdit = edit;
    return gc;
	}

public: // events
	virtual void ready () {
		if (myStart->isFulfilled () && myStop->isFulfilled ()) {
			myEdit->SetSelection (myStart->asInt (), myStop->asInt ());
		}
	}
};

void FEFormTextCompare::WMSetText (RTMessage msg) {
	DefWndProc (msg);
  this->updateSelection ();
}

void FEFormTextCompare::updateSelection () {
	// Do the default thing in case the comparison doesn't work
	this->FEFormEdit::updateSelection ();
	// Compare with original version comparison
	XuIntegerRegionP notShared = XuIntegerRegion::cast (
		XuEdition::cast(this->content()->edition ()->get (
				this->content()->formType()->fieldKey (this->fieldNum())))
		->notSharedWith (
			XuEdition::cast (this->content ()->edition ()->get (myReference)))
		->domain ());
  // update the selection when the result comes back
	XuPromise::waitForReady (FESelectionHook::make (
		notShared->start (), notShared->stop (), this));
}

// flush this checkbox's state to the backend
void FEFormCheckbox::WMKillFocus(RTMessage msg) {
	if (myOldState != GetCheck()) {
  	myOldState = GetCheck();
		XuDataHolderP value = XuDataHolder::make(GetCheck() == BF_CHECKED ? 1 : 0);
		myContent->fieldChanged(myNum, value);
		DefWndProc(msg);
	}
}

// set this checkbox's state from the backend; do a force for now
void FEFormCheckbox::setValue (XuRangeElementP newContents) {
	XuIntValueP val = XuIntValue::cast(XuDataHolder::cast(newContents)->value());
	// TODO: make this not force (easy)
	XuPromise::forceAll();
	int newState = val->asInt() ? BF_CHECKED : BF_UNCHECKED;
	SetCheck(newState);
	myOldState = newState;
}

FERefButtonHook::FERefButtonHook (XuIntValueP flag, TButton * button) {
   	myFlag = flag;
	myButton = button;
}

void FERefButtonHook::ready () {
	if (! myFlag->asInt ()) {
		myButton->Show (SW_HIDE);
	}
}

/* the button's been clicked; tell the content to follow */
void FEFormRefButton::BNClicked (RTMessage msg) {
	DefWndProc (msg);
	myContent->followFieldRef (myNum);
}


/* the button's been clicked; tell the content to follow */
void FEFormRefCheckbox::WMLButtonDown (RTMessage) {
	myContent->followFieldRef (myNum);
  // Don't pass on to DefWndProc so the checkbox state doesn't change
}

/* the button's been clicked; tell the content to follow */
void FEFormRefText::WMLButtonDown (RTMessage) {
	myContent->followFieldRef (myNum);
	// Don't pass on to DefWndProc so the text state doesn't change
}



