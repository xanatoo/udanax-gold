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
#include "cproffct.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "fe.h"

#include "pcaidcls.h"

FECProfFormContentType::FECProfFormContentType ()
	: FEFormContentType ()
{}

FECProfFormContentType const FECProfFormContentType::TheOne;

PTWindowsObject FECProfFormContentType::makeWindow (FEContent * content) {
	PTWindowsObject result = new PVCPROFDlg (TheApp->MainWindow, "CPROF");
	((PVCPROFDlg *) result)->setContent ((FEFormContent*)content);
    return result;
}

const XuStringVar FECProfFormContentType::name () {
	return "CProf";
}

int FECProfFormContentType::fieldCount () {
	return 0;
}

XuStringVar FECProfFormContentType::fieldKey (int) {
	return "";
}

FEFormContentType::FieldType FECProfFormContentType::fieldType (int) {
	return FECProfFormContentType::Reference;
}

char* FECProfFormContentType::defaultText (int) {
	return NULL;
}

int FECProfFormContentType::defaultCheck (int) {
	return 0;
}

int FECProfFormContentType::selectedField (TWindowsObject *) {
	return -1;
}

PTWindowsObject FECProfFormContentType::getControl (PTWindowsObject, int) {
	return NULL;
}

int FECProfFormContentType::resourceID (int) {
	return 0;
}

FEUI::Alignment FECProfFormContentType::vertical () {
	return FEUI::Max;
}

FEUI::Alignment FECProfFormContentType::horizontal () {
	return FEUI::Max;
}
