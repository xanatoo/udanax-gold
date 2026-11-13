// A support class to abstract trivial user-interface things like error messages.

#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "absui.h"

#include "felist.h"
#include "draft.h"
#include "content.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "title.h"
#include "dlgtools.h"

#include <listbox.h>
#include <edit.h>
#include <combobox.h>
#include <static.h>

#include "fe.h"

extern PTApplication TheApp;

void FEUI::
tell(LPSTR message, LPSTR title)
{
	MessageBox(TheApp->MainWindow->HWindow, message, title, MB_OK);
}

int FEUI::
ask(LPSTR question, LPSTR title)
{
	return (MessageBox(TheApp->MainWindow->HWindow,
										question, title, MB_YESNO)
						== IDYES);
}

void FEUI::
beep()
{
	MessageBeep(-1);
}

// The login Dialog
class FELoginDialog : public TDialog {
public:
	TEdit* hostName;
  TEdit* loginName;
	LPSTR hostBuf;
	LPSTR loginBuf;
	FELoginDialog (PTWindowsObject aParent, int resID, LPSTR hostB, LPSTR loginB);
	virtual void SetupWindow ();
protected:
	/* You must override Cancel and OK, as opposed to CloseWindow or CanClose
		(which don't seem to be called when the IDCANCEL button is clicked), or
		the destructor (which seems to have the control state trashed before it
    gets called). */
	virtual void Ok (RTMessage msg) = [ID_FIRST + IDOK];
};

FELoginDialog::
FELoginDialog (PTWindowsObject aParent, int resID, LPSTR hostB, LPSTR loginB)
	: TDialog(aParent, resID) {
	hostName = new TEdit(this, ID_HOSTNAME, FE_MYTEXTLEN);
	loginName = new TEdit(this, ID_LOGINNAME, FE_MYTEXTLEN);
	hostBuf = hostB;
	loginBuf = loginB;
}

void FELoginDialog::
SetupWindow () {
	TDialog::SetupWindow();
	GetProfileString ("PCAIDE", "Host", "<connection> <host> <port>",
		hostBuf, FE_MYTEXTLEN);
    hostName->SetText (hostBuf);
	GetProfileString ("PCAIDE", "User", "<user>",
		loginBuf, FE_MYTEXTLEN);
    loginName->SetText (loginBuf);
}

void FELoginDialog::
Ok (RTMessage msg) {
	(void) hostName->GetText(hostBuf, FE_MYTEXTLEN);
	(void) loginName->GetText(loginBuf, FE_MYTEXTLEN);
	WriteProfileString ("PCAIDE", "Host", hostBuf);
	WriteProfileString ("PCAIDE", "User", loginBuf);
	TDialog::Ok(msg);
}

void FEUI::
loginParams(char* hostBuf, char* loginBuf)
{
	FELoginDialog* newDialog =
		new FELoginDialog(TheApp->MainWindow, ID_LOGIN, hostBuf, loginBuf);
	if (TheApp->ExecDialog(newDialog) != IDOK) {
		MessageBox(TheApp->MainWindow->HWindow, "Be that way!", "OK, then...", MB_OK);
		exit(-1);
  }
}

// The Document Info dialog
/* Code for info dialog box */
/* This dialog accepts input about the permissions of a given Work. The dialog
	contains the owner's name and two combo boxes for setting permissions. Each
	combo box currently contains two choices:  "Public" and "Private" (in that
	order).  You create the dialog with a browser, and the dialog takes care of
	getting the browser's work and setting all the information. */
class FEInfoDialog : public TDialog {
public:
	FEInfoDialog (PTWindowsObject aParent, int resID, FEDraft* b);
	virtual void SetupWindow ();
protected:
	virtual void Ok (RTMessage msg) = [ID_FIRST + IDOK];
private:
	TStatic* myOwner;
  TEdit* myTitle;
	TComboBox* myReadPerm;
	TComboBox* myEditPerm;
	TStatic* myLastRevisionBy;
	TStatic* myCurrentEditor;
  TComboBox* myRecordHistory;
  FEDraft* myDraft;
	XuWorkP myWork;
	XuWorkP myTitleWork;
	char* myTitleStr;
};

void FEUI::
draftInformation(FEDraft* draft)
{
	TheApp->ExecDialog(new FEInfoDialog(TheApp->MainWindow, ID_DOCINFO, draft));
}

/* TODO: Add a HandleListBoxMsg method somewhere so when the user chooses
	"Remove" for read or edit permission she gets a "Blah blah OK/Cancel"
  dialog. */

