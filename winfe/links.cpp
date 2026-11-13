//  The manager for a list of links and its trail

#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "absui.h"
#include "draft.h"
#include "content.h"
#include "textct.h"
#include "bucket.h"
#include "felist.h"
#include "links.h"
#include "title.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "color.h"

extern PTApplication TheApp;

#define FE_MYLINKDESCKEY "FELink:Descriptor"

static XuHyperRefP theCurrentRef;

class FELinkRecord {
public:
	char* descriptor ();
	XuSingleRefP thisEnd ();
	XuSingleRefP otherEnd ();
	XuWorkP work ();
  XuHyperLinkP link () { return myLink; }
	static FELinkRecord* make (XuWorkP linkWork, FELinkManager* mgr);
  void setDesc (char* newDesc);
  FELinkManager* mgr () { return myMgr; }
private:
	XuIntValueP myAtRight;
  XuWorkP myWork;
	XuHyperLinkP myLink;
  XuStringVar myDesc;
  FELinkManager* myMgr;
};

class DescriptorHook : public XuExportHook {
	FELinkRecord* myRecord;
public:
	DescriptorHook(FELinkRecord* record) : myRecord(record) {};
	virtual void fulfilled (XuBufferVar buf, XuIntVar size) {
		myRecord->setDesc((char*)buf);
		FEListWindow* linkWindow = myRecord->mgr()->window();
		if (linkWindow != NULL) {
			linkWindow->addString(myRecord->descriptor());
		}
  }
};

FELinkRecord* FELinkRecord::make(XuWorkP linkWork, FELinkManager* mgr) {
	XuWorkP work = mgr->content()->draft()->work();
	FELinkRecord* lrec = new FELinkRecord();
	lrec->myWork = linkWork;
  lrec->myMgr = mgr;
  XuEditionP edn = linkWork->edition();
	lrec->myLink = XuHyperLink::wrap(edn);
	lrec->myAtRight = FEStuff::atRight(lrec->myLink, work);
	// set my descriptor to the default unreadable
	lrec->myDesc = _fstrdup("< New Link >");
	// fill in over that with the first few characters at the link's the other end
	FEStuff::getText(
		lrec->myLink->endAt(FEStuff::linkKey(lrec->myAtRight->logicalNot()))
			->workContext()->edition(), new DescriptorHook(lrec));
	// fill in over that with the descriptor if possible
	FEStuff::getText(
		XuSingleRef::cast(lrec->myLink->endAt(FE_MYLINKDESCKEY))->excerpt(),
		new DescriptorHook(lrec));
	return lrec;
}

char * FELinkRecord::descriptor() {
	return (char*) myDesc;
}

XuSingleRefP FELinkRecord::thisEnd () {
	return XuSingleRef::cast(FEStuff::endAt(myLink, myAtRight));
}

XuSingleRefP FELinkRecord::otherEnd () {
	return XuSingleRef::cast(FEStuff::endAt(myLink, myAtRight->logicalNot()));
}

XuWorkP FELinkRecord::work () {
	return myWork;
}

void FELinkRecord::
setDesc (char* newDescI) {
	delete (void*)myDesc;
	myDesc = newDescI;
}


class FEEachLink : public XuEachHook {
	FELinkManager* myMgr;
public:     
	FEEachLink(FELinkManager* mgr) : XuEachHook() { myMgr = mgr; }

	virtual void execute (XuPromiseP element) {
  	XuWorkP work = XuWork::cast(element);
		FELinkRecord* lrec = FELinkRecord::make(work, myMgr);
		myMgr->myItems[(myMgr->myCount)++] = lrec;
		if (myMgr->myCount > FEBUCKETMANAGER_MAX_ITEMS) {
			cerr << "ERROR: too many items in FELinkManager\n";
			exit(1);
		}
	}
};

#ifdef NO_PROPAGATE
class FELinkEditionHook : public XuFillRangeHook {
	FELinkManager* myMgr;
  XuFilterP myFilter;
public:
	FELinkEditionHook (FELinkManager* mgr, XuFilterP filter)
		: myMgr(mgr), myFilter(filter) {};
	virtual void rangeFilled (XuEditionP newIdentities) {
		myMgr->myWorkTrail = newIdentities->rangeWorks
			(XU_NULL, XU_NULL, 0, myMgr->myWorkTrail);
	}
};
#endif

// TODO: this is exactly the same as FEVariantHook; define one class somewhere
class FELinkHook : public XuFillRangeHook {
	XuEachHookP myHook;
public:
	FELinkHook (XuEachHookP hook) : myHook(hook) {}
	void rangeFilled (XuEditionP newIdentities) {
  	newIdentities->stepper()->forEach(myHook);
	}
};
	

FELinkManager* FELinkManager::make
	(FEContent* content, XuEditionP domain, XuIDRegionP linkTypes) {
	FELinkManager* newTM = new FELinkManager();
	newTM->myContent = content;
	newTM->myCount = 0;
	XuFilterP filter = FEStuff::linkFilter(linkTypes);
	newTM->myEditionTrail = domain->rangeTranscluders(XU_NULL, filter);
#ifdef NO_PROPAGATE
	newTM->myEditionHook = new FELinkEditionHook(newTM, filter);
	newTM->myEditionTrail->addFillRangeDetector(newTM->myEditionHook);
#endif
	newTM->myWorkTrail = newTM->myEditionTrail->rangeWorks();
	newTM->myEachHook = new FEEachLink(newTM);
	newTM->myWorkHook = new FELinkHook(newTM->myEachHook);
	newTM->myWorkTrail->addFillRangeDetector(newTM->myWorkHook);
  newTM->myWindow = NULL;
	return newTM;
}

