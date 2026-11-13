//REGEN_FILEHEADING
//REGEN_FILEHEADING

     /********************************************************************
      *                                                                  *
      *   Source File: PCAidCls.h                                        *
      *   Description: Dialog Classes for PCAide                         *
      *   Date:        Fri May 07 10:31:26 1993                          *
      *                                                                  *
      ********************************************************************/

#ifndef __PCAIDECLS__H
#define __PCAIDECLS__H

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

//REGEN_VARIABLES
#include "draft.oxx"
#include "content.oxx"
//REGEN_VARIABLES


_CLASSDEF(PVAKORDDlg)

// Declare PVAKORDDlg, a PVDialog descendant
class PVAKORDDlg : public PVDialog 
{
public:
   PTEdit Edit1;
   PTEdit Edit2;
   PTEdit Edit3;
   PTEdit Edit4;
   PTEdit Edit5;
   TCheckBox *PTCheck6;
   TCheckBox *PTCheck7;
   PTEdit Edit8;
   PTEdit Edit9;
   TCheckBox *PTCheck10;
   TCheckBox *PTCheck11;
   TCheckBox *PTCheck12;
   TCheckBox *PTCheck13;
   TCheckBox *PTCheck14;
   TCheckBox *PTCheck15;
   TCheckBox *PTCheck16;
   TCheckBox *PTCheck17;
   TCheckBox *PTCheck18;
   TCheckBox *PTCheck19;
   TCheckBox *PTCheck20;
   TCheckBox *PTCheck21;
   TCheckBox *PTCheck22;
   TCheckBox *PTCheck23;
   TCheckBox *PTCheck24;
   TCheckBox *PTCheck25;
   TCheckBox *PTCheck26;
   TCheckBox *PTCheck27;
   TCheckBox *PTCheck28;
   TCheckBox *PTCheck29;
   TCheckBox *PTCheck30;
   TCheckBox *PTCheck31;
   PTEdit Edit32;
   PTEdit Edit33;
   PTEdit Edit34;
   PTEdit Edit35;
   PTEdit Edit36;
   PTEdit Edit37;
   PTEdit Edit38;
   PTEdit Edit39;
   PTEdit Edit40;
   PTEdit Edit41;
   PTEdit Edit42;
   PTEdit Edit43;
   PTEdit Edit44;
   PTEdit Edit45;
   PTEdit Edit46;
   TCheckBox *PTCheck47;
   TCheckBox *PTCheck48;
   TCheckBox *PTCheck49;
   PTEdit Edit50;
   TCheckBox *PTCheck51;
   PTEdit Edit52;
   PTEdit Edit53;
   PTEdit Edit54;

   PVAKORDDlg(PTWindowsObject AParent, LPSTR AName);
   ~PVAKORDDlg();
   virtual void SetupWindow();
   virtual void RTAKORD6(RTMessage Msg) = [ID_FIRST + 6];
   virtual void RTAKORD7(RTMessage Msg) = [ID_FIRST + 7];
   virtual void RTAKORD10(RTMessage Msg) = [ID_FIRST + 10];
   virtual void RTAKORD11(RTMessage Msg) = [ID_FIRST + 11];
   virtual void RTAKORD12(RTMessage Msg) = [ID_FIRST + 12];
   virtual void RTAKORD13(RTMessage Msg) = [ID_FIRST + 13];
   virtual void RTAKORD14(RTMessage Msg) = [ID_FIRST + 14];
   virtual void RTAKORD15(RTMessage Msg) = [ID_FIRST + 15];
   virtual void RTAKORD16(RTMessage Msg) = [ID_FIRST + 16];
   virtual void RTAKORD17(RTMessage Msg) = [ID_FIRST + 17];
   virtual void RTAKORD18(RTMessage Msg) = [ID_FIRST + 18];
   virtual void RTAKORD19(RTMessage Msg) = [ID_FIRST + 19];
   virtual void RTAKORD20(RTMessage Msg) = [ID_FIRST + 20];
   virtual void RTAKORD21(RTMessage Msg) = [ID_FIRST + 21];
   virtual void RTAKORD22(RTMessage Msg) = [ID_FIRST + 22];
   virtual void RTAKORD23(RTMessage Msg) = [ID_FIRST + 23];
   virtual void RTAKORD24(RTMessage Msg) = [ID_FIRST + 24];
   virtual void RTAKORD25(RTMessage Msg) = [ID_FIRST + 25];
   virtual void RTAKORD26(RTMessage Msg) = [ID_FIRST + 26];
   virtual void RTAKORD27(RTMessage Msg) = [ID_FIRST + 27];
   virtual void RTAKORD28(RTMessage Msg) = [ID_FIRST + 28];
   virtual void RTAKORD29(RTMessage Msg) = [ID_FIRST + 29];
   virtual void RTAKORD30(RTMessage Msg) = [ID_FIRST + 30];
   virtual void RTAKORD31(RTMessage Msg) = [ID_FIRST + 31];
   virtual void RTAKORD47(RTMessage Msg) = [ID_FIRST + 47];
   virtual void RTAKORD48(RTMessage Msg) = [ID_FIRST + 48];
   virtual void RTAKORD49(RTMessage Msg) = [ID_FIRST + 49];
   virtual void RTAKORD51(RTMessage Msg) = [ID_FIRST + 51];
   virtual void RTAKORD55(RTMessage Msg) = [ID_FIRST + 55];
   virtual void RTAKORD56(RTMessage Msg) = [ID_FIRST + 56];
   //REGEN_AKORD_CLASS

