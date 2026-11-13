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
			XuEditionP edn = XuText::make("")->edition();
			newEdition = newEdition->with(this->fieldKey(i), edn);
		} else if (this->fieldType(i) == Checkbox) {
			newEdition = newEdition->with(this->fieldKey(i), XuDataHolder::make(0));
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
	FESheet::showRef(ref);
}

const FEContentType * FEFormContent::type () {
	return myType;
}

FEFormContent::FEFormContent (FEFormContentType * type)
	: FEContent ()
{
	myType = type;
}
