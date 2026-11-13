// The superclass of all Drafts.  Specific subclasses handle particular
// revise policies (for example, simple drafts versus buckets).

#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "draft.h"
#include "content.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "absui.h"
<<<<<<< draft.cpp
#include "xint2set.hxx"
=======
#include "sheet.h"
#include "xint2set.hxx"
>>>>>>> 1.8

<<<<<<< draft.cpp
// TODO: magic constants.  these should go away
const int DraftMax = 100;
int DraftCount = 0;

// TODO: make this an indexed linked list so we can't run out
static FEDraftP TheDrafts[DraftMax]; 	// all open drafts
static FEInt2Set* TheWorks = NULL; 		// map from draft numbers to works

// called after the the initial setup
void FEDraft::startup() {
	for (int i = 0; i < DraftMax; i++) {
		TheDrafts[i] = NULL;
	}
	TheWorks = FEInt2Set::make();
}

// Noone calls this with a ContentType
FEDraftP FEDraft::
fetchDraft (XuWorkP work) {
	FEContentTypeHandleP handle = FEContentTypeHandle::make(work->edition());
	XuIntVar pos = TheWorks->positionOf(work);
	if (work->isBroken()) {
			return NULL;	
	}
  // pos is negative if work is broken or not in TheWorks
	if (pos >= 0) {
		// TODO: might this return NULL?
		return TheDrafts[pos];
	} 
	FEContentTypeP type = handle->fetchType();
	if (type == NULL) {
		// TODO: put up warning that doc type couldn't be found (or wasn't unique)
		return NULL;
	}
	FEContentP content = type->makeContent (work->edition());
  return new FEDraft(work, content, DraftCount++);
}

FEDraftP FEDraft::makeNewDraft (FEContentP content) {
	XuWorkP work = XuWork::make(content->edition());
	return new FEDraft(work, content, DraftCount++);
}

/* Make a simple draft on the given work with the given content */

FEDraft::
FEDraft(XuWorkP work, FEContentP content, XuIntVar draftNum) {
	myWork = work;
	myContent = content;
	myLastReviseSuccess = XU_NULL;
	mySheet = NULL;
	amGrabbing = FALSE;
	TheWorks->addAt(draftNum, work);
	TheDrafts[draftNum] = draft;
	FETitleManager::add(work);
}

