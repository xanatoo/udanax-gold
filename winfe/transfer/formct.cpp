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
#include "edit.h"
#include "dialog.h"
#include "checkbox.h"
#include "formui.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"

FEContent* FEFormContentType::emptyContent () {
	return new FEFormContent (this);
}

/* make a form of this type, properly initialized */
XuEditionP FEFormContentType::makeEdition () {
	XuEditionP newEdition = XuEdition::empty(XuSequenceSpace::make());
	// for each field, make a rangeElement of the correct type, and store
	// it at the correct key
	for (int i = 0; i < this->fieldCount(); i++) {
		if (this->fieldType(i) == Text) {
			XuEditionP edn = XuText::make(this->defaultText(i))->edition();
			newEdition = newEdition->with(this->fieldKey(i), edn);
		} else if (this->fieldType(i) == Checkbox) {
			newEdition = newEdition->with
				(this->fieldKey(i), XuDataHolder::make
					(this->defaultCheck(i)));
		}
	}
	// endorse the resulting edition as a kind of form
	newEdition->endorse(this->endorsements ());
	return newEdition;
}

int FEFormContentType::fieldIndex (XuStringVar name) {
	for (int i = 0; i < this->fieldCount (); i++) {
		if (! strcmp (name, this->fieldKey (i))) {
			return i;
		}
	}
	return -1;
}


void FEFormContent::setEdition (XuEditionP edition) {
	myEdition = edition;
	this->endorse(myEdition);
	for (int i = 0; i < this->formType()->fieldCount (); i++) {
		this->setField (i, myEdition->get (this->formType()->fieldKey (i)));
	}
}

/* select the region in the Content's window, if any */		// UI
void FEFormContent::selectRegion (XuRegionP reg) {
	// TODO: parse sequence region and highlight appropriate fields
}

/* select the reference, which eventually may be a MultiRef */		// UI
void FEFormContent::selectReference (XuHyperRefP reference) {
	// TODO: extend to handle MultiRefs
	this->selectRegion(FEStuff::regionOf(XuSingleRef::cast(reference), myEdition));
}

/* create a reference from the current selection, using the Draft's Work */
 // UI
XuHyperRefP FEFormContent::selectionReference () {
	return FEStuff::makeSingleRef(myDraft->work(), myEdition,
		XuSequence::string(this->formType()->fieldKey(
			this->formType()->selectedField(myWindow)))->asRegion());
}

// TODO: move these next three, _soon_, if this is not the right place for them */
/* show the Content window */
void FEFormContent::showWindow () {
	if (myWindow) {
		ShowWindow(myWindow->HWindow, SW_SHOW);
		BringWindowToTop(myWindow->HWindow);
	}
}

/* hide the Content window */
void FEFormContent::hideWindow () {
	if (myWindow) {
		ShowWindow(myWindow->HWindow, SW_HIDE);
  }
}
 
/* set the Content window's title */
void FEFormContent::setTitle (XuStringVar newTitle) {
	if (myWindow) {
		myWindow->SetCaption((char*)newTitle);
  }
}

void FEFormContent::flush () {
	if (myWindow) {
		HWND focus = GetFocus ();
		for (int i = 0; i < this->formType()->fieldCount (); i++) {
			if (focus == this->formType()->getControl (myWindow, i)->HWindow) {
				SetFocus (myWindow->HWindow);
      }
		}
	}
}

/* close all windows */
void FEFormContent::close (int windowClose) {
	// if !windowClose, then we, not the user, are closing the window
	if (!windowClose && myWindow) {
		myWindow->CloseWindow();
		delete myWindow;
	}
	myWindow = NULL;
}

void FEFormContent::setTypeID (XuIDP id) {
	myType->setTypeID (id);
}
	
void FEFormContent::endorse (XuEditionP edition) {
	edition->endorse (myType->endorsements ());
}

void FEFormContent::fieldChanged (int fieldNum, XuRangeElementP value) {
	this->revise(myEdition->with(this->formType()->fieldKey(fieldNum), value));
}

void FEFormContent::setField (int field, XuRangeElementP newValue) {
	if (this->formType()->fieldType(field) == FEFormContentType::Text) {
		((FEFormEdit*) this->formType()->getControl (myWindow, field))
			->setValue(newValue);
	} else if (this->formType()->fieldType(field) == FEFormContentType::Checkbox) {
		((FEFormCheckbox*) this->formType()->getControl (myWindow, field))
			->setValue(newValue);
	}
}

void FEFormContent::setTextField (int field, XuStringVar value) {
	this->setField (field, XuText::make (value)->edition ());
}

void FEFormContent::setCheckboxField (int field, int value) {
	this->setField (field, XuDataHolder::make (value == BF_CHECKED));
}

void FEFormContent::followFieldRef (int field) {
	// we get it from the edition since it may get changed from outside
	XuHyperRefP ref = XuHyperRef::wrap (
		XuEdition::cast(this->edition()->get (this->formType()->fieldKey(field))));
	XuWorkP work = ref->workContext();
	FEDraft* doc = FEManager::draftOn(work);
	if (doc != NULL) {
		doc->content()->showWindow();
		doc->content()->selectReference(ref);
	}
}

const FEContentType * FEFormContent::type () {
	return myType;
}

FEFormContent::FEFormContent (FEFormContentType * type)
	: FEContent ()
{
	myType = type;
	myWindow = 0;
}
