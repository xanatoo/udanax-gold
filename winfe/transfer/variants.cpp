//  The manager for a list of variants and its trail

#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "bucket.h"
#include "variants.h"
#include "felist.h"
#include "browser.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "color.h"
#include "title.h"

/* FEVariantWindow */

class FEVariantRecord {
public:
	char * descriptor ();
	XuWorkP variant ();
	static FEVariantRecord* make (XuWorkP variant, XuWorkP title);
	void setDescriptor(XuStringVar desc) {
		myTitleStr = desc;
	}
private:
	XuWorkP myVariant;
	XuWorkP myTitle;
	XuStringVar myTitleStr;
};

class FEVariantTitleHook : public XuExportHook {
	FEVariantRecordP myRecord
public:
	FEVariantTitleHook(FEVariantRecordP record) : myRecord(record) {}
	virtual void fulfilled (XuBufferVar buf, XuIntVar size) {
		myRecord->setDescriptor((XuStringVar) buf);
	}
};

FEVariantRecord* FEVariantRecord::
make(XuWorkP variant, XuWorkP title) {
	FEVariantRecord* rec = new FEVariantRecord();
	rec->myVariant = variant;
	rec->myTitle = title;
	myTitleStr = NULL;
	FEStuff::getText(FETitleManager::titleEdition(rec->myTitle), new FEVariantTitleHook(this));
	return rec;
}

char * FEVariantRecord::
descriptor() {
	if ( !myTitleStr ) {
		XuPromise::forceAll();
  }
	return (char*) myTitleStr;
}

XuWorkP FEVariantRecord::
variant () {
	return myVariant;
}

class FEEachVariant : public XuEachHook {
	FEVariantManager* myMgr;
public:
	FEEachVariant(FEVariantManager* mgr) : XuEachHook() { myMgr = mgr; }

	virtual void execute (XuPromiseP element) {
		XuWorkP titleWork = XuWork::cast(element);
		XuWorkP variant = FETitleManager::titledWork(titleWork);
		FEVariantRecord* lrec = FEVariantRecord::make(variant, titleWork);
		myMgr->myItems[(myMgr->myCount)++] = lrec;
		if (myMgr->myCount > FEBUCKETMANAGER_MAX_ITEMS) {
			cerr << "ERROR: too many items in FEVariantManager\n";
			exit(1);
		}
		/* Note that this keeps myCount in sync with the index of the entry
					in the variant window. */
  	/* TODO: make this not force, by defining another kind of DataHook
    	which will put the descriptor in the window when it comes in.
			As it stands, lrec->descriptor() will force. */
		if (FEManager::fetchVariantWindow(myMgr->myBrowser->index()) != NULL) {
			((FEListWindow*)FEManager::fetchVariantWindow(myMgr->myBrowser->index()))
				->addString(lrec->descriptor());
    }
  }
};

#ifdef NO_PROPAGATE
class FEVariantWorkHook : public XuFillRangeHook {
	FEVariantManager* myMgr;
public:
	FEVariantWorkHook (FEVariantManager* mgr) : myMgr(mgr) {}
	void rangeFilled (XuEditionP newIdentities) {
		myMgr->myTitleTrail = newIdentities->rangeTranscluders
			(XU_NULL, FETitleManager::titleFilter(), XU_NULL, 0,
			 myMgr->myTitleTrail);
	}
};
#endif

// TODO: this is exactly the same as FELinkHook; merge into one class somewhere
class FEVariantHook : public XuFillRangeHook {
	XuEachHookP myHook;
public:
	FEVariantHook (XuEachHookP hook) : myHook(hook) {}
	void rangeFilled (XuEditionP newIdentities) {
  	newIdentities->stepper()->forEach(myHook);
	}
};

FEVariantManager* FEVariantManager::
make (FEBrowser* browser, XuEditionP domain) {
	FEVariantManager* newTM = new FEVariantManager();
	newTM->myBrowser = browser;
	newTM->myCount = 0;
	newTM->myWorkTrail = domain->rangeWorks(XU_NULL, XU_NULL, 0);
#ifdef NO_PROPAGATE
	newTM->myWorkHook = new FEVariantWorkHook(newTM);
  newTM->myWorkTrail->addFillRangeDetector(newTM->myWorkHook);
#endif
	XuFilterP titleFilter = FETitleManager::titleFilter();
	newTM->myTitleTrail = newTM->myWorkTrail->rangeTranscluders
		(XU_NULL, titleFilter, XU_NULL, 0);
	newTM->myEachHook = new FEEachVariant(newTM);
	newTM->myTitleHook = new FEVariantHook(newTM->myEachHook);
	newTM->myTitleTrail->addFillRangeDetector(newTM->myTitleHook);
	return newTM;
}

/* TODO: remove the assumption here that the work at the other end remains
	readable. */
void FEVariantManager::
show (int itemNum) {
	FEVariantRecord* rec = myItems[itemNum];
	/* TODO: this should really be "sharedWith" but we don't have discontig
		selection yet, so "notSharedWith" will give more information.  This
		wants to be "...->notSharedRegion(...));" to avoid the (expensive)
		domain() request, but I don't know how to do notSharedRegion any
    more efficiently. */
	myBrowser->showRegion(myBrowser->work()->edition()->notSharedWith
		(rec->variant()->edition())->domain());
}

/* TODO: remove the assumption here that the work at the other end remains
	readable. */
void FEVariantManager::
follow (int itemNum) {
	FEVariantRecord* rec = myItems[itemNum];
	FEBrowser* browser = FEManager::browserOn(rec->variant());
	BringWindowToTop(browser->draftWindow()->HWindow);
	browser->showRegion(browser->work()->edition()->notSharedWith
		(myBrowser->work()->edition())->domain());
}

LPSTR FEVariantManager::
description (int index) {
	if (index >= myCount) {
		cerr << "ERROR: requested descriptor of nonexistent variant\n";
		exit(1);
	}
	return myItems[index]->descriptor();
}
