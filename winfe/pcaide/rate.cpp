//REGEN_FILEHEADING
#pragma hdrfile "pcaide.sym"
#include <xanadu.hxx>
//REGEN_FILEHEADING

     /********************************************************************
      *                                                                  *
      *   Source File: RATE.cpp                                          *
      *   Description: Dialog implementation for PCAIDE                  *
      *   Date:        Fri May 07 10:31:33 1993                          *
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
#include "formct.h"
#include "ratefct.h"
#pragma hdrstop
//REGEN_VARIABLES

extern HANDLE hInst;



// Place all Window or field interaction here, not in the constructor.
void PVRATEDlg::SetupWindow()
{
   PVDialog::SetupWindow();

   //REGEN_RATE_SETUP
   //REGEN_RATE_SETUP

}

// Define PVRATEDlg, a PVDialog constructor
PVRATEDlg::PVRATEDlg(PTWindowsObject AParent, LPSTR AName)
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
   Edit16 = new TEdit(this, 16, 81);
   Edit17 = new TEdit(this, 17, 81);
   Edit18 = new TEdit(this, 18, 81);
   Edit19 = new TEdit(this, 19, 81);
   Edit20 = new TEdit(this, 20, 81);
   Edit21 = new TEdit(this, 21, 81);
   Edit22 = new TEdit(this, 22, 81);
   Edit23 = new TEdit(this, 23, 81);
   Edit24 = new TEdit(this, 24, 81);
   Edit25 = new TEdit(this, 25, 81);
   Edit26 = new TEdit(this, 26, 81);
   Edit27 = new TEdit(this, 27, 81);
   Edit28 = new TEdit(this, 28, 81);
   Edit29 = new TEdit(this, 29, 81);
   Edit30 = new TEdit(this, 30, 81);
   Edit31 = new TEdit(this, 31, 81);
   Edit32 = new TEdit(this, 32, 81);
   Edit33 = new TEdit(this, 33, 81);
   Edit34 = new TEdit(this, 34, 81);
   Edit35 = new TEdit(this, 35, 81);

   //REGEN_RATE_CONSTRUCTOR
   //REGEN_RATE_CONSTRUCTOR

}

// Define PVRATEDlg destructor
PVRATEDlg::~PVRATEDlg()
{

   //REGEN_RATE_DESTRUCTOR
	 FESheet::closeWindow(myDraft);
   //REGEN_RATE_DESTRUCTOR


}

void PVRATEDlg::RTRATE6(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_RATE6_ROUTING
      //REGEN_RATE6_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVRATEDlg::RTRATE7(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_RATE7_ROUTING
      //REGEN_RATE7_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVRATEDlg::RTRATE10(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_RATE10_ROUTING
      //REGEN_RATE10_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}

void PVRATEDlg::RTRATE11(RTMessage Msg)
{
   //REGEN_VAR
   //REGEN_VAR
   switch(Msg.LP.Hi)
   {
      case BN_CLICKED :
      //REGEN_RATE11_ROUTING
      //REGEN_RATE11_ROUTING
      break;
   }
   //REGEN_END
   //REGEN_END
}


//REGEN_CODE
void PVRATEDlg::setDraft (FEDraftP draft) {
	myDraft = draft;

/*
	delete Edit1;	Edit1 = new FEFormEdit (this, 1, draft, "Instructions");
*/
	delete Edit16;	Edit16 = new FEFormEdit (this, 16, draft,
		FERateFormContent::fieldKeyStr(0, "Rate"));
	delete Edit17;	Edit17 = new FEFormEdit (this, 17, draft,
		FERateFormContent::fieldKeyStr(0, "Base"));
	delete Edit18;	Edit18 = new FEFormRefEdit (this, 18, draft,
		FERateFormContent::fieldKeyStr(0, "Source"),
		FERateFormContent::fieldKeyStr(0, "Reference"));
	delete Edit19;	Edit19 = new FEFormEdit (this, 19, draft,
		FERateFormContent::fieldKeyStr(0, "Comments"));

	delete Edit20;	Edit20 = new FEFormEdit (this, 20, draft,
		FERateFormContent::fieldKeyStr(1, "Rate"));
	delete Edit21;	Edit21 = new FEFormEdit (this, 21, draft,
		FERateFormContent::fieldKeyStr(1, "Base"));
	delete Edit22;	Edit22 = new FEFormRefEdit (this, 22, draft,
		FERateFormContent::fieldKeyStr(1, "Source"),
		FERateFormContent::fieldKeyStr(1, "Reference"));
	delete Edit23;	Edit23 = new FEFormEdit (this, 23, draft,
		FERateFormContent::fieldKeyStr(1, "Comments"));

	delete Edit24;	Edit24 = new FEFormEdit (this, 24, draft,
		FERateFormContent::fieldKeyStr(2, "Rate"));
	delete Edit25;	Edit25 = new FEFormEdit (this, 25, draft,
		FERateFormContent::fieldKeyStr(2, "Base"));
	delete Edit26;	Edit26 = new FEFormRefEdit (this, 26, draft,
		FERateFormContent::fieldKeyStr(2, "Source"),
		FERateFormContent::fieldKeyStr(2, "Reference"));
	delete Edit27;	Edit27 = new FEFormEdit (this, 27, draft,
		FERateFormContent::fieldKeyStr(2, "Comments"));

	delete Edit28;	Edit28 = new FEFormEdit (this, 28, draft,
		FERateFormContent::fieldKeyStr(3, "Rate"));
	delete Edit29;	Edit29 = new FEFormEdit (this, 29, draft,
		FERateFormContent::fieldKeyStr(3, "Base"));
	delete Edit30;	Edit30 = new FEFormRefEdit (this, 30, draft,
		FERateFormContent::fieldKeyStr(3, "Source"),
		FERateFormContent::fieldKeyStr(3, "Reference"));
	delete Edit31;	Edit31 = new FEFormEdit (this, 31, draft,
		FERateFormContent::fieldKeyStr(3, "Comments"));

	delete Edit32;	Edit32 = new FEFormEdit (this, 32, draft,
		FERateFormContent::fieldKeyStr(4, "Rate"));
	delete Edit33;	Edit33 = new FEFormEdit (this, 33, draft,
		FERateFormContent::fieldKeyStr(4, "Base"));
	delete Edit34;	Edit34 = new FEFormRefEdit (this, 34, draft,
		FERateFormContent::fieldKeyStr(4, "Source"),
		FERateFormContent::fieldKeyStr(4, "Reference"));
	delete Edit35;	Edit35 = new FEFormEdit (this, 35, draft,
		FERateFormContent::fieldKeyStr(4, "Comments"));
/*
	delete Edit36;	Edit36 = new FEFormEdit (this, 36, draft,
		FERateFormContent::fieldKeyStr(5, "Rate"));
	delete Edit37;	Edit37 = new FEFormEdit (this, 37, draft,
		FERateFormContent::fieldKeyStr(5, "Base"));
	delete Edit38;	Edit38 = new FEFormEdit (this, 38, draft,
		FERateFormContent::fieldKeyStr(5, "Source"));
	delete Edit39;	Edit39 = new FEFormEdit (this, 39, draft,
		FERateFormContent::fieldKeyStr(5, "Comments"));
*/
}

void PVRATEDlg::WMDestroy (RTMessage msg) {
	FESheet::closeWindow(myDraft);
  TWindowsObject::WMDestroy(msg);
}

//REGEN_CODE

