#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

// #include "fe.h"
#include "absui.h"
#include "felist.h"
#include "draft.h"
#include "content.h"
#include "bucket.h"
#include "links.h"
#include "textct.h"
#include "femanage.h"
#include "feedit.h"
#include "filedial.h"
#include <fcntl.h>
#include <sys\stat.h>
#include <io.h>
#include "clip.h"
#include "title.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "color.h"

#define NODEBUG

/* ----------------------------------------------------------------------*/

FEEditWindow* FEEditWindow::
make(PTWindowsObject aParent, LPSTR aTitle, FETextContent* content) {
	return new FEEditWindow(aParent, aTitle, content);
}

// FEEditWindow's constructor replaces the default TEdit wwith an FEedit
// and sets the attributes to make a word-wrapping editor
FEEditWindow::
FEEditWindow(PTWindowsObject parent, LPSTR title, FETextContent* content)
	 :TEditWindow(parent, title)
{                                          	
	delete Editor;
	Editor = NULL;
	Editor = new FEEdit(content, this, ID_EDITOR, NULL, 0, 0, 0, 0, 0, TRUE, GetModule());
	Editor->Attr.Style |= ES_NOHIDESEL;
	Editor->Attr.Style &= ~WS_HSCROLL;
	Editor->Attr.Style &= ~ES_AUTOHSCROLL;
	myContent = content;
}

void FEEditWindow::flushChanges () {
	((FEEdit*)Editor)->flushChanges();
}

void FEEditWindow::
CMNewVariant (RTMessage /* Msg */) {
/*
// this is broken until we get FEContent::copy() back again
	this->flushChanges();
	FEContent* newCont = ((FEEdit*)Editor)->content()->copy();
	FEDraft* doc = FEManager::makeNewDraft (newCont);
  newCont->setDraft(doc);
	char newTitleL[100];
	strcpy(newTitleL, myContent->draft()->titleStr());
	strcat(newTitleL, " Variant");
	XuWorkP titleWork = FETitleManager::makeTitle
		(doc->work(), XuText::make(newTitleL)->edition());
	doc->setTitle(titleWork, newTitleL);
	newCont->showWindow();
*/
}

void FEEditWindow::
CMGrab (RTMessage) {
	this->flushChanges();
	((FEEdit*)Editor)->content()->draft()->grab();
	XuIf ( !myContent->draft()->work()->canRevise() ) {
		MessageBeep(-1);
	} XuEndIf
}

void FEEditWindow::
CMRelease (RTMessage) {
	this->flushChanges();
	myContent->draft()->release();
}

void FEEditWindow::
CMInfo (RTMessage /* Msg */) {
	this->flushChanges();
  FEUI::draftInformation(myContent->draft());
}

void FEEditWindow::
CMDelete (RTMessage) {
	this->flushChanges();
	/* What is the correct way for the FEEdit to get rid of itself? */
/* TODO: put these back in when we figure out how they work with FEManager
	myBrowser->releaseDraftWindow();
	myBrowser->releaseLinkWindow();
	myBrowser->releaseVariantWindow();
	myBrowser->releaseHistoryWindow();
*/
  delete this;
}

void FEEditWindow::
WMClose (RTMessage msg) {
	if (FEManager::close(myContent->draft(), TRUE)) {
		TWindowsObject::WMClose(msg);
	}
}

void FEEditWindow::
ShowLinkWindow () {
	this->flushChanges();
	myContent->linkManager()->showWindow();
}

void FEEditWindow::
CMStartLink(RTMessage /* Msg */) {
	this->flushChanges();
	FELinkManager::startLink(myContent->selectionReference());
}

void FEEditWindow::
CMEndLink(RTMessage /* Msg */) {
	this->flushChanges();
	FELinkManager::endLink(myContent->selectionReference());
}

void FEEditWindow::
CMAttach(RTMessage /* Msg */) {
	this->flushChanges();
	FELinkManager::attachLink(myContent->selectionReference());
}