	 virtual void WMDestroy (RTMessage msg) = [WM_FIRST + WM_DESTROY];

private:

	FEDraftP myDraft;

	// This should be called _right_ after the constructor
	friend class FEAkordFormContentType;
	void setDraft (FEDraftP draft);

   //REGEN_AKORD_CLASS

};

_CLASSDEF(PVRATEDlg)

// Declare PVRATEDlg, a PVDialog descendant
class PVRATEDlg : public PVDialog 
{
public:
   PTEdit Edit1;
   PTEdit Edit2;
   PTEdit Edit3;
   PTEdit Edit4;
   PTEdit Edit5;
   TCheckBox *PTCheck6;
   TCheckBox *PTCheck7;
   PTEdit Edit8;
   PTEdit Edit9;
   PTEdit Edit16;
   PTEdit Edit17;
   PTEdit Edit18;
   PTEdit Edit19;
   PTEdit Edit20;
   PTEdit Edit21;
   PTEdit Edit22;
   PTEdit Edit23;
   PTEdit Edit24;
   PTEdit Edit25;
   PTEdit Edit26;
   PTEdit Edit27;
   PTEdit Edit28;
   PTEdit Edit29;
   PTEdit Edit30;
   PTEdit Edit31;
   PTEdit Edit32;
   PTEdit Edit33;
   PTEdit Edit34;
   PTEdit Edit35;

   PVRATEDlg(PTWindowsObject AParent, LPSTR AName);
   ~PVRATEDlg();
   virtual void SetupWindow();
   virtual void RTRATE6(RTMessage Msg) = [ID_FIRST + 6];
   virtual void RTRATE7(RTMessage Msg) = [ID_FIRST + 7];
   virtual void RTRATE10(RTMessage Msg) = [ID_FIRST + 10];
   virtual void RTRATE11(RTMessage Msg) = [ID_FIRST + 11];
   //REGEN_RATE_CLASS

	 virtual void WMDestroy (RTMessage msg) = [WM_FIRST + WM_DESTROY];

private:

	FEDraftP myDraft;

	// This should be called _right_ after the constructor
	friend class FERateFormContentType;
	void setDraft (FEDraftP draft);

   //REGEN_RATE_CLASS

};

_CLASSDEF(PVCPROFDlg)

// Declare PVCPROFDlg, a PVDialog descendant
class PVCPROFDlg : public PVDialog 
{
public:
   TCheckBox *PTCheck10;
   TCheckBox *PTCheck11;
   TCheckBox *PTCheck12;
   TCheckBox *PTCheck13;
   TCheckBox *PTCheck14;
   TCheckBox *PTCheck15;
   TCheckBox *PTCheck16;
   TCheckBox *PTCheck17;
   TCheckBox *PTCheck18;
   TCheckBox *PTCheck19;
   TCheckBox *PTCheck20;
   TCheckBox *PTCheck21;
   TCheckBox *PTCheck22;
   TCheckBox *PTCheck23;
   TCheckBox *PTCheck24;
   TCheckBox *PTCheck25;
   TCheckBox *PTCheck26;
   TCheckBox *PTCheck27;
   TCheckBox *PTCheck28;
   TCheckBox *PTCheck29;
   TCheckBox *PTCheck30;
   TCheckBox *PTCheck31;
   TCheckBox *PTCheck32;
   TCheckBox *PTCheck33;
   TCheckBox *PTCheck34;
   TCheckBox *PTCheck35;
   TCheckBox *PTCheck36;
   TCheckBox *PTCheck37;
   TCheckBox *PTCheck38;
   TCheckBox *PTCheck39;
   TCheckBox *PTCheck40;
   TCheckBox *PTCheck41;
   TCheckBox *PTCheck46;
   TCheckBox *PTCheck47;
   TCheckBox *PTCheck48;
   TCheckBox *PTCheck49;
   TCheckBox *PTCheck50;

