//REGEN_FILEHEADING
#pragma hdrfile "pcaide.sym"
#include <xanadu.hxx>
//REGEN_FILEHEADING

     /********************************************************************
      *                                                                  *
      *   Source File: CPROF.cpp                                         *
      *   Description: Dialog implementation for PCAIDE                  *
      *   Date:        Fri May 07 10:31:34 1993                          *
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
void PVCPROFDlg::SetupWindow()
{
   PVDialog::SetupWindow();

   //REGEN_CPROF_SETUP
   //REGEN_CPROF_SETUP

}

// Define PVCPROFDlg, a PVDialog constructor
PVCPROFDlg::PVCPROFDlg(PTWindowsObject AParent, LPSTR AName)
               :PVDialog(AParent, AName)
{

   PTCheck10 = new TCheckBox(this, 10, 0);
   PTCheck11 = new TCheckBox(this, 11, 0);
   PTCheck12 = new TCheckBox(this, 12, 0);
   PTCheck13 = new TCheckBox(this, 13, 0);
   PTCheck14 = new TCheckBox(this, 14, 0);
   PTCheck15 = new TCheckBox(this, 15, 0);
   PTCheck16 = new TCheckBox(this, 16, 0);
   PTCheck17 = new TCheckBox(this, 17, 0);
   PTCheck18 = new TCheckBox(this, 18, 0);
   PTCheck19 = new TCheckBox(this, 19, 0);
   PTCheck20 = new TCheckBox(this, 20, 0);
   PTCheck21 = new TCheckBox(this, 21, 0);
   PTCheck22 = new TCheckBox(this, 22, 0);
   PTCheck23 = new TCheckBox(this, 23, 0);
   PTCheck24 = new TCheckBox(this, 24, 0);
   PTCheck25 = new TCheckBox(this, 25, 0);
   PTCheck26 = new TCheckBox(this, 26, 0);
   PTCheck27 = new TCheckBox(this, 27, 0);
   PTCheck28 = new TCheckBox(this, 28, 0);
   PTCheck29 = new TCheckBox(this, 29, 0);
   PTCheck30 = new TCheckBox(this, 30, 0);
   PTCheck31 = new TCheckBox(this, 31, 0);
   PTCheck32 = new TCheckBox(this, 32, 0);
   PTCheck33 = new TCheckBox(this, 33, 0);
   PTCheck34 = new TCheckBox(this, 34, 0);
   PTCheck35 = new TCheckBox(this, 35, 0);
   PTCheck36 = new TCheckBox(this, 36, 0);
   PTCheck37 = new TCheckBox(this, 37, 0);
   PTCheck38 = new TCheckBox(this, 38, 0);
   PTCheck39 = new TCheckBox(this, 39, 0);
   PTCheck40 = new TCheckBox(this, 40, 0);
   PTCheck41 = new TCheckBox(this, 41, 0);
   PTCheck46 = new TCheckBox(this, 46, 0);
   PTCheck47 = new TCheckBox(this, 47, 0);
   PTCheck48 = new TCheckBox(this, 48, 0);
   PTCheck49 = new TCheckBox(this, 49, 0);
   PTCheck50 = new TCheckBox(this, 50, 0);

   //REGEN_CPROF_CONSTRUCTOR
   //REGEN_CPROF_CONSTRUCTOR

}

// Define PVCPROFDlg destructor
PVCPROFDlg::~PVCPROFDlg()
{

   //REGEN_CPROF_DESTRUCTOR
   //REGEN_CPROF_DESTRUCTOR


}

void PVCPROFDlg::RTCPROF10(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF10_ROUTING
      //REGEN_CPROF10_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF11(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF11_ROUTING
      //REGEN_CPROF11_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF12(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF12_ROUTING
      //REGEN_CPROF12_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF13(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF13_ROUTING
      //REGEN_CPROF13_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF14(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF14_ROUTING
      //REGEN_CPROF14_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF15(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF15_ROUTING
      //REGEN_CPROF15_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF16(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF16_ROUTING
      //REGEN_CPROF16_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF17(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF17_ROUTING
      //REGEN_CPROF17_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF18(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF18_ROUTING
      //REGEN_CPROF18_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF19(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF19_ROUTING
      //REGEN_CPROF19_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF20(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF20_ROUTING
      //REGEN_CPROF20_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF21(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF21_ROUTING
      //REGEN_CPROF21_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF22(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF22_ROUTING
      //REGEN_CPROF22_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF23(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF23_ROUTING
      //REGEN_CPROF23_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF24(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF24_ROUTING
      //REGEN_CPROF24_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF25(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF25_ROUTING
      //REGEN_CPROF25_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF26(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF26_ROUTING
      //REGEN_CPROF26_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF27(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF27_ROUTING
      //REGEN_CPROF27_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF28(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF28_ROUTING
      //REGEN_CPROF28_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF29(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF29_ROUTING
      //REGEN_CPROF29_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF30(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF30_ROUTING
      //REGEN_CPROF30_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF31(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF31_ROUTING
      //REGEN_CPROF31_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF32(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF32_ROUTING
      //REGEN_CPROF32_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF33(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF33_ROUTING
      //REGEN_CPROF33_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF34(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF34_ROUTING
      //REGEN_CPROF34_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF35(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF35_ROUTING
      //REGEN_CPROF35_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF36(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF36_ROUTING
      //REGEN_CPROF36_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF37(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF37_ROUTING
      //REGEN_CPROF37_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF38(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF38_ROUTING
      //REGEN_CPROF38_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF39(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF39_ROUTING
      //REGEN_CPROF39_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF40(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF40_ROUTING
      //REGEN_CPROF40_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF41(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF41_ROUTING
      //REGEN_CPROF41_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF42(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF42_ROUTING
      //REGEN_CPROF42_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF43(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF43_ROUTING
      //REGEN_CPROF43_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF46(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF46_ROUTING
      //REGEN_CPROF46_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF47(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF47_ROUTING
      //REGEN_CPROF47_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF48(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF48_ROUTING
      //REGEN_CPROF48_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF49(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF49_ROUTING
      //REGEN_CPROF49_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVCPROFDlg::RTCPROF50(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_CPROF50_ROUTING
      //REGEN_CPROF50_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}


//REGEN_CODE
void PVCPROFDlg::setDraft (FEDraftP draft) {
	myDraft = draft;
}

void PVCPROFDlg::WMActivate (RTMessage msg) {
// this can be put back in if we want to make references to the profile
//	if (msg.WParam != WA_INACTIVE) {
//		FEDeskManager::setCurrentSheet(FESheet::sheetOn(myDraft));
//	}
	TWindowsObject::WMActivate(msg);
}


void PVCPROFDlg::WMDestroy (RTMessage msg) {
//	FEDeskManager::setCurrentSheet(NULL);
	FESheet::closeWindow(myDraft);
  TWindowsObject::WMDestroy(msg);
}

//REGEN_CODE

