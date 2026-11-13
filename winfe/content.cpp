// The superclass of all Content classes.

#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

//#include "title.h"
#include "draft.h"
#include "content.h"
#include "xconn.hxx"

<<<<<<< content.cpp
XU_DEFINE_TYPE(FEContent,XuCounted)

/* the edition of this Content */
XuEditionP FEContent::edition () {
	return myEdition;
=======
XU_DEFINE_TYPE(FEContent,XuCounted)

/* the edition of this Content */
XuEditionP FEContent::
edition () {
	return myEdition;
>>>>>>> 1.7
}

<<<<<<< content.cpp
/********************** Content Types **********************/

// a sequence-indexed edition of Works describing doc types
static XuEditionP TheContentTypes = XU_NULL;

/* The mapping from contentType IDs to contentType numbers
static XuMappingP TheContentTypeMapping = XU_NULL;

FEContentTypeP FEContentType::TheFirst = NULL;

// note that these next three members depend on the Edition structure
// created in docTypeEdition()
// note that these next three members depend on the Edition structure
// created in docTypeEdition()
XuEditionP FEContentType::
docTypeEdition () {
	if (TheContentTypes == XU_NULL) {
		// make new one, with works
		TheContentTypes = XuEdition::empty(XuSequenceSpace::make());
		TheContentTypeMapping = 
			XuCrossSpace::endorsements()
				->completeMapping(XuIntegerSpace::make()->emptyRegion())
				->restrict(XuCrossSpace::endorsements()->emptyRegion());

		/* for each registered doc type, make a work on the type name, make
			 an ID for that work, use that ID as the content class's typeID */
		for (FEContentTypeP cType = FEContentType::TheFirst; cType; cType = cType->myNext) {
			TheContentTypes = TheContentTypes->with(type->name(), cType->initializeType());
		}
	}
	return TheContentTypes;
=======
FEContent::
FEContent (XuEditionP edition) : myEdition(edition) {}

/********************** Content Types **********************/

// a sequence-indexed edition of Works describing doc types */
static XuEditionP TheContentTypes = XU_NULL;

/* The mapping from contentType IDs to contentType numbers */
static XuMappingP TheContentTypeMapping = XU_NULL;

/* The mapping from contentType IDs to contentType numbers */
static XuIntVar TheContentTypeNumber = 0;
FEContentTypeP FEContentType::TheFirst = NULL;

// note that these next three members depend on the Edition structure
// created in docTypeEdition()
// note that these next three members depend on the Edition structure
// created in docTypeEdition()
XuEditionP FEContentType::
contentTypeEdition () {
	if (TheContentTypes == XU_NULL) {
		// make new one, with works
		TheContentTypes = XuEdition::empty(XuSequenceSpace::make());
		TheContentTypeMapping = 
			XuCrossSpace::endorsements()
				->completeMapping(XuIntegerSpace::make()->emptyRegion())
				->restrict(XuCrossSpace::endorsements()->emptyRegion());

#ifdef DEBUG
TheContentTypeMapping->force();
#endif

		/* for each registered doc type, make a work on the type name, make
			 an ID for that work, use that ID as the content class's typeID */
		for (FEContentTypeP cType = FEContentType::TheFirst; cType; cType = cType->myNext) {
			TheContentTypes = TheContentTypes->with(cType->name(), cType->initializeType());

#ifdef DEBUG
TheContentTypes->force();
#endif

		}
	}
	return TheContentTypes;
>>>>>>> 1.7
}