FEEdit::
FEEdit(FETextContent* content, PTWindowsObject parent,
				int AnId, LPSTR ATitle, int X, int Y, int W, int H,
				WORD ATextLen, BOOL Multiline, PTModule AModule)
		: TEdit(parent, AnId, ATitle, X, Y, W, H, ATextLen, Multiline, AModule)
{
	myContent = content;
	myStart = -1;
	Attr.Style |= ES_NOHIDESEL;
	Attr.Style &= ~WS_HSCROLL;
	Attr.Style &= ~ES_AUTOHSCROLL;
}

// to have special display attributes
void FEEdit::
SetupWindow() {
	TEdit::SetupWindow();
	SendMessage(HWindow, WM_SETFONT, TheTextFont, FALSE);
}

void FEEdit::
deleteRange(int start, int stop) {
	this->DeleteSubText(start, stop);
	this->reportDelete(start, stop);
}

void FEEdit::
reportDelete(int start, int stop) {
	if (stop > start) {
		FETextContentP content = (FETextContentP) myDraft->content();
		XuRegionP region = XuIntegerSpace::make()->interval(start,stop)->complement();
		myDraft->revise(content->extract(XuIntegerRegion::cast(region)));
	}
}

// is this still needed?  was it ever?
#define FEEDIT_REPORTINSERT_MARGIN 100

void FEEdit::
reportInsert(int start, int stop) {
	if (start != stop) {
		LPSTR text = new char [stop - start + FEEDIT_REPORTINSERT_MARGIN];
		this->GetSubText(text, start, stop);
		int count = strlen(text);
		if (count != stop - start) {
			cerr << "insert error: " << count << " from: " << (stop-start) << "\n";
 	  }
		FETextContentP content = (FETextContentP) myDraft->content();
		myDraft->revise(content->insert(start, text));
    delete text;
  }
}

void FEEdit::
flushChanges() {
	if (myStart == -1) {
		return; 	// no outstanding changes
	}
	/* reset myStart immediately so further window events won't flush
		changes a second time. */
  int oldStart = myStart;
	myStart = -1;
	int start;
  int stop;
	this->GetSelection(start, stop);
	if (start != stop) {
		cerr << "Should not be a selection: " << start << ", " << stop << "\n";
	}
	if (start < oldStart) {
		this->reportDelete(start, oldStart);
	} else if (start > oldStart) {
		this->reportInsert(oldStart, start);
	}
}

int FEEdit::
prepareEdit() {
  int start, stop;
  this->GetSelection(start, stop);
	if (myStart == -1) {
  	// TODO: decide whether this is still needed
//  	myBrowser->startEdit();
    this->reportDelete(start, stop);
    myStart = start;
  }
  return start;
}

void FEEdit::
WMChar(RTMessage Msg) {
	switch ( Msg.WParam ) {
		case VK_ESCAPE:
			this->flushChanges();
			break;
		case VK_BACK:   // character deletion.
      this->prepareEdit();
			break;
		default:        // character insertion
      int start = this->prepareEdit();
      if (start < myStart) {
        // we were deleting.  Flush changes.
			  this->flushChanges();
			}
      break;
	}
	DefWndProc(Msg);
}
void FEEdit::
WMKeydown(RTMessage Msg) {
	switch ( Msg.WParam ) {
		case VK_PRIOR:
		case VK_NEXT:
		case VK_HOME:
		case VK_END:
		case VK_UP:
		case VK_DOWN:
		case VK_LEFT:
		case VK_RIGHT:
		case VK_SELECT:
		case VK_INSERT:
		case VK_DELETE:
			// flush the changes
			this->flushChanges();
			break;
		default:
    	// characters get handled by WMChar
			break;
	}
	this->TWindowsObject::DefWndProc(Msg);
}

// This is a generic flush changes that should be done for any
// event that changes the edit focus.  KillFocus, Menus, etc.
void FEEdit::WMLButtonDown(RTMessage Msg) {
	this->flushChanges();
	DefWndProc(Msg);
}
void FEEdit::WMCommand(RTMessage Msg) {
	this->flushChanges();
	DefWndProc(Msg);
}
void FEEdit::WMKillFocus(RTMessage Msg) {
	this->flushChanges();
	DefWndProc(Msg);
}

#ifdef ENABLE_PASTE

