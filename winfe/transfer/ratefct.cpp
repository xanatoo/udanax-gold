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
#include "ratefct.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "fe.h"

#include "pcaidcls.h"

FERateFormContentType::FERateFormContentType ()
		: FEFormContentType ()
{}

FERateFormContentType const FERateFormContentType::TheOne;

PTWindowsObject FERateFormContentType::makeWindow (FEContent * content) {
	PTWindowsObject result = new PVRATEDlg (TheApp->MainWindow, "RATE");
	((PVRATEDlg *) result)->setContent ((FEFormContent*)content);
    return result;
}

const XuStringVar FERateFormContentType::name () {
	return "Rate";
}

int FERateFormContentType::fieldCount () {
	return 1;
}

XuStringVar FERateFormContentType::fieldKey (int) {
	return "Instructions";
}

FEFormContentType::FieldType FERateFormContentType::fieldType (int) {
	return FEFormContentType::Text;
}

char* FERateFormContentType::defaultText (int) {
	return "";
}

int FERateFormContentType::defaultCheck (int) {
	return 0;
}

int FERateFormContentType::selectedField (TWindowsObject *) {
	return -1;
}

PTWindowsObject FERateFormContentType::getControl (PTWindowsObject win, int) {
	// assert (field == 0);
	return ((PVRATEDlg *) win)->Edit1;
}

int FERateFormContentType::resourceID (int) {
	// assert (field == 0);
	return 1;
}

FEUI::Alignment FERateFormContentType::vertical () {
	return FEUI::Max;
}

FEUI::Alignment FERateFormContentType::horizontal () {
	return FEUI::Max;
}