<<<<<<< content.cpp
// Load TheContentTypes from an already-made home document
void FEContentType::
setDocTypeEdition (XuEditionP newEdition) {
	TheContentTypes = newEdition;
	TheContentTypeMapping = 
		XuCrossSpace::endorsements()
			->completeMapping(XuIntegerSpace::make()->emptyRegion())
			->restrict(XuCrossSpace::endorsements()->emptyRegion());
	for (FEContentType P cType = FEContentType::TheFirst; cType; cType = cType->myNext) {
		cType->myTypeID = XuServer::iDOf( newEdition->get( cType->name()));
  }
	for (cType = FEContentType::TheFirst; cType; cType = cType->myNext) {
		cType->registerType();
  }
=======
// Load TheContentTypes from an already-made home document
void FEContentType::
setContentTypeEdition (XuEditionP newEdition) {
	TheContentTypes = newEdition;
	TheContentTypeMapping = 
		XuCrossSpace::endorsements()
			->completeMapping(XuIntegerSpace::make()->emptyRegion())
			->restrict(XuCrossSpace::endorsements()->emptyRegion());
	for (FEContentTypeP cType = FEContentType::TheFirst; cType; cType = cType->myNext) {
		cType->myTypeID = XuServer::iDOf( newEdition->get( cType->name()));

#ifdef DEBUG
cType->myTypeID->force();
#endif

  }
	for (cType = FEContentType::TheFirst; cType; cType = cType->myNext) {
		cType->registerType();
  }
>>>>>>> 1.7
}

<<<<<<< content.cpp
/* Make any works associated with the type, and get its endorsementID */
XuWorkP FEContentType::
initializeType ()
{
	XuWorkP work = XuWork::make(XuText::make(this->name())->edition());
	XuIDP iD = XuServer::assignID (work);
  myTypeID = iD;
	return work;
}

void FEContentType::
registerType () 
{
	myTypeID->force();
	if ( !(myTypeID->isFulfilled())) {
		cerr << "Can't find contentType: " << this->name() << "\n";
		return;
	}
	myTypeNumber = ContentTypeNumber++;
	/* Compute a map from the endorsement''s region to the contentType number */
	XuMappingP singleMap =
		XuCrossSpace::endorsements()
				->completeMapping(IntegerSpace::make()->position(myTypeNumber)->asRegion())
				->restrict(XuCrossSpace::endorsements()->extrusion(1,myTypeID))
	TheContentTypeMapping = TheContentTypeMapping->combine(singleMap);
=======
/* Make any works associated with the type, and get its endorsementID */
XuWorkP FEContentType::
initializeType ()
{
	XuWorkP work = XuWork::make(XuText::make(this->name())->edition());
	XuIDP iD = XuServer::assignID (work);
  myTypeID = iD;
	return work;
}

void FEContentType::
registerType () 
{
	myTypeID->force();
	if ( !(myTypeID->isFulfilled())) {
		cerr << "Can't find contentType: " << this->name() << "\n";
		return;
	}
	myTypeNum = TheContentTypeNumber++;
	/* Compute a map from the endorsement''s region to the contentType number */
	XuMappingP singleMap =
		XuCrossSpace::endorsements()
				->completeMapping(XuIntegerSpace::make()->position(myTypeNum)->asRegion())
				->restrict(XuCrossSpace::endorsements()->extrusion(1,myTypeID->asRegion()));

	TheContentTypeMapping = TheContentTypeMapping->combine(singleMap);
>>>>>>> 1.7

<<<<<<< content.cpp
	// TODO: make this use the application club's ID, not the login club's
	myEndorsements = XuTuple::endorsement(TheFEConn->loginClubID(), myTypeID) ->asRegion();
=======
#ifdef DEBUG
TheContentTypeMapping->force();
#endif

	// TODO: make this use the application club's ID, not the login club's
	myEndorsements = XuCrossRegion::cast(
		XuTuple::endorsement(FEConn::TheOne->loginClubID(), myTypeID)->asRegion());

#ifdef DEBUG
myEndorsements->force();
#endif


>>>>>>> 1.7
}

XuCrossRegionP FEContentType::
endorsements () {
	return myEndorsements;
}

<<<<<<< content.cpp
FEContentType::
FEContentType () {
	// add myself to the head of a linked list
	myNext = TheFirst;
	TheFirst = this;
=======
FEUI::Alignment FEContentType::
vertical () { return FEUI::Default; }

FEUI::Alignment FEContentType::
horizontal () { return FEUI::Default; }

FEContentType::
FEContentType () {
	// add myself to the head of a linked list
	myNext = TheFirst;
	TheFirst = this;
>>>>>>> 1.7
}

/******************* FEContentHandle ********************/

XU_DEFINE_TYPE(FEContentHandle,XuCounted)

<<<<<<< content.cpp
FEContentTypeP FEContentHandle::
make (XuEditionP edition)
{
	/* TODO: This should take the largest number in order so that a document
		 can have endorsements from supertypes of mappings and this will get 
		 the most specific type. */
	FEContentHandleP result = new FEContentHandle();
	result->myEdition = edition;
	result->myTypeNum =
		XuInteger:cast(TheContentTypeMapping->ofAll(edition->endorsements())->theOne())->value();
	return result;
}

FEContentTypeP FEContentHandle::
fetchType ()
{
	myTypeNum->force();
	XuIntVar typeNum = myTypeNum->asInt();
	for (FEContentTypeP cType = FEContentType::TheFirst; cType; cType = cType->myNext) {
		if (cType->myTypeNum == typeNum) {
			return cType;
		}
	}
	cerr << "Couldn't find contentType.\n";
	return NULL;
=======
FEContentHandleP FEContentHandle::
make (XuEditionP edition)
{
	/* TODO: This should take the largest number in order so that a document
		 can have endorsements from supertypes of mappings and this will get 
		 the most specific type. */
	FEContentHandleP result = new FEContentHandle();
	result->myEdition = edition;
	XuRegionP endorsements = edition->endorsements();
	XuRegionP mappedNumReg = TheContentTypeMapping->ofAll(endorsements);
	XuPositionP mappedNumPos = mappedNumReg->theOne();
#ifdef DEBUG
XuIntValueP mappedNumCount = mappedNumReg->count();
XuIntValueP mappedNumFull = mappedNumReg->isFull();
mappedNumFull->force();
XuIntVar num, fuf = 0, full = 0;
if (mappedNumCount->isFulfilled()) {
	num = mappedNumCount->asInt();
	full = mappedNumFull->asInt();
	fuf = 1;
}
// TODO DEBUGGING: put a breakpoint on the next line, and watch num, full, and fuf;
// run at each point and see when the mapping breaks.
#endif
	result->myTypeNum = XuInteger::cast(mappedNumPos)->value();
	return result;
}

FEContentTypeP FEContentHandle::
fetchType ()
{
	myTypeNum->force();
	if (myTypeNum->isBroken()) {
		cerr << "Edition's endorsements didn't map to anything useful.";
		return NULL;
  }
	XuIntVar typeNum = myTypeNum->asInt();
	for (FEContentTypeP cType = FEContentType::TheFirst; cType; cType = cType->myNext) {
		if (cType->myTypeNum == typeNum) {
			return cType;
		}
	}
	cerr << "Couldn't find contentType.\n";
	return NULL;
>>>>>>> 1.7
}

<<<<<<< content.cpp
FEContentTypeP FEContentHandle::
fetchContent ()
{
	FEContentTypeP type = this->fetchType();
	return type ? type->makeContent(myEdition) : NULL;
=======
FEContentP FEContentHandle::
fetchContent ()
{
	FEContentTypeP type = this->fetchType();
	if (type) {
		return type->makeContent(myEdition);
	} else {
		return XU_NULL;
  }
>>>>>>> 1.7
}