void FEEdit::CMEditCut(RTMessage /* Msg */) {
	this->flushChanges();
	int start;
  int stop;
	this->GetSelection(start, stop);
 	if (start != stop) {
		FEClipManager::copy(
			XuSingleRef::make(
				XuText::wrap(myDraft->content()->edition())->extract
					(XuIntegerSpace::make()->interval(start, stop))
					->edition(),
				myDraft()->work()));
		this->deleteRange(start, stop);
  }
}

void FEEdit::CMEditCopy(RTMessage Msg) {
	this->flushChanges();
	this->TEdit::CMEditCopy(Msg);
	int start;
  int stop;
	this->GetSelection(start, stop);
	if (start != stop) {
		FEClipManager::copy(
			XuSingleRef::make(
				XuText::wrap(myDraft->content()->edition())->extract
					(XuIntegerSpace::make()->interval(start, stop))
					->edition(),
				myDraft()->work()));
	}
}

class FEPasteHook : public XuExportHook {
	PTEdit myEdit;
	FETextContent* myContent;
	XuIntVar myStart;
	XuEditionP myExcerpt;
public:
	FEPasteHook(PTEdit edit,	FETextContent* content, XuIntVar start, XuEditionP excerpt) :
		myEdit(edit), myContent(content), myStart(start), myExcerpt(excerpt)
	{
			FEStuff::getText(myExcerpt, this);
	}
	virtual void fulfilled(XuBufferVar buf, XuIntVar size) {
		myEdit->Insert((char*)buf);
		myContent->insertText(myStart, XuText::wrap(myExcerpt));
	}
};

void FEEdit::CMEditPaste(RTMessage /* Msg */) {
	this->flushChanges();
	if (!FEClipManager::canPaste()) {
  	MessageBeep(-1);
		return;
	}
	myContent->draft()->grab();
	int start, stop;
	this->GetSelection(start, stop);
  if (start != stop) {
		this->deleteRange(start, stop);
  }
  FEClipManager::paste();
  XuSingleRefP newClip = FEClipManager::clipboard();
	// right now paste only pastes text
	/* TODO: This should come straight from the clipboard rather than doing
		a round trip to get here */
	new FEPasteHook(this, myContent, start, newClip->excerpt());
	XuPromise::forceAll();
}

#endif ENABLE_PASTE

void FEEdit::CMEditDelete(RTMessage /* Msg */) {
	this->flushChanges();
	int start, stop;
	this->GetSelection(start, stop);
	this->deleteRange(start, stop);
}
void FEEdit::CMEditUndo(RTMessage Msg) {
	this->flushChanges();
	this->TEdit::CMEditUndo(Msg);
}

void FEEdit::
CMInsertFile(RTMessage /* Msg */) {
	this->flushChanges();
	char buf[100];
	strcpy(buf, "*.*");
	if (GetApplication()->ExecDialog(new TFileDialog(this, SD_FILEOPEN, buf))
			== IDOK) {
		int file = ::open(buf, O_RDONLY | O_TEXT);
		if (file == -1) {
			FEUI::tell("Unable to open file", "Insert file error");
			return;
    }
		int len = ::filelength(file);
		char* buf = new char[len+1];
		::_read(file, (void*)buf, len);
		::close(file);
		buf[len] = '\0';
    int start, stop;
		this->GetSelection(start, stop);
		this->deleteRange(start, stop);
    int tlen = GetTextLen();
		this->Insert(buf);
		this->reportInsert(start, start+GetTextLen()-tlen);
		delete buf;
	}
}

void FEEdit::
CMCopyToFile (RTMessage /* Msg */) {
	this->flushChanges();
	char buf[100];
  strcpy(buf, "*.*");
	if (GetApplication()->ExecDialog
			(new TFileDialog(this, SD_FILESAVE, buf))
			== IDOK) {
		int start, stop;
		this->GetSelection(start, stop);
		if (start == stop) {
			start = 0;
			stop = this->GetTextLen();
    }
		int file = ::open
			(buf, O_WRONLY | O_TEXT | O_CREAT | O_TRUNC, S_IREAD | S_IWRITE);
		char* buf = new char[stop-start+1];
		this->GetSubText(buf, start, stop);
		if (file == -1) {
			FEUI::tell("Unable to open file", "Copy to file error");
      delete buf;
			return;
		}
		::write(file, buf, stop-start);
		::close(file);
		delete buf;
	}
}

