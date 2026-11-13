#include <owl.h>
#include <xanadu.hxx>
#include <stdio.h>
#include <stdlib.h>
#include <fstream.h>
#include <string.h>
#pragma hdrstop

#include "formct.h"
#include "sheet.h"
#include "content.h"

/******************* FEFormContent ********************/

XU_DEFINE_TYPE(FEString,XuCounted)

XU_DEFINE_TYPE(FEFormContent,FEContent)

<<<<<<< formct.cpp
<<<<<<< formct.cpp
FEFormContentP FEFormContent::
with(XuStringVar key, XuRangeElementP value)
{
=======
// TODO: make this go away; make caches not need it
// meanwhile, make sure this is more than any number of fields we actually use
const int FEFormContent::numFormFields = 50;

FEFormContentP FEFormContent::with (XuStringVar key, XuRangeElementP value) {                                  
>>>>>>> 1.7
	XuEditionP edition = this->edition()->with(key, value);
	edition->endorse(myType->endorsements());
<<<<<<< formct.cpp
	return myType->makeContent(edition);
=======
FEFormContentP FEFormContent::
with(XuStringVar key, XuRangeElementP value)
{
	XuEditionP edition = this->edition()->with(key, value);
	edition->endorse(myType->endorsements());
	return XU_CAST(FEFormContent,myType->makeContent(edition));
>>>>>>> 1.6
=======
	return //XU_CAST(FEFormContent,myType->makeContent(edition));
   	new FEFormContent(edition, myType, myCache->copy());
}

FEFormContentP FEFormContent::with (XuStringVar key, XuStringVar value) {
	XuEditionP edition = this->edition()->with(key, XuText::make(value)->edition());
	FEStringAssoc* cache = this->myCache->copy();
	cache->store(key, value);
	edition->endorse(myType->endorsements());
	return new FEFormContent(edition, myType, cache);
>>>>>>> 1.7
}

<<<<<<< formct.cpp
<<<<<<< formct.cpp
void FEFormContent::
followFieldRef (XuStringVar key) {
	// we get it from the edition since it may get changed from outside
	XuHyperRefP ref = XuHyperRef::wrap(XuEdition::cast(this->edition()->get(key)));
	FESheet::showRef(ref);
=======
void FEFormContent::
followFieldRef (XuStringVar key) {
=======
XuStringVar FEFormContent::fetchString (XuStringVar key) {
	return myCache->fetch(key);
}

void FEFormContent::updateCache (XuStringVar key, XuStringVar value) {
	myCache->store(key, value);
}

void FEFormContent::followFieldRef (XuStringVar key) {
>>>>>>> 1.7
	// we get it from the edition since it may get changed from outside
	XuEditionP edn = this->edition();
	XuPromiseP refPromise = edn->get(key);
	XuEditionP refEdn = XuEdition::cast(refPromise);
	XuHyperRefP ref = XuHyperRef::wrap(refEdn);
#ifdef DEBUG
ref->force();
#endif
	FESheet::showRef(ref);
>>>>>>> 1.6
}

const FEContentTypeP FEFormContent::type () {
	return myType;
}
const FEFormContentTypeP FEFormContent::formType () {
	return myType;
}

FEFormContent::FEFormContent (XuEditionP edition, FEFormContentTypeP type,
	FEStringAssoc* cache)	: FEContent(edition), myType(type), myCache(cache) {
	if (cache == NULL) {
		myCache = new FEStringAssoc(numFormFields);
	}
}

/******************* FEFormContentType ********************/

<<<<<<< formct.cpp
/* make a form of this type, properly initialized */
FEContentP FEFormContentType::
makeContent(XuEditionP XU_OR_NULL edition) {
	if (edition == XU_NULL) {
		edition = XuEdition::empty(XuSequenceSpace::make());
=======
/* make a form of this type, properly initialized */
FEContentP FEFormContentType::makeContent(XuEditionP XU_OR_NULL edition) {
	if (edition == XU_NULL) {
		edition = XuEdition::empty(XuSequenceSpace::make());
		edition->endorse(this->endorsements());
>>>>>>> 1.6
	}
	return new FEFormContent(edition, this);
}

FESheetP FEFormContentType::
makeSheet(FEDraftP draft) {
	return new FEFormSheet(draft);
}