FEContent* FELinkManager::content () {
	return myContent;
}

void FELinkManager::show (int itemNum) {
	FELinkRecord* rec = myItems[itemNum];
	myContent->selectReference(rec->thisEnd());
}

void FELinkManager::follow (int itemNum) {
	FELinkRecord* rec = myItems[itemNum];
	FESheet::showRef(rec->otherEnd());
}

void FELinkManager::info (int itemNum) {
/* TODO: make link info work again 
	FELinkInfoDialog* dlg = new FELinkInfoDialog
		((PTWindowsObject)TheApp, ID_LINKINFO, myContent, itemNum);
	(void) TheApp->MainWindow->GetModule()->ExecDialog(dlg);
*/
}

int FELinkManager::count () {
	return myCount;
}

int FELinkManager::deleteItem (int itemNum) {
	FELinkRecord* rec = myItems[itemNum];
  XuIf (rec->work()->owner()->equals(FEManager::TheFEConn->loginClubID())) {
		int ret = FEUI::ask("Deleting link...",
			"Deletion currently cannot be undone.  Are you sure?");
    if (ret) {
	  	rec->work()->removeReadClub();
  	  rec->work()->removeEditClub();
			myWindow->deleteString(itemNum);
      /* Copy the other records down onto the one being deleted */
      for (int i = itemNum + 1; i < myCount; i++) {
      	myItems[i-1] = myItems[i];
      }
			myCount--;
		}
    return TRUE;
  } XuElse {
		FEUI::tell("Cannot delete link", "You are not the owner of that link");
    return FALSE;
	} XuEndIf
}

LPSTR FELinkManager::description (int index) {
	if (index > myCount) {
		cerr << "ERROR: requested descriptor of nonexistent link\n";
		exit(1);
	}
	return myItems[index]->descriptor();
}

XuWorkP FELinkManager::work (int index) {
	if (index > myCount) {
		cerr << "ERROR: requested descriptor of nonexistent link\n";
		exit(1);
	}
	return myItems[index]->work();
}

/* This only gets called from the LINKINFO dialog if the owner is the
	right thing. */
void FELinkManager::setDescription (int index, char* newDesc) {
	FELinkRecord* rec = myItems[index];
	XuWorkP work = rec->work();
	work->grab();
	XuSingleRefP ref = XuSingleRef::make(XuText::make(newDesc)->edition());
	XuHyperLinkP link = rec->link()->withEnd(FE_MYLINKDESCKEY,ref);
	work->revise(link->edition());
	work->release();
	rec->setDesc(_fstrdup(newDesc));
	myWindow->replaceString(index, newDesc);
}

FEListWindow* FELinkManager::window() {
	return myWindow;
}

void FELinkManager::showWindow () {
	if (myWindow == NULL) {
  	FEListWindow* newWindow;
		// Set up an interesting title
		char title[50];
    XuStringVar contTitleStr;
		if (myContent->draft()->titleStr() == NULL) {
			contTitleStr = "Document";
		} else {
			contTitleStr = myContent->draft()->titleStr();
    }
		wsprintf(title, "Links for %s", myContent->draft()->titleStr());
		newWindow = FEListWindow::make
			(TheApp->MainWindow, _fstrdup(title), this, LinkWin);
		if (TheApp->MakeWindow(newWindow)) {
			myWindow = newWindow;
			if (myCount > 0) {
				for (int i = 0; i < myCount; i++) {
					myWindow->addString(this->description(i));
				}
			}
      BringWindowToTop(myWindow->HWindow);
		} else {
			myWindow = NULL;
		}
	}
}

void FELinkManager::closeWindow () {
	if (myWindow != NULL) {
		myWindow->CloseWindow();
		myWindow = NULL;
	}
}


/* TODO: all the link/variant/history "show" methods compare against
	myBrowser->work()->edition() which will NOT be what is displayed, if
  the frontend defers the incremental revise()s and some fail.  The
  browser needs to hold an edition and the managers need to compare
  against it. */

void FELinkManager::startLink (XuHyperRefP ref) {
	theCurrentRef = XuSingleRef::cast(ref);
}

void FELinkManager::endLink (XuHyperRefP ref) {
	if (theCurrentRef == XU_NULL) {
		MessageBeep(-1);
		return;
	}
	/* TODO: this should pop up the "link creation" dialog */
	XuWorkP linkWork =
		XuWork::make(FEStuff::makeLink
			(FEManager::TheFEConn->relationshipLinkTypeID(),
			 XuSingleRef::cast(theCurrentRef),
			 XuSingleRef::cast(ref))->edition());
	linkWork->setReadClub(XuServer::publicClubID());
	linkWork->release();
	theCurrentRef = XU_NULL;
}


void FELinkManager::attachLink (XuHyperRefP ref) {
	/* TODO: this should pop up the "link creation" dialog */
	// TODO: this shouldn't need to go to the backend; we should revive
  // FETextContent::make(char*)
	FEContent* newCont = FETextContentType::TheOne.makeContent
		(XuText::make("This is a new attachment.")->edition());
	FEDraft* doc = FEManager::makeNewDraft (newCont);
  newCont->setDraft(doc);
	XuWorkP titleWork = FETitleManager::makeTitle
		(doc->work(), XuText::make("New Attachment")->edition());
	doc->setTitle(titleWork, "New Attachment");
	XuWorkP linkWork =
		XuWork::make(FEStuff::makeLink
			(FEManager::TheFEConn->relationshipLinkTypeID(),
			 XuSingleRef::cast(ref),
			 FEStuff::makeSingleRef(doc->work(), newCont->edition(), XU_NULL))
			->edition());
	linkWork->release();
}

