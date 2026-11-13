//REGEN_FILEHEADING
#pragma hdrfile "pcaide.sym"
#include <xanadu.hxx>
//REGEN_FILEHEADING

     /********************************************************************
      *                                                                  *
      *   Source File: ATTN.cpp                                          *
      *   Description: Dialog implementation for PCAIDE                  *
      *   Date:        Fri May 07 10:31:39 1993                          *
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
#pragma hdrstop
//REGEN_VARIABLES

extern HANDLE hInst;



// Place all Window or field interaction here, not in the constructor.
void PVATTNDlg::SetupWindow()
{
   PVDialog::SetupWindow();

   //REGEN_ATTN_SETUP
   //REGEN_ATTN_SETUP

}

// Define PVATTNDlg, a PVDialog constructor
PVATTNDlg::PVATTNDlg(PTWindowsObject AParent, LPSTR AName)
               :PVDialog(AParent, AName)
{

   Edit3 = new TEdit(this, 3, 81);

   //REGEN_ATTN_CONSTRUCTOR
   //REGEN_ATTN_CONSTRUCTOR

}

// Define PVATTNDlg destructor
PVATTNDlg::~PVATTNDlg()
{

   //REGEN_ATTN_DESTRUCTOR
   //REGEN_ATTN_DESTRUCTOR


}

void PVATTNDlg::RTATTN1(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_ATTN1_ROUTING
      //REGEN_ATTN1_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVATTNDlg::RTATTN2(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_ATTN2_ROUTING
      //REGEN_ATTN2_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}


//REGEN_CODE
void PVATTNDlg::setDraft (FEDraftP draft) {
	myDraft = draft;
	Button1 = new FEFormRefButton (this, 1, draft, "Read");
	delete Edit3; Edit3 = new FEFormEdit (this, 3, draft, "Message");
}

void PVATTNDlg::WMDestroy (RTMessage msg) {
	FESheet::closeWindow(myDraft);
  TWindowsObject::WMDestroy(msg);
}

//REGEN_CODE

