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
#include "attnfct.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "fe.h"

#include "pcaidcls.h"

FEAttnFormContentType::FEAttnFormContentType ()
		: FEFormContentType ()
{}

FEAttnFormContentType const FEAttnFormContentType::TheOne;

PTWindowsObject FEAttnFormContentType::makeWindow (FEContent * content) {
	PTWindowsObject result = new PVATTNDlg (TheApp->MainWindow, "ATTN");
	((PVATTNDlg *) result)->setContent ((FEFormContent*)content);
    return result;
}

const XuStringVar FEAttnFormContentType::name () {
	return "Attention";
}

int FEAttnFormContentType::fieldCount () {
	return 2;
}

XuStringVar FEAttnFormContentType::fieldKey (int field) {
	// assert (field == 0 || field == 1);
	switch (field) {
	case 0: return "Message";
	case 1: return "Read";
	}
    return "";
}

FEFormContentType::FieldType FEAttnFormContentType::fieldType (int field) {
	// assert (field == 0 || field == 1);
	switch (field) {
	case 0: return FEFormContentType::Text;
	case 1: return FEFormContentType::Reference;
	}
	return FEFormContentType::Reference;
}

char* FEAttnFormContentType::defaultText (int) {
	return "Testing...";
}

int FEAttnFormContentType::defaultCheck (int) {
	return 0;
}

int FEAttnFormContentType::selectedField (TWindowsObject *) {
	return -1;
}

PTWindowsObject FEAttnFormContentType::getControl (PTWindowsObject win, int field) {
	// assert (field == 0 || field == 1);
	switch (field) {
	case 0: return ((PVATTNDlg *) win)->Edit3;
	case 1: return ((PVATTNDlg *) win)->Button1;
	}
	return NULL;
	
}

int FEAttnFormContentType::resourceID (int field) {
	// assert (field == 0 || field == 1);
	return 3 - 2 * field;
}

FEUI::Alignment FEAttnFormContentType::vertical () {
	return FEUI::Min;
}

FEUI::Alignment FEAttnFormContentType::horizontal () {
	return FEUI::Min;
}
