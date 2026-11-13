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
#include "akordfct.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "fe.h"

#include "pcaidcls.h"

FEAkordFormContentType::FEAkordFormContentType ()
	: FEFormContentType ()
{}

FEAkordFormContentType const FEAkordFormContentType::TheOne;

PTWindowsObject FEAkordFormContentType::makeWindow (FEContent * content) {
	PTWindowsObject result = new PVAKORDDlg (TheApp->MainWindow, "AKORD");
	((PVAKORDDlg *) result)->setContent ((FEFormContent*)content);
    return result;
}

const XuStringVar FEAkordFormContentType::name () {
	return "Akord";
}

int FEAkordFormContentType::fieldCount () {
	return 2;
}

XuStringVar FEAkordFormContentType::fieldKey (int fieldNum) {
	switch (fieldNum) {
	case 0: return "CGL";
	case 1: return "CCC";
	};
	return "";
}

FEFormContentType::FieldType FEAkordFormContentType::fieldType (int) {
	return FEFormContentType::Reference;
}

char* FEAkordFormContentType::defaultText (int) {
	return NULL;
}

int FEAkordFormContentType::defaultCheck (int) {
	return 0;
}

int FEAkordFormContentType::selectedField (TWindowsObject *) {
	return -1;
}

PTWindowsObject FEAkordFormContentType::getControl (PTWindowsObject win, int field) {
	// assert (field == 0 || field == 1);
	switch (field) {
		case 0: return ((PVAKORDDlg *) win)->PTCheck15;
		case 1: return ((PVAKORDDlg *) win)->Edit52;
		}
  return NULL; // fodder
}

int FEAkordFormContentType::resourceID (int field) {
	// assert (field == 0 || field == 1);
	switch (field) {
		case 0: return 15;
		case 1: return 52;
    }
	return 0; // fodder
}

FEUI::Alignment FEAkordFormContentType::vertical () {
	return FEUI::Max;
}

FEUI::Alignment FEAkordFormContentType::horizontal () {
	return FEUI::Min;
}