   PVCPROFDlg(PTWindowsObject AParent, LPSTR AName);
   ~PVCPROFDlg();
   virtual void SetupWindow();
   virtual void RTCPROF10(RTMessage Msg) = [ID_FIRST + 10];
   virtual void RTCPROF11(RTMessage Msg) = [ID_FIRST + 11];
   virtual void RTCPROF12(RTMessage Msg) = [ID_FIRST + 12];
   virtual void RTCPROF13(RTMessage Msg) = [ID_FIRST + 13];
   virtual void RTCPROF14(RTMessage Msg) = [ID_FIRST + 14];
   virtual void RTCPROF15(RTMessage Msg) = [ID_FIRST + 15];
   virtual void RTCPROF16(RTMessage Msg) = [ID_FIRST + 16];
   virtual void RTCPROF17(RTMessage Msg) = [ID_FIRST + 17];
   virtual void RTCPROF18(RTMessage Msg) = [ID_FIRST + 18];
   virtual void RTCPROF19(RTMessage Msg) = [ID_FIRST + 19];
   virtual void RTCPROF20(RTMessage Msg) = [ID_FIRST + 20];
   virtual void RTCPROF21(RTMessage Msg) = [ID_FIRST + 21];
   virtual void RTCPROF22(RTMessage Msg) = [ID_FIRST + 22];
   virtual void RTCPROF23(RTMessage Msg) = [ID_FIRST + 23];
   virtual void RTCPROF24(RTMessage Msg) = [ID_FIRST + 24];
   virtual void RTCPROF25(RTMessage Msg) = [ID_FIRST + 25];
   virtual void RTCPROF26(RTMessage Msg) = [ID_FIRST + 26];
   virtual void RTCPROF27(RTMessage Msg) = [ID_FIRST + 27];
   virtual void RTCPROF28(RTMessage Msg) = [ID_FIRST + 28];
   virtual void RTCPROF29(RTMessage Msg) = [ID_FIRST + 29];
   virtual void RTCPROF30(RTMessage Msg) = [ID_FIRST + 30];
   virtual void RTCPROF31(RTMessage Msg) = [ID_FIRST + 31];
   virtual void RTCPROF32(RTMessage Msg) = [ID_FIRST + 32];
   virtual void RTCPROF33(RTMessage Msg) = [ID_FIRST + 33];
   virtual void RTCPROF34(RTMessage Msg) = [ID_FIRST + 34];
   virtual void RTCPROF35(RTMessage Msg) = [ID_FIRST + 35];
   virtual void RTCPROF36(RTMessage Msg) = [ID_FIRST + 36];
   virtual void RTCPROF37(RTMessage Msg) = [ID_FIRST + 37];
   virtual void RTCPROF38(RTMessage Msg) = [ID_FIRST + 38];
   virtual void RTCPROF39(RTMessage Msg) = [ID_FIRST + 39];
   virtual void RTCPROF40(RTMessage Msg) = [ID_FIRST + 40];
   virtual void RTCPROF41(RTMessage Msg) = [ID_FIRST + 41];
   virtual void RTCPROF42(RTMessage Msg) = [ID_FIRST + 42];
   virtual void RTCPROF43(RTMessage Msg) = [ID_FIRST + 43];
   virtual void RTCPROF46(RTMessage Msg) = [ID_FIRST + 46];
   virtual void RTCPROF47(RTMessage Msg) = [ID_FIRST + 47];
   virtual void RTCPROF48(RTMessage Msg) = [ID_FIRST + 48];
   virtual void RTCPROF49(RTMessage Msg) = [ID_FIRST + 49];
   virtual void RTCPROF50(RTMessage Msg) = [ID_FIRST + 50];
   //REGEN_CPROF_CLASS

	 virtual void WMActivate (RTMessage msg) = [WM_FIRST + WM_ACTIVATE];
	 virtual void WMDestroy (RTMessage msg) = [WM_FIRST + WM_DESTROY];

private:

	FEDraftP myDraft;

	// This should be called _right_ after the constructor
	friend class FECProfFormContentType;
	void setDraft (FEDraftP draft);

   //REGEN_CPROF_CLASS

};

_CLASSDEF(PVTABSDlg)

// Declare PVTABSDlg, a PVDialog descendant
class PVTABSDlg : public PVDialog 
{
public:

   PVTABSDlg(PTWindowsObject AParent, LPSTR AName);
   ~PVTABSDlg();
   virtual void SetupWindow();
   virtual void RTTABS1(RTMessage Msg) = [ID_FIRST + 1];
   virtual void RTTABS2(RTMessage Msg) = [ID_FIRST + 2];
   virtual void RTTABS3(RTMessage Msg) = [ID_FIRST + 3];
   virtual void RTTABS4(RTMessage Msg) = [ID_FIRST + 4];
   //REGEN_TABS_CLASS

	 virtual void WMDestroy (RTMessage msg) = [WM_FIRST + WM_DESTROY];

private:

	TButton * Button1;
	TButton * Button3;
	TButton * Button4;
	FEDraftP myDraft;

	// This should be called _right_ after the constructor
	friend class FETabsFormContentType;
	void setDraft (FEDraftP draft);

   //REGEN_TABS_CLASS

};

_CLASSDEF(PVMEMODlg)

// Declare PVMEMODlg, a PVDialog descendant
class PVMEMODlg : public PVDialog 
{
public:
   PTEdit Edit1;
   PTEdit Edit2;
   PTEdit Edit3;
   PTEdit Edit4;
   PTEdit Edit5;

   PVMEMODlg(PTWindowsObject AParent, LPSTR AName);
   ~PVMEMODlg();
   virtual void SetupWindow();
   virtual void RTMEMO6(RTMessage Msg) = [ID_FIRST + 6];
   virtual void RTMEMO7(RTMessage Msg) = [ID_FIRST + 7];
   virtual void RTMEMO8(RTMessage Msg) = [ID_FIRST + 8];
   //REGEN_MEMO_CLASS

	 virtual void WMActivate (RTMessage msg) = [WM_FIRST + WM_ACTIVATE];
	 virtual void WMDestroy (RTMessage msg) = [WM_FIRST + WM_DESTROY];

private:

	TButton * Button6;
	FEDraftP myDraft;

	// This should be called _right_ after the constructor
	friend class FEMemoFormContentType;
	void setDraft (FEDraftP draft);

   //REGEN_MEMO_CLASS

};

_CLASSDEF(PVUMDlg)

// Declare PVUMDlg, a PVDialog descendant
class PVUMDlg : public PVDialog 
{
public:
   PTEdit Edit10;
   PTEdit Edit12;
   PTEdit Edit13;
   PTEdit Edit14;
   PTEdit Edit15;
   PTEdit Edit16;
   PTEdit Edit17;

   PVUMDlg(PTWindowsObject AParent, LPSTR AName);
   ~PVUMDlg();
   virtual void SetupWindow();
   virtual void RTUM11(RTMessage Msg) = [ID_FIRST + 11];
   virtual void RTUM18(RTMessage Msg) = [ID_FIRST + 18];
   //REGEN_UM_CLASS

	 virtual void WMActivate (RTMessage msg) = [WM_FIRST + WM_ACTIVATE];
	 virtual void WMDestroy (RTMessage msg) = [WM_FIRST + WM_DESTROY];

	// This has been made public so it can be set by
	// FEUMFormContentType::makeWindow.
	static PVUMDlg * Active; /* The currently active window */

private:

	static XuWorkP LastWork; /* The last UM Work opened */

	TButton * Button11;

	FEDraftP myDraft;

	// This should be called _right_ after the constructor
	friend class FEUMFormContentType;
	void setDraft (FEDraftP draft);

public:

	static XuWorkP lastWork () {
		return LastWork;
	}
   //REGEN_UM_CLASS

};

_CLASSDEF(PVATTNDlg)

// Declare PVATTNDlg, a PVDialog descendant
class PVATTNDlg : public PVDialog 
{
public:
   PTEdit Edit3;

   PVATTNDlg(PTWindowsObject AParent, LPSTR AName);
   ~PVATTNDlg();
   virtual void SetupWindow();
   virtual void RTATTN1(RTMessage Msg) = [ID_FIRST + 1];
   virtual void RTATTN2(RTMessage Msg) = [ID_FIRST + 2];
   //REGEN_ATTN_CLASS

	 virtual void WMDestroy (RTMessage msg) = [WM_FIRST + WM_DESTROY];

private:

	TButton * Button1;
	FEDraftP myDraft;

	// This should be called _right_ after the constructor
	friend class FEAttnFormContentType;
	void setDraft (FEDraftP draft);

   //REGEN_ATTN_CLASS

};

//REGEN_CLASSES
//REGEN_CLASSES

#endif // __PCAIDECLS_H

