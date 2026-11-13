
//REGEN_FILEHEADING
#pragma hdrfile "pcaide.sym"
#include <xanadu.hxx>
//REGEN_FILEHEADING


     /********************************************************************
      *                                                                  *
      *   Source File: PCAide.cpp                                        *
			*   Description: C++ Source file for PCAide application            *
      *   Date:        Fri May 07 10:31:26 1993                          *
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
#include "PCAide.h"
#include "PCAidCls.h"


//REGEN_VARIABLES
#include <xanadu.hxx>
#include "formui.h"
#include "draft.h"
#include "content.h"
#pragma hdrstop
#include "startup.h"
#include "femanage.h"
#include "mxapp.h"

PTApplication TheApp = NULL;

class NoWaitHook : public XuWaitHook {
public:
	virtual void done() {
  // do nothing
	}
	NoWaitHook () {}
};


//REGEN_VARIABLES

// Define application class derived from  TApplication
class TPCAide : public TApplication
{
public:
  TPCAide(LPSTR AName, HANDLE hInstance, HANDLE hPrevInstance,
                   LPSTR lpCmdLine, int nCmdShow)
    : TApplication(AName, hInstance, hPrevInstance, lpCmdLine, nCmdShow) {};
    virtual void InitMainWindow();
    //REGEN_APPCLASS
		virtual void InitApplication ();
		virtual void IdleAction();

    //REGEN_APPCLASS
};

// Declare TMainWindow, a TWindow descendant
class TMainWindow : public TWindow
{
public:
   TMainWindow(PTWindowsObject AParent, LPSTR ATitle);
   ~TMainWindow();
   virtual void ATTENTION(RTMessage Msg) = [CM_FIRST + IDM_ATTENTION];
   virtual void AKORD(RTMessage Msg) = [CM_FIRST + IDM_AKORD];
   virtual void RATE(RTMessage Msg) = [CM_FIRST + IDM_RATE];
   virtual void MEMO(RTMessage Msg) = [CM_FIRST + IDM_MEMO];
   virtual void UM(RTMessage Msg) = [CM_FIRST + IDM_UM];
   virtual void CPROFILE(RTMessage Msg) = [CM_FIRST + IDM_CPROFILE];
   virtual void PAPERS(RTMessage Msg) = [CM_FIRST + IDM_PAPERS];
   virtual void INITIALIZE(RTMessage Msg) = [CM_FIRST + IDM_INITIALIZE];
   virtual void RETURNHOME(RTMessage Msg) = [CM_FIRST + IDM_RETURNHOME];
   virtual void WRITETODISK(RTMessage Msg) = [CM_FIRST + IDM_WRITETODISK];
   virtual void NEXTDEMO(RTMessage Msg) = [CM_FIRST + IDM_NEXTDEMO];
   //REGEN_MAINCLASS
   virtual void SetupWindow ();
   //REGEN_MAINCLASS

};


/****************************************************
 * TMainWindow implementations: 
 ****************************************************/

// Define TMainWindow, a TWindow constructor
TMainWindow::TMainWindow(PTWindowsObject AParent, LPSTR ATitle)
                         : TWindow(AParent, ATitle)
{
   AssignMenu("PCAide");
   //REGEN_MAINCONSTRUCT
   //REGEN_MAINCONSTRUCT

}

// Define TMainWindow destructor
TMainWindow::~TMainWindow()
{
   //REGEN_MAINDESTRUCT
   //REGEN_MAINDESTRUCT

}








void TMainWindow::ATTENTION(RTMessage)
{
   PTWindowsObject PTWndObj;

   //REGEN_VAR
   //REGEN_VAR

   // Create modeless dialog
   if((PTWndObj = GetModule()->MakeWindow(
               new PVATTNDlg(this, "ATTN"))) != NULL)
   {
     // Create successful
     //REGEN_CREATE
     //REGEN_CREATE
     ShowWindow(PTWndObj->HWindow, SW_SHOW);
   }
   else
   {

      // Create unsuccessful
      //REGEN_FAIL
      //REGEN_FAIL
   }

   //REGEN_END
   //REGEN_END

}

void TMainWindow::AKORD(RTMessage)
{
   PTWindowsObject PTWndObj;

   //REGEN_VAR
   //REGEN_VAR

   // Create modeless dialog
   if((PTWndObj = GetModule()->MakeWindow(
               new PVAKORDDlg(this, "AKORD"))) != NULL)
   {
     // Create successful
     //REGEN_CREATE
     //REGEN_CREATE
     ShowWindow(PTWndObj->HWindow, SW_SHOW);
   }
   else
   {

      // Create unsuccessful
      //REGEN_FAIL
      //REGEN_FAIL
   }

   //REGEN_END
   //REGEN_END

}

void TMainWindow::RATE(RTMessage)
{

   //REGEN_VAR
   //REGEN_VAR

   // Execute modal dialog
   if (GetModule()->ExecDialog(
               new PVRATEDlg(this, "RATE")) == IDOK )
   {
   //REGEN_EXEC
// NOTE: What was this for?!
//	 FEStartupManager::setupHomeDoc();
   //REGEN_EXEC

   }

   //REGEN_END
   //REGEN_END

}

