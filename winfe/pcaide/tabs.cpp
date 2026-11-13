//REGEN_FILEHEADING
#pragma hdrfile "pcaide.sym"
#include <xanadu.hxx>
//REGEN_FILEHEADING

     /********************************************************************
      *                                                                  *
      *   Source File: TABS.cpp                                          *
      *   Description: Dialog implementation for PCAIDE                  *
      *   Date:        Fri May 07 10:31:36 1993                          *
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
void PVTABSDlg::SetupWindow()
{
   PVDialog::SetupWindow();

   //REGEN_TABS_SETUP
   //REGEN_TABS_SETUP

}

// Define PVTABSDlg, a PVDialog constructor
PVTABSDlg::PVTABSDlg(PTWindowsObject AParent, LPSTR AName)
               :PVDialog(AParent, AName)
{


   //REGEN_TABS_CONSTRUCTOR
   //REGEN_TABS_CONSTRUCTOR

}

// Define PVTABSDlg destructor
PVTABSDlg::~PVTABSDlg()
{

   //REGEN_TABS_DESTRUCTOR
   //REGEN_TABS_DESTRUCTOR


}

void PVTABSDlg::RTTABS1(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_TABS1_ROUTING
      //REGEN_TABS1_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVTABSDlg::RTTABS2(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_TABS2_ROUTING
			if (PVUMDlg::lastWork () != XU_NULL) {
				FESheet::showWork(PVUMDlg::lastWork ());
			}
      //REGEN_TABS2_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVTABSDlg::RTTABS3(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_TABS3_ROUTING
      //REGEN_TABS3_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVTABSDlg::RTTABS4(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_TABS4_ROUTING
      //REGEN_TABS4_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}


//REGEN_CODE
void PVTABSDlg::setDraft (FEDraftP draft) {
	myDraft = draft;
	Button1 = new FEFormRateRefButton (this, 1, draft, "Rate Instructions");
	Button3 = new FEFormRefButton (this, 3, draft, "Akord");
	Button4 = new FEFormRefButton (this, 4, draft, "Contractual Profile");
}

void PVTABSDlg::WMDestroy (RTMessage msg) {
	FESheet::closeWindow(myDraft);
  TWindowsObject::WMDestroy(msg);
}

//REGEN_CODE

