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
#include "homefct.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "fe.h"

#include "pcaidcls.h"

FEFormContent * FEHomeFormContentType::TheHomeContent = NULL;

FEHomeFormContentType::FEHomeFormContentType ()
		: FEFormContentType ()
{}

FEHomeFormContentType const FEHomeFormContentType::TheOne;

PTWindowsObject FEHomeFormContentType::makeWindow (FEContent * content) {
	return NULL;
}

const XuStringVar FEHomeFormContentType::name () {
	return "Home";
}

int FEHomeFormContentType::fieldCount () {
	return 5;
}

XuStringVar FEHomeFormContentType::fieldKey (int field) {
	switch (field) {
	case 0: return "Akord";
	case 1: return "Papers";
	case 2: return "Attention 1B";
	case 3: return "Attention 2B";
	case 4: return "Attention 1C";
	}
    return "";
}

FEFormContentType::FieldType FEHomeFormContentType::fieldType (int) {
	return FEFormContentType::Reference;
}

char* FEHomeFormContentType::defaultText (int) {
	return NULL;
}

int FEHomeFormContentType::defaultCheck (int) {
	return 0;
}

int FEHomeFormContentType::selectedField (TWindowsObject *) {
	return -1;
}

PTWindowsObject FEHomeFormContentType::getControl (PTWindowsObject, int) {
	return NULL;
}

int FEHomeFormContentType::resourceID (int) {
	return 0;
}

void FEHomeFormContentType::show (XuStringVar name) {
	if (TheHomeContent) {
		TheHomeContent->followFieldRef (TheHomeContent->formType()->fieldIndex (name));
	}
}

void FEHomeFormContentType::setInstance (FEFormContent * home) {
	// assert (home == TheHomeContent || ! TheHomeContent)
	TheHomeContent = home;
}
