//REGEN_FILEHEADING
#pragma hdrfile "pcaide.sym"
#include <xanadu.hxx>
//REGEN_FILEHEADING

     /********************************************************************
      *                                                                  *
      *   Source File: AKORD.cpp                                         *
      *   Description: Dialog implementation for PCAIDE                  *
      *   Date:        Fri May 07 10:31:31 1993                          *
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
void PVAKORDDlg::SetupWindow()
{
   PVDialog::SetupWindow();

   //REGEN_AKORD_SETUP
	 PTCheck15->Check();
	 PTCheck11->Check();
	 PTCheck17->Check();
	 PTCheck18->Check();
	 PTCheck14->Check();
   //REGEN_AKORD_SETUP

}

// Define PVAKORDDlg, a PVDialog constructor
PVAKORDDlg::PVAKORDDlg(PTWindowsObject AParent, LPSTR AName)
               :PVDialog(AParent, AName)
{

   Edit1 = new TEdit(this, 1, 81);
   Edit2 = new TEdit(this, 2, 81);
   Edit3 = new TEdit(this, 3, 81);
   Edit4 = new TEdit(this, 4, 81);
   Edit5 = new TEdit(this, 5, 81);
   PTCheck6 = new TCheckBox(this, 6, 0);
   PTCheck7 = new TCheckBox(this, 7, 0);
   Edit8 = new TEdit(this, 8, 81);
   Edit9 = new TEdit(this, 9, 81);
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
   Edit32 = new TEdit(this, 32, 81);
   Edit33 = new TEdit(this, 33, 81);
   Edit34 = new TEdit(this, 34, 81);
   Edit35 = new TEdit(this, 35, 81);
   Edit36 = new TEdit(this, 36, 81);
   Edit37 = new TEdit(this, 37, 81);
   Edit38 = new TEdit(this, 38, 81);
   Edit39 = new TEdit(this, 39, 81);
   Edit40 = new TEdit(this, 40, 81);
   Edit41 = new TEdit(this, 41, 81);
   Edit42 = new TEdit(this, 42, 81);
   Edit43 = new TEdit(this, 43, 81);
   Edit44 = new TEdit(this, 44, 81);
   Edit45 = new TEdit(this, 45, 81);
   Edit46 = new TEdit(this, 46, 81);
   PTCheck47 = new TCheckBox(this, 47, 0);
   PTCheck48 = new TCheckBox(this, 48, 0);
   PTCheck49 = new TCheckBox(this, 49, 0);
   Edit50 = new TEdit(this, 50, 81);
   PTCheck51 = new TCheckBox(this, 51, 0);
   Edit52 = new TEdit(this, 52, 81);
   Edit53 = new TEdit(this, 53, 81);
   Edit54 = new TEdit(this, 54, 81);

   //REGEN_AKORD_CONSTRUCTOR
   //REGEN_AKORD_CONSTRUCTOR

}

// Define PVAKORDDlg destructor
PVAKORDDlg::~PVAKORDDlg()
{

   //REGEN_AKORD_DESTRUCTOR
   //REGEN_AKORD_DESTRUCTOR


}

void PVAKORDDlg::RTAKORD6(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD6_ROUTING
      //REGEN_AKORD6_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD7(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD7_ROUTING
      //REGEN_AKORD7_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD10(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD10_ROUTING
      //REGEN_AKORD10_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD11(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD11_ROUTING
      //REGEN_AKORD11_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD12(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD12_ROUTING
      //REGEN_AKORD12_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD13(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD13_ROUTING
      //REGEN_AKORD13_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD14(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD14_ROUTING
      //REGEN_AKORD14_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD15(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD15_ROUTING
      //REGEN_AKORD15_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD16(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD16_ROUTING
      //REGEN_AKORD16_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD17(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD17_ROUTING
      //REGEN_AKORD17_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD18(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD18_ROUTING
      //REGEN_AKORD18_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD19(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD19_ROUTING
      //REGEN_AKORD19_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD20(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD20_ROUTING
      //REGEN_AKORD20_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD21(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD21_ROUTING
      //REGEN_AKORD21_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD22(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD22_ROUTING
      //REGEN_AKORD22_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD23(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD23_ROUTING
      //REGEN_AKORD23_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD24(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD24_ROUTING
      //REGEN_AKORD24_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD25(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD25_ROUTING
      //REGEN_AKORD25_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD26(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD26_ROUTING
      //REGEN_AKORD26_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD27(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD27_ROUTING
      //REGEN_AKORD27_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD28(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD28_ROUTING
      //REGEN_AKORD28_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD29(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD29_ROUTING
      //REGEN_AKORD29_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD30(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD30_ROUTING
      //REGEN_AKORD30_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD31(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD31_ROUTING
      //REGEN_AKORD31_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD47(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD47_ROUTING
      //REGEN_AKORD47_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD48(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD48_ROUTING
      //REGEN_AKORD48_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD49(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD49_ROUTING
      //REGEN_AKORD49_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD51(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD51_ROUTING
      //REGEN_AKORD51_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD55(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD55_ROUTING
      //REGEN_AKORD55_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVAKORDDlg::RTAKORD56(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_AKORD56_ROUTING
      //REGEN_AKORD56_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}


//REGEN_CODE
<<<<<<< akord.cpp
void PVAKORDDlg::setDraft (FEDraftP draft) {
	myDraft = draft;
	delete PTCheck15; PTCheck15 = new FEFormRefCheckbox (this, 15, draft, "GLC");
	delete Edit52; Edit52 = new FEFormRefText (this, 52, draft, "GCC");
=======
void PVAKORDDlg::setDraft (FEDraftP draft) {
	myDraft = draft;
	delete PTCheck15; PTCheck15 = new FEFormRefCheckbox (this, 15, draft, "CGL");
	delete Edit52; Edit52 = new FEFormRefText (this, 52, draft, "CCC");
>>>>>>> 1.18
}


void PVAKORDDlg::WMDestroy (RTMessage msg) {
<<<<<<< akord.cpp
	FESheet::sheetOn(myDraft)->flush();
/*	if (FEManager::close(myContent->draft(), TRUE)) {
		this->PVDialog::WMDestroy (msg);
	}
*/}
=======
	FESheet::closeWindow(myDraft);
	TWindowsObject::WMDestroy(msg);
}

>>>>>>> 1.18
//REGEN_CODE