XuWorkP FEDraft::
editWork () {
=======
XU_DEFINE_TYPE(FEDraft,XuCounted)

// TODO: magic constants.  these should go away
const int DraftMax = 100;
int DraftCount = 0;

// TODO: make this an indexed linked list so we can't run out
static FEDraftP TheDrafts[DraftMax];    // all open drafts
static FEInt2Set* TheWorks = NULL;              // map from draft numbers to works

// called after the the initial setup
void FEDraft::startup() {
	TheWorks = FEInt2Set::make();
	for (int i = 0; i < DraftMax; i++) {
		TheDrafts[i] = XU_NULL;
  }
}

// Noone calls this with a ContentType
FEDraftP FEDraft::fetchDraft (XuWorkP work, FEContentP content) {
	if (content != XU_NULL) {
		return new FEDraft(work, content, DraftCount++);
	}
	FEContentHandleP handle = FEContentHandle::make(work->edition());
	XuIntVar pos = TheWorks->positionOf(work);
	if (work->isBroken()) {
			return XU_NULL; 
	}
  // pos is negative if work is broken or not in TheWorks
	if (pos >= 0) {
		// TODO: might this return NULL?
		return TheDrafts[pos];
	} 
	FEContentP newContent = handle->fetchContent();
	if (newContent == XU_NULL) {
		// TODO: put up warning that doc type couldn't be found (or wasn't unique)
		return XU_NULL;
	}
	return new FEDraft(work, newContent, DraftCount++);
}

FEDraftP FEDraft::makeNewDraft (FEContentP content) {
	XuWorkP work = XuWork::make(content->edition());
	return new FEDraft(work, content, DraftCount++);
}

void FEDraft::closeAll () {
	for (int i = 0; i < DraftMax; i++) {
		TheDrafts[i] = XU_NULL;
	}
}

/* Make a simple draft on the given work with the given content */

FEDraft::FEDraft(XuWorkP work, FEContentP content, XuIntVar draftNum) {
	myWork = work;
	myContent = content;
	myLastReviseSuccess = XU_NULL;
	mySheet = NULL;
	amGrabbing = FALSE;
	TheWorks->addAt(draftNum, work);
	TheDrafts[draftNum] = this;
	// FETitleManager::add(work);
}

FEDraft::~FEDraft () {
	this->release();
}

XuWorkP FEDraft::editWork () {
>>>>>>> 1.8
	return myWork;
}  

/* The save work.  If edit works are not supported, this gets revised
	on every call to revise(). This may be XU_NULL if the Draft has
	never been saved. */
XuWorkP FEDraft::
work () {
	return myWork;
}

/* Access the Content of this Draft. */
FEContentP FEDraft::content () {
	return myContent;
}

<<<<<<< draft.cpp
/* Grab revise protocol */
=======
/* Access the Sheet of this Draft.  Private; used by FESheet::draft(). */
FEDraftP FEDraft::draftFor (FESheetP sheet) {
	for (int i = 0; i < DraftMax; i++) {
		if (TheDrafts[i] != XU_NULL && TheDrafts[i]->mySheet == sheet) {
			return TheDrafts[i];
		}
  }
	return XU_NULL;
}

/* Grab revise protocol */
>>>>>>> 1.8
// TODO: support NULL myWork here.  Not yet implemented.
void FEDraft::revise (FEContentP newContent) {
	if (!amGrabbing) {
		this->grab();
  }
	XuEditionP newEdition = newContent->edition();
	if (newEdition->isBroken()
			&& FEUI::ask("Edition broken.\nQuit now?", "Revise Error")) {
	   exit(-1);
	}
<<<<<<< draft.cpp
 	XuVoidP success = myWork->revise(newEdition);
	if (myLastReviseSuccess == NULL || myLastReviseSuccess->isFulfilled()) {
=======
	XuVoidP success = myWork->revise(newEdition);
	if (myLastReviseSuccess == XU_NULL || myLastReviseSuccess->isFulfilled()) {
>>>>>>> 1.8
		myLastReviseSuccess = success;
	}   /* Fall through so we immediately test success if possible. */
	if (myLastReviseSuccess->isBroken()) {
	// the last revise broke; we lost the grab.  Ask what to do.
		if (FEUI::ask("Make a new variant?", "Revise failed.")) {

			// TODO: add code here so we can keep original around and request grab.
			// TODO: add code to make new variant's title and update new Doc
			// immediately.

      // make the new Work and Draft
<<<<<<< draft.cpp
			FESheet::showDraft(FEDraft::makeNewDraft(myContent));
/*			// set the new Variant's title
			XuWorkP titleWork = 
				FETitleManager::makeTitle(newDoc->work(), 
													XuText::make("New Variant")->edition());
=======
			FESheet::sheetOn(FEDraft::makeNewDraft(newContent))->show();
/*                      // set the new Variant's title
			XuWorkP titleWork = 
				FETitleManager::makeTitle(newDoc->work(), 
													XuText::make("New Variant")->edition());
>>>>>>> 1.8
			newDoc->setTitle(titleWork, "New Variant");
<<<<<<< draft.cpp
*/			
			// TODO: get rid of me
=======
*/                      
			// TODO: get rid of me
>>>>>>> 1.8
			this->release();
			return;
		} else {
<<<<<<< draft.cpp
    	// rewind to work's current edition
			myContent = myContent->type()->makeContent(myWork->edition());
=======
	// rewind to work's current edition
			myContent = myContent->type()->makeContent(myWork->edition());
>>>>>>> 1.8
    }
	} else {
		myContent = newContent;
  }
}

/* Attempt to grab this draft.  This lets people who would rather not
<<<<<<< draft.cpp
	type onto a moving document try to grab in a more direct way. */	
=======
	type onto a moving document try to grab in a more direct way. */        
>>>>>>> 1.8
// TODO: we want this to wait for the grab to come back and give feedback ASAP,
// not to mention checking whether it's moved out from under us.
<<<<<<< draft.cpp
void FEDraft::
grab () {
	if (!amGrabbing) {
=======
void FEDraft::grab () {
	if (!amGrabbing) {
>>>>>>> 1.8
		// TODO: this must update title, too.
<<<<<<< draft.cpp
		amGrabbing = TRUE;
		myWork->grab();
=======
		amGrabbing = TRUE;
		XuVoidP grabbed = myWork->grab();
<<<<<<< draft.cpp
#ifdef DEBUG
grabbed->force();
int i = 2; // place for bp
#endif
>>>>>>> 1.8
=======
>>>>>>> 1.9
	}
<<<<<<< draft.cpp
}	
                                         
/* Release this draft. amGrabbing must be TRUE. */
void FEDraft::
release () {
	if (amGrabbing) {
=======
}       
					 
/* Release this draft. amGrabbing must be TRUE. */
void FEDraft::release () {
	if (amGrabbing) {
>>>>>>> 1.8
		// TODO: this must update title, also.
		amGrabbing = FALSE;
		myWork->release();
  }
}

<<<<<<< draft.cpp
XuBooleanValueP FEDraft::
replace (FEContentP oldContent, FEContentP newContent) {
	// Is this the right semantics?
	if (!amGrabbing) {
		myWork->grab();
	}
	XuBooleanValueP flag = myContent->edition()->isIdentical(oldContent->edition());
	flag = flag->logicalAnd(myWork->canRevise());
	flag->force();
	if (flag->asBooleanVar()) {
		myContent = newContent;
		myWork->revise(newContent->edition());
	}
	if (!amGrabbing) {
		myWork->release();
	}
	return flag;
=======
XuBooleanValueP FEDraft::replace (FEContentP oldContent, FEContentP newContent) {
	// Is this the right semantics?
	if (!amGrabbing) {
		myWork->grab();
	}
	XuBooleanValueP flag = myContent->edition()->isIdentical(oldContent->edition());
	flag = flag->logicalAnd(myWork->canRevise());
	flag->force();
	if (flag->asBoolean()) {
		myContent = newContent;
		myWork->revise(newContent->edition());
	}
	if (!amGrabbing) {
		myWork->release();
	}
	return flag;
>>>>>>> 1.8
}

<<<<<<< draft.cpp
/* Revise the save work. */	
// TODO: extend this to only save if save is needed.
void FEDraft::save (FEContentP content) {
	this->revise(content);
}
	
=======
XuBooleanValueP FEDraft::canRevise () {
	return myWork->canRevise();
}

/* Revise the save work. */
// TODO: extend this to only save if save is needed.
/* void FEDraft::save (FEContentP content) {
	this->revise(content);
}       */
	
>>>>>>> 1.8
