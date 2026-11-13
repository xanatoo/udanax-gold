//REGEN_FILEHEADING
#pragma hdrfile "pcaide.sym"
#include <xanadu.hxx>
//REGEN_FILEHEADING

     /********************************************************************
      *                                                                  *
      *   Source File: UM.cpp                                            *
      *   Description: Dialog implementation for PCAIDE                  *
      *   Date:        Fri May 07 10:31:38 1993                          *
      *                                                                  *
      ********************************************************************/

#include <owl.h>
#include <edit.h>
#include <listbox.h>
#include <combobox.h>
#include <bchkbox.h>
#include <checkbox.h>
#include <bradio.h>
#include <radiobut.h>
#include <scrollba.h>
#include <dialog.h>
#include <pvdialog.h>
#include <bwcc.h>
#include <dtctl.h>
#include "PCAideID.h"
#include "PCAidCls.h"


//REGEN_VARIABLES
#include <xanadu.hxx>
#include "formui.h"
#include "draft.h"
#include "content.h"
#include "sheet.h"
#include "mxapp.h"
#pragma hdrstop
//REGEN_VARIABLES

extern HANDLE hInst;



// Place all Window or field interaction here, not in the constructor.
void PVUMDlg::SetupWindow()
{
   PVDialog::SetupWindow();

   //REGEN_UM_SETUP
	 //REGEN_UM_SETUP

}

// Define PVUMDlg, a PVDialog constructor
PVUMDlg::PVUMDlg(PTWindowsObject AParent, LPSTR AName)
               :PVDialog(AParent, AName)
{

   Edit10 = new TEdit(this, 10, 81);
   Edit12 = new TEdit(this, 12, 81);
   Edit13 = new TEdit(this, 13, 81);
   Edit14 = new TEdit(this, 14, 81);
   Edit15 = new TEdit(this, 15, 81);
   Edit16 = new TEdit(this, 16, 81);
   Edit17 = new TEdit(this, 17, 81);

   //REGEN_UM_CONSTRUCTOR
   //REGEN_UM_CONSTRUCTOR

}

// Define PVUMDlg destructor
PVUMDlg::~PVUMDlg()
{

   //REGEN_UM_DESTRUCTOR
   //REGEN_UM_DESTRUCTOR


}

void PVUMDlg::RTUM11(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_UM11_ROUTING
      //REGEN_UM11_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVUMDlg::RTUM18(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_UM18_ROUTING
      //REGEN_UM18_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}


//REGEN_CODE

PVUMDlg * PVUMDlg::Active = NULL;
XuWorkP PVUMDlg::LastWork;

void PVUMDlg::setDraft (FEDraftP draft) {
	myDraft = draft;
	delete Edit10; 	Edit10 = new FEFormTextCompare (this, 10, draft, "Contents", "Original");
	Button11 = new FEFormRefButton (this, 11, draft, "Exhibit");
	XuPromise::waitForReady (new FERefButtonHook (
		draft->content()->edition()->hasPosition ("Exhibit"),
        Button11));
	delete Edit12; 	Edit12 = new FEFormEdit (this, 12, draft, "Manual");
	delete Edit13; 	Edit13 = new FEFormEdit (this, 13, draft, "Procedure");
	delete Edit14; 	Edit14 = new FEFormEdit (this, 14, draft, "Page");
	delete Edit15; 	Edit15 = new FEFormEdit (this, 15, draft, "Date");
	delete Edit16; 	Edit16 = new FEFormEdit (this, 16, draft, "Rev");
	delete Edit17; 	Edit17 = new FEFormEdit (this, 17, draft, "Title");

  LastWork = draft->work();
}

#ifdef UMCHANGE_SUPPORT_OBSOLETE
// Obsolete since we don't actually do any magic with the UM change.
class FEUMChangedHook : public XuReadyHook {
private:
	FESheetP mySheet;
  XuIntValueP myValue;
public:
	FEUMChangedHook (FESheetP sheet, XuIntValueP value)
		: XuReadyHook(), mySheet(sheet), myValue(value) {}

	virtual void ready () {
		FEDeskManager::setCurrentSheet(mySheet, myValue->asInt());
	}
};
#endif

void PVUMDlg::WMActivate (RTMessage msg) {
	if (msg.WParam != WA_INACTIVE) {
		FEDeskManager::setCurrentSheet(FESheet::sheetOn(myDraft));
	}
	TWindowsObject::WMActivate(msg);
}

void PVUMDlg::WMDestroy (RTMessage msg) {
	FEDeskManager::setCurrentSheet(NULL);
	FESheet::closeWindow(myDraft);
  TWindowsObject::WMDestroy(msg);
}

//REGEN_CODE

