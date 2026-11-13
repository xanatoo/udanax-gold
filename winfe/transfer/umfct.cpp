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
#include "umfct.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "fe.h"

#include "pcaidcls.h"

FEUMFormContentType::FEUMFormContentType ()
	: FEFormContentType ()
{}

FEUMFormContentType const FEUMFormContentType::TheOne;

PTWindowsObject FEUMFormContentType::makeWindow (FEContent * content) {
	PTWindowsObject result = new PVUMDlg (TheApp->MainWindow, "UM");
	((PVUMDlg *) result)->setContent ((FEFormContent*) content);
    return result;
}

const XuStringVar FEUMFormContentType::name () {
	return "UM";
}

int FEUMFormContentType::fieldCount () {
	return 8;
}

XuStringVar FEUMFormContentType::fieldKey (int fieldNum) {
	switch (fieldNum) {
	case 0: return "Contents";
	case 1: return "Exhibit";
	case 2: return "Manual";
	case 3: return "Procedure";
	case 4: return "Page";
	case 5: return "Date";
	case 6: return "Rev";
	case 7: return "Title";
	};
	return "";
}

FEFormContentType::FieldType FEUMFormContentType::fieldType (int field) {
	if (field == 1) {
		return FEFormContentType::Reference;
	} else {
		return FEFormContentType::Text;
	}
}

char* FEUMFormContentType::defaultText (int) {
	return "";
}

int FEUMFormContentType::defaultCheck (int) {
	return 0;
}

int FEUMFormContentType::selectedField (TWindowsObject *) {
	return -1;
}

PTWindowsObject FEUMFormContentType::getControl (PTWindowsObject win, int field) {
	switch (field) {
	case 0: return ((PVUMDlg *) win)->Edit10;
	case 1: return ((PVUMDlg *) win)->Button11;
	case 2: return ((PVUMDlg *) win)->Edit12;
	case 3: return ((PVUMDlg *) win)->Edit13;
	case 4: return ((PVUMDlg *) win)->Edit14;
	case 5: return ((PVUMDlg *) win)->Edit15;
	case 6: return ((PVUMDlg *) win)->Edit16;
	case 7: return ((PVUMDlg *) win)->Edit17;
	};
	return NULL;
}

int FEUMFormContentType::resourceID (int field) {
	return field + 10;
}

FEUI::Alignment FEUMFormContentType::vertical () {
	return FEUI::Max;
}

FEUI::Alignment FEUMFormContentType::horizontal () {
	return FEUI::Max;
}
