#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "xmdi.h"
#include "title.h"
#include "draft.h"
#include "content.h"
#include "bucket.h"
#include "links.h"
#include "textct.h"
#include "fe.h"
#include "feedit.h"
#include "femanage.h"
#include "xstuff.hxx"
#include "xconn.hxx"
#include "dlgtools.h"

FETextContentType const FETextContentType::TheOne;

const XuStringVar FETextContentType::name () {
	return "FEText";
}

PTWindowsObject FETextContentType::
makeWindow (FEDraftP text) {
	return FEEditWindow::make (TheApp->MainWindow, "", text);
}

/* make an FEContent on edition, with draft */
/* note this does not do a revise */ 
FEContent* FETextContentType::makeContent (XuEditionP edition, FEDraft* draft /* = NULL */) {
	FETextContent* ret = (FETextContent *) this->FEContentType::makeContent (edition, draft);
	ret->myLinkMgr = FELinkManager::make(ret, edition,
		XuIDRegion::cast(FEManager::TheFEConn->relationshipLinkTypeID()->asRegion()));
	return ret;
}

XuEditionP FETextContentType::makeEdition (XuStringVar str) {
	XuEditionP edn = XuText::make(str)->edition();
	edn->endorse(TheOne.endorsements ());
	return edn;
}

const FEContentType* FETextContent::type () {
	return &FETextContentType::TheOne;
}

XuEditionP FETextContentType::makeEdition () {
	XuEditionP result = XuText::make ("")->edition ();
	result->endorse (this->endorsements ());
	return result;
}

FEContent * FETextContentType::emptyContent () {
	return new FETextContent ();
}

/* set the edition of this Content to newEdition; update content window, if
	any, using version compare if appropriate */		// UI
void FETextContent::setEdition (XuEditionP newEdition) {
	// TODO: make this incremental so we can do revisedetector in Draft
	myEdition = newEdition;
	myEdition->endorse(this->type()->endorsements ());
	DialogTools::setEditText(myEdition, myWindow->Editor);
	XuPromise::forceAll();
}

/* select the region in the Content's window, if any */		// UI
void FETextContent::selectRegion (XuRegionP reg) {
	XuIntegerRegionP region = XuIntegerRegion::cast(reg);
	XuIntValueP startP = region->start();
	XuIntValueP stopP = region->stop();
	XuPromise::forceAll();
	if (startP->isBroken() || stopP->isBroken()) {
		myWindow->Editor->SetSelection(0, 0);
	} else {
		myWindow->Editor->SetSelection(startP->asInt(), stopP->asInt());
	}
}

/* select the reference, which eventually may be a MultiRef */		// UI
void FETextContent::selectReference (XuHyperRefP reference) {
	// TODO: extend to handle MultiRefs
	this->selectRegion(FEStuff::regionOf(XuSingleRef::cast(reference), myEdition));
}

/* create a reference from the current selection, using the Draft's Work */
 // UI
XuHyperRefP FETextContent::selectionReference () {
	int start, stop;
	myWindow->Editor->GetSelection(start, stop);
	if (start == stop) {
		start = 0;
		stop = myWindow->Editor->GetTextLen();
  }
	return FEStuff::makeSingleRef(myDraft->work(), myEdition,
		XuIntegerSpace::make()->interval(start, stop));
}

// TODO: move these next three, _soon_, if this is not the right place for them */
/* show the Content window */
void FETextContent::showWindow () {
	ShowWindow(myWindow->HWindow, SW_SHOW);
	BringWindowToTop(myWindow->HWindow);
}

/* hide the Content window */
void FETextContent::hideWindow () {
	ShowWindow(myWindow->HWindow, SW_HIDE);
}
 
/* set the Content window's title */
void FETextContent::setTitle (XuStringVar newTitle) {
	myWindow->SetCaption((char*)newTitle);
}

void FETextContent::flush () {
	myWindow->flushChanges();
}

/* close all windows */
void FETextContent::close (int windowClose) {
	if (!windowClose) {
		myWindow->CloseWindow();
		delete myWindow;
	}
	myWindow = NULL;
	myLinkMgr->closeWindow();
}
  

/* this Content's link manager */
FELinkManager* FETextContent::linkManager () {
	return myLinkMgr;
}

/* length of the Content's text */
XuIntVar FETextContent::length () {
	return myWindow->Editor->GetTextLen();
}

/* revise my Draft to myEdition, after endorsing it */
void FETextContent::revise (XuEditionP newEdition) {
	myEdition = newEdition;
	myEdition->endorse(this->type ()->endorsements ());
	myDraft->revise(myEdition);
}

/* insert string at pos, in Edition only */
// TODO: is this method of endorsing too cumbersome in any way?  is there any
// quicker way to do it?
void FETextContent::insertString (XuIntVar pos, XuStringVar string) {
	revise(XuText::wrap(myEdition)
		->insert(pos, XuText::make(string))->edition());
}

/* delete len characters at pos, in Edition only */
void FETextContent::deleteString (XuIntVar pos, XuIntVar len) {
	if (len > 0) {
		revise(XuText::wrap(myEdition)->extract(XuIntegerRegion::cast
			(XuIntegerSpace::make()->interval(pos, pos+len)->complement()))->edition());
	}
}

/* insert text at pos, in Edition only */
void FETextContent::insertText (XuIntVar pos, XuTextP text) {
	revise(XuText::wrap(myEdition)->insert(pos, text)->edition());
}
