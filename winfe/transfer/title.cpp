// associates titles with drafts

#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "title.h"
#include "felist.h"
#include "draft.h"
#include "content.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"

static FETitleManager* theTitleMgr;		// map from works to titles for works

class FEEachTitle : public XuEachHook {
public:
	virtual void execute (XuPromiseP element) {
		XuWorkP titleWork = XuWork::cast(element);
		XuWorkP docWork = FETitleManager::titledWork(titleWork);
		/* TODO: check that title is readable?! Public and PRIVATE TITLES?!!! */
		FEDraft* draft = FEManager::draftOn(docWork);
    if (draft != NULL) {
			draft->setTitle(titleWork);
		}
  };
};


/* the keys at which the titled Work and the title edition are stored */
#define FE_TITLE_DOCLOC 0
#define FE_TITLE_EDNLOC 1

XuWorkP FETitleManager::
makeTitle (XuWorkP titledDoc, XuEditionP titleEdn) {
	/* note that the Edition must order its elements according to
		FE_TITLE_DOCLOC and FE_TITLE_EDNLOC */
	XuEditionP edn = XuEdition::empty(XuIntegerSpace::make())
		->with(FE_TITLE_DOCLOC, titledDoc)->with(FE_TITLE_EDNLOC, titleEdn);
	edn->endorse(XuCrossRegion::endorsements
		(XuIDRegion::cast(XuInitialOwner.get()->asRegion()),
		 XuIDRegion::cast(FEManager::TheFEConn->titleTypeID()->asRegion())));
	XuWorkP titleWork = XuWork::make(edn);
	titleWork->release();
	return titleWork;
}

void FETitleManager::
reviseTitle (XuWorkP titleWork, XuEditionP titleEdition) {
	titleWork->grab();
	XuEditionP edn = XuEdition::empty(XuIntegerSpace::make())
		->with(FE_TITLE_DOCLOC, titledWork(titleWork))
		->with(FE_TITLE_EDNLOC, titleEdition);
	edn->endorse(XuCrossRegion::endorsements
		(XuIDRegion::cast(XuInitialOwner.get()->asRegion()),
		 XuIDRegion::cast(FEManager::TheFEConn->titleTypeID()->asRegion())));
	titleWork->revise(edn);
	titleWork->release();
}

XuWorkP FETitleManager::
titledWork (XuWorkP titleWork) {
	return XuWork::cast(titleWork->edition()->get(FE_TITLE_DOCLOC));
}

XuEditionP FETitleManager::
titleEdition (XuWorkP titleWork) {
	return XuEdition::cast(titleWork->edition()->get(FE_TITLE_EDNLOC));
}

static XuFilterP theTitleFilter = XU_NULL;

// TODO: make this cache the title filter
XuFilterP FETitleManager::
titleFilter () {
	if (theTitleFilter == XU_NULL) {
		theTitleFilter =	XuFilterSpace::make(XuCrossSpace::endorsements())
			->anyFilter(XuCrossRegion::endorsements
				(XuIDRegion::cast(XuIDSpace::global()->fullRegion()),
				 XuIDRegion::cast(FEManager::TheFEConn->titleTypeID()->asRegion())));
  }
	return theTitleFilter;
}


#ifdef NO_PROPAGATE
class FETitleEditionHook : public XuFillRangeHook {
	virtual void rangeFilled (XuEditionP newIdentities) {
  	theTitleMgr->myWorkTrail = newIdentities->rangeWorks
			(XU_NULL, XU_NULL, 0, theTitleMgr->myWorkTrail);
	}
};
#endif

/* This perhaps should support localOnly, but not until we get WaitTrails. */
void FETitleManager::
startup () {
	theTitleMgr = new FETitleManager();
  theTitleMgr->myHook = (new FEEachTitle())->asFillRangeHook();
	theTitleMgr->myEditionTrail = XuEdition::empty(XuIDSpace::global())
		->rangeTranscluders(XU_NULL, FETitleManager::titleFilter());
#ifdef NO_PROPAGATE
	theTitleMgr->myEditionHook = new FETitleEditionHook();
	theTitleMgr->myEditionTrail->addFillRangeDetector(theTitleMgr->myEditionHook);
#endif
	theTitleMgr->myWorkTrail = theTitleMgr->myEditionTrail->rangeWorks();
	theTitleMgr->myWorkTrail->addFillRangeDetector(theTitleMgr->myHook);
}

void FETitleManager::
add (XuWorkP work) {
	// TODO: is the with even needed here, or can we just add it into the trail?
	theTitleMgr->myEditionTrail =	work->transcluders
		(FETitleManager::titleFilter(),	XU_NULL, 0, theTitleMgr->myEditionTrail);  
}

/* TODO: ignore titles of deleted Works (i.e. Works that we closed and that
	we want to _stay_ closed */
void FETitleManager::
remove (XuWorkP work) {
	cerr << "Can't remove the titles for works yet!\n";
}


