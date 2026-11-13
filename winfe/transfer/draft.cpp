// The superclass of all Drafts.  Specific subclasses handle particular
// revise policies (for example, simple drafts versus buckets).

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
#include "xstuff.hxx"
#include "absui.h"
#include "femanage.h"

XuWorkP FEDraft::editWork () {
	return myWork;
}  

/* The save work.  If edit works are not supported, this gets revised
	on every call to revise(). This may be XU_NULL if the Draft has
	never been saved. */
XuWorkP FEDraft::work () {
	return myWork;
}

/* Access the Content of this Draft. */
FEContent* FEDraft::content () {
	return myContent;
}

/* Set the Content of this Draft.  Note this does not revise the
	Draft's Work. */
void FEDraft::setContent (FEContent* newContent) {
	myContent = newContent;
}

/* Access the title Work of this Draft. */
XuWorkP FEDraft::title () {
	return myTitleWork;
}

/* Access the title string of this Draft.  Note this may be different
	from the title of the Draft's Content's window, if (say) the Draft
	is grabbed. */
XuStringVar FEDraft::titleStr () {
	return myTitleStr;
}

class DocTitleHook : public XuExportHook {
	FEDraft* myDraft;
  XuWorkP myTitleWork;
public:
	DocTitleHook(FEDraft* doc, XuWorkP titleWork) :
		myDraft(doc), myTitleWork(titleWork) {};
	virtual void fulfilled(XuBufferVar buf, XuIntVar size) {
		myDraft->setTitle(myTitleWork, (XuStringVar)buf);
	}
};

/* Set the title.  If newTitleStr is NULL, will begin a fetch of the title. */
// UI
void FEDraft::setTitle (XuWorkP newTitle, XuStringVar newTitleStr) {
	myTitleWork = newTitle;
	if (newTitleStr == NULL) {
		FEStuff::getText(FETitleManager::titleEdition(myTitleWork),
										 new DocTitleHook(this, myTitleWork));
	} else {
		if (myTitleStr != NULL) {
			delete (char*)myTitleStr;
		}
		myTitleStr = _fstrdup(newTitleStr);
		if (myContent != NULL) {
			myContent->setTitle(myTitleStr);
  	}
	}
}


// Make a simple draft on the given work with the given (maybe NULL) content.
// This is not a static method because subclasses get installed at
// init time.
FEDraft* FEDraft::make (XuWorkP work, FEContent* content) {
	FEDraft* ret = new FEDraft();
	ret->myWork = work;
	ret->myContent = content;
	ret->myTitleWork = XU_NULL;
	ret->myTitleStr = "";
	ret->myAmGrabbing = FALSE;
	ret->myLastReviseSuccess = XU_NULL;
	/* myStatusHook, myGrabberID, myAmWaiting, myIsGrabbed, and myGrabberStr
		are all NYI */
  ret->myIsGrabbed = FALSE;
	ret->myAmWaiting = FALSE;
	ret->myStatusHook = XU_NULL;
	ret->myGrabberID = XU_NULL;
	ret->myGrabberStr = NULL;
  return ret;
}

/* Revise the (edit) work. */		// UI
// TODO: support NULL myWork here.  Not yet implemented.
void FEDraft::revise (XuEditionP newEdition) {
	if (!myAmGrabbing) {
		this->grab();
  }
	if (newEdition->isBroken()
			&& FEUI::ask("Edition broken.\nQuit now?", "Revise Error")) {
	   exit(-1);
	}
 	XuVoidP success;
	success = myWork->revise(newEdition);
	if (myLastReviseSuccess == NULL || myLastReviseSuccess->isFulfilled()) {
		myLastReviseSuccess = success;
	}   /* Fall through so we immediately test success if possible. */
	if (myLastReviseSuccess->isBroken()) {
  	// the last revise broke; we lost the grab.  Ask what to do.
		if (FEUI::ask("Make a new variant?", "Revise failed.")) {

			// TODO: add code here so we can keep original around and request grab.
			// TODO: add code to make new variant's title and update new Doc
			// immediately.

      // make the new Work and Draft
			FEDraft* newDoc = FEManager::makeNewDraft(myContent);
			myContent->setDraft(newDoc);
			// set the new Variant's title
			XuWorkP titleWork = FETitleManager::makeTitle
				(newDoc->work(), XuText::make("New Variant")->edition());
			newDoc->setTitle(titleWork, "New Variant");
			// get rid of me
			myContent = NULL;
			this->release();
			return;
		} else {
    	// rewind to work's current edition
			myContent->setEdition(myWork->edition());
    }
	}
}

/* Revise the save work. */			// UI
// TODO: extend this to only save if save is needed.
void FEDraft::save (XuEditionP newEdition) {
	this->revise(newEdition);
}

/* Close this Draft, asking the user whether to save, if applicable. */
/* Note that the Content must still be around in case the user has never
	saved and the Draft hasn't been tracking revisions. */		// UI
// TODO: implement this for edit works or XU_NULL myWork.
XuBooleanVar FEDraft::close (int windowClose) {
	if (myContent != NULL) {
		myContent->flush();
	}
	if (this->confirmSave()) {
		this->release();
		// make any extant promises come back, so it will be OK when we
    // completely drop the draft
		XuPromise::forceAll();
		if (myContent != NULL) {
			myContent->close(windowClose);
		}
		return TRUE;
	} else {
		return FALSE;
  }
}

/* Confirm a save. */
// TODO: actually implement this for edit works, or at least check that
// the last revise is fulfilled....
XuBooleanVar FEDraft::confirmSave () {
	return TRUE;
}
	

/* Attempt to grab this draft.  This lets people who would rather not
	type onto a moving document try to grab in a more direct way. */	// UI
// TODO: we want this to wait for the grab to come back and give feedback ASAP,
// not to mention checking whether it's moved out from under us.
void FEDraft::grab () {
	if (!myAmGrabbing) {
		// TODO: this must update title, too.
		myAmGrabbing = TRUE;
		myWork->grab();
	}
}	
                                         
/* Release this draft. myAmGrabbing must be TRUE. */	// UI
void FEDraft::release () {
	if (myAmGrabbing) {
		// TODO: this must update title, also.
		myAmGrabbing = FALSE;
		myWork->release();
  }
}

/* TRUE if myWork is grabbed by someone. */
XuBooleanVar FEDraft::isGrabbed () {
	return myIsGrabbed;
}

/* TRUE if I am grabbing myWork. */
XuBooleanVar FEDraft::amGrabbing () {
	return myAmGrabbing;
}

/* TRUE if I am waiting for a grab of myWork. */
XuBooleanVar FEDraft::amWaiting () {
	return myAmWaiting;
}

/* The ID of the current grabber (valid only if isGrabbed is TRUE). */
XuIDP FEDraft::currentGrabber () {
	return myGrabberID;
}

/* The name of the current grabber (valid only if isGrabbed is TRUE). */
XuStringVar FEDraft::currentGrabberStr () {
	return myGrabberStr;
}