FEInfoDialog::
FEInfoDialog (PTWindowsObject aParent, int resID, FEDraft* b)
		: TDialog(aParent, resID) {
	myOwner = new TStatic(this, ID_OWNER, FE_MYTEXTLEN);
	myTitle = new TEdit(this, ID_TITLE, FE_MYTEXTLEN);
	myReadPerm = new TComboBox(this, ID_READPERM, FE_MYTEXTLEN);
	myEditPerm = new TComboBox(this, ID_EDITPERM, FE_MYTEXTLEN);
  myRecordHistory = new TComboBox(this, ID_RECORDHISTORY, FE_MYTEXTLEN);
	myLastRevisionBy = new TStatic(this, ID_LASTREVISIONBY, FE_MYTEXTLEN);
	myCurrentEditor = new TStatic(this, ID_CURRENTEDITOR, FE_MYTEXTLEN);
	myDraft = b;
	myWork = b->work();
	myTitleWork = b->title();
	myTitleStr = (char*)b->titleStr();
}

/* In writing this code I experienced confusion about whether xxx->readClub()
	returns an ID or a Club.  I went to the FeXxxx::xxxClubID naming convention
	for this very reason; unfortunately, it's in the interface for good. */
/* TODO: add much error checking for clubs that aren't in the ClubDirectory. */
void FEInfoDialog::
SetupWindow () {
	XuIDP loginClub = FEManager::TheFEConn->loginClubID();
	XuIDP publicClub = XuServer::publicClubID();
	XuIDP emptyClub = XuServer::emptyClubID();

  // read stuff
	XuIDP readClub = myWork->readClub();
	XuBooleanValueP publicRead 		= (publicClub->equals(readClub));
	XuBooleanValueP privateRead		= (loginClub->equals(readClub));
	XuBooleanValueP emptyRead			= (emptyClub->equals(readClub));

	// edit stuff
	XuIDP editClub = myWork->editClub();
	XuBooleanValueP publicEdit 		= (publicClub->equals(editClub));
	XuBooleanValueP privateEdit		= (loginClub->equals(editClub));
	XuBooleanValueP emptyEdit			= (emptyClub->equals(editClub));

	// history stuff
	XuIDP historyClub = myWork->historyClub();
	XuBooleanValueP publicHistory 	= (publicClub->equals(historyClub));
	XuBooleanValueP privateHistory	= (loginClub->equals(historyClub));

	// owner stuff
	XuIDP owner = myWork->owner();
	DialogTools::setEditText(XuServer::clubName(owner), myOwner);
	XuBooleanValueP privateOwner		= (loginClub->equals(owner));

	// last revision information
	XuIDP lastAuthor = myWork->lastRevisionAuthor();
	myLastRevisionBy->SetText("Unknown");
	DialogTools::setEditText(XuServer::clubName(lastAuthor), myLastRevisionBy);
	
	// current editor information
	XuIDP editor = myWork->grabber();
	myCurrentEditor->SetText("None");
	DialogTools::setEditText(XuServer::clubName(editor), myCurrentEditor);

	TDialog::SetupWindow();

	/* Set up the dialog's title as a function of the FEEditWindow's title. */
	char buf[FE_MYTEXTLEN];
	strcpy(buf, "Info for ");
	strcat(buf, this->Parent->Parent->Title);
	SetCaption(buf);

	// set up the read permissions box
	myReadPerm->AddString("Public");
	myReadPerm->AddString("Private");
	myReadPerm->AddString("No one");
	myReadPerm->AddString("Removed");

  // set up edit permissions box
	myEditPerm->AddString("Public");
	myEditPerm->AddString("Private");
	myEditPerm->AddString("No one");
	myEditPerm->AddString("Removed");

	// set up history box
	myRecordHistory->AddString("Public");
	myRecordHistory->AddString("Private");
  myRecordHistory->AddString("No recording");

	XuPromise::forceAll();

	myTitle->SetText(myTitleStr);

	int readIndex = -1;
	if (readClub->isBroken()) {
		readIndex = 3;
		EnableWindow(myReadPerm->HWindow, FALSE);
	} else if (publicRead->asBoolean()) {
   	readIndex = 0;
	} else if (emptyRead->asBoolean()) {
   	readIndex = 2;
	} else { // if (privateRead->asBoolean()) {
   	readIndex = 1;
	}
	myReadPerm->SetSelIndex(readIndex);

	int editIndex = -1;
	if (editClub->isBroken()) {
		editIndex = 3;
		EnableWindow(myEditPerm->HWindow, FALSE);
	} else if (publicEdit->asBoolean()) {
		editIndex = 0;
	} else if (emptyEdit->asBoolean()) {
		editIndex = 2;
	} else { // if (privateEdit->asBoolean()) {
		editIndex = 1;
	}
	myEditPerm->SetSelIndex(editIndex);

	int historyIndex = -1;
	if (historyClub->isBroken()) {
		historyIndex = 2;
	} else if (publicHistory->asBoolean()) {
		historyIndex = 0;
	} else { // if (privateHistory->asBoolean()) {
		historyIndex = 1;
	} 
	myRecordHistory->SetSelIndex(historyIndex);

	/* Disable windows if not owner. */
	if ( !(privateOwner->asBoolean()) ) {
		/* You cannot use editPerm->Attr.Style |= WS_DISABLE to do
			this, you must do it this way. */
    EnableWindow(myTitle->HWindow, FALSE);
		EnableWindow(myReadPerm->HWindow, FALSE);
		EnableWindow(myEditPerm->HWindow, FALSE);
    EnableWindow(myRecordHistory->HWindow, FALSE);
	}
}

