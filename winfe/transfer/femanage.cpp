// The manager for all documents, windows, and managers.

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
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "xint2set.hxx"
#include "startup.h"
#include "clip.h"
#include "bucket.h"
#include "title.h"
#include "formct.h"
#include "ratefct.h"
#include "memofct.h"
#include "akordfct.h"
#include "homefct.h"
#include "tabsfct.h"
#include "attnfct.h"
#include "umfct.h"
#include "cproffct.h"

// a sequence-indexed edition of Works describing doc types
static XuEditionP TheDocTypes = XU_NULL;

// an ID-indexed edition of integers; each integer is an index into
// theDocTypes, and the IDs are token IDs with which drafts are
// endorsed to set their type
static XuEditionP TheDocTypeNumbers = XU_NULL;

// TODO: get rid of these
const int DraftMax = 100;
int FEManager::DraftCount = 0;

// TODO: make this an indexed linked list so we can't run out
static FEDraft* TheDrafts[DraftMax]; 	// all open drafts

static FEInt2Set* TheWorks = NULL; 		// map from draft numbers to doc works

FEConn* FEManager::TheFEConn = NULL;

// called after the the initial setup
void FEManager::startup() {
	for (int i = 0; i < DraftMax; i++) {
		TheDrafts[i] = NULL;
	}
	TheWorks = FEInt2Set::make();
}

FEDraft* FEManager::draftOn (XuWorkP work, FEContentType* type) {

	XuIntValueP docTypeNum;
	if (type == NULL) {
		docTypeNum = FEManager::docTypeNumber (work->edition());
	}
	// this forces, so we don't need to force docTypeNum
	XuIntVar pos = TheWorks->positionOf(work);
  FEDraft* doc;
  // pos is negative if work is broken or not in TheWorks
	if (pos >= 0) {
		// work _is_ in TheWorks, but the draft's been closed; need to reopen a
    // draft on it
		doc = TheDrafts[pos];
		if (doc != NULL) {
			return doc;
		}
		// now fall through; pos is set to the empty slot where work's Doc
		// used to be    	
	} else if (work->isBroken()) {
			return NULL;
	} else {
		// work needs a new slot
		pos = DraftCount++;
  }
	if (type == NULL) {
		if (docTypeNum->isBroken()) {
			// TODO: put up warning that doc type couldn't be found (or wasn't
       // unique)
			return NULL;
		}
		type = FEManager::contentType (docTypeNum->asInt ());
	}
	doc = FEDraft::make(work);
	FEContent* cont = type->makeContent (work->edition(), doc);
	doc->setContent(cont);      
	TheWorks->addAt(pos, work);
	TheDrafts[pos] = doc;
	FETitleManager::add(work);
	return doc;
}

FEDraft* FEManager::makeNewDraft (FEContent* content) {
	XuWorkP work = XuWork::make(content->edition());
	// TODO: make dispatch on type of work if docClass is NULL
	int pos = DraftCount++;
	TheWorks->addAt(pos, work);
	FEDraft* draft = FEDraft::make (work);
  draft->setContent(content);
	TheDrafts[pos] = draft;
	FETitleManager::add(work);
	return draft;
}

XuBooleanVar FEManager::shutdown() {
	for (int i = 0; i < DraftMax; i++) {
		if (TheDrafts[i] != NULL) {
			if (!FEManager::close(TheDrafts[i], FALSE)) {
				return FALSE;
			}
		}
  }
	XuSession::current()->endSession();
  return TRUE;
}

XuBooleanVar FEManager::close (FEDraft* doc, int windowClose) {
	if (doc->close(windowClose)) {
		for (int i = 0; i < DraftMax; i++) {
			if (TheDrafts[i] == doc) {
				// TODO: figure this out.  It seems that removing doc->work()
				// from the table eventually causes a xuFatalError, when a promise
				// with the work's name on it comes back from the server.  Now,
				// the question is, why does that happen?
				TheWorks->remove(doc->work());
				delete doc;
				TheDrafts[i] = NULL;
				break;
			}
		}
    return TRUE;
	} else {
		return FALSE;
  }
}


void FEManager::returnHome () {
	if (TheWorks == NULL) {
		cerr << "Haven't finished startup!!!\n";
		XuIntValue::signedMake(42);
    XuPromise::forceAll();
		XuDetectorHook::poll();
		MessageBeep(-1);
		return;
  }
	XuWorkP loginHomeDoc = FEStartupManager::fetchAppHome();
	if ( loginHomeDoc != XU_NULL ) {
		FEDraft * home = FEManager::draftOn (loginHomeDoc);
    if (home) {
			FEHomeFormContentType::setInstance ((FEFormContent*)home->content ());
			FEHomeFormContentType::show ("Akord");
			FEHomeFormContentType::show ("Papers");
		}
  }
}

// note that these next three members depend on the Edition structure
// created in docTypeEdition()
XuEditionP FEManager::docTypeEdition () {
	if (TheDocTypes == XU_NULL) {
		// make new one, with works
		TheDocTypeNumbers = XuEdition::empty(XuIDSpace::global());
		XuEditionP edn = XuEdition::empty(XuSequenceSpace::make());

		// for each registered doc type, make a work on the type name, make
		// an ID for that work, use that ID as the content class's typeID,
		// and save the ID in TheDocTypeNumbers for speedy lookup
    int index = 0;
		for (FEContentType* type = FEContentType::fetchFirst (); type; type = type->fetchNext ()) {
			XuWorkP work = XuWork::make(XuText::make (type->name ())->edition());
			XuIDP id = XuServer::assignID (work);
			type->setTypeID (id);
			TheDocTypeNumbers = TheDocTypeNumbers->with (id, XuDataHolder::make(index));
			edn = edn->with(XuSequence::string (type->name ()), work);
      index++;
		}
		TheDocTypes = edn;
	}
	return TheDocTypes;
}


// Load TheDocTypes from an already-made home document
void FEManager::setDocTypeEdition (XuEditionP newEdition) {
	TheDocTypes = newEdition;

	// TODO: TheDocTypeNumbers will be broken if any of the current types are unavailable
  // This should be fixed so that it gracefully ignores missing ones
	int index = 0;
	TheDocTypeNumbers = XuEdition::empty(XuIDSpace::global());
	for (FEContentType * type = FEContentType::fetchFirst (); type; type = type->fetchNext ()) {
		XuIDP id = XuServer::iDOf (newEdition->get (XuSequence::string (type->name ())));
		type->setTypeID (id);
		TheDocTypeNumbers = TheDocTypeNumbers->with (id, XuDataHolder::make (index));
		index++;
  }
}

// get the number of the type with which edition is endorsed, by comparing
// the endorsements on edition with the numbers stored in TheDocTypeNumbers
XuIntValueP FEManager::docTypeNumber (XuEditionP edition) {
	XuIDP docTypeID = XuID::cast(TheDocTypeNumbers->domain()->intersect
		(edition->endorsements()->projection(1))->theOne());
	XuIntValueP result = XuIntValue::cast(XuDataHolder::cast
		(TheDocTypeNumbers->get(docTypeID))->value());
	return result;
} 	

FEContentType* FEManager::contentType (int index) {
	// for now, just do a linear search
	FEContentType * result = FEContentType::fetchFirst ();
	for (int i = 0; i < index; i++) {
		result = result->fetchNext ();
	}
//  assert (result != NULL);
	return result;
}