//REGEN_FILEHEADING
#pragma hdrfile "pcaide.sym"
#include <xanadu.hxx>
//REGEN_FILEHEADING

     /********************************************************************
      *                                                                  *
      *   Source File: MEMO.cpp                                          *
      *   Description: Dialog implementation for PCAIDE                  *
      *   Date:        Fri May 07 10:31:37 1993                          *
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
#pragma hdrfile "pcaide.sym"
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
void PVMEMODlg::SetupWindow()
{
   PVDialog::SetupWindow();

   //REGEN_MEMO_SETUP
   //REGEN_MEMO_SETUP

}

// Define PVMEMODlg, a PVDialog constructor
PVMEMODlg::PVMEMODlg(PTWindowsObject AParent, LPSTR AName)
               :PVDialog(AParent, AName)
{

   Edit1 = new TEdit(this, 1, 81);
   Edit2 = new TEdit(this, 2, 81);
   Edit3 = new TEdit(this, 3, 81);
   Edit4 = new TEdit(this, 4, 81);
   Edit5 = new TEdit(this, 5, 81);

   //REGEN_MEMO_CONSTRUCTOR
   //REGEN_MEMO_CONSTRUCTOR

}

// Define PVMEMODlg destructor
PVMEMODlg::~PVMEMODlg()
{

   //REGEN_MEMO_DESTRUCTOR
   //REGEN_MEMO_DESTRUCTOR


}

void PVMEMODlg::RTMEMO6(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_MEMO6_ROUTING
      //REGEN_MEMO6_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVMEMODlg::RTMEMO7(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_MEMO7_ROUTING
      //REGEN_MEMO7_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVMEMODlg::RTMEMO8(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_MEMO8_ROUTING
      //REGEN_MEMO8_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}


//REGEN_CODE
void PVMEMODlg::setDraft (FEDraftP draft) {
	myDraft = draft;
	delete Edit1;
	Edit1 = new FEFormEdit (this, 1, draft, "Date");
	delete Edit2;
	Edit2 = new FEFormEdit (this, 2, draft, "File");
	delete Edit3;
	Edit3 = new FEFormEdit (this, 3, draft, "From");
	delete Edit4;
	Edit4 = new FEFormEdit (this, 4, draft, "To");
	delete Edit5;
	Edit5 = new FEFormEdit (this, 5, draft, "Memorandum");
	Button6 = new FEFormRefButton (this, 6, draft, "References");
	XuPromise::waitForReady (new FERefButtonHook (
		draft->content()->edition()->hasPosition ("References"),
		Button6));
}


void PVMEMODlg::WMActivate (RTMessage msg) {
	if (msg.WParam != WA_INACTIVE) {
		FEDeskManager::setCurrentSheet(FESheet::sheetOn(myDraft));
	}
	TWindowsObject::WMActivate(msg);
}


void PVMEMODlg::WMDestroy (RTMessage msg) {
	FEDeskManager::setCurrentSheet(NULL);
	FESheet::closeWindow(myDraft);
  TWindowsObject::WMDestroy(msg);
}

//REGEN_CODE

