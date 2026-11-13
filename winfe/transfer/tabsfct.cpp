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
#include "tabsfct.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "fe.h"

#include "pcaidcls.h"
FETabsFormContentType::FETabsFormContentType ()
	: FEFormContentType ()
{}

FETabsFormContentType const FETabsFormContentType::TheOne;
					  
PTWindowsObject FETabsFormContentType::makeWindow (FEContent * content) {
	PTWindowsObject result = new PVTABSDlg (TheApp->MainWindow, "TABS");
	((PVTABSDlg *) result)->setContent ((FEFormContent*) content);
    return result;
}

const XuStringVar FETabsFormContentType::name () {
	return "Tabs";
}

int FETabsFormContentType::fieldCount () {
	return 3;
}

XuStringVar FETabsFormContentType::fieldKey (int field) {
  switch (field) {
	case 0: return "Rate Instructions";
	case 1: return "Akord";
	case 2: return "Contractual Profile";
	}
	return NULL; // fodder 
}

FEFormContentType::FieldType FETabsFormContentType::fieldType (int) {
	return FEFormContentType::Reference;
}

char* FETabsFormContentType::defaultText (int) {
	return NULL;
}

int FETabsFormContentType::defaultCheck (int) {
	return 0;
}

int FETabsFormContentType::selectedField (TWindowsObject *) {
	return -1;
}

PTWindowsObject FETabsFormContentType::getControl (PTWindowsObject win, int) {
	return ((PVTABSDlg *) win)->Button1;
}

int FETabsFormContentType::resourceID (int field) {
  switch (field) {
	case 0: return 1;
	case 1: return 3;
	case 2: return 4;
	}
  return 0;
}

FEUI::Alignment FETabsFormContentType::vertical () {
	return FEUI::Min;
}

FEUI::Alignment FETabsFormContentType::horizontal () {
	return FEUI::Max;
}
