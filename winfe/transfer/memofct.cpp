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
#include "memofct.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "fe.h"

#include "pcaidcls.h"

FEMemoFormContentType::FEMemoFormContentType ()
	: FEFormContentType ()
{}

FEMemoFormContentType const FEMemoFormContentType::TheOne;

PTWindowsObject FEMemoFormContentType::makeWindow (FEContent * content) {
	PTWindowsObject result = new PVMEMODlg (TheApp->MainWindow, "Memo");
	((PVMEMODlg *) result)->setContent ((FEFormContent*)content);
    return result;
}

const XuStringVar FEMemoFormContentType::name () {
	return "Memo";
}

int FEMemoFormContentType::fieldCount () {
	return 6;
}

XuStringVar FEMemoFormContentType::fieldKey (int field) {
	switch (field) {
	case 0: return "Date";
	case 1: return "File";
	case 2: return "From";
	case 3: return "To";
	case 4: return "Memorandum";
	case 5: return "References";
	};
	return "";
}

FEFormContentType::FieldType FEMemoFormContentType::fieldType (int field) {
	if (field == 5) {
		return FEFormContentType::Reference;
	} else {
		return FEFormContentType::Text;
    }
}

char* FEMemoFormContentType::defaultText (int) {
	return "";
}

int FEMemoFormContentType::defaultCheck (int) {
	return 0;
}

int FEMemoFormContentType::selectedField (TWindowsObject *) {
	return -1;
}

PTWindowsObject FEMemoFormContentType::getControl (PTWindowsObject win, int field) {
	switch (field) {
	case 0: return ((PVMEMODlg *) win)->Edit1;
	case 1: return ((PVMEMODlg *) win)->Edit2;
	case 2: return ((PVMEMODlg *) win)->Edit3;
	case 3: return ((PVMEMODlg *) win)->Edit4;
	case 4: return ((PVMEMODlg *) win)->Edit5;
	case 5: return ((PVMEMODlg *) win)->Button6;
	};
	return NULL;
}

int FEMemoFormContentType::resourceID (int field) {
	return field + 1;
}

FEUI::Alignment FEMemoFormContentType::vertical () {
	return FEUI::Max;
}

FEUI::Alignment FEMemoFormContentType::horizontal () {
	return FEUI::Min;
}
