// The superclass of all Content classes.

#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "title.h"
#include "draft.h"
#include "content.h"
#include "femanage.h"
#include "xmdi.h"
#include "xconn.hxx"

void FEContentType::setTypeID (XuIDP id) {
	// TODO: make this use the application club's ID, not the login club's
  myTypeID = id;
	myEndorsements = XuCrossRegion::endorsements
		(XuIDRegion::cast(FEManager::TheFEConn->loginClubID()->asRegion()),
		 XuIDRegion::cast(id->asRegion()));
}

XuCrossRegionP FEContentType::endorsements () {
	return myEndorsements;
}

FEContentType::FEContentType () {
	// add myself to the head of a linked list
	myNext = TheFirst;
	TheFirst = this;
}

FEContentType* FEContentType::TheFirst = NULL;

FEContentType* FEContentType::fetchFirst () {
	return TheFirst;
}

FEContentType* FEContentType::fetchNext () {
	return myNext;
}

FEContent * FEContentType::makeContent (XuEditionP edition, FEDraft* draft /* = NULL */) {
	FEContent * ret = this->emptyContent ();
	// TODO: add error checking here to make sure it's wrappable
	ret->myDraft = draft;
	ret->myEdition = edition;
	ret->myWindow = this->makeWindow (ret);
	if (ret->myWindow) {
		if (TheApp->MakeWindow(ret->myWindow)) {
			ret->setEdition(edition);
			FEUI::align (ret->myWindow->HWindow,
				this->horizontal (), this->vertical ());
			ret->myWindow->Show (SW_SHOWNORMAL);
		} else {
			cerr << "Panic and confusion--can't make window!\n";
			abort();
		}
  }
	return ret;
}

/* the edition of this Content */
XuEditionP FEContent::edition () {
	return myEdition;
}

/* the Draft of this Content, if any */
FEDraft* FEContent::draft () {
	return myDraft;
}

/* set the Draft of this Content; do not revise */
void FEContent::setDraft (FEDraft* draft) {
	myDraft = draft;
}

/* endorse me */
void FEContent::revise (XuEditionP newEdn) {
	myEdition = newEdn;
	newEdn->endorse (this->type()->endorsements());
	myDraft->revise(myEdition);
}