void TMainWindow::MEMO(RTMessage)
{
   PTWindowsObject PTWndObj;

   //REGEN_VAR
   //REGEN_VAR

   // Create modeless dialog
   if((PTWndObj = GetModule()->MakeWindow(
               new PVMEMODlg(this, "MEMO"))) != NULL)
   {
     // Create successful
     //REGEN_CREATE
     //REGEN_CREATE
     ShowWindow(PTWndObj->HWindow, SW_SHOW);
   }
   else
   {

      // Create unsuccessful
      //REGEN_FAIL
      //REGEN_FAIL
   }

   //REGEN_END
   //REGEN_END

}

void TMainWindow::UM(RTMessage)
{
   PTWindowsObject PTWndObj;

   //REGEN_VAR
   //REGEN_VAR

   // Create modeless dialog
   if((PTWndObj = GetModule()->MakeWindow(
               new PVUMDlg(this, "UM"))) != NULL)
   {
     // Create successful
     //REGEN_CREATE
     //REGEN_CREATE
     ShowWindow(PTWndObj->HWindow, SW_SHOW);
   }
   else
   {

      // Create unsuccessful
      //REGEN_FAIL
      //REGEN_FAIL
   }

   //REGEN_END
   //REGEN_END

}

void TMainWindow::CPROFILE(RTMessage)
{
   PTWindowsObject PTWndObj;

   //REGEN_VAR
   //REGEN_VAR

   // Create modeless dialog
   if((PTWndObj = GetModule()->MakeWindow(
               new PVCPROFDlg(this, "CPROF"))) != NULL)
   {
     // Create successful
     //REGEN_CREATE
     //REGEN_CREATE
     ShowWindow(PTWndObj->HWindow, SW_SHOW);
   }
   else
   {

      // Create unsuccessful
      //REGEN_FAIL
      //REGEN_FAIL
   }

   //REGEN_END
   //REGEN_END

}

void TMainWindow::PAPERS(RTMessage)
{
   PTWindowsObject PTWndObj;

   //REGEN_VAR
   //REGEN_VAR

   // Create modeless dialog
   if((PTWndObj = GetModule()->MakeWindow(
               new PVTABSDlg(this, "TABS"))) != NULL)
   {
     // Create successful
     //REGEN_CREATE
     //REGEN_CREATE
     ShowWindow(PTWndObj->HWindow, SW_SHOW);
   }
   else
   {

      // Create unsuccessful
      //REGEN_FAIL
      //REGEN_FAIL
   }

   //REGEN_END
   //REGEN_END

}

void TMainWindow::INITIALIZE(RTMessage)
{
   //REGEN_EXEC
	 FEStartupManager::setupHomeDoc();
   //REGEN_EXEC
}

void TMainWindow::RETURNHOME(RTMessage)
{
   //REGEN_EXEC
	 FEManager::returnHome ();
   //REGEN_EXEC
}

void TMainWindow::WRITETODISK(RTMessage)
{
   //REGEN_EXEC
	 XuServer::waitForWrite (new NoWaitHook ());
   //REGEN_EXEC
}

void TMainWindow::NEXTDEMO(RTMessage)
{
   //REGEN_EXEC
	static int stage = 0;
	switch (stage) {
		case 0:
			FEApplication::show ("Attention 1B");
			break;
		case 1:
			FEApplication::show ("Attention 2B");
			break;
		case 2:
			FEApplication::show ("Attention 1C");
			break;
	}
	stage++;
	if (stage > 2) {
		stage = 0;
	}
   //REGEN_EXEC
}


/***************************************************
 * TPCAideApp method implementations:
 ***************************************************/

// Construct the TPCAide's MainWindow of type TMainWindow
void TPCAide::InitMainWindow()
{
   MainWindow = new TMainWindow(NULL, Name);
   //REGEN_MAINCREATE
	FEStartupManager::startup();
   //REGEN_MAINCREATE
}

// Main program
int PASCAL WinMain(HANDLE hInstance,
                   HANDLE hPrevInstance,
                   LPSTR lpCmdLine,
                   int nCmdShow)
{
   HANDLE hBorLibrary;

   hInst = hInstance;
   hBorLibrary = LoadLibrary("bwcc.dll");

   if(hBorLibrary <= 32)
      MessageBox(NULL, "Unable to load Borland Controls", "System Error", MB_OK | MB_ICONHAND);

   //REGEN_INIT
	 _InitEasyWin();
   BWCCGetVersion();
   //REGEN_INIT

   TPCAide PCAide ("Memex Property/Casualty AIDE", hInstance, hPrevInstance,
      lpCmdLine, nCmdShow);

   PCAide.Run();

   if(hBorLibrary > 32)
      FreeLibrary(hBorLibrary);

   //REGEN_CLEANUP

	 FEManager::shutdown();
	 //exit(0); // this will make the EasyWin go away

   //REGEN_CLEANUP

   return PCAide.Status;
}

//REGEN_CUSTOMCODE

void TPCAide::InitApplication () {
	this->TApplication::InitApplication ();
	TheApp = this;
}

void TPCAide::
IdleAction()
{
	MSG tmpMsg;
	// poll until polling does nothing or there's a Windows message
	int msgWaiting = FALSE;
  int pollDidSomething = FALSE;
	do {
		msgWaiting = PeekMessage(&tmpMsg, this->MainWindow->HWindow, 0, 0, PM_NOREMOVE);
		pollDidSomething = XuDetectorHook::poll();
	} while (!msgWaiting && pollDidSomething);
}

void TMainWindow::SetupWindow () {
	ShowWindow(this->HWindow, SW_SHOWMAXIMIZED);
} 
	
//REGEN_CUSTOMCODE