void FEInfoDialog::
Ok (RTMessage msg) {
	LPSTR str = new char[FE_MYTEXTLEN];
	(void) myTitle->GetText(str, FE_MYTEXTLEN);
	if (strcmp(str, myTitleStr)) {
		if (myTitleWork == XU_NULL) {
			XuBind (XuInitialReadClub, XuServer::publicClubID()) {
      	XuBind (XuInitialEditClub, XuInitialOwner.get()) {
					myTitleWork = FETitleManager::makeTitle
						(myDraft->work(), XuText::make(str)->edition());
				} XuEndBind
			} XuEndBind
		} else {
			/* TODO: what if someone else is revising the title right now?! */
			FETitleManager::reviseTitle(myTitleWork, XuText::make(str)->edition());
		}
		myDraft->setTitle(myTitleWork, str);
	}
	delete str;
	XuIf (FEManager::TheFEConn->loginClubID()->equals(myWork->owner())) {
		/* OK to set permissions according to dialog */
		XuIDP publicClub 	= XuServer::publicClubID();
		XuIDP privateClub = FEManager::TheFEConn->privateClubID();
		XuIDP emptyClub 	= XuServer::emptyClubID();
		switch (myReadPerm->GetSelIndex()) {
			case 0:
				myWork->setReadClub(publicClub);			break;
			case 1:
				myWork->setReadClub(privateClub);			break;
			case 2:
				myWork->setReadClub(emptyClub);				break;
			case 3:
				myWork->removeReadClub();							break;
		}
		switch (myEditPerm->GetSelIndex()) {
			case 0:
				myWork->setEditClub(publicClub);			break;
			case 1:
				myWork->setEditClub(privateClub);			break;
			case 2:
				myWork->setEditClub(emptyClub);				break;
			case 3:
				myWork->removeEditClub();							break;
		}
		switch (myRecordHistory->GetSelIndex()) {
			case 0:
				myWork->setHistoryClub(publicClub); 	break;
			case 1:
				myWork->setHistoryClub(privateClub);	break;
			case 2:
				myWork->setHistoryClub(XU_NULL);			break;
		}
	} XuEndIf
	TDialog::Ok(msg);
}

void FEUI::align (HWND win,
		FEUI::Alignment horizontal,
		FEUI::Alignment vertical)
{
	RECT screen;
	GetWindowRect (GetDesktopWindow (), &screen);
	RECT window;
	GetWindowRect (win, &window);
	switch (horizontal) {
		case FEUI::Default:
			break;
		case FEUI::Min:
			window.right -= window.left - screen.left;
			window.left = screen.left;
			break;
		case FEUI::Center:
			int width = window.right - window.left;
			window.left = (screen.left + screen.right - width) / 2;
			window.right = window.left + width;
			break;
		case FEUI::Max:
			window.left += screen.right - window.right;
			window.right = screen.right;
			break;
	}
	switch (vertical) {
		case FEUI::Default:
			break;
		case FEUI::Min:
			window.bottom -= window.top - screen.top;
			window.top = screen.top;
			break;
		case FEUI::Center:
			int height = window.bottom - window.top;
			window.top = (screen.top + screen.bottom - height) / 2;
			window.bottom = window.top + height;
			break;
		case FEUI::Max:
			window.top += screen.bottom - window.bottom;
			window.bottom = screen.bottom;
			break;
	}
	MoveWindow (win, window.left, window.top,
		window.right - window.left, window.bottom - window.top,
		TRUE);
}

